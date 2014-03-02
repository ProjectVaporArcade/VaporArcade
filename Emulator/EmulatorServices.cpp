#include "EmulatorServices.h"
QStringList EmulatorServices::getSysEmus()
{
    QDirIterator iter (mEmulatorDir);
    QStringList emuSystems;
    while (iter.hasNext())
    {
        if(iter.fileInfo().isFile() && iter.next().endsWith(".py"))
            emuSystems.append(iter.fileName());
    }
    return emuSystems;
}
void EmulatorServices::startGame(const QString & exeCmd, const QString & game)
{
    QString tmp = mSettingsReader.ReadEmuLaunchCommand(exeCmd);
    qDebug() << tmp + game;
    if(exeCmd != "" && QFile::exists(game))
    {
        mEmulatorCore.start(mSettingsReader.ReadEmuLaunchCommand(exeCmd), "\"" + game + "\"");
    }
}
