import QtQuick 2.0

//must set size from parent object
VaporRectangle
{
	id: emuSettingsContainer
	scalable: false
	pressable: false
    zScalable: false
    anchors.horizontalCenterOffset: 0
    z: settingsContainer.z + 1
	color: vaporTheme.base
    height: settingsContainer
    width: settingsContainer.width
    border.width: 2
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
		emuSettingsContainer.visible = true;
		emuSettingsContainer.focus = true;
	}

	Keys.onPressed:
	{
		if (event.key == Qt.Key_Return)
		{
			emuSettingsContainer.focus = false;
			//settings category_x.focus = true;
			event.accepted = true;
		}
		else if (event.key == Qt.Key_Backspace)
		{
			emuSettingsContainer.visible = false;
			emuSettingsContainer.focus = false;
			settingsContainer.setDefaultFocus("emu");
			event.accepted = true;
		}
	}
}
