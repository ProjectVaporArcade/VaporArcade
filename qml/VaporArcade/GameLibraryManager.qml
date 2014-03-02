import QtQuick 2.0

VaporRectangle {
    id: gameLigraryManager
    color:"transparent"
    visible: false
    VaporDirBrowser
    {
        id: findRoms
        visible:parent.visible
        height: parent.height/2
        width: parent.width/2
        anchors.right: parent.right
        anchors.top:parent.top
        anchors.margins: width/20
    }
    function setDefaultFocus()
    {
        findRoms.setDefaultFocus()
    }
}
