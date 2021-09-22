import QtQuick 2.0

Item {
    property string title: ""
    Image {
        id: headerItem
        source: "qrc:/App/Media/Image/title.png"
        height: implicitHeight/2
        Text {
            id: headerTitleText
            text: title
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: 46
        }
    }
}
