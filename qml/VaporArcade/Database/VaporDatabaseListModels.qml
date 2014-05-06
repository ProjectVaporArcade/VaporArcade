import QtQuick 2.0
import "VaporDatabase.js" as VaporDB
import "RomDatabaseProxy.js" as RomProxy
import "EmulatorDatabaseProxy.js" as EmulatorProxy
import "MediaDatabaseProxy.js" as MediaProxy

Item
{
    property ListModel gameTitleDataList: gameTitleDataListModel
    property ListModel gameTitleNameList: gameTitleNameListModel
    property ListModel gameRomList: romDataListModel
    property ListModel emulatorNameList: emulatorNameListModel
    property ListModel emulatorDataList: emulatorDataListModel
    property ListModel gameSystemNameList: gameSystemNameListModel
    property ListModel gameSystemDataList: gameSystemDataListModel
    property ListModel mediaTypeDataList: mediaTypeDataListModel
    property ListModel mediaTypeNameList: mediaTypeNameListModel
    property ListModel romMediaDataList: romMediaDataListModel
    Component.onCompleted:
    {
        VaporDB.initialize();
        //testInserts();
        selectAllGameTitles()
        selectAllGameSystems()
        //
    }
    function testInserts()
    {
        insertGameTitle("Test Title")
        insertGameTitle("N/A")
        insertGameTitle("Title 1")
        insertGameTitle("Title 2")
        insertGameTitle("Title 3")
        insertGameTitle("Title 4")
        insertGameTitle("Mario")
        insertGameSystem("Calculator","Calc","")
        insertGameSystem("Nintendo 64","N64","")
        insertGameSystem("Super Nintendo Entertainment System","SNES","")
        insertGameSystem("Nintendo Entertainment System","NES","")
        insertEmulator(1,"C# Calculator","/Users/Aaron Lindberg/Documents/GitHub/VaporArcade/Emulator/CALC/CALC.py")
        insertMediaType("COVER");
        insertRomRecord("","calc", "desc",1,"")
        insertMedia(1,1,"")
    }

    id: vaporDatabaseListModels
    ListModel
    {
        id: gameTitleDataListModel
    }
    ListModel
    {
        id: gameTitleNameListModel
    }
    ListModel
    {
        id: romDataListModel
    }
    ListModel
    {
        id: gameSystemDataListModel
    }
    ListModel
    {
        id: gameSystemNameListModel
    }
    ListModel
    {//combobox ready
        id: emulatorNameListModel
        //string text
    }
    ListModel
    {
        id: emulatorDataListModel
    }
    ListModel
    {
        id: mediaTypeDataListModel
        //String TypeName
        //int typeId
    }
    ListModel
    {//combobox ready
        id: mediaTypeNameListModel
        //string text
    }
    ListModel
    {
        id: romMediaDataListModel
        //String Path
        //int typeId
        //int romId
    }

    function initialize()
    {
        VaporDB.initialize();
    }
//Game System Related Transactions
    function insertGetGameTitleId( gameTitle )
    {
        return RomProxy.getInsertGameTitleID(gameTitle);
    }

    function selectAllGameTitles()
    {
        RomProxy.selectAllGameTitles(gameTitleNameListModel,gameTitleDataListModel)
    }
    function insertGameTitle(title)
    {
        RomProxy.insertGameTitle(title)
    }

    function selectAllGameSystems()
    {
        EmulatorProxy.selectAllGameSystems(gameSystemDataListModel,gameSystemNameListModel)
    }
    function removeGameSystem(systemID)
    {
        EmulatorProxy.removeGameSystem(systemID)
    }
    function insertGameSystem(SystemName, SystemAbbr, SystemPic)
    {
        EmulatorProxy.insertGameSystem(SystemName, SystemAbbr, SystemPic);
    }
    function updateGameSystem( SystemID, SystemName, Abbr, HoursPlayed, PlayCount, LastPlayedGameID, SystemPic)
    {
        EmulatorProxy.updateGameSystem(SystemID, SystemName, Abbr, HoursPlayed, PlayCount, LastPlayedGameID, SystemPic)
    }
//Emulator Related Transactions
    function selectAllEmulators()
    {
        EmulatorProxy.selectAllEmulatorSystem(emulatorDataListModel,emulatorNameListModel)
    }
    function selectEmulatorsBySystem(systemID)
    {
        EmulatorProxy.selectEmulatorsBySystem(emulatorNameListModel,emulatorDataListModel,systemID)
    }
    function insertEmulator(SystemID, EmulatorName, PythonFile)
    {
        EmulatorProxy.insertEmulatorSystem(SystemID, EmulatorName, PythonFile);
    }
    function updateEmulator(EmulatorID, EmulatorName, SystemID, EmulatorPath)
    {
        EmulatorProxy.updateEmulatorSystem(EmulatorID, EmulatorName, SystemID, EmulatorPath)
    }
    function removeEmulator(EmulatorID)
    {
        EmulatorProxy.removeEmulatorSystem(EmulatorID)
    }
//Rom Related Transactions
    //Insert into the database functions
    function insertRomRecord(GameTitleID, GameName, description, GameSystemID, RomPath)
    {
        RomProxy.insertRomRecord(GameName,GameTitleID,description,GameSystemID,RomPath)
    }
    //Update database tables
    function updateRomRecord(RomRecordID, GameTitleID, GameName, GameSystemID, PlayCount, TimeSpan)
    {//needs implimented

    }
    //Delete record from database
    function removeRomRecord(RomRecordID)
    {//needs implimented

    }
    //Select from the database
    function selectAllRomRecords()
    {
        RomProxy.refreshAllGames(romDataListModel)
    }
    //Media
    function insertMedia(RomID, TypeID, MediaName)
    {
        MediaProxy.insertRomMedia(RomID,TypeID,MediaName)
    }
    function selectAllRomMedias()
    {
        MediaProxy.selectAllRomMedias();
    }
    function selectRomMediasByRom(RomID)
    {
        MediaProxy.selectRomMediasByRom(RomID)
    }
    function selectRomMediasByType(typeId)
    {
        MediaProxy.selectRomMediasByType(typeId)
    }
    function selectRomMediasByTypeAndRom(RomID, typeId)
    {
        MediaProxy.selectRomMediasByTypeAndRom(RomID, typeId)
    }
    function removeRomMedia(RomID, typeId, MediaName)
    {

    }

    function insertMediaType(type)
    {
        MediaProxy.insertMediaType(type)
    }
    function selectAllMediaTypes()
    {
        MediaProxy.selectAllMediaTypes()
    }

}
