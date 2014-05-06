.import QtQuick.LocalStorage 2.0 as Sql
.import "VaporDatabase.js" as VaporDB
function insertMediaType( type )
{
    VaporDB.getDatabase().transaction(
    function(tx)
    {
        tx.executeSql('INSERT INTO MediaTypes(TypeName) VALUES(?);', [type]);
    });
}
function selectAllMediaTypes()
{
    VaporDB.getDatabase().transaction(
    function (tx)
    {
        mediaTypeDataListModel.clear();
        mediaTypeNameListModel.clear();
        var res = tx.executeSql('SELECT TypeID, TypeName FROM MediaTypes');
        for(var i = 0; i < res.rows.length; ++i)
        {
            var itm=res.rows.item(i)
            var typeID = itm.TypeID
            var typeName = itm.TypeName
            mediaTypeNameListModel.append({"text":typeName})
            mediaTypeDataListModel.append({"typeID":typeID,"typeName":typeName})
        }
    });
}
function selectAllRomMedias()
{
    VaporDB.getDatabase().transaction(
    function (tx)
    {
        romMediaDataListModel.clear();
        var res = tx.executeSql('SELECT MediaID, ROM_ID, TypeID, MediaName FROM ROM_Media;');
        for(var i = 0; i < res.rows.length; ++i)
        {
            var itm=res.rows.item(i)
            var mediaID = itm.MediaID
            var romID = itm.ROM_ID
            var typeID = itm.TypeID
            var mediaName = itm.MediaName
            romMediaDataListModel.append({"mediaID":mediaID,"romID":romID,"typeID":typeID,"mediaName":mediaName})
        }
    });
}

function selectRomMediasByRom(RomID)
{
    VaporDB.getDatabase().transaction(
    function (tx)
    {
        romMediaDataListModel.clear();
        var res = tx.executeSql('SELECT MediaID, ROM_ID, TypeID, MediaName FROM ROM_Media WHERE ROM_ID = ?;',[RomID]);
        for(var i = 0; i < res.rows.length; ++i)
        {
            var itm=res.rows.item(i)
            var mediaID = itm.MediaID
            var romID = itm.ROM_ID
            var typeID = itm.TypeID
            var mediaName = itm.MediaName
            romMediaDataListModel.append({"mediaID":mediaID,"romID":romID,"typeID":typeID,"mediaName":mediaName})
        }
    });
}

function selectRomMediasByType(typeId)
{
    VaporDB.getDatabase().transaction(
    function (tx)
    {
        romMediaDataListModel.clear();
        var res = tx.executeSql('SELECT MediaID, ROM_ID, TypeID, MediaName FROM ROM_Media WHERE TypeID = ?;',[typeId]);
        for(var i = 0; i < res.rows.length; ++i)
        {
            var itm=res.rows.item(i)
            var mediaID = itm.MediaID
            var romID = itm.ROM_ID
            var typeID = itm.TypeID
            var mediaName = itm.MediaName
            romMediaDataListModel.append({"mediaID":mediaID,"romID":romID,"typeID":typeID,"mediaName":mediaName})
        }
    });
}
function selectRomMediasByTypeAndRom(RomID, typeId)
{
    VaporDB.getDatabase().transaction(
    function (tx)
    {
        romMediaDataListModel.clear();
        var res = tx.executeSql('SELECT MediaID, ROM_ID, TypeID, MediaName FROM ROM_Media WHERE TypeID = ? AND ROM_ID = ?;',[typeId, RomID]);
        for(var i = 0; i < res.rows.length; ++i)
        {
            var itm=res.rows.item(i)
            var mediaID = itm.MediaID
            var romID = itm.ROM_ID
            var typeID = itm.TypeID
            var mediaName = itm.MediaName
            romMediaDataListModel.append({"mediaID":mediaID,"romID":romID,"typeID":typeID,"mediaName":mediaName})
        }
    });
}
function insertRomMedia( RomID, TypeID, MediaName )
{
    VaporDB.getDatabase().transaction(
        function(tx) {
            tx.executeSql('INSERT INTO ROM_Media( ROM_ID, TypeID, MediaName) VALUES (?,?,?);',[RomID,TypeID,MediaName]);
    });
}
