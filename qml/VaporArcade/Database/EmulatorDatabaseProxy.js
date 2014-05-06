.import QtQuick.LocalStorage 2.0 as Sql
.import "VaporDatabase.js" as VaporDB
//Game Systems
function selectAllGameSystems(systemsDataModel, systemsNameModel)
{
    VaporDB.getDatabase().transaction(
    function (tx)
    {
        systemsDataModel.clear();
        systemsNameModel.clear();
        var res = tx.executeSql('SELECT SystemID, SystemName, AbbrName, HoursPlayed, PlayCount, LastPlayedGame, SystemPic FROM GameSystem');
        var qLen=res.rows.length
        for(var i = 0; i < res.rows.length; ++i)
        {
            var itm=res.rows.item(i)
            var systemID=itm.SystemID;
            var systemName=itm.SystemName;
            var abbrName=itm.AbbrName;
            var hoursPlayed=itm.HoursPlayed
            var playCount=itm.PlayCount;
            var lastPlayedGame=itm.LastPlayedGame;
            var systemPic=itm.SystemPic;
            systemsDataModel.append({"systemID":systemID,"systemName":systemName, "abbrName":abbrName, "hoursPlayed":hoursPlayed, "lastPlayedGame":lastPlayedGame, "systemPic":systemPic})
            systemsNameModel.append({"title":systemName,"sqlID":systemID})
        }
    });
}
function insertGameSystem( SystemName, Abbr, pic)
{
    VaporDB.getDatabase().transaction(
                function(tx)
                {
                    tx.executeSql('INSERT INTO GameSystem(SystemName, AbbrName, HoursPlayed, PlayCount, LastPlayedGame, SystemPic) VALUES (?, ?, 0, 0, null,?);',[SystemName, Abbr, pic]);
                });
}
function updateGameSystem( SystemID, SystemName, Abbr, HoursPlayed, PlayCount, LastPlayedGameID, SystemPic)
{
    VaporDB.getDatabase().transaction(
                function(tx)
                {
                    tx.executeSql('UPDATE GameSystem SET SystemName=?, AbbrName=?, HoursPlayed=?, PlayCount=?, LastPlayedGame=?, SystemPic=? WHERE SystemID=?;',[SystemName, Abbr, HoursPlayed, PlayCount, LastPlayedGameID, SystemPic, SystemID]);
                });
}
function removeGameSystem( SystemID)
{
    VaporDB.getDatabase().transaction(
                function(tx)
                {
                    tx.executeSql('DELETE FROM GameSystem WHERE SystemID = ?;',[SystemID]);
                });
}
//Emulator
function insertEmulatorSystem( systemID, emuName, emuPath )
{
    VaporDB.getDatabase().transaction(
        function(tx)
        {
            tx.executeSql('INSERT INTO EmulatorSystem(SystemID, EmulatorName, EmulatorPath)VALUES(?,?,?);',[systemID, emuName, emuPath]);
        });
}

function selectEmulatorsBySystem(emuNameList,emuDataList,system)
{
    VaporDB.getDatabase().transaction(
    function (tx)
    {
        emuNameList.clear();
        emuDataList.clear();
        var res = tx.executeSql('SELECT EmulatorID, EmulatorName, EmulatorPath FROM EmulatorSystem WHERE SystemID = ?;',[system]);
        for(var i = 0; i < res.rows.length; ++i)
        {
            var itm=res.rows.item(i)
            var emuName = itm.EmulatorName
            var emuPath = itm.EmulatorPath
            var emuID = itm.EmulatorID;
            emuNameList.append({"text":emuName})
            console.debug(emuName);
            emuDataList.append({"emulatorID":emuID,"emulatorName":emuName,"emulatorPath":emuPath})
        }
    });
}

function selectAllEmulatorSystem(emuList,emuNameList)
{
    VaporDB.getDatabase().transaction(
    function (tx)
    {
        emuNameList.clear();
        emuList.clear();
        var res = tx.executeSql('SELECT EmulatorID, EmulatorName, EmulatorPath FROM EmulatorSystem');
        for(var i = 0; i < res.rows.length; ++i)
        {
            var itm=res.rows.item(i)
            var emuName = itm.EmulatorName
            var emuPath = itm.EmulatorPath
            var emuID = itm.EmulatorID
            emuNameList.append({"text":emuName})
            console.debug(emuName);
            emuList.append({"emulatorID":emuID,"emulatorName":emuName,"emulatorPath":emuPath})
        }
    });
}
function updateEmulatorSystem( EmulatorID, EmulatorName, SystemID, EmulatorPath)
{
    VaporDB.getDatabase().transaction(
                function(tx)
                {
                    tx.executeSql('UPDATE EmulatorSystem SET EmulatorName=?, SystemID=?, EmulatorPath=? WHERE EmulatorID=?;',[EmulatorName, SystemID, EmulatorPath, EmulatorID]);
                });
}
function removeEmulatorSystem( EmulaotrID)
{
    VaporDB.getDatabase().transaction(
                function(tx)
                {
                    tx.executeSql('DELETE FROM EmulatorSystem WHERE SystemID = ?;',[SystemID]);
                });
}
