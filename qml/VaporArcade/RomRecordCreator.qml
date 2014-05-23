import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Controls.Styles 1.0
VaporRectangle
{
    property var selectedContainer: romPathContainer
    id: romRecordCreator
    focus:false
    anchors.margins: 10
    gradient: Gradient
    {
        GradientStop { position: 0.0; color: vaporTheme.mid }
        GradientStop { position: 0.3; color: vaporTheme.midlight }
        GradientStop { position: 1.0; color: vaporTheme.mid }
    }//property string defaultDir: DefaultDirectory
    function setDefaultFocus()
    {
        romPathContainer.focus=true
        vaporDbListModels.selectAllGameSystems()
    }
    Column
    {
        clip: false
        anchors.fill: parent
        Label
        {
            id:romCreatorTitle
            color:romRecordCreator.focus?vaporTheme.selectedText:vaporTheme.text
            font.pixelSize: parent.height / 15
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Rom Record Creator"
        }
        VaporRectangle
        {
            id: romPathContainer
            radius:height/6
            gradient: Gradient
            {
                GradientStop { position: 0.0; color: vaporTheme.mid }
                GradientStop { position: 0.3; color: vaporTheme.midlight }
                GradientStop { position: 1.0; color: vaporTheme.mid }
            }
            height: parent.height/10
            width: parent.width
            FileDialog
            {
                property string pathToRom:fileDialog.fileUrl.toString().substring(10)
                id: fileDialog
                title: "Please choose a ROM"
                onAccepted:
                {
                    console.debug(fileDialog.fileUrl.toString().substring(8))
                    filePath.text = fileDialog.fileUrl.toString().substring(8)//.toLocalFile()
                }
                onRejected:
                {
                    romRecordRequiredCheckbox.checked = false;
                    filePath
                }
            }
            Keys.onPressed:
            {
               if(event.key == Qt.Key_Return)
                {
                   event.accepted = true;
                   if(!romRecordRequiredCheckbox.checked)
                        romRecordRequiredCheckbox.checked = true
                    fileDialog.visible = true
                    romPathContainer.focus = true
                    //fileDialog.visible = false
               }else if(event.key == Qt.Key_Backspace)
               {
                   event.accepted = true;
                   romRecordCreator.focus = true
               }else if(event.key == Qt.Key_Down)
               {
                   getInsertGameTitle.focus = true
               }
               else if(event.key == Qt.Key_Right)
               {
                    romRecordRequiredCheckbox.focus = true
               }
            }
            Row
            {
                height:parent.height
                width: parent.width
                Label
                {
                    id:romPathLbl
                    color: romPathContainer.focus?vaporTheme.selectedText:vaporTheme.text
                    anchors.verticalCenter: parent.verticalCenter
                    text:"Rom Path"
                    width: font.pixelSize * (text.length-3)
                }
                TextField
                {
                    id: filePath
                    enabled: false
                    textColor: "black"
                    style:TextFieldStyle
                    {
                        background: Rectangle {
                            implicitWidth: 100
                            implicitHeight: 20
                            color: (romRecordRequiredCheckbox.checked)?filePath.text.length > 0?vaporTheme.glowColor:vaporTheme.error:vaporTheme.midlight
                            antialiasing: true
                            border.color: vaporTheme.light
                            radius: height/2
                        }
                    }
                    text: romRecordRequiredCheckbox.checked?fileDialog.pathToRom:"Path to game rom"
                    height: parent.height
                    width: parent.width - romPathLbl.width - romRecordRequiredCheckbox.width
                }
                VaporCheckbox
                {
                    id: romRecordRequiredCheckbox
                    checked:true
                    height: parent.height
                    KeyNavigation.down: associateEmulator
                    KeyNavigation.left: romPathContainer
                    checkboxTitle: "Requires Path"
                    Keys.onReturnPressed:
                    {
                        event.accepted = true;
                        checked = !checked;
                    }
                    Keys.onPressed:
                    {
                        if(event.key == Qt.Key_Backspace)
                        {
                            event.accepted = true;
                            romRecordRequiredCheckbox.focus = true
                        }
                    }
                }
            }
        }
        Row{
            id: titleGameSystemRow
            height: parent.height/10
            width: parent.width
            z:gameDescription.z + 2
            VaporRectangle
            {
                id: getInsertGameTitle
                anchors.margins: parent.height/4
                height: parent.height
                radius: height/5
                width: parent.width/2
                KeyNavigation.up: romPathContainer
                KeyNavigation.right: associateEmulator
                KeyNavigation.down:gameNameContainer
                Keys.onReturnPressed:
                {
                    event.accepted = true
                    gameTitleComboBox.focus = true
                }
                Row
                {
                    id: gameTitleRow
                    anchors.fill: parent
                    anchors.margins: gameTitleComboBox.height/5
                    Label
                    {
                        id:gameTitleLabel
                        width: font.pixelSize * (text.length-5)
                        anchors.margins: parent.height/5
                        anchors.verticalCenter: parent.verticalCenter
                        color: getInsertGameTitle.focus?vaporTheme.selectedText:vaporTheme.text
                        text:"Game Title"
                    }
                    EditableComboBox
                    {id:gameTitleComboBox
                        width:parent.width-gameTitleLabel.width
                        z:1000
                        dropDownModel:vaporDbListModels.gameTitleNameList
                        onFocusChanged:
                        {
                            if(focus == true)
                            {
                                vaporDbListModels.selectAllGameTitles()
                            }
                        }
                        onAccept:
                        {
                            getInsertGameTitle.focus = true
                        }
                    }
                }
                gradient: Gradient
                {
                    GradientStop { position: 0.0; color: vaporTheme.mid }
                    GradientStop { position: 0.3; color: vaporTheme.midlight }
                    GradientStop { position: 1.0; color: vaporTheme.mid }
                }
            }
            VaporRectangle
            {
                id: associateEmulator
                anchors.margins: parent.height/4
                height: parent.height
                radius: height/5
                width: parent.width/2
                KeyNavigation.up: romPathContainer
                KeyNavigation.left: getInsertGameTitle
                KeyNavigation.down:gameNameContainer
                Keys.onReturnPressed:
                {
                    event.accepted = true
                    gameSystemComboBox.focus = true
                }
                Row
                {
                    id: gameSystemRow
                    anchors.fill: parent
                    anchors.margins: gameTitleComboBox.height/5
                    Label
                    {
                        id:gameSystemLable
                        width: font.pixelSize * (text.length-5)
                        anchors.margins: parent.height/5
                        anchors.verticalCenter: parent.verticalCenter
                        color: associateEmulator.focus?vaporTheme.selectedText:vaporTheme.text
                        text:"Game System"
                    }
                    VaporComboBox
                    {
                        id:gameSystemComboBox
                        property var selectedId:gameSystemComboBox.sqlRowID
                        width: parent.width-gameSystemLable.width
                        dropDownModel:vaporDbListModels.gameSystemNameList
                        z:1000
                        onAccept:
                        {
                            associateEmulator.focus = true
                        }
                    }
                }
                gradient: Gradient
                {
                    GradientStop { position: 0.0; color: vaporTheme.mid }
                    GradientStop { position: 0.3; color: vaporTheme.midlight }
                    GradientStop { position: 1.0; color: vaporTheme.mid }
                }
            }
        }
        VaporRectangle
        {
            id:gameNameContainer
            height: parent.height/10
            width: parent.width
            //z:titleGameSystemRow.z-10
            gradient: Gradient
            {
                GradientStop { position: 0.0; color: vaporTheme.mid }
                GradientStop { position: 0.3; color: vaporTheme.midlight }
                GradientStop { position: 1.0; color: vaporTheme.mid }
            }
            Keys.onPressed:
            {
                if(event.key == Qt.Key_Return)
                {
                    event.accepted = true
                    gameNameTextField.focus = true
                }
            }
            KeyNavigation.up:getInsertGameTitle
            KeyNavigation.down:gameDescription
            Row{
                id: gameNameRow
                height: parent.height
                width: parent.width
                Label
                {
                    id: gameNameLabel
                    color:gameNameContainer.focus?vaporTheme.selectedText:vaporTheme.text
                    text: "Rom Name"
                }
                TextField
                {
                    id: gameNameTextField
                    text:"Some Rom"
                    height: parent.height
                    //KeyNavigation.up:gameNameContainer
                    //KeyNavigation.down:gameNameContainer
                    width: parent.width - gameNameLabel.width
                    Keys.onReturnPressed:
                    {
                        event.accepted = true
                        gameNameContainer.focus = true;
                    }

                    onAccepted:
                    {
                        gameNameContainer.focus = true;
                    }
                }
            }
        }
        VaporRectangle
        {
            id: gameDescription
            KeyNavigation.up: gameNameContainer
            KeyNavigation.down: addRomRecordButton
            Keys.onPressed:
            {
                if(event.key == Qt.Key_Return)
                {
                    event.accepted = true
                    gameDescriptionTextField.focus = true
                }
            }

            width: parent.width
            height: parent.height/2
            gradient: Gradient
            {
                GradientStop { position: 0.0; color: vaporTheme.mid }
                GradientStop { position: 0.3; color: vaporTheme.midlight }
                GradientStop { position: 1.0; color: vaporTheme.mid }
            }
            Row{
                anchors.fill: parent
                id: gameDescriptionRow
                Label{
                    id: gameDescriptionLabel
                    text: "Description"
                    color: gameDescription.focus?vaporTheme.selectedText:vaporTheme.text
                }
                TextArea
                {
                    Keys.onPressed:
                    {
                        if(event.key == Qt.Key_Return)
                        {
                            event.accepted = true
                            gameDescription.focus = true
                        }
                    }

                    height: parent.height
                    width: parent.width - gameDescriptionLabel.width
                    id: gameDescriptionTextField
                    text: "game description"

                }
            }
        }
        VaporRectangle
        {
            id:addRomRecordButton
            width: parent.width/6
            height: parent.height/10
            KeyNavigation.up: gameDescription
            Label
            {
                id: addRomText
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                text:"Create Rom Record"
                color: addRomRecordButton.focus? vaporTheme.selectedText:vaporTheme.text
            }

            Keys.onPressed:
            {
                if(event.key == Qt.Key_Return)
                {
                    event.accepted = true
                    validateRecordInsert();
                }
            }
            function validateRecordInsert( )
            {
                if(romRecordRequiredCheckbox.checked && filePath.text.length > 0 || !romRecordRequiredCheckbox.checked)
                {
                    if(gameTitleComboBox.currentText.length <= 0)
                        gameTitleComboBox.currentText = "N/A";
                    if(gameNameTextField.text.length > 0)
                        insertRomRecord()
                }
            }

            function insertRomRecord()
            {
                var titleId =  vaporDbListModels.insertGetGameTitleId(gameTitleComboBox.currentText)
                console.debug("Adding RomRecord:"+titleId+":"+ gameNameTextField.text +":"+ gameDescriptionTextField.text +":"+gameSystemComboBox.sqlRowID+":"+filePath.text)
                vaporDbListModels.insertRomRecord(titleId,gameNameTextField.text,gameDescriptionTextField.text,gameSystemComboBox.sqlRowID,filePath.text)
                vaporDbListModels.selectAllRomRecords()

            }
            gradient: Gradient
            {
                GradientStop { position: 0.0; color: vaporTheme.mid }
                GradientStop { position: 0.3; color: vaporTheme.midlight }
                GradientStop { position: 1.0; color: vaporTheme.mid }
            }
        }
    }
}
