import QtQuick 2.0


VaporRectangle
{
	id: settingsContainer
	width: homescreen.width
	height: homescreen.height
	color: vaporTheme.base
	visible: false
	z: parent.z + 1

	property string currentTab: ""

	function setDefaultFocus (setTab)
	{
		navigationTabContainer.focus = true;
		if (setTab == "app")
		{
			appTab.openTab = true;
		}
		else if (setTab == "emu")
		{
			emuTab.openTab = true;
		}
		else if (setTab == "cont")
		{
			contTab.openTab = true;
		}
		currentTab = setTab;
	}

	Image
	{
		id: lobbyBackground
		source: "./vaporBackground.jpg"
		anchors.left: navigationTabContainer.right
		height: parent.height
		width: parent.width - navigationTabContainer.width
		opacity: 0.2
	}

	//define settings interfaces
	ApplicationSettings
	{
		id: appSettings
		visible: false
		focus: false

		KeyNavigation.left: navigationTabContainer
		KeyNavigation.right: navigationTabContainer
	}

	ControllerSettings
	{
		id: contSettings
		visible: false
		focus: false

		KeyNavigation.left: navigationTabContainer
		KeyNavigation.right: navigationTabContainer
	}

	EmulatorSettings
	{
		id: emuSettings
		visible: false
		focus: false

		KeyNavigation.left: navigationTabContainer
		KeyNavigation.right: navigationTabContainer
	}

	VaporRectangle
	{
		id: navigationTabContainer
		height: parent.height
		width: parent.width * 0.05
		anchors.left: parent.left
		color: vaporTheme.alternateBase
		focus: false
		radius: 9

		scalable: false
		pressable: false

		Keys.onReturnPressed: appTab.focus = true;

		Column
		{
			id: navigationTabPositioner
			anchors.fill: parent

			VaporVerticalTab
			{
				id: appTab
				height: parent.height / 3
				width: parent.width
				tabText: "Application Settings"

				KeyNavigation.down: emuTab
				KeyNavigation.up: contTab
				KeyNavigation.right: appSettings

				Keys.onPressed:
				{
					if (event.key == Qt.Key_Return)
					{
						focus = false;
						appTab.openTab = true;
						currentTab = "app";
						appSettings.setDefaultFocus();
						emuTab.openTab = false;
						contTab.openTab = false;
						event.accepted = true;
					}
					else if (event.key == Qt.Key_Backspace)
					{
						focus = false;
						navigationTabContainer.focus = true;
						event.accepted = true;
					}
				}
			}
			VaporVerticalTab
			{
				id: emuTab
				height: parent.height / 3
				width: parent.width
				tabText: "Emulator Settings"

				KeyNavigation.up: appTab
				KeyNavigation.down: contTab

				Keys.onPressed:
				{
					if (event.key == Qt.Key_Return)
					{
						focus = false;
						appTab.openTab = false;
						emuTab.openTab = true;
						currentTab = "emu";
						emuSettings.setDefaultFocus();
						contTab.openTab = false;
						event.accepted = true;
					}
					else if (event.key == Qt.Key_Backspace)
					{
						focus = false;
						navigationTabContainer.focus = true;
						event.accepted = true;
					}
				}
			}
			VaporVerticalTab
			{
				id: contTab
				height: parent.height / 3
				width: parent.width
				tabText: "Controller Settings"

				KeyNavigation.up: emuTab
				KeyNavigation.down: appTab

				Keys.onPressed:
				{
					if (event.key == Qt.Key_Return)
					{
						focus = false;
						appTab.openTab = false;
						emuTab.openTab = false;
						contTab.openTab = true;
						currentTab = "cont";
						contSettings.setDefaultFocus();
						event.accepted = true;
					}
					else if (event.key == Qt.Key_Backspace)
					{
						focus = false;
						navigationTabContainer.focus = true;
						event.accepted = true;
					}
				}
			}
		}
	}

	function resetTabSelection()
	{
		appTab.openTab = false;
		emuTab.openTab = false;
		contTab.openTab = false;
		currentTab = "";
	}

	onCurrentTabChanged:
	{
//		console.log(currentTab);
		switch (currentTab)
		{
//		case "app":
//			appSettings.visible = true;
//			appSettings.focus = true;
//			emuSettings.visible = false;
//			contSettings.visible = false;
//			break;
//		case "emu":
//			emuSettings.visible = true;
//			emuSettings.focus = true;
//			appSettings.visible = false;
//			contSettings.visible = false;
//			break;
//		case "cont":
//			contSettings.visible = true;
//			contSettings.focus = true;
//			appSettings.visible = false;
//			emuSettings.visible = false;
//			break;
		default:
			appSettings.visible = false;
			emuSettings.visible = false;
			contSettings.visible = false;
			appSettings.focus = false;
			emuSettings.focus = false;
			contSettings.focus = false;
			break;
		}
	}

	Keys.onPressed:
	{
		if (event.key == Qt.Key_Return)
		{

		}
		else if (event.key == Qt.Key_Backspace)
		{
			resetTabSelection();
			settingsContainer.visible = false;
			homescreen.setDefaultFocus();
			event.accepted = true;
		}
	}
}
