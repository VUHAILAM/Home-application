import QtQuick 2.12
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtQml.Models 2.1

Item {
    id: root
    width: 1920
    height: 1096
    function openApplication(url){
        parent.push(url)
    }
    property var focusingItem
    property var focustModel: [visualModelWidget, visualModel]
    property var focustIndex: [0, 0]
    property int focusSection: 0
    // set focus to current choose item
    function setFocus(item, isWidget) {
        // reset focus of old item
        if (focusingItem != undefined && focusingItem != item) {
            focusingItem.focus = false
            focusingItem.state = "Normal"
        }
        let section = isWidget ? 0 : 1
        focusingItem = item
        focusSection = section
        focustIndex[section] = item.parent.visualIndex
     }

     function forceFocus(item, isWidget) {
         setFocus(item, isWidget)
         item.focus = true
         item.state = "Focus"
     }

    ListView {
        id: lvWidget
        spacing: 10
        orientation: ListView.Horizontal
        width: 1920
        height: 570
        interactive: false

        displaced: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
        }

        model: DelegateModel {
            id: visualModelWidget
            model: ListModel {
                id: widgetModel
                ListElement { type: "map" }
                ListElement { type: "climate" }
                ListElement { type: "media" }
            }

            delegate: DropArea {
                id: delegateRootWidget
                width: 635; height: 570
                keys: ["widget"]

                onEntered: {
                    visualModelWidget.items.move(drag.source.visualIndex, iconWidget.visualIndex)
                    iconWidget.item.enabled = false
                }
                property int visualIndex: DelegateModel.itemsIndex
                Binding { target: iconWidget; property: "visualIndex"; value: visualIndex }
                onExited: iconWidget.item.enabled = true
                onDropped: {
                    console.log(drop.source.visualIndex)
                }
                Loader {
                    id: iconWidget
                    property int visualIndex: 0
                    width: 635; height: 570
                    anchors {
                        horizontalCenter: parent.horizontalCenter;
                        verticalCenter: parent.verticalCenter
                    }
                    sourceComponent: {
                        switch(model.type) {
                        case "map": return mapWidget
                        case "climate": return climateWidget
                        case "media": return mediaWidget
                        }
                    }

                    states: [
                        State {
                            when: iconWidget.Drag.active
                            ParentChange {
                                target: iconWidget
                                parent: lvWidget
                            }

                            AnchorChanges {
                                target: iconWidget
                                anchors.horizontalCenter: undefined
                                anchors.verticalCenter: undefined
                            }
                        }
                    ]
                }
            }
        }
        //Define components
        Component {
            id: mapWidget
            MapWidget {
              id: mapItem
              onPressed: {
                  root.setFocus(mapItem, true)
              }

              onReleased: {
                  root.forceFocus(mapItem, true)
              }

              onClicked: {
                  openApplication("qrc:/App/Map/Map.qml")
              }

           }
        }
        Component {
           id: climateWidget
           ClimateWidget {
               id: climateItem
               onPressed: {
                  root.setFocus(climateItem, true)
               }

               onClicked: {
                   openApplication("qrc:/App/Climate/Climate.qml")
               }

               onReleased: {
                   root.forceFocus(climateItem, true)
               }


             }
         }
         Component {
            id: mediaWidget
            MediaWidget {
                id: mediaItem

                 onPressed: {
                     root.setFocus(mediaItem, true)
                 }

                 onClicked: {
                      openApplication("qrc:/App/Media/Media.qml")
                  }

                  onReleased: {
                      root.forceFocus(mediaItem, true)
                  }

             }
        }
    }
    ScrollView {
        id: scrollApps
        width: 1920; height: 456
        ScrollBar.horizontal: ScrollBar{
            anchors.bottom: lvApps.top
            policy: (lvApps.count > 6) ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
            size: scrollApps.width/lvApps.width
            contentItem: Rectangle {
                    implicitWidth: 1920
                    implicitHeight: 6
                    radius: height / 2
                }
        }
        x: 0
        y:570
        ListView {
            id: lvApps
            height: 456
            orientation: ListView.Horizontal
            interactive: false
            spacing: 4
            displaced: Transition {
                NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
            }

            model: DelegateModel {
                id: visualModel
                model: appsModel
                delegate: DropArea {
                    id: delegateRoot
                    width: 316; height: 456
                    keys: "AppButton"

                    onEntered: {
                        visualModel.items.move(drag.source.visualIndex, icon.visualIndex)
                        var listData = []
                        //get Application Data and save it
                        for(var i = 0; i < lvApps.count; i++) {
                            var data = []
                            data.push(visualModel.items.get(i).model.title)
                            data.push(visualModel.items.get(i).model.url)
                            data.push(visualModel.items.get(i).model.iconPath)
                            listData.push(data)
                        }
                        xmlHandler.saveData(listData)
                    }
                    property int visualIndex: DelegateModel.itemsIndex
                    Binding { target: icon; property: "visualIndex"; value: visualIndex }
                    Item {
                        id: icon
                        property int visualIndex: 0
                        property string mTitle: model.title
                        property string mIcon: model.iconPath
                        property string mUrl: model.url
                        property variant myData: appsModel
                        width: 316; height: 456
                        anchors {
                            horizontalCenter: parent.horizontalCenter;
                            verticalCenter: parent.verticalCenter
                        }

                        AppButton{
                            id: app
                            anchors.fill: parent
                            title: model.title
                            icon: model.iconPath
                            onClicked: openApplication(model.url)
                            property bool held: false
                            drag.axis: Drag.XAxis
                            drag.target: icon
                            onPressAndHold: {app.held = true
                            console.log(app.held)}
                            onPressed: {
                                root.setFocus(app, false)
                            }
                            onReleased: {
                                app.held = false
                                root.forceFocus(app, false)
                            }

                        }

                        onFocusChanged: app.focus = icon.focus

                        Drag.active: app.drag.active
                        Drag.hotSpot.x: delegateRoot.width / 2
                        Drag.hotSpot.y: delegateRoot.height / 2
                        Drag.keys: "AppButton"

                        states: [
                            State {
                                when: icon.Drag.active
                                ParentChange {
                                    target: icon
                                    parent: scrollApps
                                }

                                AnchorChanges {
                                    target: icon
                                    anchors.horizontalCenter: undefined
                                    anchors.verticalCenter: undefined
                                }
                            }
                        ]
                    }
                }
            }
        }
    }

}
