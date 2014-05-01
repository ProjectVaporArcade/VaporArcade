import QtQuick 2.0

VaporRectangle
{
	id: homescreen
	height: ScreenHeight
	width: ScreenWidth
	scalable: false
	pressable: false
	zScalable: false
	focusable: false
	color: vaporTheme.shadow
	Image
	{
		id: background
		source: "./vaporBackground.jpg"
		height: parent.height
		width: parent.width
        opacity: .8
		anchors.centerIn: parent
	}
    Image
    {
        id: logo
        source: "./vaporLogo.png"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 10
        anchors.leftMargin: 10
        opacity: 0.5
    }

	//global instances
	VaporTheme
	{
		id: vaporTheme
	}

	NetLobby
	{
		id: vaporChat
		visible: false
	}

	SettingsMenu
	{
		id: vaporSettings
		visible: false
	}
	GamesMenu
	{
		id: gamesMenu
		visible: false
	}

	//end global instances

	//main navigation items

	VaporRectangle
	{
		id: gameEntry
        height: parent.height * 0.33
        width: parent.width * 0.25
		gradient: Gradient
		{
			GradientStop { position: 0.0; color: vaporTheme.mid }
			GradientStop { position: 0.3; color: vaporTheme.midlight }
			GradientStop { position: 1.0; color: vaporTheme.mid }
		}

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter
		anchors.leftMargin: 10
		anchors.rightMargin: 10
		radius: 9
		opacity: 0.9

		KeyNavigation.up: powerButton
		KeyNavigation.right: networkEntry
		KeyNavigation.left: settingsEntry

		Keys.onReturnPressed:
		{
			gamesMenu.visible = true;
			event.accepted = true;
			gamesMenu.setDefaultFocus();
		}

		Image
		{
			id: gameLogo
			source: "./vaporGamesLogo.png"
			anchors.centerIn: parent
		}

	}

	VaporRectangle
	{
		id: networkEntry
        height: parent.height * 0.33
        width: parent.width * 0.25
		gradient: Gradient
		{
			GradientStop { position: 0.0; color: vaporTheme.mid }
			GradientStop { position: 0.3; color: vaporTheme.midlight }
			GradientStop { position: 1.0; color: vaporTheme.mid }
		}
		anchors.verticalCenter: parent.verticalCenter
		anchors.left: gameEntry.right
		anchors.leftMargin: 30
		radius: 9
		opacity: 0.9

		KeyNavigation.up: powerButton
		KeyNavigation.left: gameEntry
		KeyNavigation.right: settingsEntry

		Keys.onReturnPressed:
		{
			vaporChat.visible = true;
			event.accepted = true;
			vaporChat.setDefaultFocus();
		}

		Image
		{
			id: networkLogo
			source: "./vaporNetworkLogo.png"
			anchors.centerIn: parent
		}
	}

	VaporRectangle
	{
		id: settingsEntry
        height: parent.height * 0.33
        width: parent.width * 0.25
		gradient: Gradient
		{
			GradientStop { position: 0.0; color: vaporTheme.mid }
			GradientStop { position: 0.3; color: vaporTheme.midlight }
			GradientStop { position: 1.0; color: vaporTheme.mid }
		}
		anchors.verticalCenter: parent.verticalCenter
		anchors.right: gameEntry.left
		anchors.rightMargin: 30
		radius: 9
		opacity: 0.9

		KeyNavigation.up: powerButton
		KeyNavigation.left: networkEntry
		KeyNavigation.right: gameEntry

		Keys.onReturnPressed:
		{
			vaporSettings.visible = true;
            vaporSettings.setDefaultFocus();
			event.accepted = true;
		}

		Image
		{
			id: settingsLogo
			source: "./vaporSettingsLogo.png"
			anchors.centerIn: parent
		}
	}

	//end main navigation items


	//vapor power item
	VaporRectangle
	{
		id: powerButton
		height: homescreen.height / 14
        width: height
		visible: true
		anchors.right: parent.right
		anchors.top: parent.top
        anchors.rightMargin: parent.width/24
        anchors.topMargin: parent.height/16
		color: "transparent"
		radius:	powerButton.width / 2
        Image
        {
            id: powerButtonImage
            source: "vaporPowerButton.png"
            fillMode: Image.PreserveAspectFit
            anchors.margins: parent/10
            height: parent.height
            width: parent.width
        }
		Keys.onPressed:
		{
			if (event.key == Qt.Key_Return)
			{
                parent.exit()
			}
		}

		KeyNavigation.down: gameEntry
	}

	function setDefaultFocus()
	{
		gameEntry.focus = true;
	}
    function exit()
    {
        Qt.quit();
    }

	//this function does work after
	//all elements have been generated
	Component.onCompleted:
	{
		homescreen.setDefaultFocus();
	}
}

