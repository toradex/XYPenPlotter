#ifndef XYPENPLOTTERCONTROLLER_H
#define XYPENPLOTTERCONTROLLER_H

#include <QObject>

class XYPenPlotterController : public QObject
{
    Q_OBJECT
public:
    explicit XYPenPlotterController(QObject *parent = 0);
    Q_INVOKABLE void setState(QString state);

signals:
    void stateChanged(QString newState);

private slots:
    void setStoppedState();

public slots:

};

#endif // XYPENPLOTTERCONTROLLER_H
