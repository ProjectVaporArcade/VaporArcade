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
    color: "transparent"
    height: settingsContainer.height
    width: (settingsContainer.width - navigationTabContainer.width)
	border.width: 8
	border.color: vaporTheme.shadow
	radius: 9
	focus: false

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
}
