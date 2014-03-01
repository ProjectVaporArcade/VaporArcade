.import QtQuick.LocalStorage 2.0 as Sql
function getDatabase()
{
     return Sql.LocalStorage.openDatabaseSync("VaporArcade.db", "1.0", "database for storing paths for rom library cover art.", 100000);
}
function initialize()
{
    var db = getDatabase();
    db.transaction(
        function(tx)
        {
            tx.executeSql('CREATE TABLE IF NOT EXISTS Game (GameID INTEGER PRIMARY KEY NOT NULL, GameName VARCHAR(60));');
    });
    db.transaction(
        function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS MediaTypes( TypeID INTEGER PRIMARY KEY NOT NULL, TypeName VARCHAR(20));');
    });
    db.transaction(
        function(tx)
        {
            tx.executeSql('CREATE TABLE IF NOT EXISTS GameSystem( SystemID INTEGER PRIMARY KEY NOT NULL, SystemName VARCHAR(60), AbbrName VARCHAR(5), HoursPlayed INTEGER, PlayCount INTEGER, LastPlayedGame INTEGER, SystemPic VARCHAR(256), FOREIGN KEY(LastPlayedGame) REFERENCES Game(GameID));');
    });
    db.transaction(
        function(tx)
        {
            tx.executeSql('CREATE TABLE IF NOT EXISTS EmulatorSystem( EmulatorID INTEGER PRIMARY KEY NOT NULL, SystemID INTEGER, EmulatorName VARCHAR(32), EmulatorPath VARCHAR(256), FOREIGN KEY(SystemID) REFERENCES GameSystem(SystemID));'); });
    db.transaction(
        function(tx)
        {
            tx.executeSql('CREATE TABLE IF NOT EXISTS ROM_Records( ROM_ID INTEGER PRIMARY KEY NOT NULL, ROM_Name VARCHAR(60), Description VARCHAR(2048), PlayCount 	INTEGER, HoursPlayed INTEGER, SystemID INTEGER NOT NULL, GameID INTEGER NOT NULL, FOREIGN KEY(GameID) REFERENCES Game(GameID), FOREIGN KEY(SystemID) REFERENCES GameSystem(SystemID));');
    });
    db.transaction(
        function(tx)
        {
            tx.executeSql('CREATE TABLE IF NOT EXISTS ROM_Media( MediaID INTEGER PRIMARY KEY NOT NULL, ROM_ID INTEGER NOT NULL, TypeID INTEGER NOT NULL, MediaName VARCHAR(256), FOREIGN KEY(ROM_ID) REFERENCES ROM_Records(ROM_ID), FOREIGN KEY(TypeID) REFERENCES MediaTypes(TypeID))');
    });
}
function refreshAllGames()
{
    var res;
    getDatabase().transaction(
    function (tx)
    {
        gameList.clear();
        res = tx.executeSql('SELECT G.GameID, ROM_Name, GameName, MediaName, Description, S.SystemName, S.AbbrName, S.SystemPic, S.SystemID FROM ROM_Records AS RR LEFT OUTER JOIN (SELECT ROM_ID, MediaName FROM ROM_Media AS RM LEFT OUTER JOIN MediaTypes AS MT ON MT.TypeID = RM.TypeID WHERE TypeName = "COVER") AS RRM ON RR.ROM_ID = RRM.ROM_ID JOIN Game AS G ON G.GameID == RR.GameID JOIN GameSystem AS S ON RR.SystemID = S.SystemID;');
        var qLen=res.rows.length
        for(var i = 0; i < res.rows.length; ++i)
        {
            var itm=res.rows.item(i)
            var RomName=itm.ROM_Name;
            var GameName=itm.GameName;
            var Desc=itm.Description
            var Disp=itm.MediaName;
            var sys=itm.AbbrName;
            var sysFull=itm.SystemName;
            var sPic=itm.SystemPic;
            var sysID=itm.SystemID
            console.debug(RomName + ":" + GameName + ":" + sys)
            gameList.append({"name":RomName, "game":GameName, "desc":Desc, "display":Disp, "sysFull":sysFull, "sysAbbr":sys, "sysPic":sPic, "sysID":sysID})
        }
        libraryView.model = gameList
    });
    return res;
}
function refreshEmuList(emuNameList,emuList,system)
{
    getDatabase().transaction(
    function (tx)
    {
        emuNameList.clear();
        emuList.clear();
        var res = tx.executeSql('SELECT EmulatorName, EmulatorPath FROM EmulatorSystem WHERE ? = SystemID;',[system]);
        for(var i = 0; i < res.rows.length; ++i)
        {
            var itm=res.rows.item(i)
            var emuName = itm.EmulatorName
            var emuPath = itm.EmulatorPath
            emuNameList.append({"text":emuName})
            console.debug(emuName);
            emuList.append({"text":emuName,"emuPath":emuPath})
        }
    });
}

