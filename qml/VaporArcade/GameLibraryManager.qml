import QtQuick 2.0

VaporRectangle {
    id: gameLigraryManager
    color:"transparent"
    property var returnObj: parent
    visible: false
    RomRecordCreator
    {
        //KeyNavigation.Left:
        id: romRecordCreator
        visible:parent.visible
        height: parent.height/2
        width: parent.width/2
        anchors.right: parent.right
        anchors.top:parent.top
        anchors.margins: width/20
        Keys.onPressed:
        {
             if (event.key === Qt.Key_Return)
                 setDefaultFocus()
        }
    }

    Keys.onPressed:
    {
        event.accepted = true;
        if (event.key === Qt.Key_Backspace)
            returnObj.setDefaultFocus();
    }
    function setDefaultFocus()
    {
        romRecordCreator.focus = true;
    }

}
