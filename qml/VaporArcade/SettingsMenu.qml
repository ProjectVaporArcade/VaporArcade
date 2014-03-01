import QtQuick 2.0

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
    property var tabs: [ appTab, gameLibTab, emuTab, contTab ]
    property var tabViews: [ appSettings, gameLibManager, contSettings, emuSettings]
    property int currentTab: 0

    function setTab(tabNum)
    {
        tabViews[currentTab % tabCount].visible=false
        tabs[currentTab % tabCount].openTab=false;
        if(tabNum < 0)
            currentTab=tabCount-1
        else if (tabNum >= tabCount)
            currentTab=0
        else
            currentTab=tabNum % tabCount
        console.debug(currentTab)
        tabs[currentTab % tabCount].focus=true
        tabViews[currentTab % tabCount].visible=true
    }

    function setDefaultFocus ()
	{

        //navigationTabContainer.focus = true;
        //currentTab = setTab;
        visible=true
        tabs[currentTab].openTab = true
        setTab(currentTab)
	}
    Keys.onPressed:
    {
        if(event.key == Qt.Key_Down)
        {
            setTab(currentTab+1)
        }
        else if(event.key == Qt.Key_Up)
        {
            setTab(currentTab-1)
        }else if (event.key == Qt.Key_Backspace)
        {
            resetTabSelection();
            settingsContainer.visible = false;
            homescreen.setDefaultFocus();
            event.accepted = true;
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
                height: navigationTabContainer.navTabHeight
                width: navigationTabContainer.width
                tabText: "Application Settings"
            }
            VaporVerticalTab
            {
                id: gameLibTab
                height: navigationTabContainer.navTabHeight
                width: navigationTabContainer.width
                tabText: "Library Manager"
            }
            VaporVerticalTab
            {
                id: emuTab
                height:navigationTabContainer.navTabHeight
                width: navigationTabContainer.width
                tabText: "Emulator Settings"
            }
            VaporVerticalTab
            {
                id: contTab
                height: navigationTabContainer.navTabHeight
                width: navigationTabContainer.width
                tabText: "Controller Settings"
            }
		}
	}
    ApplicationSettings
    {
        id: appSettings
        visible: false
        focus: false
        anchors.fill: tabsView
    }

    ControllerSettings
    {
        id: contSettings
        visible: false
        focus: false
        anchors.fill: tabsView
    }

    EmulatorSettings
    {
        id: emuSettings
        visible: false
        focus: false
        anchors.fill: tabsView
    }
    GameLibraryManager
    {
        id: gameLibManager
        visible: false
        focus: false
        anchors.fill: tabsView
    }

	function resetTabSelection()
	{
		appTab.openTab = false;
		emuTab.openTab = false;
		contTab.openTab = false;
        gameLibTab.openTab = false;
        currentTab = 0;
	}
}
