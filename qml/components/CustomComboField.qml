import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

ComboBox {
    id: combobox

    // Custom Properties
    property color colorDefault: "#adbee1"
    property color colorOnFocus: "#8392b3"
    property color colorMouseOver: "#808da7"
//    property color colorText: "2B2F38"

    QtObject{
        id: internal

        property var dynamicColor: if(combobox.focus){
                                        combobox.focus ? colorOnFocus : colorDefault
                                   }else{
                                       combobox.hovered ? colorMouseOver : colorDefault
                                   }
    }

    implicitWidth: 300
    implicitHeight: 40
    background: Rectangle {
        color: internal.dynamicColor
        radius: 10
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.9;height:40;width:640}
}
##^##*/
