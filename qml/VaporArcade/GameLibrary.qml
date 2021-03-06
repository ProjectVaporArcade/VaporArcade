import QtQuick 2.0
import "Database"

GridView {
    id:gameLibrary
    //property ListModel emuList:vaporDbGameList.emuList
    //property ListModel emuNameList:vaporDbGameList.emuNameList
    //property ListModel gameList:vaporDbGameList.gameList
    //property GridView libraryView:vaporDbGameList.libraryView
    cellHeight : ScreenHeight*1/4
    cellWidth : ScreenWidth/8
    highlightRangeMode:GridView.ApplyRange
    width: parent.width
    height: ScreenHeight/3
    //signal emmitted when the currently selected game changes
    signal selectedChanged(string name, string path, string desc, string disp, string sysFull, string sysAbbr, string sysPic, var sysID)
    //interactive: false
    //the delegate for the gridview
    Component {//describes how to display each element in the List model on the Gridview
        id: gameDelegate
        VaporRectangle {
            id: wrapper
            onActiveFocusChanged: {
                if(focus == true)
                {
                    gameLibrary.selectedChanged(name,path,desc,display,sysFull,sysAbbr,sysPic,sysID);
                }
            }
            radius: width/16
            width: gameLibrary.cellWidth*15/16
            height: gameLibrary.cellHeight*15/16
            gradient: Gradient
            {
                GradientStop { position: 0.0; color: vaporTheme.mid }
                GradientStop { position: 0.3; color: vaporTheme.midlight }
                GradientStop { position: 1.0; color: vaporTheme.mid }
            }
            Text
            {//the game name
                id: romTxt
                text: name
                color: (wrapper.focus?vaporTheme.shadow:vaporTheme.text)
                anchors.centerIn: parent
                z:parent.z + 20
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }
            Image
            {//the cover image
                id:cover
                anchors.fill: wrapper
                source: display
                z:romTxt.z + 1
            }

        }
    }//the list model and delegate to use
    model: vaporDbListModels.gameRomList
    delegate: gameDelegate
    focus: true
}
