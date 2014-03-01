import QtQuick 2.0

//must set size from parent object
VaporRectangle
{
	id: contSettingsContainer
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
		contSettingsContainer.visible = true;
		contSettingsContainer.focus = true;
	}

	Keys.onPressed:
	{
		if (event.key == Qt.Key_Return)
		{
			contSettingsContainer.focus = false;
			//settings category_x.focus = true;
			event.accepted = true;
		}
		else if (event.key == Qt.Key_Backspace)
		{
			contSettingsContainer.visible = false;
			contSettingsContainer.focus = false;
			settingsContainer.setDefaultFocus("cont");
			event.accepted = true;
		}
	}

	VaporRectangle
	{
		id: controllerLayoutContainer
		height: parent.height * 0.95
		width: parent.width * 0.95
		opacity: 0.75
		radius: 9
		gradient: Gradient
		{
			GradientStop { position: 0.0; color: vaporTheme.mid }
			GradientStop { position: 1.0; color: vaporTheme.shadow }
		}
	}

}
