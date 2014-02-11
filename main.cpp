#include "qtquick1applicationviewer.h"
#include <QApplication>
#include <QGraphicsBlurEffect>
#include <QDeclarativeEngine>
#include <QtDeclarative>
#include <QWSServer>
#include "cpuinfo.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QtQuick1ApplicationViewer viewer;

    /* Disable cursor since we have a touchscreen */
#ifdef Q_WS_QWS
    QWSServer::setCursorVisible( false );
#endif

    CpuInfo cpuInfo;
    viewer.rootContext()->setContextProperty("cpuInfo", &cpuInfo);

    viewer.addImportPath(QLatin1String("modules"));
    viewer.setOrientation(QtQuick1ApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/XYPenPlotter/main.qml"));

    /* Show in fullscreen on target */
#ifdef Q_WS_QWS
    viewer.showFullScreen();
#else
    viewer.show();
#endif


    return app.exec();
}

