import QtQuick 2.0
//import QtQuick 2.15
import "../components"
import QtQuick.Timeline 1.0
import QtQuick.Controls 2.15

Item {
    id: item1

    property variant exerArray

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
//            rotation : parseInt(s_MAX.text)
            PropertyAnimation {
                id: aminShoulder
                target: imgShoulder
                property: "rotation"
//                from: s_MIN.text
//                to: s_MAX.text
                duration: 5000
                loops: Animation.Infinite
                easing.type: Easing.OutQuad
                running: true
            }


            Image {
                id : imgElbow
                x : -28
                y : 165
                width : 281
                height : 284
                source : "../../images/virtual_arm/elbow.png"
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
            text: exerArray.name
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
                id: s_MAX
                x: 42
                text: exerArray.s_max
                anchors.top: parent.top
                font.pixelSize: 12
                anchors.topMargin: 5
            }

            Text {
                id: s_MIN
                x: 42
                text: exerArray.s_min
                anchors.top: s_MAX.bottom
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
                id: e_MAX
                x: 42
                text: exerArray.e_max
                anchors.top: parent.top
                font.pixelSize: 12
                anchors.topMargin: 5
            }

            Text {
                id: e_MIN
                x: 42
                text: exerArray.e_min
                anchors.top: e_MAX.bottom
                font.pixelSize: 12
                anchors.topMargin: 5
            }
            font.pointSize: 12
        }


        CustomButton {
                    id: btnChangeuSER
                    x: 350
                    width: 140
                    height: 30
                    opacity: 1
                    text: "Back to Home"
                    anchors.right: parent.right
                    anchors.top: parent.top
                    font.pointSize: 8
                    font.bold: true
                    anchors.rightMargin: 10
                    anchors.topMargin: 10
                    colorPressed: "#55aaff"
                    colorMouseOver: "#40405f"
                    colorDefault: "#40405f"
                    CustomToolTip{
                        text: "Change user"
                    }
                    onClicked: {
                        stackView.push(Qt.resolvedUrl("passive.qml"))
                    }
                }


        Component.onCompleted: {
//              console.log("Exercise Component Loaded")

            aminShoulder.from = parseInt(exerArray.s_max);
            aminShoulder.to = parseInt(exerArray.s_min);

//            rotateImgEL.from = parseInt(e_MIN.text);
//            rotateImgEL.to = parseInt(e_MAX.text);

//            imgShoulder.rotation = 0;
//            imgElbow.rotation = 0;

//            rotateImgSH.direction = RotationAnimation.Clockwise;
//            rotateImgEL.direction = RotationAnimation.Clockwise;

//            rotateImgSH.start();
//            rotateImgEL.start();
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
    D{i:0;autoSize:true;formeditorColor:"#c0c0c0";formeditorZoom:0.75;height:580;width:800}
D{i:22;property:"opacity";target:"labelNoInternet"}D{i:19}
}
##^##*/
