import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import "components"
import QtQuick.Timeline 1.0

Window {
    id : splashScreen
    width : 380
    height : 580
    visible : true
    color : "#00000000"
    title : qsTr("Hello World")

    Item {
        id: nameyte
        focus: true
        Keys.onPressed: {
                console.log("Pressed")
            }
        Keys.onReleased: {
            console.log("AASSDD")
        }
    }

    // Remove Title Bar
    flags : Qt.SplashScreen | Qt.FramelessWindowHint
    modality: Qt.ApplicationModal

    Loader {
        id: squareLoader
        // source: "main.qml"
        onLoaded: console.log("ADOO 123");
    }


    // Internal Functions
    QtObject {
        id : internalWelcomePage

        function checkLogin(idPatient, idDoctor, mode) {
            // console.log(idPatient)
            // console.log(idDoctor)
            // console.log(mode)
            // if(username === "wanderson" || password === "123456"){
            if(mode==='Passive'){
//                console.log(mode+" - "+idPatient+" -- "+idDoctor)
                // var componentA = Qt.createComponent("main.qml")
                // var winA = componentA.createObject()
                // winA.idPatient = idPatient
                // winA.idDoctor = idDoctor
                // winA.mode = mode
                // winA.show()
                // squareLoader.source="main.qml"
                squareLoader.setSource("main.qml",
                             { "idPatient": idPatient,"idDoctor": idDoctor });
                visible = false
            }
            else{
//                console.log(mode+" - "+idPatient+" -- "+idDoctor)
                var componentB = Qt.createComponent("main_mirror.qml")
                var winB = componentB.createObject()
                winB.idPatient = idPatient
                winB.idDoctor = idDoctor
                winB.mode = mode
                winB.show()
                visible = false
            }



            // }
        }

        function request(url, callback) {
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = (function (myxhr) {
                return function () {
                    if (myxhr.readyState === 4)
                        callback(myxhr);
                }
            })(xhr);
            xhr.open('GET', url, true);
            xhr.send('');
        }



    }


    Rectangle {
        id : bg
        x : 78
        y : 131
        width : 360
        height : 560
        color : "#151515"
        radius : 10
        anchors.verticalCenter : parent.verticalCenter
        anchors.horizontalCenter : parent.horizontalCenter
        z : 1

        CircularProgressBar {
            id : circularProgressBar
            x : 55
            y : 198
            opacity : 0
            anchors.verticalCenter : parent.verticalCenter
            value : 100
            progressWidth : 8
            strokeBgWidth : 4
            progressColor : "#1761a0"
            anchors.horizontalCenter : parent.horizontalCenter
        }

        Image {
            id : logoImage
            x : 85
            width : 250
            height : 250
            opacity : 1
            anchors.top : parent.top
            source : "../images/logo_rehabot.png"
            anchors.topMargin : 0
            anchors.horizontalCenter : parent.horizontalCenter
            fillMode : Image.PreserveAspectFit
        }


        // CustomTextField {
        //     id : dropdownPatient
        //     x : 30
        //     y : 365
        //     opacity : 1
        //     anchors.bottom : dropdownDoctor.top
        //     anchors.bottomMargin : 10
        //     anchors.horizontalCenter : parent.horizontalCenter
        //     placeholderText : "Username or email"
        // }

        CustomComboField {
            id : dropdownPatient
            x : 30
            y : 365
            opacity : 1
            anchors.bottom : label3.top
            anchors.bottomMargin : 10
            anchors.horizontalCenter : parent.horizontalCenter
            // placeholderText : "Username or email"
            colorMouseOver : "#808da7"
            colorOnFocus : "#8392b3"
            colorDefault : "#adbee1"
            displayText : ""
            flat : true
            currentIndex : -1
            width : 300
            height : 40
            editable : true
            textRole : "key"
            valueRole : "value"
            model : ListModel {
                id : modelPatient
            }

            Component.onCompleted : {
                // internalWelcomePage.request('https://rehabot.chamara.cc/patlist', function (o) {
                //     var arrnew = eval('new Object(' + o.responseText + ')');
                //     for (var i = 0; i < arrnew.length; i++) {
                //         modelPatient.append({
                //             value: arrnew[i].id,
                //             key: arrnew[i].nic + " - " + arrnew[i].f_name
                //         });
                //     }
                // });
                modelPatient.append({
                   key:"Test Patient",
                   value:"1"
                })
            }

            onAccepted : {
                if (find(editText) === -1) 
                    modelPatient.append({text: editText})
                currentIndex = dropdownDoctor.find(editText)
            }
        }


        CustomComboField {
            id : dropdownDoctor
            x : 30
            y : 160
            opacity : 1
            anchors.bottom : btnPassive.top
            colorMouseOver : "#808da7"
            colorOnFocus : "#8392b3"
            colorDefault : "#adbee1"
            // displayText : "Size: " + currentText
            flat : true
            currentIndex : -1
            anchors.bottomMargin : 10
            anchors.horizontalCenter : parent.horizontalCenter
            width : 300
            height : 40
            editable : true
            textRole : "key"
            valueRole : "value"
            model : ListModel {
                id : modelDoctor
            }
            Component.onCompleted : {
                // internalWelcomePage.request('https://rehabot.chamara.cc/doclist', function (o) {
                //     var arrnew = eval('new Object(' + o.responseText + ')');
                //     for (var i = 0; i < arrnew.length; i++) {
                //         modelDoctor.append({
                //             value: arrnew[i].id,
                //             key: arrnew[i].reg_no + " - " + arrnew[i].f_name
                //         });
                //     }
                // });
                modelDoctor.append({
                    key: "Test Doctor",
                    value:"2"
                });
            }
            onAccepted : {
                if (find(editText) === -1) 
                    modelDoctor.append({text: editText})
                
                currentIndex = dropdownDoctor.find(editText)
            }
        }

        CustomButton {
            id : btnPassive
            x : 30
            y : 469
            width : 300
            height : 40
            opacity : 0
            visible : true
            text : "Passive"
            anchors.bottom : btnActive.top
            font.pointSize : 10
            font.family : "Segoe UI"
            colorPressed : "#0b2f4e"
            colorMouseOver : "#135186"
            colorDefault : "#1761a0"
            anchors.bottomMargin : 10
            anchors.horizontalCenter : parent.horizontalCenter
            onClicked : internalWelcomePage.checkLogin(dropdownPatient.currentValue, dropdownDoctor.currentValue, 'Passive')
        }

        Label {
            id : label1
            x : 55
            y : 260
            opacity : 1
            color : "#ffffff"
            text : qsTr("Select Patient and Doctor")
            anchors.bottom : dropdownPatient.top
            anchors.bottomMargin : 33
            anchors.horizontalCenterOffset : 0
            font.family : "Segoe UI"
            anchors.horizontalCenter : parent.horizontalCenter
            font.pointSize : 10
        }

        Label {
            id : label
            x : 100
            y : 222
            opacity : 1
            color : "#ffffff"
            text : qsTr("Final Year Project")
            anchors.bottom : label1.top
            anchors.horizontalCenterOffset : 0
            anchors.bottomMargin : 0
            font.family : "Segoe UI"
            font.pointSize : 16
            anchors.horizontalCenter : parent.horizontalCenter
        }

        CustomButton {
            id : btnClose
            x : 20
            width : 30
            height : 30
            opacity : 1
            text : "X"
            anchors.right : parent.right
            anchors.top : parent.top
            anchors.topMargin : 15
            anchors.rightMargin : 15
            colorPressed : "#0b2f4e"
            font.family : "Segoe UI"
            colorMouseOver : "#135186"
            colorDefault : "#1761a0"
            font.pointSize : 10
            onClicked : splashScreen.close()
        }

        CustomButton {
            id : btnActive
            x : 20
            y : 475
            width : 300
            height : 40
            opacity : 0
            visible : true
            text : "Passive Mirror"
//            anchors.bottom : btnAssistive.top
            anchors.horizontalCenter : parent.horizontalCenter
            anchors.bottomMargin : 10
            colorPressed : "#0b2f4e"
            font.family : "Segoe UI"
            font.pointSize : 10
            colorMouseOver : "#135186"
            colorDefault : "#1761a0"
            onClicked : internalWelcomePage.checkLogin(dropdownPatient.currentValue, dropdownDoctor.currentValue, "Mirror")
        }

//        CustomButton {
//            id : btnAssistive
//            x : 26
//            y : 478
//            width : 300
//            height : 40
//            opacity : 0
//            visible : true
//            text : "Testing"
//            anchors.bottom : parent.bottom
//            anchors.horizontalCenter : parent.horizontalCenter
//            anchors.bottomMargin : 10
//            colorPressed : "#558b1f"
//            font.family : "Segoe UI"
//            font.pointSize : 10
//            colorDefault : "#67aa25"
//            colorMouseOver : "#7ece2d"
//            onClicked : internal.checkLogin(dropdownPatient.currentText, dropdownDoctor.currentText, 'Assistive')
//        }

        Label {
            id : label2
            y : 286
            width : 81
            height : 13
            color : "#ffffff"
            text : qsTr("Patient")
            anchors.left : dropdownPatient.left
            anchors.bottom : dropdownPatient.top
            anchors.leftMargin : 0
            anchors.bottomMargin : 5
        }

        Label {
            id : label3
            y : 348
            width : 81
            height : 13
            color : "#ffffff"
            text : qsTr("Doctor")
            anchors.left : dropdownDoctor.left
            anchors.bottom : dropdownDoctor.top
            anchors.leftMargin : 0
            anchors.bottomMargin : 5
        }

    }

    DropShadow {
        anchors.fill : bg
        source : bg
        verticalOffset : 0
        horizontalOffset : 0
        radius : 10
        color : "#40000000"
        z : 0
    }

    Timeline {
        id : timeline
        animations : [TimelineAnimation {
                id : timelineAnimation
                duration : 3000
                running : true
                loops : 1
                to : 3000
                from : 0
            }
        ]
        enabled : true
        startFrame : 0
        endFrame : 3000

        KeyframeGroup {
            target : circularProgressBar
            property : "value"
            Keyframe {
                frame : 0
                value : 0
            }

            Keyframe {
                frame : 1300
                value : 100
            }
        }

        KeyframeGroup {
            target : circularProgressBar
            property : "opacity"
            Keyframe {
                frame : 1301
                value : 1
            }

            Keyframe {
                frame : 1800
                value : 0
            }

            Keyframe {
                frame : 0
                value : 1
            }
        }

        KeyframeGroup {
            target : logoImage
            property : "opacity"
            Keyframe {
                frame : 1801
                value : 0
            }

            Keyframe {
                frame : 2300
                value : 1
            }

            Keyframe {
                frame : 0
                value : 0
            }
        }

        KeyframeGroup {
            target : label
            property : "opacity"
            Keyframe {
                frame : 1899
                value : 0
            }

            Keyframe {
                frame : 2396
                value : 1
            }

            Keyframe {
                frame : 0
                value : 0
            }
        }

        KeyframeGroup {
            target : label1
            property : "opacity"
            Keyframe {
                frame : 1996
                value : 0
            }

            Keyframe {
                frame : 2504
                value : 1
            }

            Keyframe {
                frame : 0
                value : 0
            }
        }

        KeyframeGroup {
            target : dropdownPatient
            property : "opacity"
            Keyframe {
                frame : 2097
                value : 0
            }

            Keyframe {
                frame : 2652
                value : 1
            }

            Keyframe {
                frame : 0
                value : 0
            }
        }

        KeyframeGroup {
            target : dropdownDoctor
            property : "opacity"
            Keyframe {
                frame : 2198
                value : 0
            }

            Keyframe {
                frame : 2796
                value : 1
            }

            Keyframe {
                frame : 0
                value : 0
            }
        }

        KeyframeGroup {
            target : label2
            property : "opacity"
            Keyframe {
                frame : 2097
                value : 0
            }

            Keyframe {
                frame : 2652
                value : 1
            }

            Keyframe {
                frame : 0
                value : 0
            }
        }

        KeyframeGroup {
            target : label3
            property : "opacity"
            Keyframe {
                frame : 2198
                value : 0
            }

            Keyframe {
                frame : 2796
                value : 1
            }

            Keyframe {
                frame : 0
                value : 0
            }
        }


        KeyframeGroup {
            target : btnPassive
            property : "opacity"
            Keyframe {
                frame : 2298
                value : 0
            }

            Keyframe {
                frame : 2951
                value : 1
            }

            Keyframe {
                frame : 0
                value : 0
            }
        }

        KeyframeGroup {
            target : btnActive
            property : "opacity"
            Keyframe {
                frame : 2398
                value : 0
            }

            Keyframe {
                frame : 2951
                value : 1
            }

            Keyframe {
                frame : 0
                value : 0
            }
        }

//        KeyframeGroup {
//            target : btnAssistive
//            property : "opacity"
//            Keyframe {
//                frame : 2498
//                value : 0
//            }

//            Keyframe {
//                frame : 2951
//                value : 1
//            }

//            Keyframe {
//                frame : 0
//                value : 0
//            }
//        }

        KeyframeGroup {
            target : bg
            property : "height"
            Keyframe {
                frame : 1301
                value : 360
            }

            Keyframe {
                easing.bezierCurve : [
                    0.221,
                    -0.00103,
                    0.222,
                    0.997,
                    1,
                    1
                ]
                frame : 1899
                value : 560
            }

            Keyframe {
                frame : 0
                value : 360
            }
        }
    }
}
