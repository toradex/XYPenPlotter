#include "qtquick1applicationviewer.h"
#include <QApplication>
#include <QGraphicsBlurEffect>
#include <QDeclarativeEngine>
#include <QtDeclarative>
#include "cpuinfo.h"

int main(int argc, char *argv[])
{
    /*
    qmlRegisterType<QGraphicsBlurEffect>("Effects",1,0,"Blur");
    qmlRegisterType<QGraphicsColorizeEffect>("Effects",1,0,"Colorize");
    qmlRegisterType<QGraphicsDropShadowEffect>("Effects",1,0,"DropShadow");
    qmlRegisterType<QGraphicsOpacityEffect>("Effects",1,0,"OpacityEffect");
*/

    QApplication app(argc, argv);

    QtQuick1ApplicationViewer viewer;

/*
    CpuInfo cpuInfo;
    viewer.rootContext()->setContextProperty("cpuInfo", &cpuInfo);*/

    viewer.addImportPath(QLatin1String("modules"));
    viewer.setOrientation(QtQuick1ApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/XYPenPlotter/main.qml"));
    viewer.showFullScreen();
    //viewer.show();

    return app.exec();
}
