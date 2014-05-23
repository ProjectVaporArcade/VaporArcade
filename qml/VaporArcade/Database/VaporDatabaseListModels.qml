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
        testInserts();
        selectAllGameTitles()
        selectAllGameSystems()
        //
    }
    function testInserts()
    {
        try{
        insertGameTitle("Mario")

        insertGameSystem("Calculator","Calc","")//1
        insertGameSystem("Nintendo 64","N64","")//2
        insertGameSystem("Super Nintendo Entertainment System","SNES","/Dropbox/OIT Shared Files/VaporArcade/Emulators/SNES/SNES.png")//3
        insertGameSystem("Nintendo Entertainment System","NES","")//4

        insertEmulator(3,"ZSNES","/Users/Aaron Lindberg/config/VaporArcade/Emulators/SNES/zsnes.py")//1
        insertEmulator(4,"JNES","/Users/Aaron Lindberg/config/VaporArcade/Emulators/NES/jnes.py")//2
        insertEmulator(1,"CALC","/Users/Aaron Lindberg/config/VaporArcade/Emulators/CALC/CALC.py")//3

        insertMediaType("COVER");//1

        insertRomRecord(1,"Super Mario Bros. 3", "nes Mario Game... Play me Meow.",4,"C:\\Dropbox\\OIT Shared Files\\VaporArcade\\Roms\\Super Mario Bros 3.zip")//1
        insertRomRecord(1,"Super Mario World", "sNes Mario Game... Play me Meow.",3,"C:\\Dropbox\\OIT Shared Files\\VaporArcade\\Roms\\Super Mario World.smc")//2
        insertRomRecord(1,"Romancing Saga 3","Romancing Saga 3",3,'C:\\Users\\Aaron Lindberg\\Downloads\\Romancing Saga 3.smc')
        insertMedia(1,1,"")
        }catch(e){}
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
