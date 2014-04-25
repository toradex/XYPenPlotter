#include "xypenplottercontroller.h"
#include <QDebug>
#include <QTimer>
#include <QProcess>
#include <QTime>
#ifdef Q_WS_QWS
#include <stdint.h>

extern "C" {
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <signal.h>
#include <fcntl.h>
#include <ctype.h>
#include <termios.h>
#include <sys/types.h>
#include <sys/mman.h>
}

#define MAP_SIZE 4096UL
#define MAP_MASK (MAP_SIZE - 1)
#define ADDR_READ 0x8f9ffffc
#define ADDR_WRITE 0x8f9ffff8
#define ADDR_EXIST 0x8f9ffff4

#define PLOTTER_STOP    0 /* Plotter is in Stopped mode */
#define PLOTTER_START   1 /* Plotter is in Started mode */
#define PLOTTER_DRAW    2 /* Start to draw, from the beginning */
#define PLOTTER_UNPAUSE 9 /* Continue drawing, at last point */
#define PLOTTER_PAUSE   10 /* Pause drawing */
#define PLOTTER_HOME    11
#define PLOTTER_WELCOME 12

int XYPenPlotterController::send_msg(msg_t *msg)
{
    *((unsigned long *) virt_addr_write) = msg->data;

    return 0;
}

int XYPenPlotterController::receive_msg(msg_t *msg)
{
    int val;

    val = *((unsigned long *) virt_addr_read);
    msg->status = (val >> 16) & 0xff;
    msg->data = val & 0xff;

    return 0;
}

unsigned int XYPenPlotterController::firmware_exists(void)
{
    unsigned int val;

    val = *((unsigned long *) virt_addr_exist);

    return val;
}

XYPenPlotterController::XYPenPlotterController(QObject *parent) :
    QObject(parent)
{
    qDebug("Plotter app");

    if((fd = open("/dev/mem", O_RDWR | O_SYNC)) == -1)
        qDebug("Open /dev/mem error");

    map_base_read = mmap(0, MAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, ADDR_READ & ~MAP_MASK);
    map_base_write = mmap(0, MAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, ADDR_WRITE & ~MAP_MASK);
    map_base_exist = mmap(0, MAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, ADDR_EXIST & ~MAP_MASK);

    if(map_base_read == (void*) -1)
        qDebug("map_base_exist error");
    if(map_base_write == (void*) -1)
        qDebug("map_base_exist error");
    if(map_base_exist == (void*) -1)
        qDebug("map_base_exist error");

    virt_addr_read = map_base_read + (ADDR_READ & MAP_MASK);
    virt_addr_write = map_base_write + (ADDR_WRITE & MAP_MASK);
    virt_addr_exist = map_base_exist + (ADDR_EXIST & MAP_MASK);

    qDebug("Connecting to plotter...");
    msg.data = PLOTTER_WELCOME;


    if(firmware_exists() != 0xdeadbeef) {
        qDebug("Loading firmware...");
        QProcess *process = new QProcess(this);
        process->start("mqxboot /var/cache/xyplotter/plotter.bin 0x8f000400 0x0f000411");
        process->waitForFinished();
        if(process->exitCode() != 0) {
            qDebug("Loading firmware failed");
            qDebug("mqxboot: returned %d", process->exitCode());
            return;
        }
    }

    QTime dieTime = QTime::currentTime().addSecs(2);
    while(firmware_exists() != 0xdeadbeef) {
        // Wait until its ready...
        if (QTime::currentTime() > dieTime) {
            qDebug("Timeout waiting for firmware");
            return;
        }
    }

    qDebug("Homing plotter");
    fflush(stdout);
    msg.data = PLOTTER_HOME;
    if(send_msg(&msg))
        return;

    timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SLOT(receivePlotterMessages()));
    timer->start(300);
}



