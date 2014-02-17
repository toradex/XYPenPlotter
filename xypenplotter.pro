# Add more folders to ship with the application, here
folder_01.source = qml/XYPenPlotter
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    cpuinfo.cpp \
    cpuloadworker.cpp \
    xypenplottercontroller.cpp

# Installation path
# target.path =

OTHER_FILES += \
    qml/XYPenPlotter/Button.qml \
    qml/XYPenPlotter/main.qml \
    qml/XYPenPlotter/ProgressBar.qml \
    qml/XYPenPlotter/RoundButton.qml

RESOURCES = resources.qrc

HEADERS += \
    cpuinfo.h \
    cpuloadworker.h \
    xypenplottercontroller.h

# Please do not modify the following two lines. Required for deployment.
include(qtquick1applicationviewer/qtquick1applicationviewer.pri)
qtcAddDeployment()
