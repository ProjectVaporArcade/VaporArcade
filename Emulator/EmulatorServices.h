#ifndef EMULATORSERVICES_H
#define EMULATORSERVICES_H
#include <QObject>
#include <QString>
#include <QStringList>
#include <QHash>
#include <QPair>
#include <QList>
#include <QDir>
#include <QDirIterator>
#include "EmulatorCore.h"
#include "EmulatorSettingsReader.h"
/******************************************************************************
* Author: Aaron Lindberg
* Class: EmulatorServices
* Created: 10/16/2013           Modified: 11/04/2013
*** OVERVIEW ***
*   The buisness class to expose the c++ functionality of
* launching emulators with games, and managing emulator settings.
******************************************************************************/
class EmulatorServices: public QObject
{
    Q_OBJECT
public:
    EmulatorServices(QObject* parent = nullptr):QObject(parent),tryStart(false){}
    ~EmulatorServices(){}
    Q_INVOKABLE void start(const QString & emuPy, const QString & game){startGame(emuPy, game);}
    Q_INVOKABLE void setRomsDir(const QString& RomsDir){ mRomsDir = RomsDir;}
    Q_INVOKABLE void setPythonInterpreter(const QString& py){mEmulatorCore.setPythonInterpreter(py);mSettingsReader.setPythonInterpreter(py);}
    Q_INVOKABLE void setEmulatorSystemDir(const QString& EmuDir){mEmulatorDir = EmuDir;}
    Q_INVOKABLE void stop(){mEmulatorCore.stop();}
    Q_INVOKABLE QStringList getEmulators(){return getSysEmus();}
    Q_INVOKABLE void readSettings(QString emuPyFile){mSettingsReader.ReadSettings(emuPyFile);}
    Q_INVOKABLE void writeSettings(/*QString system, QString emuPyFile, SettingsHash settings*/){qDebug() << "FooBar";}
signals:
    void emulatorStopped();
    void emulatorError(QString errorMsg);
    //void emulatorFailedToStart(QString executable, QString game);
    void emulatorStart(QString executablePath, QString romPath);
    void MultipleEmulatorsFound(QStringList emuList);
    void NoEmulatorsFound(QString directory);
    void SettingsLoaded(SettingsHash hash);
    void SettingsSaved();
public slots:
    //void emulatorFailedToStartSlot(const QString executable, const QString game);
    void emulatorStartedSlot(QString exe, QString game);
    void emulatorErrorSlot(QString errorMsg);
    void emulatorStoppedSlot();
private:
    void startGame(const QString & emuPy, const QString & game);
    bool tryStart;
    QStringList getSysEmus();
    QString mEmulatorDir;
    QString mRomsDir;
    EmulatorCore mEmulatorCore;
    EmulatorSettingsReader mSettingsReader;
};
#endif
