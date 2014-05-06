import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Controls.Styles 1.0

VaporRectangle
{
    signal accept ()
    property int previewCount: 5
    property string currentText:editField.text
    property ListModel dropDownModel:defaultModel
    ListModel
    {
        id:defaultMode;
        ListElement
        {
            title:"comboBoxItem title"
        }
    }
    id: editableComboBox
    anchors.margins: parent.height/40
    implicitHeight: 20
    radius: height/5
    implicitWidth: 100
    focus: false
    onFocusChanged:
    {
        if(focus)
        {
            editField.focus = focus
            focus = false
        }

    }
    TextField
    {
        anchors.margins: editableComboBox.height/5
        //anchors.verticalCenter: editableComboBox.verticalCenter
        id:editField
        height: editableComboBox.height
        width: editableComboBox.width

        property bool selected:!selectedFromDropDown
        style: TextFieldStyle
        {
                textColor: "black"
                background: Rectangle {
                radius: 2
                color: editableComboBox.focus && editableComboBox.selected?vaporTheme.glowColor:vaporTheme.light
                border.color:  editableComboBox.focus && editableComboBox.selected?vaporTheme.light:vaporTheme.glowColor
                border.width: 1
            }
        }
        Keys.onReturnPressed:
        {
            event.accepted = true
            if(editField.selectedFromDropDown)
            {
                text = editableComboBox.dropDownModel.get(suggestions.currentIndex).title
                editableComboBox.dropDownModel.get(suggestions.currentIndex).selected = false
            }
            selectedFromDropDown = false
            accept()
        }
        text:"N/A"
        focus:false
        property bool selectedFromDropDown: false
        Keys.onPressed:
        {
            if(event.key == Qt.Key_Down)
            {
                event.accepted = true
                if(!selectedFromDropDown)
                {
                    selectedFromDropDown = true
                    if (suggestions.currentIndex == suggestions.count-1)
                        suggestions.currentIndex = 0
                    //selected = false;
                }else if(suggestions.count > 0 && suggestions.currentIndex < suggestions.count-1)
                {
                    suggestions.incrementCurrentIndex()
                    selectedFromDropDown = true;
                    //selected = false;
                }else
                {
                    selectedFromDropDown = false
                    //selected = true;
                }
            }else if(event.key == Qt.Key_Up)
            {
                event.accepted = true
                if (!selectedFromDropDown)
                {
                    selectedFromDropDown = true
                    if(suggestions.currentIndex == 0)
                    {
                        suggestions.currentIndex = suggestions.count-1
                    }
                }else if(suggestions.currentIndex == 0)
                {
                    selectedFromDropDown = false
                }else if (selectedFromDropDown)
                {
                    suggestions.decrementCurrentIndex()
                }
                else
                {
                    selectedFromDropDown = true
                }
            }
        }
    }
    ListView
    {
        id:suggestions
        visible:editField.focus
        anchors.top: editableComboBox.bottom
        clip: true
        height: editField.height*previewCount
        width:editableComboBox.width
        model: dropDownModel
        delegate: TextField
        {
            property bool itemSelected: suggestions.currentItem == del && editField.selectedFromDropDown
            text:title
            enabled:false
            id:del
            style: TextFieldStyle
            {
                    textColor: "black"
                    background: Rectangle {
                    radius: 2
                    color: itemSelected?vaporTheme.glowColor:vaporTheme.light
                    border.color:  itemSelected?vaporTheme.light:vaporTheme.glowColor
                    border.width: 1
                }
            }
            textColor: itemSelected?vaporTheme.selectedText:vaporTheme.text
            focus: false
        }
    }
}
