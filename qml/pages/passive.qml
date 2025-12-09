import QtQuick 2.0
import "../components"
import QtQuick.Timeline 1.0
import QtQuick.Controls 2.15

Item {
    id: item1

    Rectangle{
        id: rectangle
        anchors.fill: parent
        radius: 10
        color: "#a1a1a1"

        CircularProgressBar {
            id: circularProgressBar
            width: 200
            height: 200
            opacity: 0
            text: "loading..."
            anchors.verticalCenter: parent.verticalCenter
            textShowValue: false
            anchors.horizontalCenter: parent.horizontalCenter
            value: 0
            textColor: "#ffffff"
            progressColor: "#55aaff"
            strokeBgWidth: 2
            enableDropShadow: false
            progressWidth: 4
            bgStrokeColor: "#33334c"
        }

        Image {
            id : imgShoulder
            x : 544
            y : 136
            width : 206
            height : 232
            source : "../../images/virtual_arm/shoulder.jpg"
            transformOrigin : Item.Top
            rotation : dialB.value
            Image {
                id : imgElbow
                x : -28
                y : 165
                width : 281
                height : 284
                source : "../../images/virtual_arm/elbow.png"
                transformOrigin : Item.Top
                rotation : dialA.value
                fillMode : Image.PreserveAspectFit
            }
            //            rotation: 0
            fillMode : Image.PreserveAspectFit
        }

        Dial {
            id: dialA
            x: 8
            y: 8
            width: 120
            height: 120
            stepSize : 1
            to : 90

            background: Rectangle {
                x: dialA.width / 2 - width / 2
                y: dialA.height / 2 - height / 2
                width: Math.max(64, Math.min(dialA.width, dialA.height))
                height: width
                color: "transparent"
                radius: width / 2
                border.color: "#33334c"
                border.width: 4
                opacity: dialA.enabled ? 1 : 0.3
            }

            handle: Rectangle {
                id: handleItemA
                x: dialA.background.x + dialA.background.width / 2 - width / 2
                y: dialA.background.y + dialA.background.height / 2 - height / 2
                width: 16
                height: 16
                color: "#55aaff"
                radius: 8
                antialiasing: true
                opacity: dialA.enabled ? 1 : 0.3
                transform: [
                    Translate {
                        y: -Math.min(dialA.background.width, dialA.background.height) * 0.4 + handleItemA.height / 2
                    },
                    Rotation {
                        angle: dialA.angle
                        origin.x: handleItemA.width / 2
                        origin.y: handleItemA.height / 2
                    }
                ]
            }

            Label {
                anchors.centerIn: parent
                text: dialA.value.toFixed(0) + "°"
                color: "#33334c"
                font.pixelSize: 24
                font.bold: true
            }

            Label {
                anchors.top: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 5
                text: "Elbow"
                color: "#33334c"
                font.pixelSize: 18
                font.bold: true
            }
        }

        Dial {
            id: dialB
            x: 8
            y: 206
            width: 120
            height: 120
            stepSize : 1
            to : 90

            background: Rectangle {
                x: dialB.width / 2 - width / 2
                y: dialB.height / 2 - height / 2
                width: Math.max(64, Math.min(dialB.width, dialB.height))
                height: width
                color: "transparent"
                radius: width / 2
                border.color: "#33334c"
                border.width: 4
                opacity: dialB.enabled ? 1 : 0.3
            }

            handle: Rectangle {
                id: handleItemB
                x: dialB.background.x + dialB.background.width / 2 - width / 2
                y: dialB.background.y + dialB.background.height / 2 - height / 2
                width: 16
                height: 16
                color: "#55aaff"
                radius: 8
                antialiasing: true
                opacity: dialB.enabled ? 1 : 0.3
                transform: [
                    Translate {
                        y: -Math.min(dialB.background.width, dialB.background.height) * 0.4 + handleItemB.height / 2
                    },
                    Rotation {
                        angle: dialB.angle
                        origin.x: handleItemB.width / 2
                        origin.y: handleItemB.height / 2
                    }
                ]
            }

            Label {
                anchors.centerIn: parent
                text: dialB.value.toFixed(0) + "°"
                color: "#33334c"
                font.pixelSize: 24
                font.bold: true
            }

            Label {
                anchors.top: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 5
                text: "Shoulder"
                color: "#33334c"
                font.pixelSize: 18
                font.bold: true
            }
        }

        CustomButton {
            id: customButton
            y: 489
            width: 220
            height: 30
            text: "Wear"
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: 20
            anchors.bottomMargin: 20
            colorPressed: "#55aaff"
            colorMouseOver: "#40405f"
            colorDefault: "#33334c"
            onClicked:{
                var shoulder_w=dialB.value.toFixed(0)
                var elbow_w=dialA.value.toFixed(0)
                // console.log(dialA.value.toFixed(0)+"==="+dialB.value.toFixed(0))
                backend.btnWear(shoulder_w,elbow_w);
            }
        }



    }

    Timeline {
        id: timeline
        animations: [
            TimelineAnimation {
                id: timelineAnimation
                running: true
                loops: 1
                duration: 3000
                to: 3000
                from: 0
            }
        ]
        enabled: true
        startFrame: 0
        endFrame: 3000

        KeyframeGroup {
            target: circularProgressBar
            property: "value"
            Keyframe {
                value: 100
                frame: 1397
            }

            Keyframe {
                value: 0
                frame: 0
            }
        }

        KeyframeGroup {
            target: circularProgressBar
            property: "opacity"
            Keyframe {
                value: 1
                frame: 1299
            }

            Keyframe {
                value: 0
                frame: 1601
            }
        }

        KeyframeGroup {
            target: imgShoulder
            property: "opacity"
            Keyframe {
                value: 0
                frame: 1499
            }

            Keyframe {
                value: 1
                frame: 1996
            }

            Keyframe {
                value: 0
                frame: 0
            }
        }

        KeyframeGroup {
            target: imgElbow
            property: "opacity"
            Keyframe {
                value: 0
                frame: 1499
            }

            Keyframe {
                value: 1
                frame: 1996
            }

            Keyframe {
                value: 0
                frame: 0
            }
        }


    }

    Connections {
        target : backend

        function onPassiveArm(val1, val2) {
            // console.log(val1)
            dialA.value = parseInt(val1);
            dialB.value = parseInt(val2);
        }

    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#c0c0c0";formeditorZoom:0.75;height:580;width:800}
D{i:7}D{i:21;property:"opacity";target:"labelNoInternet"}D{i:8}
}
##^##*/