function insertGameRom( RomPath )
{
    getDatabase().transaction(
    function(tx)
    {
        tx.executeSql('INSERT INTO Game(GameName) VALUES(?);', [RomPath]);
    });
}
function insertGameSystem( SystemName, Abbr, pic)
{
    getDatabase().transaction(
    function(tx)
    {
         tx.executeSql('INSERT INTO GameSystem(SystemName, AbbrName, HoursPlayed, PlayCount, LastPlayedGame, SystemPic)VALUES (?, ?, 0, 0, null,?);',[SystemName, Abbr, pic]);
    });
}
function insertMediaType( type )
{
    getDatabase().transaction(
    function(tx)
    {
        tx.executeSql('INSERT INTO MediaTypes(TypeName) VALUES(?);', [type]);
    });
}
function insertRomMedia( RomID, TypeID, MediaName )
{
    getDatabase().transaction(
        function(tx) {
            tx.executeSql('INSERT INTO ROM_Media( ROM_ID, TypeID, MediaName) VALUES (?,?,?);',[RomID,TypeID,MediaName]);
    });
}
function insertRomRecord( gameTitle, description, systemID, gameID )
{
    getDatabase().transaction(
    function(tx)
    {
        tx.executeSql('INSERT INTO ROM_Records(ROM_Name, Description, PlayCount, HoursPlayed, SystemID, GameID)VALUES (?, ?, 0,0,?,?);',[gameTitle, description, systemID, gameID]);
    });
}
function insertEmulatorSystem( systemID, emuName, emuPath )
{
    getDatabase().transaction(
    function(tx)
    {
        tx.executeSql('INSERT INTO EmulatorSystem(SystemID, EmulatorName, EmulatorPath)VALUES(?,?,?);',[systemID, emuName, emuPath]);
    });
}
function deleteAllRecords()
{
    getDatabase().transaction(
        function(tx)
        {
            tx.executeSql('DELETE FROM EmulatorSystem;');
            tx.executeSql('DELETE FROM ROM_Media;');
            tx.executeSql('DELETE FROM MediaTypes;');
            tx.executeSql('DELETE FROM ROM_Records;');
            tx.executeSql('DELETE FROM Game;');
            tx.executeSql('DELETE FROM GameSystem;');
        }
    );
}
function testInserts()
{
    deleteAllRecords()
    insertMediaType("COVER");
    insertMediaType("SPINE");
    insertGameSystem("Super Nintendo Entertainment System", "SNES","/Dropbox/My Qt/JP Stuff/JP Stuff For Eli And Aaron/VaporRevamp/VaporRevamp/Emulator/SNES/SNES.png");
    insertGameSystem("Nintendo 64", "N64","/Dropbox/My Qt/JP Stuff/JP Stuff For Eli And Aaron/VaporRevamp/VaporRevamp/Emulator/N64/N64.png");
    insertEmulatorSystem(2,"MUPEN64 PLUS", "MUPEN.py")
    insertEmulatorSystem(2,"Project64", "Project64.py")
    insertGameRom("MarioKart.smc");
    insertGameRom("Dropbox/OIT Shared Files/VaporArcade/Roms/Army Men - Air Combat.z64")
    insertGameRom("Bonkers.smc")
    insertRomRecord("Super Mario Brothers", "Mario is an italian plumber, created by japanese, speaks English, looks like a mexican, runs like a jamaican, jumps like he's black and snatches coins like a jew.",1,1);
    insertRomRecord("Army Men - Air Combat", "The Green and Tan armies are once again at war, this time by air. Players can select either the Huey, Chinook, Super Stallion or the Apache. In addition to the Tan Army are hordes of insects that players must also fight off. Players must protect tanks, trucks, other helicopters, a train, and a UFO.",2,2)
    insertRomRecord("Bonkers","That crazy game you have to be on acid to play.", 1,3);

    //fill
    insertRomRecord("Super Mario Brothers", "Mario is an italian plumber, created by japanese, speaks English, looks like a mexican, runs like a jamaican, jumps like he's black and snatches coins like a jew.",1,1);
    insertRomRecord("Army Men - Air Combat", "The Green and Tan armies are once again at war, this time by air. Players can select either the Huey, Chinook, Super Stallion or the Apache. In addition to the Tan Army are hordes of insects that players must also fight off. Players must protect tanks, trucks, other helicopters, a train, and a UFO.",2,2)
    insertRomRecord("Bonkers","That crazy game you have to be on acid to play.", 1,3);
    insertRomRecord("Super Mario Brothers", "Mario is an italian plumber, created by japanese, speaks English, looks like a mexican, runs like a jamaican, jumps like he's black and snatches coins like a jew.",1,1);
    insertRomRecord("Army Men - Air Combat", "The Green and Tan armies are once again at war, this time by air. Players can select either the Huey, Chinook, Super Stallion or the Apache. In addition to the Tan Army are hordes of insects that players must also fight off. Players must protect tanks, trucks, other helicopters, a train, and a UFO.",2,2)
    insertRomRecord("Bonkers","That crazy game you have to be on acid to play.", 1,3);
    insertRomRecord("Super Mario Brothers", "Mario is an italian plumber, created by japanese, speaks English, looks like a mexican, runs like a jamaican, jumps like he's black and snatches coins like a jew.",1,1);
    insertRomRecord("Army Men - Air Combat", "The Green and Tan armies are once again at war, this time by air. Players can select either the Huey, Chinook, Super Stallion or the Apache. In addition to the Tan Army are hordes of insects that players must also fight off. Players must protect tanks, trucks, other helicopters, a train, and a UFO.",2,2)
    insertRomRecord("Bonkers","That crazy game you have to be on acid to play.", 1,3);
    insertRomRecord("Super Mario Brothers", "Mario is an italian plumber, created by japanese, speaks English, looks like a mexican, runs like a jamaican, jumps like he's black and snatches coins like a jew.",1,1);
    insertRomRecord("Army Men - Air Combat", "The Green and Tan armies are once again at war, this time by air. Players can select either the Huey, Chinook, Super Stallion or the Apache. In addition to the Tan Army are hordes of insects that players must also fight off. Players must protect tanks, trucks, other helicopters, a train, and a UFO.",2,2)
    insertRomRecord("Bonkers","That crazy game you have to be on acid to play.", 1,3);
    insertRomRecord("Bonkers","That crazy game you have to be on acid to play.", 1,3);
    insertRomRecord("Bonkers","That crazy game you have to be on acid to play.", 1,3);
    insertRomRecord("Bonkers","That crazy game you have to be on acid to play.", 1,3);
    insertRomRecord("Bonkers","That crazy game you have to be on acid to play.", 1,3);
    insertRomRecord("Bonkers","That crazy game you have to be on acid to play.", 1,3);
    insertRomRecord("Bonkers","That crazy game you have to be on acid to play.", 1,3);
    insertRomRecord("Bonkers","That crazy game you have to be on acid to play.", 1,3);
    insertRomRecord("Bonners","That crazy game you have to be on acid to play.", 1,3);
    //
    insertRomMedia(1,1,"/Dropbox/OIT Shared Files/VaporArcade/Covers/Super-Mario-Bros.jpg");
    insertRomMedia(2,1,"/Dropbox/OIT Shared Files/VaporArcade/Covers/n64_armymenaircombat_front.jpg");
    //fill
    insertRomMedia(4,1,"/Dropbox/OIT Shared Files/VaporArcade/Covers/Super-Mario-Bros.jpg");
    insertRomMedia(5,1,"/Dropbox/OIT Shared Files/VaporArcade/Covers/n64_armymenaircombat_front.jpg");
    insertRomMedia(7,1,"/Dropbox/OIT Shared Files/VaporArcade/Covers/Super-Mario-Bros.jpg");
    insertRomMedia(8,1,"/Dropbox/OIT Shared Files/VaporArcade/Covers/n64_armymenaircombat_front.jpg");
    insertRomMedia(10,1,"/Dropbox/OIT Shared Files/VaporArcade/Covers/Super-Mario-Bros.jpg");
    insertRomMedia(11,1,"/Dropbox/OIT Shared Files/VaporArcade/Covers/n64_armymenaircombat_front.jpg");
}
