import QtQuick 1.1

Rectangle {
    property color buttonColor: "lightgray"
    property color onHoverColor: "gold"
    property color borderColor: "white"
    property string buttonLabel: "button label"

    signal buttonClick()
    onButtonClick: {
        console.log(buttonLabel + " clicked" )
    }

    id: button
    width: 150; height: 75

    Text{
        anchors.centerIn: parent
        text: buttonLabel
    }

    MouseArea{
        width: 150; height: 75
        id: buttonMouseArea
        onClicked: buttonClick()
        hoverEnabled: true
        onEntered: parent.border.color = onHoverColor
        onExited:  parent.border.color = borderColor
    }

    //determines the color of the button by using the conditional operator
    color: buttonMouseArea.pressed ? Qt.darker(buttonColor, 1.5) : buttonColor
}
