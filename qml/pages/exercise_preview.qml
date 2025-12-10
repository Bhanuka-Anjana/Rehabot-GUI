import QtQuick 2.0
import "../components"
import QtQuick.Timeline 1.0
import QtQuick.Controls 2.15

Item {
    id: item1
    width: 800
    height: 580

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
            x : 506
            y : 207
            width : 206
            height : 232
            source : "../../images/shoulder.jpg"
            transformOrigin : Item.Top
//            rotation : dialB.value
            Image {
                id : imgElbow
                x : -28
                y : 165
                width : 281
                height : 284
                source : "../../images/elbow.png"
                transformOrigin : Item.Top
//                rotation : dialA.value
                fillMode : Image.PreserveAspectFit
            }
            //            rotation: 0
            fillMode : Image.PreserveAspectFit
        }

        Text {
            id: text1
            x: 389
            y: 27
            text: qsTr("exercise_name")
            font.pixelSize: 20
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        GroupBox {
            id: groupBox
            x: 29
            y: 90
            width: 90
            height: 87
            font.pointSize: 12
            title: qsTr("Shoulder")

            Text {
                id: text2
                x: 0
                text: qsTr("Max:")
                anchors.top: parent.top
                font.pixelSize: 12
                anchors.topMargin: 5
            }

            Text {
                id: text3
                x: 0
                text: qsTr("Min:")
                anchors.top: text2.bottom
                font.pixelSize: 12
                anchors.topMargin: 5
            }

            Text {
                id: text4
                x: 42
                text: qsTr("90")
                anchors.top: parent.top
                font.pixelSize: 12
                anchors.topMargin: 5
            }

            Text {
                id: text5
                x: 42
                text: qsTr("15")
                anchors.top: text4.bottom
                font.pixelSize: 12
                anchors.topMargin: 5
            }
        }

        GroupBox {
            id: groupBox1
            x: 29
            width: 90
            height: 87
            anchors.top: groupBox.bottom
            anchors.topMargin: 10
            title: qsTr("Elbow")
            Text {
                id: text6
                x: 0
                text: qsTr("Max:")
                anchors.top: parent.top
                font.pixelSize: 12
                anchors.topMargin: 5
            }

            Text {
                id: text7
                x: 0
                text: qsTr("Min:")
                anchors.top: text6.bottom
                font.pixelSize: 12
                anchors.topMargin: 5
            }

            Text {
                id: text8
                x: 42
                text: qsTr("90")
                anchors.top: parent.top
                font.pixelSize: 12
                anchors.topMargin: 5
            }

            Text {
                id: text9
                x: 42
                text: qsTr("15")
                anchors.top: text8.bottom
                font.pixelSize: 12
                anchors.topMargin: 5
            }
            font.pointSize: 12
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

}

/*##^##
Designer {
    D{i:0;formeditorColor:"#c0c0c0";formeditorZoom:0.5}D{i:7}D{i:8}D{i:9}D{i:10}D{i:11}
D{i:29;property:"opacity";target:"labelNoInternet"}D{i:16}
}
##^##*/
