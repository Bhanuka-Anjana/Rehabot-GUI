import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects
import "../components"
import QtQuick.Timeline 1.0

Item {

    property bool showValue: true
    height: 500

    Flickable {
        id: flickable
        opacity: 0
        anchors.fill: parent
        contentHeight: gridLayout.height
        clip: true

        GridLayout {
            id: gridLayout
            height: 500
            columns: 1
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            columnSpacing: 10
            rows: 3

            Rectangle{
                id: card
                color: "#27273a"
                height: 500
                width: flickable.width
                radius: 10

                Rectangle {
                    id: whiteCard_1
                    width: 340
                    color: "#ffffff"
                    radius: 10
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 10
                    anchors.bottomMargin: 10
                    anchors.topMargin: 10

                    Image {
                        id: iconCart
                        sourceSize.height: 30
                        sourceSize.width: 30
                        anchors.topMargin: 15
                        anchors.leftMargin: 15
                        height: 30
                        width: 30
                        visible: false
                        anchors.left: parent.left
                        anchors.top: parent.top
                        source: "../../images/svg_images/cart_icon.svg"
                        fillMode: Image.PreserveAspectFit
                        antialiasing: false
                    }

                    ColorOverlay{
                        anchors.fill: iconCart
                        source: iconCart
                        color: "#7f7f7f"
                        antialiasing: false
                    }

                    Label {
                        id: labelTitleBar
                        x: 58
                        y: 20
                        color: "#767676"
                        text: qsTr("Credit Card")
                        font.bold: true
                        font.pointSize: 11
                        font.family: "Segoe UI"
                    }

                    Label {
                        id: labelTitleBar1
                        x: 15
                        y: 129
                        color: "#767676"
                        text: qsTr("Current")
                        font.pointSize: 10
                        font.family: "Segoe UI"
                    }

                    Label {
                        id: labelTitleBar2
                        x: 13
                        y: 138
                        color: "#55aaff"
                        text: qsTr("$ 3.605")
                        font.bold: true
                        font.pointSize: 20
                        font.family: "Segoe UI"
                        visible: showValue
                    }

                    Label {
                        id: labelTitleBar3
                        x: 14
                        y: 170
                        color: "#767676"
                        text: "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\np, li { white-space: pre-wrap; }\n</style></head><body style=\" font-family:'MS Shell Dlg 2'; font-size:8.25pt; font-weight:400; font-style:normal;\">\n<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Limit: <span style=\" font-weight:600; color:#55aa00;\">$ 6.500</span></p></body></html>"
                        textFormat: Text.RichText
                        font.pointSize: 10
                        font.family: "Segoe UI"
                        visible: showValue
                    }

                    CustomButton {
                        x: 227
                        y: 153
                        width: 108
                        height: 30
                        text: "ACCESS"
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.rightMargin: 15
                        colorMouseOver: "#40405f"
                        colorPressed: "#55aaff"
                        colorDefault: "#33334c"
                        anchors.bottomMargin: 17
                    }

                    Rectangle {
                        id: hideValue_1
                        x: 8
                        y: 146
                        width: 187
                        height: 44
                        color: "#ebfcff"
                        radius: 5
                        visible: !showValue
                    }
                }

                Label {
                    id: labelContaInfo
                    y: 140
                    height: 50
                    opacity: 1
                    color: "#b907ff"
                    text: "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\np, li { white-space: pre-wrap; }\n</style></head><body style=\" font-family:'MS Shell Dlg 2'; font-size:8.25pt; font-weight:400; font-style:normal;\">\n<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-size:10pt; color:#ffffff;\">Gastos</span><span style=\" font-size:10pt; color:#da7dff;\">: gastos referentes ao mês de Dezembro </span></p>\n<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-size:10pt; color:#ffffff;\">Cartão final</span><span style=\" font-size:10pt; color:#da7dff;\">: XXX XXX XXX 1510 </span></p>\n<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-size:10pt; color:#ffffff;\">Bandeira</span><span style=\" font-size:10pt; color:#da7dff;\">: Master Card Platinium</span></p></body></html>"
                    anchors.left: whiteCard_1.right
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    verticalAlignment: Text.AlignBottom
                    anchors.rightMargin: 15
                    anchors.bottomMargin: 30
                    anchors.leftMargin: 40
                    font.bold: false
                    font.pointSize: 10
                    font.family: "Segoe UI"
                    font.weight: Font.Normal
                    textFormat: Text.RichText
                    anchors.topMargin: 5
                }

                Rectangle {
                    id: greenBar
                    height: 10
                    opacity: 0
                    color: "#55ff7f"
                    radius: 5
                    anchors.left: whiteCard_1.right
                    anchors.right: parent.right
                    anchors.top: parent.top
                    clip: true
                    anchors.topMargin: 30
                    anchors.rightMargin: 15
                    anchors.leftMargin: 400

                    Rectangle {
                        id: blueBar
                        x: 395
                        width: parent.width / 2
                        height: 10
                        color: "#55aaff"
                        radius: 5
                        anchors.right: parent.right
                        anchors.rightMargin: 1
                        clip: true
                    }

                    Rectangle {
                        id: orangeBar
                        x: 10
                        y: 0
                        width: parent.width / 4
                        height: 10
                        color: "#ff5500"
                        radius: 5
                        anchors.right: parent.right
                        anchors.rightMargin: 0
                        clip: true
                    }
                }

                GridLayout {
                    id: textsFatura
                    x: 402
                    y: 52
                    anchors.left: whiteCard_1.right
                    anchors.right: parent.right
                    anchors.top: greenBar.bottom
                    anchors.topMargin: 10
                    anchors.rightMargin: 15
                    anchors.leftMargin: 40
                    rows: 2
                    columns: 3

                    Label {
                        id: textValue_1
                        color: "#55ff7f"
                        text: qsTr("$ 6.500")
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.pointSize: 14
                        font.bold: true
                        font.family: "Segoe UI"
                        visible: showValue
                    }

                    Label {
                        id: textValue_2
                        color: "#55aaff"
                        text: qsTr("$ 3.605")
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.pointSize: 14
                        font.bold: true
                        font.family: "Segoe UI"
                        visible: showValue
                    }

                    Label {
                        id: textValue_3
                        color: "#ff5500"
                        text: qsTr("$ 2.805")
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.pointSize: 14
                        font.bold: true
                        font.family: "Segoe UI"
                        visible:  showValue
                    }

                    Label {
                        id: labelTitleBar20
                        color: "#ffffff"
                        text: qsTr("available")
                        font.pointSize: 9
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.bold: false
                        font.family: "Segoe UI"
                        visible: showValue
                    }

                    Label {
                        id: labelTitleBar21
                        color: "#ffffff"
                        text: qsTr("current")
                        font.pointSize: 9
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.bold: false
                        font.family: "Segoe UI"
                        visible: showValue
                    }

                    Label {
                        id: labelTitleBar22
                        color: "#ffffff"
                        text: qsTr("next")
                        font.pointSize: 9
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.bold: false
                        font.family: "Segoe UI"
                        visible: showValue
                    }
                }

            }
        }
        ScrollBar.vertical: ScrollBar {
            id: control
            size: 0.3
            position: 0.2
            orientation: Qt.Vertical
            visible: flickable.moving || flickable.moving

            contentItem: Rectangle {
                implicitWidth: 6
                implicitHeight: 100
                radius: width / 2
                color: control.pressed ? "#55aaff" : "#40405f"
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
                duration: 1000
                to: 1000
                from: 0
            }
        ]
        endFrame: 1000
        enabled: true
        startFrame: 0

        KeyframeGroup {
            target: flickable
            property: "opacity"
            Keyframe {
                frame: 550
                value: 1
            }

            Keyframe {
                frame: 0
                value: 0
            }
        }

        KeyframeGroup {
            target: greenBar
            property: "anchors.leftMargin"
            Keyframe {
                easing.bezierCurve: [0.254,0.00129,0.235,0.999,1,1]
                value: 40
                frame: 850
            }

            Keyframe {
                value: 400
                frame: 399
            }

            Keyframe {
                value: 400
                frame: 0
            }
        }

        KeyframeGroup {
            target: greenBar
            property: "opacity"
            Keyframe {
                value: 1
                frame: 650
            }

        }

    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#c0c0c0";formeditorZoom:0.66;height:800;width:800}
D{i:33;property:"anchors.leftMargin";target:"greenBar"}D{i:26}
}
##^##*/