void XYPenPlotterController::receivePlotterMessages()
{
    if(receive_msg(&rcv_msg))
        return;

    if(rcv_msg.status == PLOTTER_DRAW)
    {
        qDebug("Plotter start draw!");
        setCurrentState("RUNNING");
    }
    else if(rcv_msg.status == PLOTTER_START)
    {
        qDebug("Plotter running... %d%%", rcv_msg.data);

        // Update progress bar...
        setProgress(rcv_msg.data);
    }
    else if(rcv_msg.status == PLOTTER_UNPAUSE)
    {
        setCurrentState("RUNNING");
    }
    else if(rcv_msg.status == PLOTTER_PAUSE)
    {
        setCurrentState("PAUSED");
    }
    else if(rcv_msg.status == PLOTTER_HOME)
    {
        setCurrentState("STOPPED");
    }
    else if(rcv_msg.status == PLOTTER_STOP)
    {
        if(currentState != "STOPPED")
            setCurrentState("STOPPED");
        // Reset progress bar...
        setProgress(0);
    }
    else
    {
        qDebug("Something went wrong! Plotter status = 0x%x", rcv_msg.status);
    }
    msg.data = 0xff;
    if(send_msg(&msg))
        return;
}


/*
 * User requests new state by pressing button
 */
void XYPenPlotterController::pressStart()
{
    int ret;

    int lastPoint = selectedImage.lastIndexOf(".");
    QString binaryFile = selectedImage.left(lastPoint) + ".bin";
    binaryFile.remove(0, 7); // Remove file://
    qDebug() << "pressStart, currentState is " << currentState << ", binaryFile is " << binaryFile;

    if (currentState == "STOPPED")
    {
        // Load the graphics using mqxboot again...
        QProcess *process = new QProcess(this);
        process->start("mqxboot " + binaryFile + " 0x8fa00000 0x0f000411");
        process->waitForFinished();

        qDebug("Send PLOTTER_DRAW");
        msg.data = PLOTTER_DRAW;
        ret = send_msg(&msg);
        if(ret)
            qDebug("Failed to send PLOTTER_DRAW message, ret %d.", ret);
        setCurrentState("RUNNING");

    }
    else if(currentState == "PAUSED")
    {
        msg.data = PLOTTER_UNPAUSE;
        ret = send_msg(&msg);
        if(ret)
            qDebug("Failed to send PLOTTER_START message, ret %d.", ret);
        setCurrentState("RUNNING");
    }
    else if (currentState == "RUNNING")
    {
        msg.data = PLOTTER_PAUSE;
        if(send_msg(&msg))
            qDebug() << "Failed to send PLOTTER_PAUSE message.";
        setCurrentState("PAUSED");
    }

}

void XYPenPlotterController::home()
{
    qDebug() << "Home...";
    msg.data = PLOTTER_HOME;
    if(send_msg(&msg))
        return;
}

XYPenPlotterController::~XYPenPlotterController()
{
    munmap(map_base_read, MAP_SIZE);
    munmap(map_base_write, MAP_SIZE);
    munmap(map_base_exist, MAP_SIZE);
    close(fd);
}

#else /* Q_WS_QWS => Desktop... */

XYPenPlotterController::XYPenPlotterController(QObject *parent) :
    QObject(parent)
{
    setCurrentState("STOPPED");
    timer = new QTimer(this);
    timer->setInterval(100);
    connect(timer, SIGNAL(timeout()), this, SLOT(setStoppedState()));
}

XYPenPlotterController::~XYPenPlotterController()
{
}

void XYPenPlotterController::pressStart()
{
    qDebug() << "pressStart";

    if(currentState == "STOPPED")
    {
        // We set state imeaditly..
        setCurrentState("RUNNING");
        counter = 0;

        timer->start();
    }
    else if(currentState == "RUNNING")
    {
        timer->stop();
        setCurrentState("PAUSED");
    }
    else if(currentState == "PAUSED")
    {
        timer->start();
        setCurrentState("RUNNING");
    }
}

void XYPenPlotterController::setStoppedState()
{
    counter++;

    /* After 5 seconds, we stop simulated printing... */
    if(counter >= 50)
    {
        qDebug() << "setStoppedState";
        setCurrentState("STOPPED");
        timer->stop();
    }

    setProgress(counter * 2);
}

void XYPenPlotterController::home()
{
    qDebug() << "Home...";
}
#endif

bool XYPenPlotterController::isStopped()
{
    return currentState == "STOPPED";
}
void XYPenPlotterController::selectImage(QString image)
{
    selectedImage = image;
}

/*
 * Printer says which state it is in...
 */
void XYPenPlotterController::setCurrentState(QString newState)
{
    qDebug() << "printer is in new state:" << newState;
    currentState = newState;
    emit stateChanged(newState);
}

/*
 * Update current progress
 */
void XYPenPlotterController::setProgress(int progress)
{
    if(progress > 100)
        emit progressUpdate(100);
    else
        emit progressUpdate(progress);
}
