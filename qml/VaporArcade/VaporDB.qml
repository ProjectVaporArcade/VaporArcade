import "vapordb.js" as VaporStorage
//Qt.include("vapordb.js");
import QtQuick 2.0
Item {
    id:vaporDatabase
    //color:"transparent"
    property GridView libraryView:gameLibrary
    property ListModel gameList:gameListModel
    property ListModel emuNameList:emuNameListModel
    property ListModel emuList:emulatorListModel
    ListModel
    {
        id:emuNameListModel
    }

    ListModel
    {
        id:gameListModel
    }
    ListModel
    {
        id:emulatorListModel
    }

    Component.onCompleted:
    {
        VaporStorage.initialize();
        VaporStorage.testInserts();
        VaporStorage.refreshAllGames();
    }
}
