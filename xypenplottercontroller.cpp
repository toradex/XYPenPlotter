#include "xypenplottercontroller.h"
#include <QDebug>
#include <QTimer>

XYPenPlotterController::XYPenPlotterController(QObject *parent) :
    QObject(parent)
{

}


void XYPenPlotterController::setState(QString state)
{
    qDebug() << state;

    QTimer::singleShot(2000, this, SLOT(setStoppedState()));
}


void XYPenPlotterController::setStoppedState()
{
    qDebug() << "updateState delayed!";
    emit stateChanged("STOPPED");
}
