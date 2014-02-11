import QtQuick 1.1


Rectangle {
    id: coolLine
    width: parent.width
    height: 2
    color: "transparent"

    Rectangle {
        width: 1
        height: parent.width
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter


        gradient: Gradient {
            GradientStop { color: "transparent"; position: 0.0 }
            GradientStop { color: "lightgray"; position: 0.2 }
            GradientStop { color: "lightgray"; position: 0.8 }
            GradientStop { color: "transparent"; position: 1.0 }
        }
        rotation: 90
    }

    Rectangle {
        width: 1
        height: parent.width
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -1
        anchors.horizontalCenter: parent.horizontalCenter

        gradient: Gradient {
            GradientStop { color: "transparent"; position: 0.0 }
            GradientStop { color: "white"; position: 0.2 }
            GradientStop { color: "white"; position: 0.8 }
            GradientStop { color: "transparent"; position: 1.0 }
        }
        rotation: 90
    }
}
