import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
/******************************************************************************
*Author Aaron Lindberg
*Contributers Eli Kloft & Aaron Lindberg
* Checkbox control, Vapor Style
******************************************************************************/
CheckBox {
        id:checkbox
        property string checkboxTitle:"Check Box"
        text: checkboxTitle
        style: CheckBoxStyle {
            indicator: Rectangle {
                    implicitWidth: 32
                    implicitHeight: 32
                    radius: 3
                    border.color: control.activeFocus ? vaporTheme.glowColor : vaporTheme.light
                    border.width: 4
                    Rectangle {
                        id:indicatorRect
                        Image{
                           anchors.fill:parent
                           fillMode: Image.PreserveAspectFit
                           source: "CheckboxIndicator.png"
                        }
                        visible: control.checked
                        color: "#555"
                        border.color: "#333"
                        radius: 1
                        anchors.margins: 4
                        anchors.fill: parent
                    }
            }
        }
    }
