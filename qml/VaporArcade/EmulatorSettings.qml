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
    color: "transparent"
    border.width: 8
	border.color: vaporTheme.shadow
	radius: 9
	focus: false


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
            settingsContainer.setDefaultFocus();
			event.accepted = true;
		}
	}
}
