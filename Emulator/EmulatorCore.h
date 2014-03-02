#ifndef EMULATORCORE_H
#define EMULATORCORE_H
#include <QObject>
#include <QDir>
#include <QFile>
#include <QString>
#include <QProcess>
#include <QDebug>
#include "EmulatorSettingsReader.h"
/******************************************************************************
* Class:        EmulatorCore
* Author:       Aaron Lindberg
* Date Created: 11/21/2013          Date Modified: 11/21/2013
**** OVERVIEW ***
*   Reads the the system emulator directory for python files to supply
* information about indevidual emulator systems or programs. Intended for the
* use of launching "retro console" emulators from a application.
**** INPUT ***
*   Before use the rom directory and emulator system directory should be set.
******************************************************************************/
class EmulatorCore: public QObject
{
    Q_OBJECT
public:
    EmulatorCore(QObject* parent = nullptr);
    ~EmulatorCore();
    //bool loadEmulator(QString Emu, QString game);
    void start(const QString & emuPy, const QString & game);
    void setRomsDir(const QString& RomsDir);
    void setEmulatorSystemDir(const QString& EmuDir);
    void setPythonInterpreter(const QString& py);
signals:
    void Error(QString msg);
    void EmulatorStarted(QString system, QString game);
    void EmulatorStopped();
    void MultipleEmulatorsFound(QStringList emuList);
    void NoEmulatorsFound(QString directory);
    void BadPyDataProcessed();
public slots:
    void emuError(QProcess::ProcessError status);
    void emuStopped(int, QProcess::ExitStatus);
    int stop(int status = 0, QProcess::ExitStatus etc = QProcess::NormalExit);
private:
    QProcess* mProcess;
    QString mRomsDir;
    QString mLastPlayedGame;
    QString mLastPlayedSystem;
    QString mEmulatorDir;
    QString mArguments;
    QString mPythonInterpreter;
};

#endif // EMULATORCORE_H
