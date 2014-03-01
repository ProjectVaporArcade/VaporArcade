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
    EmulatorServices(QObject* parent = nullptr):QObject(parent){}
    ~EmulatorServices(){}
    Q_INVOKABLE void start(QString system,QString emuFile, QString game){mEmulatorCore.loadEmulator(mEmulatorDir + "/" + system,emuFile, mRomsDir + "/" +game);}
    Q_INVOKABLE void start(const QString & system, const QString & game){mEmulatorCore.start(mEmulatorDir + "/" + system,mRomsDir + "/" +game);}
    Q_INVOKABLE void setRomsDir(const QString& RomsDir){ mRomsDir = RomsDir;}
    Q_INVOKABLE void setPythonInterpreter(const QString& py){mEmulatorCore.setPythonInterpreter(py);};
    Q_INVOKABLE void setEmulatorSystemDir(const QString& EmuDir){mEmulatorDir = EmuDir;}
    Q_INVOKABLE void stop(){mEmulatorCore.stop();}
    Q_INVOKABLE QStringList getEmulators(){return getSysEmus();}
    Q_INVOKABLE void readSettings(QString system, QString emuPyFile){mSettingsReader.ReadSettings(mEmulatorDir + "/" + system, emuPyFile);}
    Q_INVOKABLE void writeSettings(/*QString system, QString emuPyFile, SettingsHash settings*/){qDebug() << "FooBar";}
signals:
    void MultipleEmulatorsFound(QStringList emuList);
    void NoEmulatorsFound(QString directory);
    void BadPyDataProcessed(QString ErrMsg);
    void SettingsLoaded(SettingsHash hash);
    void SettingsSaved();
private:
    QStringList getSysEmus();
    QString mEmulatorDir;
    QString mRomsDir;
    EmulatorCore mEmulatorCore;
    EmulatorSettingsReader mSettingsReader;
};
#endif
