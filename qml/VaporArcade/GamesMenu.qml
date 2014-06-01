import QtQuick 2.0
//Author Jack Sanchez
//contributers Eli Kloft, Aaron Lindberg & Jack Sanchez
VaporRectangle
{
    id: gamesContainer
	width: homescreen.width
	height: homescreen.height
	color: vaporTheme.shadow
	scalable: false
	focusable: false
	pressable: false
	z: parent.z + 1

	function setDefaultFocus()
    {
        fullGameListEntry.focus=true;
		trailerPlayer.play();
	}


	Keys.onPressed:
	{
		if (event.key == Qt.Key_Return)
		{
            if(fullGameListEntry.focus == true)
            {
                allGameLibrary.setDefaultFocus();
            }
		}
		else if (event.key == Qt.Key_Backspace)
		{
			gamesContainer.visible = false;
			homescreen.setDefaultFocus();
		}
    }

	//define an emulator launcher object
	//for use only within the game menus

	Image
	{
		id: lobbyBackground
		source: "./vaporBackground.jpg"
		anchors.centerIn: parent
		height: parent.height
		width: parent.width
		opacity: 0.2
	}

	VaporRectangle
	{
		id: trailerContainer
		height: (parent.height / 3) * 0.95
		width: (parent.width / 3) * 0.95
		gradient: Gradient
		{
			GradientStop { position: 0.0; color: vaporTheme.mid }
			GradientStop { position: 1.0; color: vaporTheme.shadow }
		}
		radius: 9

		anchors.left: parent.left
		anchors.leftMargin: 100
		anchors.top: parent.top
		anchors.topMargin: 100

		VaporVideoPlayer
		{
			id: trailerPlayer
			height: parent.height
			width: parent.width
		}
	}

	VaporRectangle
	{
		id: lastPlayedContainer
        Image{
            id: lastPlayedContainerLogo
            source:"./vaporGamesLastPlayed.png"
            anchors.centerIn: parent.Center
            anchors.fill: parent
        }

		height: (parent.height / 3) * 0.95
		width: (parent.width / 3) * 0.95
        gradient: Gradient
        {
            GradientStop { position: 0.0; color: vaporTheme.mid }
            GradientStop { position: 0.3; color: vaporTheme.midlight }
            GradientStop { position: 1.0; color: vaporTheme.mid }
        }
		radius: 9

		KeyNavigation.right: fullGameListEntry
		KeyNavigation.left: fullGameListEntry
		KeyNavigation.up: lastPlayedContainer
		KeyNavigation.down: lastPlayedContainer

		anchors.left: parent.left
		anchors.leftMargin: 100
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 100
	}

	VaporRectangle
	{
		id: filteredGameList
        Image{
            id: filteredGameListContainerLogo
            source:"./vaporGamesFilterGames.png"
            anchors.centerIn: parent.Center
            anchors.fill: parent
        }
        height: (parent.height / 3) * 0.95
		width: (parent.width / 3) * 0.95
		radius: 9
		gradient: Gradient
		{
			GradientStop { position: 0.0; color: vaporTheme.mid }
			GradientStop { position: 0.3; color: vaporTheme.midlight }
			GradientStop { position: 1.0; color: vaporTheme.mid }
		}

		KeyNavigation.left: filteredGameList
		KeyNavigation.right: filteredGameList
		KeyNavigation.down: fullGameListEntry
		KeyNavigation.up: fullGameListEntry

		anchors.right: parent.right
		anchors.rightMargin: 100
		anchors.top: parent.top
		anchors.topMargin: 100
	}
    AllGamesLibrary
    {
        id: allGameLibrary
        visible: false
    }
	VaporRectangle
	{
		id: fullGameListEntry
        Image{
            id: allGamesListContainerLogo
            source:"./vaporGamesAllGames.png"
            anchors.centerIn: parent.Center
            anchors.fill: parent
        }

        height: (parent.height / 3) * 0.95
		width: (parent.width / 3) * 0.95
		radius: 9
		gradient: Gradient
		{
			GradientStop { position: 0.0; color: vaporTheme.mid }
			GradientStop { position: 0.3; color: vaporTheme.midlight }
            GradientStop { position: 0.9; color: vaporTheme.mid }
		}
		KeyNavigation.left: lastPlayedContainer
		KeyNavigation.right: lastPlayedContainer
		KeyNavigation.up: filteredGameList
		KeyNavigation.down: filteredGameList

        anchors.right: parent.right
		anchors.rightMargin: 100
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 100
	}
}
