import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Controls.Styles 1.0
/******************************************************************************
*Author Aaron Lindberg
*Contributers Eli Kloft & Aaron Lindberg
* Vapor Style Combobox
******************************************************************************/
VaporRectangle
{
    signal accept (string system)
    property int previewCount: 5
    property ListModel dropDownModel:defaultModel
    property var sqlRowID:options.count == 0? 0 : options.currentItem.sqlRowID
    ListModel
    {
        id:defaultMode
        ListElement
        {
            title:"comboBoxItem title"
            sqlID:0
        }
    }
    id: vaporComboBox
    anchors.margins: parent.height/40
    implicitHeight: 20
    radius: height/5
    implicitWidth: 100
    focus: false

    Keys.onReturnPressed:
    {
        event.accepted = true
        sqlRowID = vaporComboBox.dropDownModel.get(options.currentIndex).sqlID
        accept(sqlRowID);
    }
    property bool selectedFromDropDown: focus
    Keys.onPressed:
    {
        if(event.key == Qt.Key_Down)
        {
            event.accepted = true
            if (options.currentIndex == options.count-1)
            {
                options.currentIndex = 0
                //selected = false;
            }else
            {
                options.incrementCurrentIndex()
                //selected = false;
            }
        }else if(event.key == Qt.Key_Up)
        {
            event.accepted = true
            if (selectedFromDropDown)
            {
                if(options.currentIndex == 0)
                {
                    options.currentIndex = options.count-1
                }else
                {
                    options.decrementCurrentIndex()
                }
            }
        }
    }
    ListView
    {
        id:options
        clip: true
        height: vaporComboBox.focus?vaporComboBox.height*vaporComboBox.previewCount:vaporComboBox.height
        width:vaporComboBox.width
        model: dropDownModel
        delegate: TextField
        {
            property bool itemSelected: vaporComboBox.focus && options.currentItem == dele
            //property var sqlRowID:sqlID
            text:title
            width:vaporComboBox.width
            height: vaporComboBox.height
            enabled:false
            id:dele
            style: TextFieldStyle
            {
                textColor: "black"
                background:
                Rectangle {
                    radius: 2
                    color: dele.itemSelected?vaporTheme.glowColor:vaporTheme.light
                    border.color:  dele.itemSelected?vaporTheme.light:vaporTheme.glowColor
                    border.width: 1
                }
            }
            //textColor: dele.itemSelected?vaporTheme.selectedText:vaporTheme.text
            focus: false
        }
    }
}
