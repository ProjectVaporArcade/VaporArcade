import QtQuick 2.0
import QtQuick.Controls 1.0
import "vapordb.js" as VaporStorage
VaporRectangle {
    id: allGamesLibrary
    width: homescreen.width
    height: homescreen.height
    color: vaporTheme.shadow
    visible: false
    z: parent.z + 1

    function setDefaultFocus()
    {
        allGameLibrary.visible = true
        gameLibrary.focus = true;

    }
    function leaveFocus()
    {
        allGameLibrary.visible = false;
        gameLibrary.focus = false;
        gamesContainer.setDefaultFocus();
    }
    GameLibrary
    {
        id:gameLibrary
        property int systemID: 0
        property string gameName: ""
        property string gamePath: ""
        property string systemAbbrName: ""
        property string gameDesc: ""
        property string gameCover: ""
        property string systemPic: ""
        anchors.top:  parent.top
        anchors.left: parent.left
        anchors.right: gameCoverRect.left
        anchors.bottom: gameDescRect.top
        anchors.margins: ScreenHeight/18
        height: ScreenHeight/3
        z:parent.z + 1  
        onSelectedChanged:
        {
            var tmp = "";
            var tmpc = 0
            var splt=desc.split(" ");
            for( var d in splt)
            {
                if((tmpc += splt[d].length) > 80)
                {
                    tmp += "\n";
                    tmpc =  splt[d].length;
                }
                tmp +=  splt[d] + " ";
            }
            //systemRect
            gameDesc=tmp
            gameName=name
            gamePath=game
            systemAbbrName = sysAbbr
            gameCover = disp
            systemPic = sysPic
            systemID = sysID
        }
    }
    VaporRectangle
    {
        id: gameDescRect
        radius: height/16
        color: vaporTheme.midlight
        opacity: 1
        anchors.margins: ScreenHeight/16
        height: ScreenHeight/3
        width: ScreenWidth*2/3
        //anchors.top: gameLibrary.bottom
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        z:parent.z + 1
        visible: true
        gradient: Gradient
        {
            GradientStop { position: 0.0; color: vaporTheme.mid }
            GradientStop { position: 0.3; color: vaporTheme.midlight }
            GradientStop { position: 1.0; color: vaporTheme.mid }
        }
        Text{
            id:gameDescription
            anchors.fill: gameDescRect
            font.pixelSize: width/41
            anchors.margins: parent.height/16
            color: vaporTheme.text
            text:gameLibrary.gameDesc
        }
    }
    VaporRectangle{
        id:systemRect
        Text
        {
            id:systemRectTxt
            height: parent.height/8
            width: parent.width/2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            text:gameLibrary.systemAbbrName
            font.pixelSize: height//width/text.length
            color: vaporTheme.text
        }
        Image
        {
            id:sysImage
            anchors.bottom: parent.bottom
            anchors.top:systemRectTxt.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            fillMode: Image.PreserveAspectFit
            source: gameLibrary.systemPic
        }
        ComboBox
        {
            id:emuComboBox
            model: gameLibrary.emuNameList
            anchors.top: systemRectTxt.bottom
            anchors.horizontalCenter: systemRectTxt.horizontalCenter
            visible: false
        }
        radius:width/16
        anchors.right: parent.right
        anchors.left: gameLibrary.right
        anchors.top: parent.top
        anchors.bottom: gameCoverRect.top
        anchors.margins: gameCoverRect.anchors.margins
        gradient: Gradient
        {
            GradientStop { position: 0.0; color: vaporTheme.mid }
            GradientStop { position: 0.3; color: vaporTheme.midlight }
            GradientStop { position: 1.0; color: vaporTheme.mid }
        }
    }
    VaporRectangle
    {
        id: gameCoverRect
        opacity:1.0
        Image
        {
            id:gameCoverImage
            anchors.fill: parent
            source: gameLibrary.gameCover
            opacity: parent.opacity
        }
        Text
        {
            font.pixelSize: parent.width/text.length
            id:gameNameTxt
            //anchors.fill: parent
            color:vaporTheme.text
            anchors.horizontalCenter: parent.horizontalCenter
            text:gameLibrary.gameName
        }
        radius: height/16
        gradient: Gradient
        {
            GradientStop { position: 0.0; color: vaporTheme.mid }
            GradientStop { position: 0.3; color: vaporTheme.midlight }
            GradientStop { position: 1.0; color: vaporTheme.mid }
        }
        anchors.margins: ScreenHeight/20
        height: ScreenHeight*7/16
        anchors.left: gameDescRect.right
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        z:parent.z + 1
        visible: true
    }
    Image
    {
        id: background
        source: "./vaporBackground.jpg"
        anchors.fill: parent
        opacity: 0.1
        anchors.centerIn: parent
    }
    Keys.onPressed:
    {
        if (event.key == Qt.Key_Return)
        {
            if(gameLibrary.focus)
            {
                VaporStorage.refreshEmuList(gameLibrary.emuNameList,gameLibrary.emuList,gameLibrary.systemID)
                emuComboBox.visible = true
                emuComboBox.focus = true
            }else if(emuComboBox.focus)
            {
              Emulators.start(gameLibrary.systemAbbrName, gameLibrary.emuList.get(emuComboBox.currentIndex).emuPath ,gameLibrary.gamePath);
            }

            //gameLibrary.currentItem
            //)
        }else if (event.key == Qt.Key_Backspace)
        {
            event.accepted = true
            if(gameLibrary.focus)
            {
                leaveFocus();
            }else if(emuComboBox.focus)
            {
                emuComboBox.visible = false
                gameLibrary.focus = true
            }
        }
    }
}
