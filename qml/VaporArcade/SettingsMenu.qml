import QtQuick 2.0
/******************************************************************************
*Author Jack sanchez
*Contributers Eli Kloft & Aaron Lindberg
******************************************************************************/
VaporRectangle
{
	id: settingsContainer
	width: homescreen.width
	height: homescreen.height
	color: vaporTheme.base
    pressable:true
	visible: false
	z: parent.z + 1
    readonly property int tabCount: 4
    property var tabs:      [ appTab,       gameLibTab,     emuTab,         contTab     ]
    property var tabViews:  [ appSettings,  gameLibManager, emuSettings,    contSettings]
    property int currentTab: 0

    function setTab(tabNum)
    {
        resetTabSelection()
        if(tabNum < 0)
            currentTab=tabCount-1
        else
            currentTab=tabNum % tabCount
        tabs[currentTab].openTab = true
        tabViews[currentTab % tabCount].visible=true
    }

    function setDefaultFocus ()
    {
        resetTabSelection()
        visible=true
        setTab(currentTab)
	}
    Keys.onPressed:
    {
        event.accepted = true;
        if(event.key == Qt.Key_Down)
        {
            setTab(currentTab+1)
        }
        else if(event.key == Qt.Key_Up)
        {
            setTab(currentTab-1)
        }else if(event.key == Qt.Key_Return)
        {
            tabViews[currentTab].setDefaultFocus()
        }else if (event.key == Qt.Key_Backspace)
        {
            resetTabSelection();
            settingsContainer.visible = false;
            homescreen.setDefaultFocus();
        }
    }
	Image
	{
        id: tabsView
		source: "./vaporBackground.jpg"
		anchors.left: navigationTabContainer.right
		height: parent.height
		width: parent.width - navigationTabContainer.width
	}
	//define settings interfaces

    Rectangle
    {
		id: navigationTabContainer
        z:tabsView.z+2
        clip:false
        property int navTabHeight: height / tabCount * 32/33
        height: parent.height
		width: parent.width * 0.05
		anchors.left: parent.left
        color: "transparent"
		focus: false
		radius: 9
		Column
		{
			id: navigationTabPositioner
			anchors.fill: parent
            clip:false
            VaporVerticalTab
            {
                id: appTab
                focus:openTab
                height: navigationTabContainer.navTabHeight
                width: navigationTabContainer.width
                tabText: "Application Settings"
            }
            VaporVerticalTab
            {
                id: gameLibTab
                focus:openTab
                height: navigationTabContainer.navTabHeight
                width: navigationTabContainer.width
                tabText: "Library Manager"
            }
            VaporVerticalTab
            {
                id: emuTab
                focus:openTab
                height:navigationTabContainer.navTabHeight
                width: navigationTabContainer.width
                tabText: "Emulator Settings"
            }
            VaporVerticalTab
            {
                id: contTab
                focus:openTab
                height: navigationTabContainer.navTabHeight
                width: navigationTabContainer.width
                tabText: "Controller Settings"
            }
		}
	}
    ApplicationSettings
    {
        id: appSettings
        visible: appTab.openTab
        focus: false
        anchors.fill: tabsView
        height: tabsView.height
        width: tabsView.width
        z:tabsView.z+1
    }

    ControllerSettings
    {
        id: contSettings
        visible: contTab.openTab
        focus: false
        anchors.fill: tabsView
        height: tabsView.height
        width: tabsView.width
        z:tabsView.z+1
    }

    EmulatorSettings
    {
        id: emuSettings
        visible: emuTab.openTab
        focus: false
        anchors.fill: tabsView
        height: tabsView.height
        width: tabsView.width
        z:tabsView.z+1
    }
    GameLibraryManager
    {
        id: gameLibManager
        visible: gameLibTab.openTab
        focus: false
        anchors.fill: tabsView
        height: tabsView.height
        width: tabsView.width
        z:tabsView.z+1
    }

	function resetTabSelection()
	{
		appTab.openTab = false;
        appSettings.visible=appTab.openTab
		emuTab.openTab = false;
        emuSettings.visible = emuTab.openTab
		contTab.openTab = false;
        contSettings.visible = contTab.openTab
        gameLibTab.openTab = false;
        gameLibManager.visible = gameLibTab.openTab
	}
}
