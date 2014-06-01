import QtQuick 2.0
/******************************************************************************
* Author Jack Sanchez
* Contributers Jack Sanchez, Aaron Lindber & Eli Kloft
* Overview *
* Notice that you have to double enter to even select a category, this is how
* jack thought navigation works... So broken to say the least.
* Aaron Lindberg and Eli Kloft want no credit to this because of the Ui
* attrocity that it is. The lack of comments adhears to the vapor coding
* standard.
******************************************************************************/
//must set size from parent object
VaporRectangle
{
	id: appSettingsContainer
	scalable: false
	pressable: false
	zScalable: false
	anchors.verticalCenter: settingsContainer.verticalCenter
	anchors.horizontalCenter: settingsContainer.horizontalCenter
	anchors.horizontalCenterOffset: 35
	z: settingsContainer.z + 1
	color: vaporTheme.base
	height: settingsContainer.height * 0.95
	width: (settingsContainer.width - navigationTabContainer.width) * 0.95
	border.width: 8
	border.color: vaporTheme.shadow
	radius: 9
	focus: false

	Image
	{
		id: lobbyBackground
		source: "./vaporBackground.jpg"
		height: parent.height
		width: parent.width
		opacity: 0.2
	}

	function setDefaultFocus()
	{
		appSettingsContainer.visible = true;
		appSettingsContainer.focus = true;
	}

	Keys.onPressed:
	{
		if (event.key == Qt.Key_Return)
		{
			appSettingsContainer.focus = false;
			videoSettings.focus = true;
			event.accepted = true;
		}
		else if (event.key == Qt.Key_Backspace)
        {
			appSettingsContainer.focus = false;
            settingsContainer.setDefaultFocus();
			event.accepted = true;
		}
	}

	VaporRectangle
	{
		id: videoSettings

		height: (appSettingsContainer.height / 2) * 0.95
		width: (appSettingsContainer.width / 2) * 0.95

		anchors.left: parent.left
		anchors.leftMargin: 25
		anchors.top: parent.top
		anchors.topMargin: 25
		focus: false

		z: parent.z + 1

		KeyNavigation.left: audioSettings
		KeyNavigation.right: audioSettings
		KeyNavigation.down: generalSettings
		KeyNavigation.up: generalSettings

		Keys.onPressed:
		{
			if (event.key == Qt.Key_Backspace)
			{
				videoSettings.focus = false;
				appSettingsContainer.focus = true;
				event.accepted = true;
			}
		}

		gradient: Gradient
		{
			GradientStop { position: 0.0; color: vaporTheme.midlight }
			GradientStop { position: 0.7; color: vaporTheme.mid }
			GradientStop { position: 1.0; color: vaporTheme.shadow }
		}
	}

	VaporRectangle
	{
		id: audioSettings
		height: (appSettingsContainer.height / 2) * 0.95
		width: (appSettingsContainer.width / 2) * 0.95

		anchors.left: videoSettings.right
		anchors.leftMargin: 25
		anchors.top: appSettingsContainer.top
		anchors.topMargin: 25
		focus: false

		z: parent.z + 1

		KeyNavigation.left: videoSettings
		KeyNavigation.right: videoSettings
		KeyNavigation.down: generalSettings
		KeyNavigation.up: generalSettings

		gradient: Gradient
		{
			GradientStop { position: 0.0; color: vaporTheme.midlight }
			GradientStop { position: 0.7; color: vaporTheme.mid }
			GradientStop { position: 1.0; color: vaporTheme.shadow }
		}
	}

	VaporRectangle
	{
		id: generalSettings
		height: (appSettingsContainer.height / 2) * 0.9
		width: appSettingsContainer.width * 0.95
		anchors.horizontalCenter: appSettingsContainer.horizontalCenter
		anchors.horizontalCenterOffset: -5
		anchors.top: videoSettings.bottom
		anchors.topMargin: 25

		KeyNavigation.up: videoSettings
		KeyNavigation.down: videoSettings
		KeyNavigation.right: generalSettings
		KeyNavigation.left:	generalSettings

		gradient: Gradient
		{
			GradientStop { position: 0.0; color: vaporTheme.midlight }
			GradientStop { position: 0.7; color: vaporTheme.mid }
			GradientStop { position: 1.0; color: vaporTheme.shadow }
		}
	}
}
