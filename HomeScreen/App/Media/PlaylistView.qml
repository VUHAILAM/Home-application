import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.1

Drawer {
    id: drawer
    property alias mediaPlaylist: mediaPlaylist
    interactive: false
    modal: false
    property int holdIndex
    background: Rectangle {
        id: playList_bg
        anchors.fill: parent
        color: "transparent"
    }
    ListView {
        id: mediaPlaylist
        anchors.fill: parent
        model: myModel
        clip: true
        spacing: 2
        currentIndex: player.playlist.currentIndex
        delegate: MouseArea {
            property variant myData: model
            implicitWidth: playlistItem.width
            implicitHeight: playlistItem.height
            property bool pref: false
            Image {
                id: playlistItem
                width: 675
                height: 193/1.5
                source: "qrc:/App/Media/Image/playlist.png"
                opacity: 0.5
            }
            Image {
                id: imgHold
                width: 675
                height: 193/1.5
                source: "qrc:/App/Media/Image/hold.png"
                opacity: 0.5
                visible: pref
            }

            Text {
                text: title
                anchors.fill: parent
                anchors.leftMargin: 70
                verticalAlignment: Text.AlignVCenter
                color: "white"
                font.pixelSize: 32
            }
            onClicked: {
                player.playlist.currentIndex = index
            }

            onPressed: {
                pref = true
                holdIndex = index
            }
            onReleased: {
                playlistItem.source = "qrc:/App/Media/Image/playlist.png"
                pref = false
            }
        }
        highlight: Image {
            source: "qrc:/App/Media/Image/playlist_item.png"
            Image {
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/App/Media/Image/playing.png"
            }
        }
        onDragEnded: {
            mediaPlaylist.itemAtIndex(holdIndex).pref = false
            console.log("Drag End!!")
        }
        ScrollBar.vertical: ScrollBar {
            parent: mediaPlaylist.parent
            anchors.top: mediaPlaylist.top
            anchors.left: mediaPlaylist.right
            anchors.bottom: mediaPlaylist.bottom
        }
    }

    Connections{
        target: player.playlist
        onCurrentIndexChanged: {
            mediaPlaylist.currentIndex = index;
        }
    }
}
