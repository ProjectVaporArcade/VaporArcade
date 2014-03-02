import QtQuick 2.0
import QtQuick.Controls 1.0
VaporRectangle {
    id: vaporDirBrowserwser
    focus:false
    gradient: Gradient
    {
        GradientStop { position: 0.0; color: vaporTheme.mid }
        GradientStop { position: 0.3; color: vaporTheme.midlight }
        GradientStop { position: 1.0; color: vaporTheme.mid }
    }property string defaultDir: DefaultDirectory
    function setDefaultFocus()
    {
        focus=true
    }

    //property ListModel fileLsit: {"":""}
    TextField
    {
        id: filePath
        //height:parent.height
        width: parent.width
        KeyNavigation.backtab: vaporDirBrowserwser
    }


    /*VaporRectangle
    {
       id: browseDirButton
       height:parent.height
       width: parent.width/10

       Text{
           id: browseDirButtonTxt
           text:"..."
           color:browseDirButton.focus?vaporTheme.text:vaporTheme.selectedText
       }
    }*/
}
