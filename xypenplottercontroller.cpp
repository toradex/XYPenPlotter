#include "xypenplottercontroller.h"
#include <QDebug>
#include <QTimer>
#include <QProcess>
#include <QTime>
#ifdef Q_WS_QWS
#include <linux/mcc_config.h>
#include <linux/mcc_common.h>
#include <linux/mcc_linux.h>
#include <mcc_api.h>
#endif
#include <stdint.h>


#define MCC_MQX_NODE_A5 1
#define MCC_MQX_NODE_M4 2

#define PLOTTER_STOP    0 /* Plotter is in Stopped mode */
#define PLOTTER_START   1 /* Plotter is in Started mode */
#define PLOTTER_DRAW    2 /* Start to draw, from the beginning */
#define PLOTTER_UNPAUSE 9 /* Continue drawing, at last point */
#define PLOTTER_PAUSE   10 /* Pause drawing */
#define PLOTTER_HOME    11
#define PLOTTER_WELCOME 12


MCC_ENDPOINT    mqx_endpoint_a5 = {0,0,1};
MCC_ENDPOINT    mqx_endpoint_m4 = {1,0,2};


int send_msg(msg_t *msg)
{
    int retval;

    retval = mcc_send(&mqx_endpoint_m4, msg, sizeof(msg_t), 0xffffffff);
    if(retval)
        qDebug("mcc_send failed, result = 0x%x", retval);

    //mcc_destroy(mqx_endpoint_a5.node);
    return retval;
}

int receive_msg(msg_t *msg, int timeout)
{
    int retval, num_of_received_bytes;

    retval = mcc_recv_copy(&mqx_endpoint_a5, msg, sizeof(msg_t), &num_of_received_bytes, timeout);
    if(retval)
        qDebug("mcc_recv_copy failed, result = 0x%x",  retval);
    return retval;
}



XYPenPlotterController::XYPenPlotterController(QObject *parent) :
    QObject(parent)
{
    MCC_INFO_STRUCT info_data;
    int retval = 0;
    uint32_t node_num = mqx_endpoint_a5.node;

    retval = mcc_initialize(node_num);
    if(retval)
    {
        qDebug("Error during mcc_initialize, result = %d", retval);
        return;
    }

    retval = mcc_get_info(node_num, &info_data);
    if(retval)
    {
        qDebug("Error during mcc_get_info, result = %d", retval);
        return;
    }

    qDebug("Plotter app");
    qDebug("mcc version: %s", info_data.version_string);

    retval = mcc_create_endpoint(&mqx_endpoint_a5, mqx_endpoint_a5.port);
    if(retval)
    {
        qDebug("mcc_create_endpoint failes, result = 0x%x", retval);
        mcc_destroy(node_num);
        return;
    }

    qDebug("Connecting to plotter...");
    msg.data = PLOTTER_WELCOME;

    do {
        retval = send_msg(&msg);

        if(retval == MCC_ERR_ENDPOINT)
        {
            // Firmware is not loaded!? Load the plotter firmware...
            qDebug("Loading firmware...");
            QProcess *process = new QProcess(this);
            process->start("mqxboot /var/cache/xyplotter/plotter.bin 0x8f000400 0x0f000411");
            process->waitForFinished();

            // Wait until its ready...
            QTime dieTime= QTime::currentTime().addMSecs(100);
            while( QTime::currentTime() < dieTime );
        }
    } while (retval != MCC_SUCCESS);

    qDebug("Welocme message sent! Waiting for response...");
    if(receive_msg(&rcv_msg, 1000000))
        return;

    if(rcv_msg.status != PLOTTER_WELCOME)
    {
        qDebug("Oops! Something went wrong! Plotter response = 0x%x\n", rcv_msg.status);
        return;
    }
    else
    {
        qDebug("Greeting received. Connected to ploter!\n");
    }

    qDebug("Homing plotter");
    fflush(stdout);
    msg.data = PLOTTER_HOME;
    if(send_msg(&msg))
        return;

    QTimer *timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SLOT(receivePlotterMessages()));
    timer->start(100);
}



void XYPenPlotterController::receivePlotterMessages()
{
    bool trigger = false;
    if(receive_msg(&rcv_msg, 100))
        return;

    if(rcv_msg.status == PLOTTER_DRAW)
    {
        qDebug("Plotter start draw!");
        setCurrentState("RUNNING");
    }
    else if(rcv_msg.status == PLOTTER_START)
    {
        qDebug("Plotter running... %d\%", rcv_msg.data);

        // Update progress bar...

        trigger = true;
    }
    else if(rcv_msg.status == PLOTTER_UNPAUSE)
    {
        setCurrentState("RUNNING");
        trigger = true;
    }
    else if(rcv_msg.status == PLOTTER_PAUSE)
    {
        setCurrentState("PAUSED");
    }
    else if(rcv_msg.status == PLOTTER_HOME)
    {
        setCurrentState("STOPPED");
        trigger = true;
    }
    else if(rcv_msg.status == PLOTTER_STOP)
    {
        if(currentState != "STOPPED")
            setCurrentState("STOPPED");
        trigger = true;
        // Reset progress bar...
    }
    else
    {
        qDebug("Something went wrong! Plotter status = 0x%x", rcv_msg.status);
    }

    // Trigger a dummy message to get status back...
    if (trigger)
    {
        msg.data = 0xff;
        if(send_msg(&msg))
            return;
    }
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

bool XYPenPlotterController::isStopped()
{
    return currentState == "STOPPED";
}

/*
 * User requests new state by pressing button
 */
void XYPenPlotterController::pressStart()
{
    int ret;
#ifdef Q_WS_QWS

    qDebug() << "pressStart, currentState is " << currentState;

    if (currentState == "STOPPED")
    {
        // Load the graphics using mqxboot again...
        QProcess *process = new QProcess(this);
//        process->start("mqxboot /var/cache/xyplotter/TE.bin 0x8fa00000 0x0f000411");
        process->start("mqxboot /var/cache/xyplotter/COLIBRI.bin 0x8fa00000 0x0f000411");
        process->waitForFinished();

        qDebug("Send PLOTTER_DRAW");
        msg.data = PLOTTER_DRAW;
        ret = send_msg(&msg);
        if(ret)
            qDebug("Failed to send PLOTTER_DRAW message, ret %d.", ret);
    }
    else if(currentState == "PAUSED")
    {
        msg.data = PLOTTER_UNPAUSE;
        ret = send_msg(&msg);
        if(ret)
            qDebug("Failed to send PLOTTER_START message, ret %d.", ret);
    }
    else if (currentState == "RUNNING")
    {
        msg.data = PLOTTER_PAUSE;
        if(send_msg(&msg))
            qDebug() << "Failed to send PLOTTER_PAUSE message.";
    }
#else
    if(requestedState == "RUNNING")
        QTimer::singleShot(10000, this, SLOT(setStoppedState()));
#endif
}


void XYPenPlotterController::setStoppedState()
{
    qDebug() << "updateState delayed!";
    emit stateChanged("STOPPED");
}
