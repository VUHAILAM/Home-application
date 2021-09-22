import QtQuick 2.0
import "../../Qml/Common"

Item {
    width: 1920
    height: 1080-54
    AppHeader {
        id: headerItem
        width: parent.width
        height: 141/2
        title: "VinID"
    }
    Image {
        id: videoScr
        height: implicitHeight
        width: implicitWidth
        anchors.centerIn: parent
        anchors.top: headerItem.bottom
        source: "qrc:/Img/Apps/image_20210330_144320_452a6264ad5b14bd220ff9842d11c67f54d440eb27f3c3e90515ec090b907b09.png"
    }
}
