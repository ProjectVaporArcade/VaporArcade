import QtQuick 2.0
/******************************************************************************
*Author Jack Sanchez
*Contributers Jack Sanchez
*** Overview ***
* The UI Rat trap network lobby
******************************************************************************/
VaporRectangle
{
	id: netLobbyContainer
	width: homescreen.width
	height: homescreen.height
	visible: false
	focus: false
	z: parent.z + 1
	color: vaporTheme.base

	Image
	{
		id: lobbyBackground
		source: "./vaporBackground.jpg"
		height: parent.height
		width: parent.width
		opacity: 0.2
	}

	//define the netservices object for use
	//only within the netlobby object

	objectName: "NetLobby"

	function submitMessage(message)
	{
		textContainer.text += (message + '\n');
	}

	function setDefaultFocus()
	{
		userListContainer.focus = true;
	}

	//begin user list area
	VaporRectangle
	{
		id: userListContainer
		width: parent.width * 0.25
		height: parent.height
		anchors.left: parent.left
		anchors.top: parent.top
		color: "transparent"
		radius: 9

		KeyNavigation.right: textAreaContainer
		KeyNavigation.left: settingsButtons

		UserList
		{
			id: userList
			width: parent.width * 0.95
			height: parent.height * 0.95
			anchors.verticalCenter: parent.verticalCenter
			anchors.horizontalCenter: parent.horizontalCenter
		}
	}//end user list area

	//begin text area
	VaporRectangle
	{
		id: textAreaContainer
		width: parent.width * 0.5
		height: parent.height * 0.8
		anchors.top: parent.top
		anchors.horizontalCenter: parent.horizontalCenter
		color: "transparent"
		pressable: false

		//perhaps allow selection later for text grabbing, etc.. from group chat?

		KeyNavigation.up: textEditor
		KeyNavigation.down: textEditor
		KeyNavigation.left: userListContainer
		KeyNavigation.right: settingsButtons

		VaporRectangle
		{
			id: textArea
			width: parent.width * 0.95
			height: parent.height * 0.95
			anchors.verticalCenter: parent.verticalCenter
			anchors.horizontalCenter: parent.horizontalCenter
			color: vaporTheme.dark
			opacity: 0.9
			radius: 9

			TextEdit
			{
				id: textContainer
				width: parent.width
				height: parent.height
				anchors.verticalCenter: parent.verticalCenter
				anchors.horizontalCenter: parent.horizontalCenter
				color: vaporTheme.light
				textMargin: 8
				font.pointSize: 16
				wrapMode: TextEdit.Wrap
				activeFocusOnPress: false
			}
		}
	}//end text area

	VaporTextEdit
	{
		id: textEditor
		anchors.bottom: parent.bottom
		anchors.horizontalCenter: parent.horizontalCenter
	}

	//begin settings area
	VaporRectangle
	{
		id: settingsAreaContainer
		width: parent.width * 0.25
		height: parent.height * 0.15
		anchors.top: parent.top
		anchors.right: parent.right
		pressable: false
		color: "transparent"

		VaporRectangle
		{
			id: settingsButtons
			width: parent.width * 0.95
			height: parent.height * 0.5
			anchors.verticalCenter: parent.verticalCenter
			anchors.horizontalCenter: parent.horizontalCenter
			color: vaporTheme.base
			pressable: false
			radius: 9

			KeyNavigation.left: textAreaContainer
			KeyNavigation.right: userListContainer

			Keys.onReturnPressed:
			{
				settingsButtons.focus = false;
				fontButton.focus = true;
				event.accepted = true;
			}

			//place holder buttons
			Button
			{
				id: fontButton
				width: parent.width * 0.2
				height: parent.height
				anchors.left: parent.left
				text: "Font"
				KeyNavigation.right: sizeButton
				KeyNavigation.left: clearChatButton
				KeyNavigation.up: backButton
				KeyNavigation.down: gamesButton
			}
			Button
			{
				id: sizeButton
				width: parent.width * 0.2
				height: parent.height
				anchors.left: fontButton.right
				text: "Size"
				KeyNavigation.right: fontColorButton
				KeyNavigation.left: fontButton
				KeyNavigation.up: backButton
				KeyNavigation.down: gamesButton
			}
			Button
			{
				id: fontColorButton
				width: parent.width * 0.2
				height: parent.height
				anchors.left: sizeButton.right
				text: "Color"
				KeyNavigation.right: setUserNameButton
				KeyNavigation.left: sizeButton
				KeyNavigation.up: backButton
				KeyNavigation.down: gamesButton
			}
			Button
			{
				id: setUserNameButton
				width: parent.width * 0.2
				height: parent.height
				anchors.left: fontColorButton.right
				text: "UserName"
				KeyNavigation.right: clearChatButton
				KeyNavigation.left: fontColorButton
				KeyNavigation.up: backButton
				KeyNavigation.down: gamesButton
			}
			Button
			{
				id: clearChatButton
				width: parent.width * 0.2
				height: parent.height
				anchors.left: setUserNameButton.right
				text: "ClearChat"
				KeyNavigation.right: fontButton
				KeyNavigation.left: setUserNameButton
				KeyNavigation.up: backButton
				KeyNavigation.down: gamesButton
			}
			//end place holder buttons
		}
	}//end settings area

	//need to define something for file share
	//between the top buttons and bottom buttons

	//application navigation buttons
	VaporRectangle
	{
		id: navigationButtonContainer
		width: parent.width * 0.25
		height: parent.height * 0.35
		anchors.bottom: parent.bottom
		anchors.right: parent.right
		color: "transparent"
		pressable: false
		property bool backButtonPressed: false

		VaporRectangle
		{
			id:	gamesContainer
			width: parent.width
			height: parent.height * 0.5
			color: "transparent"
			anchors.top: parent.top
			pressable: false

			Button
			{
				id: gamesButton
				width: parent.width * 0.95
				height: parent.height * 0.95
				anchors.verticalCenter: parent.verticalCenter
				anchors.horizontalCenter: parent.horizontalCenter
				text: "Go To Games"

				//need to reset these once center piece of
				//right hand screen is determined
				KeyNavigation.up: settingsButtons
				KeyNavigation.down: backButton
				KeyNavigation.left: textEditor
//				KeyNavigation.right: lobbyListContainer
			}
		}

		//file transfer block

		VaporRectangle
		{
			id: backContainer
			width: parent.width
			height: parent.height * 0.5
			color: "transparent"
			anchors.bottom: parent.bottom
			pressable: false

			Button
			{
				id: backButton
				width: parent.width * 0.95
				height: parent.height * 0.95
				anchors.verticalCenter: parent.verticalCenter
				anchors.horizontalCenter: parent.horizontalCenter
				text: "Back Home"

				//need to reset these once center piece of
				//right hand screen is determined
				KeyNavigation.up: gamesButton
				KeyNavigation.down: settingsButtons
				KeyNavigation.left: textEditor
//				KeyNavigation.right: lobbyListContainer

				onClicked:
				{
					navigationButtonContainer.backButtonPressed = true;
					netLobbyContainer.visible = false;
					homescreen.setDefaultFocus();
				}
			}
		}
	}//end application navigation buttons
}
