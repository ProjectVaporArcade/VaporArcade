import QtQuick 2.0
GridView {
    id:gameLibrary
    property VaporDB vaporDB:vaporDbGameList
    property ListModel emuList:vaporDbGameList.emuList
    property ListModel emuNameList:vaporDbGameList.emuNameList
    property ListModel gameList:vaporDbGameList.gameList
    property GridView libraryView:vaporDbGameList.libraryView
    cellHeight : ScreenHeight*1/4
    cellWidth : ScreenWidth/8
    highlightRangeMode:GridView.ApplyRange
    width: parent.width
    height: ScreenHeight/3
    signal selectedChanged(string name, string game, string desc, string disp, string sysFull, string sysAbbr, string sysPic, var sysID)
    //interactive: false
    VaporDB{
        id:vaporDbGameList
    }
    Component {
        id: gameDelegate
        VaporRectangle {
            id: wrapper
            onActiveFocusChanged: {
                if(focus == true)
                {
                    gameLibrary.selectedChanged(name,game,desc,display,sysFull,sysAbbr,sysPic,sysID);
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
            {
                id: romTxt
                text: name
                color: (wrapper.focus?vaporTheme.shadow:vaporTheme.text)
                anchors.centerIn: parent
                z:parent.z + 20
            }
            Image
            {
                id:cover
                anchors.fill: wrapper
                source: display
                z:romTxt.z + 1
            }

        }
    }
    model: vaporDbGameList.gameList
    delegate: gameDelegate
    focus: true
}
