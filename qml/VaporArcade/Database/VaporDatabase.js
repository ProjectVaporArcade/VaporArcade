.import QtQuick.LocalStorage 2.0 as Sql

function getDatabase()
{
     return Sql.LocalStorage.openDatabaseSync("VaporArcade", "1.0", "database for storing paths for rom library cover art.", 100000);
}
function initialize()
{
    //creates database tables if they do not already exist
    initializeGameSystemTable();
    initializeEmulatorSystemTable();

    initializeGameTitleTable();
    initializeRomRecords();

    initializeMediaTypeTable();
    initializeRomMediaTable();
}
function initializeGameSystemTable()
{
    getDatabase().transaction(
        function(tx)
        {
            tx.executeSql('CREATE TABLE IF NOT EXISTS GameSystem( SystemID INTEGER PRIMARY KEY NOT NULL, SystemName VARCHAR(60), AbbrName VARCHAR(5), HoursPlayed INTEGER, PlayCount INTEGER, LastPlayedGame INTEGER, SystemPic VARCHAR(256), FOREIGN KEY(LastPlayedGame) REFERENCES Game(GameID));');
    });
}
function initializeEmulatorSystemTable()
{
    getDatabase().transaction(
        function(tx)
        {
            tx.executeSql('CREATE TABLE IF NOT EXISTS EmulatorSystem( EmulatorID INTEGER PRIMARY KEY NOT NULL, SystemID INTEGER, EmulatorName VARCHAR(32), EmulatorPath VARCHAR(256), FOREIGN KEY(SystemID) REFERENCES GameSystem(SystemID));');
        }
    );
}
function initializeGameTitleTable()
{
    getDatabase().transaction(
        function(tx)
        {
            tx.executeSql('CREATE TABLE IF NOT EXISTS GameTitle (GameTitleID INTEGER PRIMARY KEY NOT NULL, Title VARCHAR(128) UNIQUE);');
    });
}
function initializeRomRecords()
{
    getDatabase().transaction(
        function(tx)
        {
            tx.executeSql('CREATE TABLE IF NOT EXISTS ROM_Records( ROM_ID INTEGER PRIMARY KEY NOT NULL, ROM_Name VARCHAR(60) UNIQUE, Description VARCHAR(2048), PlayCount INTEGER, HoursPlayed INTEGER, SystemID INTEGER NOT NULL, GameTitleID INTEGER, RomPath VARCHAR(1024), FOREIGN KEY(GameTitleID) REFERENCES GameTitle(GameTitleID), FOREIGN KEY(SystemID) REFERENCES GameSystem(SystemID));');
    });
}
function initializeMediaTypeTable()
{
    getDatabase().transaction(
        function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS MediaTypes( TypeID INTEGER PRIMARY KEY NOT NULL, TypeName VARCHAR(20));');
    });
}
function initializeRomMediaTable()
{
    getDatabase().transaction(
        function(tx)
        {
            tx.executeSql('CREATE TABLE IF NOT EXISTS ROM_Media( MediaID INTEGER PRIMARY KEY NOT NULL, ROM_ID INTEGER NOT NULL, TypeID INTEGER NOT NULL, MediaName VARCHAR(256) ,UNIQUE(ROM_ID, TypeID, MediaName) ,FOREIGN KEY(ROM_ID) REFERENCES ROM_Records(ROM_ID), FOREIGN KEY(TypeID) REFERENCES MediaTypes(TypeID))');
    });
}
