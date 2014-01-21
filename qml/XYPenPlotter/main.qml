import QtQuick 1.1

Rectangle {
    width: 635
    height: 480
    color: "#f1f1f1"



    property color buttonColor: "lightblue"
    property color onHoverColor: "gold"
    property color borderColor: "white"
/*
    SequentialAnimation on rotation {
                    running: mouse.pressed
                    id: anim
                    loops: Animation.Infinite
                    NumberAnimation { from: 0; to: 360; easing.type: Easing.InOutBack; duration: 4000 }
                    PauseAnimation { duration: 2000 }
            }
    MouseArea {
                    id: mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: { anim.start() }
                    onExited: { anim.stop(); parent.rotation = 0 }
            }
*/
    Column {
        anchors.topMargin: 10
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        spacing: 10


        /* Row 1 */

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 620
            spacing: 10
            Image {
                width: 211; height: 48;
                source: "qrc:///toradex-logo.png"
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("XY-Plotter")
                font.pointSize: 15
                rotation: 0
            }
        }

        /* Row 2 */

        Row {

            spacing: 50
            Button {
                id: loadButton
                buttonLabel: "CPU-Load"

                onButtonClick: {
                }
            }
            Button {
                id: quitButton
                color: "#d4d4d4"
                buttonLabel: "Quit"

                onButtonClick: {
                    Qt.quit();
                }
            }
            Button {
                id: sendButton
                color: "#d4d4d4"
                buttonLabel: "Send"

                onButtonClick: {
                    animateOpacity.start()
                }
            }

        }


        Row {
            Rectangle {
                width: 180; height: 180
                color: "transparent"
                Rectangle {
                     id: flashingblob
                     anchors.horizontalCenter: parent.horizontalCenter;
                     anchors.verticalCenter: parent.verticalCenter;
                     width: 180; height: 180
                     color: "gray"
                     opacity: 1.0

                     NumberAnimation {
                         id: animateOpacity
                         target: flashingblob
                         properties: "width, height"
                         from: 180.0
                         to: 0.0
                         duration: 2000
                         easing
                         {
                             type: Easing.InQuart;
                         }
                    }
                }
            }
        }

        Row {
            Text {
                text: "CPU-Load: "
            }

            Rectangle {
                id: cpuLoadBar
                width: 500
                height: 20
                color: "green"


                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: 5

                    id: cpuLoadText
                    text: "0%"
                }
            }

        }
    }

    Timer {
        interval: 500; running: true; repeat: true;
        onTriggered: {
            cpuLoadText.text = cpuInfo.getCpuLoad().toFixed(1);
        }

    }

}
