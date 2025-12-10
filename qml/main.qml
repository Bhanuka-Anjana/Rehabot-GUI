import QtQuick 2.15
import QtQuick.Window 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Timeline 1.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"
import "pages"

Window {
    width: 1300
    height: 720
    minimumWidth: 1300
    minimumHeight: 850
    visible: true
    color: "#00000000"
    id: mainWindow
    title: qsTr("RehaBot v1.0")

    // Remove title bar
    flags: Qt.Window | Qt.FramelessWindowHint

    // Text Edit Properties
    property alias actualPage: stackView.currentItem
    property bool isValueVisible: true
    property int windowStatus: 0
    property int windowMargin: 10
    property int bgRadius: 20

    // Custom Properties
    property string idPatient
    property string idDoctor
    property string mode


    onIdPatientChanged : {
        // var myurl = 'https://rehabot.chamara.cc/patdetails?pat_id=' + idPatient;
        // internalMain.request(myurl, function (o) {
        //     var objPatient = eval('new Object(' + o.responseText + ')');
        //     console.log(o.responseText);
        //     label_patName.btnValue = objPatient.f_name + " " + objPatient.l_name;
        //     label_patNic.btnValue = objPatient.nic;
        //     label_patDob.btnValue = objPatient.dof;
        //     label_patAddress.btnValue = objPatient.address;
        //     label_patContact.btnValue = objPatient.contact_no;
        //     imagePatient.source = "https://rehabot.chamara.cc/storage/images/patient/" + objPatient.photo;
        // });
        label_patName.btnValue = "Test Patient";
    }

    onIdDoctorChanged : {
        // var myurl = 'https://rehabot.chamara.cc/docdetails?doc_id=' + idDoctor;
        // internalMain.request(myurl, function (o) {
        //     var objDoctor = eval('new Object(' + o.responseText + ')');
        //     console.log(o.responseText);
        //     label_docName.btnValue = objDoctor.f_name + " " + objDoctor.l_name;
        //     label_docNic.btnValue = objDoctor.nic;
        //     imageDoctor.source = "https://rehabot.chamara.cc/storage/images/doctor/" + objDoctor.photo;
        // });
        label_docName.btnValue = "Test Doctor";
    }

    // Internal functions
    QtObject{
        id: internalMain

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

        //        ===============================================

        function resetResizeBorders(){
            // Resize visibility
            resizeLeft.visible = true
            resizeRight.visible = true
            resizeBottom.visible = true
            resizeApp.visible = true
            bg.radius = bgRadius
            bg.border.width = 3
        }

        function maximizeRestore(){
            if(windowStatus == 0){
                mainWindow.showMaximized()
                windowStatus = 1
                windowMargin = 0
                // Resize visibility
                resizeLeft.visible = false
                resizeRight.visible = false
                resizeBottom.visible = false
                resizeApp.visible = false
                bg.radius = 0
                bg.border.width = 0
                btnMaximizeRestore.btnIconSource = "../images/restore_icon.svg"
            }
            else{
                mainWindow.showNormal()
                windowStatus = 0
                windowMargin = 10
                // Resize visibility
                internalMain.resetResizeBorders()
                bg.border.width = 3
                btnMaximizeRestore.btnIconSource = "../images/maximize_icon.svg"
            }
        }

        function ifMaximizedWindowRestore(){
            if(windowStatus == 1){
                mainWindow.showNormal()
                windowStatus = 0
                windowMargin = 10
                // Resize visibility
                internalMain.resetResizeBorders()
                bg.border.width = 3
                btnMaximizeRestore.btnIconSource = "../images/maximize_icon.svg"
            }
        }

        function restoreMargins(){
            windowStatus = 0
            windowMargin = 10
            bg.radius = bgRadius
            // Resize visibility
            internalMain.resetResizeBorders()
            bg.border.width = 3
            btnMaximizeRestore.btnIconSource = "../images/maximize_icon.svg"
        }
    }

    Rectangle {
        id: bg
        opacity: 0
        color: "#1d1d2b"
        radius: 20
        border.color: "#33334c"
        border.width: 3
        anchors.fill: parent
        anchors.margins: windowMargin
        clip: true
        z: 1

        TopBarButton {
            id: btnClose
            x: 1140
            visible: true
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 8
            btnColorClicked: "#55aaff"
            btnColorMouseOver: "#ff007f"
            anchors.topMargin: 8
            btnIconSource: "../images/close_icon.svg"
            CustomToolTip {
                text: "Sair"
            }
            onPressed: mainWindow.close()
        }

        TopBarButton {
            id: btnMaximizeRestore
            x: 1105
            visible: true
            anchors.right: btnClose.left
            anchors.top: parent.top
            anchors.rightMargin: 0
            anchors.topMargin: 8
            btnColorMouseOver: "#40405f"
            btnColorClicked: "#55aaff"
            btnIconSource: "../images/maximize_icon.svg"
            CustomToolTip {
                text: "Maximizar"
            }
            onClicked: internalMain.maximizeRestore()
        }

        TopBarButton {
            id: btnMinimize
            x: 1070
            visible: true
            anchors.right: btnMaximizeRestore.left
            anchors.top: parent.top
            btnRadius: 17
            anchors.rightMargin: 0
            btnColorClicked: "#55aaff"
            btnColorMouseOver: "#40405f"
            anchors.topMargin: 8
            btnIconSource: "../images/minimize_icon.svg"
            CustomToolTip {
                text: "Minimizar"
            }
            onClicked: {
                mainWindow.showMinimized()
                internalMain.restoreMargins()
            }
        }

        Rectangle {
            id: titleBar
            height: 40
            color: "#33334c"
            radius: 14
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 120
            anchors.leftMargin: 8
            anchors.topMargin: 8

            DragHandler { onActiveChanged: if(active){
                                               mainWindow.startSystemMove()
                                               internalMain.ifMaximizedWindowRestore()
                                           }
            }

            Image {
                id: iconTopLogo
                y: 5
                width: 46
                height: 40
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                source: "../images/2.svg"
                sourceSize.height: 50
                sourceSize.width: 50
                anchors.leftMargin: 15
                fillMode: Image.PreserveAspectFit
            }

            Label {
                id: labelTitleBar
                y: 14
                color: "#ffffff"
                text: qsTr("Rehabot - Upper Limb Rehabilitation Robot")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: iconTopLogo.right
                font.pointSize: 12
                font.family: "Segoe UI"
                anchors.leftMargin: 15
            }
        }

        //        Column {
        //            id: columnCircularButtons
        //            width: 50
        //            anchors.left: parent.left
        //            anchors.top: titleBar.bottom
        //            anchors.bottom: flickable.top
        //            spacing: 5
        //            anchors.bottomMargin: 10
        //            anchors.topMargin: 10
        //            anchors.leftMargin: 15

        //            CustomCircularButton {
        //                id: btnHome
        //                width: 50
        //                height: 50
        //                visible: true
        //                CustomToolTip {
        //                    text: "Página inicial"
        //                }
        //                btnIconSource: "../images/home_icon.svg"
        //                onClicked: {
        //                    stackView.push(Qt.resolvedUrl("pages/homePage.qml"))
        //                    actualPage.showValue = isValueVisible
        //                }
        //            }
        //            CustomCircularButton {
        //                id: btnSettings
        //                width: 50
        //                height: 50
        //                visible: true
        //                CustomToolTip {
        //                    id: settingsTooltip
        //                    text: "Configurações da conta"
        //                }
        //                btnIconSource: "../images/settings_icon.svg"
        //                // onClicked: {
        //                //     animationMenu.running = true
        //                //     if(leftMenu.width == 0){
        //                //         btnSettings.btnIconSource = "../images/close_icon_2.svg"
        //                //         settingsTooltip.text = "Ocultar configurações"
        //                //     } else {
        //                //         btnSettings.btnIconSource = "../images/settings_icon.svg"
        //                //         settingsTooltip.text = "Configurações da conta"
        //                //     }
        //                // }
        //            }
        //            CustomCircularButton {
        //                id: btnShowHide
        //                visible: true
        //                width: 50
        //                height: 50
        //                CustomToolTip {
        //                    text: "Ocultar valores da conta"
        //                }
        //                btnIconSource: "../images/eye_open_icon.svg"
        //                onClicked: {
        //                    if(isValueVisible == true){
        //                        isValueVisible = false
        //                        if(typeof actualPage.showValue !== 'undefined'){
        //                            actualPage.showValue = isValueVisible
        //                        }
        //                        btnShowHide.btnIconSource = "../images/eye_close_icon.svg"
        //                    } else{
        //                        isValueVisible = true
        //                        if(typeof actualPage.showValue !== 'undefined'){
        //                            actualPage.showValue = isValueVisible
        //                        }
        //                        btnShowHide.btnIconSource = "../images/eye_open_icon.svg"
        //                    }
        //                }
        //            }
        //        }

        Rectangle {
            id: leftMenu
            width: 240
            color: "#00000000"
            border.color: "#00000000"
            border.width: 0
            //            anchors.left: columnCircularButtons.right
            anchors.top: titleBar.bottom
            anchors.bottom: parent.bottom
            //            anchors.bottom: flickable.top
            clip: true
            anchors.bottomMargin: 15
            anchors.leftMargin: 5
            anchors.topMargin: 10

            //            PropertyAnimation{
            //                id: animationMenu
            //                target: leftMenu
            //                property: "width"
            //                to: if(leftMenu.width == 0) return 240; else return 0
            //                duration: 800
            //                easing.type: Easing.InOutQuint
            //            }

            Image {
                id: imagePatient
                width: 110
                height: 110
                source: "../images/qr-code.svg"
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
                sourceSize.width: 110
                sourceSize.height: 110
            }

            Label {
                id: labelContaInfo
                x: 39
                opacity: 1
                color: "#55aaff"
                text: "Patient ID: #000127745"
                anchors.top: imagePatient.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                textFormat: Text.RichText
                anchors.horizontalCenterOffset: 0
                font.family: "Segoe UI"
                anchors.topMargin: 10
                font.bold: false
                font.weight: Font.Normal
                font.pointSize: 8
            }

            Column {
                id: columnMenus
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: labelContaInfo.bottom
                anchors.bottom: parent.bottom
                LeftButton {
                    id: label_patName
                    text: "Name"
                    btnIconSource: "../images/user_icon.svg"
                    btnValue: "Chamara Herath"
                    // onClicked: stackView.push("pages/pageNoInternet.qml")
                }

                LeftButton {
                    id: label_patNic
                    text: "NIC"
                    btnIconSource: "../images/id_card1.svg"
                    // onClicked: stackView.push("pages/pageNoInternet.qml")
                    btnValue: "960000000V"
                }

                LeftButton {
                    id: label_patDob
                    text: "DOB"
                    btnValue: "1996-02-01"
                    btnIconSource: "../images/calendar2.svg"
                    // onClicked: stackView.push("pages/pageNoInternet.qml")
                }

                LeftButton {
                    id: label_patAddress
                    text: "Address"
                    btnValue: "Kegalle, Sri Lanka"
                    btnIconSource: "../images/home_icon.svg"
                    // onClicked: stackView.push("pages/pageNoInternet.qml")
                }

                LeftButton {
                    id: label_patContact
                    text: "Contact"
                    btnValue: "+9470 0000 000"
                    btnIconSource: "../images/phone-symbol-2.svg"
                    // onClicked: stackView.push("pages/pageNoInternet.qml")
                }
                anchors.topMargin: 10
            }

            CustomButton {
                width: 220
                height: 30
                text: "Voice"
                anchors.bottom: parent.bottom
                colorPressed: "#55aaff"
                colorMouseOver: "#40405f"
                colorDefault: "#33334c"
                anchors.bottomMargin: 0
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    console.log("VOICE COOMANDD");
                    backend.btnStart();
                }

                Image {
                    id: image1
                    x: 13
                    y: -1
                    width: 113
                    height: 31
                    source: "../images/mic_2.svg"
                    sourceSize.height: 30
                    sourceSize.width: 30
                    fillMode: Image.PreserveAspectFit
                }
            }

            CustomButton {
                id: customButton
                x: 8
                y: 349
                width: 220
                height: 30
                text: "History"
                colorPressed: "#55aaff"
                colorMouseOver: "#40405f"
                colorDefault: "#33334c"
            }

            GroupBox {
                id: groupBox2
                x: 18
                y: 391
                width: 200
                height: 87
                title: '<font color="white">Voice Command</font>'

                Text {
                    id: labelVoiceClass
                    x: 64
                    y: 25
                    color: "#ffffff"
                    // text: qsTr("Text")
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 30
                    horizontalAlignment: Text.AlignHCenter
                    font.bold: true
                    renderType: Text.QtRendering
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Image {
                id: image
                width: 134
                anchors.left: parent.left
                anchors.top: groupBox2.bottom
                anchors.bottom: parent.bottom
                source: "../images/2.svg"
                anchors.leftMargin: 0
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 10
                anchors.topMargin: 0
                sourceSize.height: 300
                sourceSize.width: 300
                fillMode: Image.PreserveAspectFit

            }
        }

        Rectangle {
            id: contentPages
            color: "#00000000"
            anchors.left: leftMenu.right
            anchors.right: parent.right
            anchors.top: titleBar.bottom
            anchors.bottom: parent.bottom
            //            anchors.bottom: flickable.top
            anchors.rightMargin: 255
            anchors.leftMargin: 10
            anchors.bottomMargin: 15
            anchors.topMargin: 10

            StackView {
                id: stackView
                anchors.fill: parent
                clip: true
                initialItem: Qt.resolvedUrl("pages/passive.qml")
            }
        }

        Rectangle {
            id: ightMenuR
            width: 240
            color: "#00000000"
            border.color: "#00000000"
            border.width: 0
            anchors.right: parent.right
            //            anchors.left: columnCircularButtons.right
            anchors.top: titleBar.bottom
            anchors.bottom: parent.bottom
            //            anchors.bottom: flickable.top
            anchors.rightMargin: 0
            clip: true
            anchors.bottomMargin: 15
            anchors.leftMargin: 5
            anchors.topMargin: 10

            Image {
                id: imageDoctor
                width: 110
                height: 110
                source: "../images/qr-code.svg"
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
                sourceSize.width: 110
                sourceSize.height: 110
            }

            Label {
                id: labelContaInfoR
                x: 39
                opacity: 1
                color: "#55aaff"
                text: "Doctor ID: #00697845"
                anchors.top: imageDoctor.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                textFormat: Text.RichText
                anchors.horizontalCenterOffset: 0
                font.family: "Segoe UI"
                anchors.topMargin: 10
                font.bold: false
                font.weight: Font.Normal
                font.pointSize: 8
            }

            Column {
                id: columnMenusRR
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: labelContaInfoR.bottom
                anchors.bottom: groupBox.top
                anchors.bottomMargin: -372
                LeftButton {
                    id: label_docName
                    text: "Name"
                    btnIconSource: "../images/user_icon.svg"
                    btnValue: "Chamara Herath"
                    // onClicked: stackView.push("pages/pageNoInternet.qml")
                }

                LeftButton {
                    id: label_docNic
                    text: "NIC"
                    btnIconSource: "../images/id_card1.svg"
                    // onClicked: stackView.push("pages/pageNoInternet.qml")
                    btnValue: "960000000V"
                }
                anchors.topMargin: 10
            }

            CustomButton {
                width: 220
                height: 30
                text: "Home"
                anchors.bottom: parent.bottom
                colorPressed: "#55aaff"
                colorMouseOver: "#40405f"
                colorDefault: "#33334c"
                anchors.bottomMargin: 0
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    stackView.push(Qt.resolvedUrl("pages/passive.qml"))
                }
            }

            GroupBox {
                id: groupBox
                y: 255
                height: 118
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: 6
                anchors.leftMargin: 5
                //                title: qsTr("Group Box")
                title: "<font color=\"white\">Select Exercise</font>"

                ComboBox {
                    id: comboBox
                    y: 13
                    height: 28
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 5
                    anchors.rightMargin: 5
                    background: Rectangle {
                        color:"#8585ad"
                        border.color: "#33334c"
                        border.width: 2
                    }
                    textRole : "key"
                    valueRole : "value"
                    model : ListModel {
                        id : modelExercise
                    }
                    Component.onCompleted : {
                        // internalMain.request('https://rehabot.chamara.cc/exelist', function (o) {
                        //     var arrExercise = eval('new Object(' + o.responseText + ')');
                        //     for (var i = 0; i < arrExercise.length; i++) {
                        //         modelExercise.append({value: arrExercise[i].id, key: arrExercise[i].name});
                        //     }
                        // });
                        modelExercise.append({
                            key:"Exe 1",
                            value:"0"
                        })
                        modelExercise.append({
                            key:"Exe 2",
                            value:"1"
                        })
                    }
                    onActivated : label_exercise.btnValue = comboBox.currentText



                }
                LeftButton {
                    id: label_exercise
                    height: 40
                    text: "Preview"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: comboBox.bottom
                    anchors.rightMargin: 5
                    anchors.leftMargin: 5
                    anchors.topMargin: 5
                    btnIconSource: "../images/magnifier-1.svg"
                    onClicked: {
                        // internalMain.request('https://rehabot.chamara.cc/exedetails?exe_id=' + comboBox.currentValue, function (o) {
                        //     var arrExerciseDetails = eval('new Object(' + o.responseText + ')');
                        //     stackView.push("pages/exercise_preview_2.qml",{exerArray: arrExerciseDetails})
                        // });
                        var exeData=[
                            {
                                name:"Exercise 1 - Shoulder",
                                s_max:90,
                                s_min:0,
                                e_max:0,
                                e_min:0
                            },
                            {
                                name:"Exercise 2 - Elbow",
                                s_max:0,
                                s_min:0,
                                e_max:90,
                                e_min:0
                            }
                        ]
                        var arrExerciseDetails=exeData[comboBox.currentValue]
                        stackView.push("pages/exercise_preview_2.qml",{exerArray: arrExerciseDetails})

                    }
                }
            }

            GroupBox {
                id: groupBox1
                height: 163
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: groupBox.bottom
                anchors.topMargin: 10
                anchors.rightMargin: 5
                anchors.leftMargin: 5
                title: '<font color="white">Timer</font>'

                CircularProgressBar {
                    id: circularProgressBar
                    x: 40
                    width: 120
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    value: 100
                    anchors.rightMargin: 5
                    anchors.bottomMargin: 5
                    anchors.topMargin: 5
                }

                Rectangle {
                    id : rectangle2
                    y: 22
                    width : 56
                    height: 50
                    border.color : "#313131"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.verticalCenterOffset: -23
                    anchors.leftMargin: 7
                    gradient : Gradient {
                        GradientStop {
                            position : 0
                            color : "#00000000"
                        }

                        GradientStop {
                            position : 0.04777
                            color : "#00000000"
                        }

                        GradientStop {
                            position : 0.98726
                            color : "#ffffff"
                        }

                    }
                }

                Rectangle {
                    id : rectangle3
                    y: 61
                    width : 56
                    height : 50
                    border.color : "#313131"
                    anchors.left: parent.left
                    anchors.leftMargin: 7
                    rotation : -180
                    gradient : Gradient {
                        GradientStop {
                            position : 0
                            color : "#00000000"
                        }

                        GradientStop {
                            position : 0.04777
                            color : "#00000000"
                        }

                        GradientStop {
                            position : 0.98726
                            color : "#ffffff"
                        }
                    }
                }

                Tumbler {
                    id: tumbler
                    y: 32
                    width: 60
                    height: 76
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    font.bold: true
                    font.pointSize: 15
                    wheelEnabled: false
                    visibleItemCount: 3
                    model: 60
                    onCurrentIndexChanged : {
                        console.log(tumbler.currentIndex);
                    }
                }
            }

            CustomAppButton {
                id: customAppButton
                width: 90
                height: 90
                text: "Start"
                anchors.left: parent.left
                anchors.top: groupBox1.bottom
                setIcon: "../images/play.svg"
                anchors.topMargin: 10
                anchors.leftMargin: 20
                checkable: false
                font.bold: true
                font.pointSize: 15
                onClicked: {
                    console.log("Click Start Button");

                    // internalMain.request('https://rehabot.chamara.cc/exedetails?exe_id=' + comboBox.currentValue, function (o) {
                    //     var arrExerciseDetails = eval('new Object(' + o.responseText + ')');
                    //     console.log(comboBox.currentValue)
                    //     backend.btnStart2(arrExerciseDetails.s_max,arrExerciseDetails.s_min,arrExerciseDetails.e_max,arrExerciseDetails.e_min);
                    // });
                    var exeData=[
                            {
                                name:"Exercise 1 - Shoulder",
                                s_max:90,
                                s_min:0,
                                e_max:0,
                                e_min:0
                            },
                            {
                                name:"Exercise 2 - Elbow",
                                s_max:0,
                                s_min:0,
                                e_max:90,
                                e_min:0
                            }
                        ]
                    var arrExerciseDetails=exeData[comboBox.currentValue]
                    console.log(comboBox.currentValue)
                    backend.btnStart2(arrExerciseDetails.s_max,arrExerciseDetails.s_min,arrExerciseDetails.e_max,arrExerciseDetails.e_min);

                    // Start countdown timer
                    tumbler.currentIndex = 59
                    circularProgressBar.value = 100
                    countdownTimer.start()
                }
            }

            CustomAppButton {
                id: customAppButton1
                width: 90
                height: 90
                text: "Stop"
                anchors.left: customAppButton.right
                anchors.top: groupBox1.bottom
                setIcon: "../images/stop.svg"
                anchors.topMargin: 10
                anchors.leftMargin: 20
                font.bold: true
                font.pointSize: 15
                onClicked: {
                    console.log("Click Stop Button");
                    backend.btnStop()
                    stackView.pop(null)
                    countdownTimer.stop()
                }
            }


            // Animation Hide Top Left Popup
        }


    }

    Timer {
        id: countdownTimer
        interval: 2000
        repeat: true
        onTriggered: {
            if (tumbler.currentIndex > 0) {
                tumbler.currentIndex = tumbler.currentIndex - 1
                circularProgressBar.value = (tumbler.currentIndex / 59) * 100
            } else {
                countdownTimer.stop()
                // Optionally auto-stop the exercise
                customAppButton1.clicked()
            }
        }
    }

    DropShadow{
        id: dropShadowBG
        opacity: 0
        anchors.fill: bg
        source: bg
        verticalOffset: 0
        horizontalOffset: 0
        radius: 10
        color: "#40000000"
        z: 0
    }


    MouseArea {
        id: resizeLeft
        width: 12
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        anchors.leftMargin: 0
        anchors.topMargin: 10
        cursorShape: Qt.SizeHorCursor
        DragHandler{
            target: null
            onActiveChanged: if (active) { mainWindow.startSystemResize(Qt.LeftEdge) }
        }
    }

    MouseArea {
        id: resizeRight
        width: 12
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 0
        anchors.bottomMargin: 25
        anchors.leftMargin: 6
        anchors.topMargin: 10
        cursorShape: Qt.SizeHorCursor
        DragHandler{
            target: null
            onActiveChanged: if (active) { mainWindow.startSystemResize(Qt.RightEdge) }
        }
    }

    MouseArea {
        id: resizeBottom
        height: 12
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        cursorShape: Qt.SizeVerCursor
        anchors.rightMargin: 25
        anchors.leftMargin: 15
        anchors.bottomMargin: 0
        DragHandler{
            target: null
            onActiveChanged: if (active) { mainWindow.startSystemResize(Qt.BottomEdge) }
        }
    }

    MouseArea {
        id: resizeApp
        x: 1176
        y: 697
        width: 25
        height: 25
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.rightMargin: 0
        cursorShape: Qt.SizeFDiagCursor
        DragHandler{
            target: null
            onActiveChanged: if (active){
                                 mainWindow.startSystemResize(Qt.RightEdge | Qt.BottomEdge)
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
            target: bg
            property: "opacity"
            Keyframe {
                frame: 949
                value: 1
            }

            Keyframe {
                frame: 0
                value: 0
            }
        }

        KeyframeGroup {
            target: dropShadowBG
            property: "opacity"
            Keyframe {
                frame: 949
                value: 1
            }

            Keyframe {
                frame: 0
                value: 0
            }
        }
    }

    Connections {
            target : backend

            // onError:console.log("WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW")

            function onPrintTime(name) {
                 console.log(name)
                // imgShoulder.rotation = -parseInt(name)
                // imgElbow.rotation = 2 * parseInt(name)
                // dialB.value = parseInt(name)
            }

            function onMirrorArm(val1, val2) { //                console.log(val1+"=="+val2);
                dialA.value = parseInt(val1);
                dialB.value = parseInt(val2);
            }

            // function onPassiveArm(val1, val2) {
            //     console.log(val1)
            //     // console.log(stackView.currentItem)
            //     stackView.push('pages/passive.qml', {dialAmy: 50})
            //     // stackView.find(function(item, index) {
            //     //     // console.log(item)
            //     //     stackView.push(item, {dialAmy: 50})
            //     //     // return item.id
            //     // });
                
            //     // stackView.currentItem.dialA.value = parseInt(val1);
            //     // stackView.currentItem.dialB.value = parseInt(val2);
            // }

            function onVoiceFrontend(a,b){
                labelVoiceClass.text=a;
                // labelVoiceProb.text=b;

                console.log(a)

                if(a==='one'){
                    comboBox.currentIndex=0;
                    label2.text = comboBox.currentText
                }else if (a==='two'){
                    comboBox.currentIndex=1;
                    label2.text = comboBox.currentText
                }else if (a==='three'){
                    comboBox.currentIndex=2;
                    label2.text = comboBox.currentText
                }else if (a==='start'){
                    console.log("START Voice")
                    customAppButton.clicked()
                }else if (a==='stop'){
                    console.log("STOP Voice")
                    customAppButton1.clicked()
                }

            }
        }

}



/*##^##
Designer {
    D{i:0;formeditorZoom:0.33}D{i:66}
}
##^##*/
