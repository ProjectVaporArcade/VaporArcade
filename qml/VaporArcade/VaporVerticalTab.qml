import QtQuick 2.0

VaporRectangle
{
	id: tabContainer
	color: selected ? vaporTheme.dark : vaporTheme.mid
	visible: true
	scalable: false
	pressable: true
	focus: false

	border.width: 8
	border.color: vaporTheme.shadow

	radius: 9

	property string tabText: ""
	property alias openTab: tabContainer.selected

	Text
	{
		id: tabLabel
		anchors.centerIn: parent
		font.pointSize: 16
		color: vaporTheme.light
		rotation: -90
		text: tabText
	}
}
