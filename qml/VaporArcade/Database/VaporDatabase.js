.import QtQuick.LocalStorage 2.0 as Sql
/******************************************************************************
*Author Aaron Lindberg
*Contributers Eli Kloft & Aaron Lindberg
*** Overview ***
* Manages the database initialization and connection.
******************************************************************************/
/******************************************************************************
* getDatabase
* Returns the database connection
******************************************************************************/
function getDatabase()
{
     return Sql.LocalStorage.openDatabaseSync("VaporArcade", "1.0", "database for storing paths for rom library cover art.", 100000);
}
/******************************************************************************
* initialize
* Initializes all of the vapor database tables in the correct order.
******************************************************************************/
function initialize()
{
    //creates database tables if they do not already exist
    //initialize game dichotomy and emulator systems table
    initializeGameSystemTable();
    initializeEmulatorSystemTable();

    //Initialize Game Title and Rom Record tables
    initializeGameTitleTable();
    initializeRomRecords();
    //initialize Media Type and Media to rom Tables
    initializeMediaTypeTable();
    initializeRomMediaTable();
}
/******************************************************************************
* initializeGameSystemTable
* Initializes the Game System Table, Creating if it doesn't already exist.
******************************************************************************/
function initializeGameSystemTable()
{
    getDatabase().transaction(
        function(tx)
        {
            tx.executeSql('CREATE TABLE IF NOT EXISTS GameSystem( SystemID INTEGER PRIMARY KEY NOT NULL, SystemName VARCHAR(60), AbbrName VARCHAR(5), HoursPlayed INTEGER, PlayCount INTEGER, LastPlayedGame INTEGER, SystemPic VARCHAR(256), FOREIGN KEY(LastPlayedGame) REFERENCES Game(GameID));');
    });
}
/******************************************************************************
* initializeEmulatorSystemTable
* Initializes the Emulator System Table, Creating if it doesn't already exist.
******************************************************************************/
function initializeEmulatorSystemTable()
{
    getDatabase().transaction(
        function(tx)
        {
            tx.executeSql('CREATE TABLE IF NOT EXISTS EmulatorSystem( EmulatorID INTEGER PRIMARY KEY NOT NULL, SystemID INTEGER, EmulatorName VARCHAR(32), EmulatorPath VARCHAR(256), FOREIGN KEY(SystemID) REFERENCES GameSystem(SystemID));');
        }
    );
}
/******************************************************************************
* initializeEmulatorSystemTable
* Initializes the Game Title Table, Creating if it doesn't already exist.
******************************************************************************/
function initializeGameTitleTable()
{
    getDatabase().transaction(
        function(tx)
        {
            tx.executeSql('CREATE TABLE IF NOT EXISTS GameTitle (GameTitleID INTEGER PRIMARY KEY NOT NULL, Title VARCHAR(128) UNIQUE);');
    });
}
/******************************************************************************
* initializeRomRecords
* Initializes the Game ROM Table, Creating if it doesn't already exist.
******************************************************************************/
function initializeRomRecords()
{
    getDatabase().transaction(
        function(tx)
        {
            tx.executeSql('CREATE TABLE IF NOT EXISTS ROM_Records( ROM_ID INTEGER PRIMARY KEY NOT NULL, ROM_Name VARCHAR(60) UNIQUE, Description VARCHAR(2048), PlayCount INTEGER, HoursPlayed INTEGER, SystemID INTEGER NOT NULL, GameTitleID INTEGER, RomPath VARCHAR(1024), FOREIGN KEY(GameTitleID) REFERENCES GameTitle(GameTitleID), FOREIGN KEY(SystemID) REFERENCES GameSystem(SystemID));');
    });
}
/******************************************************************************
* initializeMediaTypeTable
* Initializes the Media Type Table, Creating if it doesn't already exist.
******************************************************************************/
function initializeMediaTypeTable()
{
    getDatabase().transaction(
        function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS MediaTypes( TypeID INTEGER PRIMARY KEY NOT NULL, TypeName VARCHAR(20));');
    });
}
/******************************************************************************
* initializeRomMediaTable
* Initializes the ROM Media Table, Creating if it doesn't already exist.
******************************************************************************/
function initializeRomMediaTable()
{
    getDatabase().transaction(
        function(tx)
        {
            tx.executeSql('CREATE TABLE IF NOT EXISTS ROM_Media( MediaID INTEGER PRIMARY KEY NOT NULL, ROM_ID INTEGER NOT NULL, TypeID INTEGER NOT NULL, MediaName VARCHAR(256) ,UNIQUE(ROM_ID, TypeID, MediaName) ,FOREIGN KEY(ROM_ID) REFERENCES ROM_Records(ROM_ID), FOREIGN KEY(TypeID) REFERENCES MediaTypes(TypeID))');
    });
}
