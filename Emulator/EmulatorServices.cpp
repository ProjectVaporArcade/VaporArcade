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
    if(!tryStart)
    {
        tryStart = true;
        //QString tmp = mSettingsReader.ReadEmuLaunchCommand(exeCmd);
        //qDebug() << tmp + game;
        if(exeCmd != "" && QFile::exists(exeCmd))
        {
            //connect the process start, stop and error signals
            connect(&mEmulatorCore,SIGNAL(Error(QString)),this,SLOT(emulatorErrorSlot(QString)));
            connect(&mEmulatorCore,SIGNAL(EmulatorStopped()),this,SLOT(emulatorStoppedSlot()));
            connect(&mEmulatorCore,SIGNAL(EmulatorStarted(QString,QString)),this,SLOT(emulatorStartedSlot(QString,QString)));
            mEmulatorCore.start(mSettingsReader.ReadEmuLaunchCommand(exeCmd), (game.length() == 0)? "":" \"" + game + "\"");
        }else
            emit emulatorError("The executable supplied by the core python file does not exist.");
    }

}
void EmulatorServices::emulatorErrorSlot(QString errorMsg)
{
    emit emulatorError(errorMsg);
    tryStart = false;
}

void EmulatorServices::emulatorStartedSlot(QString exe,QString game)
{
    emit emulatorStart(exe, game);
}

void EmulatorServices::emulatorStoppedSlot()
{
    emit emulatorStopped();
    tryStart = false;
}
