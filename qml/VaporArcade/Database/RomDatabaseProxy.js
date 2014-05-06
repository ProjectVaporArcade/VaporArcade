.import QtQuick.LocalStorage 2.0 as Sql
.import "VaporDatabase.js" as VaporDB

function insertGameTitle( gameTitle )
{
    VaporDB.getDatabase().transaction(
    function(tx)
    {
        tx.executeSql('INSERT INTO GameTitle(Title)VALUES (?);',[gameTitle]);
    });
}
function getInsertGameTitleID( gameTitle )
{
    var gameTitleID = gameTitleExists(gameTitle)
    if(gameTitleID == false)
    {
        insertGameTitle(gameTitle)
        gameTitleID = gameTitleExists(gameTitle)
    }
    return gameTitleID
}

function gameTitleExists( gameTitle )
{
    var res;
    var result = false;
    VaporDB.getDatabase().transaction(
    function(tx)
    {
        res = tx.executeSql('SELECT GameTitleID FROM GameTitle WHERE Title = ?;',[gameTitle]);
        if(res.rows.length == 1)
        {
            result = res.rows.item(0).GameTitleID
        }
    });
    return result
}
function selectAllGameTitles(gameTitleName, gameTitleData)
{
    var res;
    VaporDB.getDatabase().transaction(
    function (tx)
    {
        gameTitleName.clear();
        gameTitleData.clear();
        res = tx.executeSql('SELECT GameTitleID, Title FROM GameTitle;');
        var qLen=res.rows.length
        for(var i = 0; i < res.rows.length; ++i)
        {
            var itm=res.rows.item(i)
            var gameTitleID = itm.GameTitleID
            var title = itm.Title
            gameTitleName.append({"title":title});
            gameTitleData.append({"gameTitleID":gameTitleID, "title":title})
        }
    });
    return res;
}

function insertRomRecord( romName, gameTitleID, description, systemID, romPath )
{
    VaporDB.getDatabase().transaction(
    function(tx)
    {
        tx.executeSql('INSERT INTO ROM_Records(ROM_Name, GameTitleID, Description, PlayCount, HoursPlayed, SystemID, RomPath)VALUES (?, ?, ?, 0, 0, ?, ?);',[romName,gameTitleID, description, systemID, romPath]);
    });
}
function refreshAllGames(gameList)
{
    var res;
    VaporDB.getDatabase().transaction(
    function (tx)
    {
        gameList.clear();
        res = tx.executeSql('SELECT RR.ROM_ID, ROM_Name, RomPath, MediaName, Description, S.SystemName, S.AbbrName, S.SystemPic, S.SystemID FROM ROM_Records AS RR LEFT OUTER JOIN (SELECT ROM_ID, MediaName FROM ROM_Media AS RM LEFT OUTER JOIN MediaTypes AS MT ON MT.TypeID = RM.TypeID WHERE TypeName = "COVER") AS RRM ON RR.ROM_ID = RRM.ROM_ID JOIN GameSystem AS S ON RR.SystemID = S.SystemID;');
        var qLen=res.rows.length
        for(var i = 0; i < res.rows.length; ++i)
        {
            var itm=res.rows.item(i)
            var RomName=itm.ROM_Name;
            var RomPath=itm.RomPath;
            var Desc=itm.Description
            var Disp=itm.MediaName;
            var sys=itm.AbbrName;
            var sysFull=itm.SystemName;
            var sPic=itm.SystemPic;
            var sysID=itm.SystemID
            console.debug(RomName + ":" + Disp + ":" + sys)
            gameList.append({"name":RomName, "path":RomPath, "desc":Desc, "display":Disp, "sysFull":sysFull, "sysAbbr":sys, "sysPic":sPic, "sysID":sysID})
        }
    });
    return res;
}
