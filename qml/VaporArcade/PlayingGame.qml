import QtQuick 2.0
import com.vapor.project 1.0
/******************************************************************************
*Author Aaron Lindberg
*Contributers Eli Kloft & Aaron Lindberg
* shows messages about starting a emulator with a rom.
******************************************************************************/
VaporRectangle {
    id: activeGameDialog
    property bool error: false
    property bool started: false;
    property var returnObj: parent
    property string gamePlaying: ""
    visible: false
    width: parent.width/2
    height: parent.height/ 2
    anchors.centerIn: parent
    function setDefaultFocus()
    {
        visible = true
        emuComboBox.visible = false
        focus = true;
    }
    function leaveFocus()
    {
        visible = false
        returnObj.setDefaultFocus();
    }
    function startGame(emuPy, game)
    {
        if(!started)
        {
            started = true
            error = false
            emulatorServices.start(emuPy, game)
            gamePlaying = game
        }
    }
    function stopGame()
    {
        emulatorServices.stop();
    }

    Text{
        id:message
        anchors.margins: parent.height * 0.1
        anchors.fill: parent
        anchors.centerIn: parent
        color: activeGameDialog.focus?"black":vaporTheme.text
        font.pixelSize: parent.height / 10
        text: error?"An error Occurred":"Emulator is actively running"
        wrapMode: Text.Wrap
    }

    Keys.onPressed:
    {
        event.accepted = true;
        if(error)
        {
            error = false
            leaveFocus()
        }else
        {
            stopGame();
        }
    }

    Connections
    {
        id: emuConnections
        target: emulatorServices
        onEmulatorStart:
        {
            message.text = "Emulator Started"
            activeGameDialog.setDefaultFocus()
            started = false;
            returnObj.resetStarted();
        }
        onEmulatorError:
        {
            started = false;
            message.text = errorMsg
            activeGameDialog.setDefaultFocus()
            error = true;
            returnObj.resetStarted();
        }

        onEmulatorStopped:
        {
            started = false
            //event.accepted = true;
            activeGameDialog.leaveFocus();
            returnObj.resetStarted();
        }
    }

    EmulatorServices
    {
        id: emulatorServices
        objectName: "emulatorServices"
        Component.onCompleted:
        {
            setEmulatorSystemDir(AppSettings.getEmulatorDirectory())
            setPythonInterpreter(AppSettings.getPythonInterpreter())
        }
        Component.onDestruction:
        {
            emuConnections.destroy();
        }
    }
}
