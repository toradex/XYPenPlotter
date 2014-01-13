import QtQuick 1.1

Rectangle {
    width: 800
    height: 480
    color: "#f1f1f1"



    property color buttonColor: "lightblue"
    property color onHoverColor: "gold"
    property color borderColor: "white"


    Column {
        anchors.horizontalCenter: parent.horizontalCenter

        spacing: 10


        /* Row 1 */

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 780
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
                buttonLabel: "Load"

                onButtonClick: {
                    animateOpacity.start()
                }
            }
            Button {
                id: saveButton
                color: "#d4d4d4"
                buttonLabel: "Save"

                onButtonClick: {
                    Qt.quit();
                }
            }

            Rectangle {
                width: 180; height: 180
                color: "transparent"
                Rectangle {
                     id: flashingblob
                     anchors.horizontalCenter: parent.horizontalCenter;
                     anchors.verticalCenter: parent.verticalCenter;
                     width: 180; height: 180
                     color: "lightblue"
                     opacity: 1.0

                     NumberAnimation {
                         id: animateOpacity
                         target: flashingblob
                         properties: "width, height"
                         from: 0.0
                         to: 180.0
                         duration: 2000
                         easing
                         {
                             type: Easing.OutElastic;
                             amplitude: 1.0
                             period: 0.5
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
                color: "lightgreen"


                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: 5

                    id: cpuLoadText
                    text: "0%"
                }
            }

        }
    }



}
