#ifndef XYPENPLOTTERCONTROLLER_H
#define XYPENPLOTTERCONTROLLER_H

#include <QObject>
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
    Q_INVOKABLE void pressStart();
    Q_INVOKABLE bool isStopped();

private:
    msg_t msg, rcv_msg;

    void setCurrentState(QString newState);
    QString currentState;

signals:
    void stateChanged(QString newState);

private slots:
    void setStoppedState();
    void receivePlotterMessages();

public slots:

};

#endif // XYPENPLOTTERCONTROLLER_H
