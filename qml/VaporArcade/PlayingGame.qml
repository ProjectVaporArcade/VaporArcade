import QtQuick 2.0
import com.vapor.project 1.0

VaporRectangle {
    id: activeGameDialog
    property var error: false
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

        error = false
        gamePlaying = game
        emulatorServices.start(emuPy, game)
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
            //event.accepted = true;
            message.text = "Emulator Started"
            activeGameDialog.setDefaultFocus()
        }
        onEmulatorError:
        {
            message.text = errorMsg
            activeGameDialog.setDefaultFocus()
            error = true;
        }

        onEmulatorStopped:
        {
            //event.accepted = true;
            activeGameDialog.leaveFocus();
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
