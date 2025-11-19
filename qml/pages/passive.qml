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
            stepSize : 1
            to : 90
        }

        Dial {
            id: dialB
            x: 8
            y: 206
            stepSize : 1
            to : 90
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
