import QtQuick 2.0
import "../../Qml/Common"
Item {
    width: 1920
    height: 1080-54
    AppHeader {
        id: headerItem
        width: parent.width
        height: 141/2
        title: "Setting"
    }
    Image {
        id: settingScr
        height: implicitHeight
        width: implicitWidth
        anchors.centerIn: parent
        anchors.top: headerItem.bottom
        source: "qrc:/Img/Apps/Settings.png"
    }
}
