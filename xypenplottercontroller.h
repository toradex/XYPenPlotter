#ifndef XYPENPLOTTERCONTROLLER_H
#define XYPENPLOTTERCONTROLLER_H

#include <QObject>
#include <QTimer>
#include <stdint.h>

typedef struct msg_s
{
   uint32_t     data;
   uint32_t     status;
} msg_t;

class XYPenPlotterController : public QObject
{
    Q_OBJECT
public:
    explicit XYPenPlotterController(QObject *parent = 0);
    ~XYPenPlotterController();
    Q_INVOKABLE void pressStart();
    Q_INVOKABLE bool isStopped();
    Q_INVOKABLE void home();
    Q_INVOKABLE void selectImage(QString image);

private:
    msg_t msg, rcv_msg;
    int fd;
    void *map_base_read, *virt_addr_read;
    void *map_base_write, *virt_addr_write;
    void *map_base_exist, *virt_addr_exist;
    int send_msg(msg_t *msg);
    int receive_msg(msg_t *msg);
    unsigned int firmware_exists(void);
    QTimer *timer;

    void setCurrentState(QString newState);
    void setProgress(int progress);
    QString currentState;
    QString selectedImage;

#ifndef Q_WS_QWS
    int counter;
#endif
signals:
    void stateChanged(QString newState);
    void progressUpdate(int progress);

private slots:
#ifdef Q_WS_QWS
    void receivePlotterMessages();
#else
    void setStoppedState();
#endif
public slots:

};

#endif // XYPENPLOTTERCONTROLLER_H
