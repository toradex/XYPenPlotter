import QtQuick 1.1

Rectangle {
    property int progress: 100

    onProgressChanged:
    {
        imageProgress.width = progress * 3;
    }

    width: 302
    height: 19

    Image {
        anchors.left: parent.left
        anchors.leftMargin: 2
        id: imageProgress
        height: 19
        fillMode: Image.TileHorizontally

        source: "qrc:///progressbar.png"
    }

    color: "#e3e3e3";
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#d8d8d8" }
        GradientStop { position: 0.2; color: "#e3e3e3"}
        GradientStop { position: 1.0; color: "#e3e3e3"}
    }
    radius: 1
    border.width: 1
    border.color: "#cecece"
}
