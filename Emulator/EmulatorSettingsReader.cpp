/******************************************************************************
* Author: Aaron Lindberg
* Date Created: 11/22/2013                          Date Modified: 11/24/2013
* File: EmulatorSettingsReader.cpp
**** Overview ****
*   This module is designed to read settings from a python file. Settings are
* categorized for the gui to group similar settings.
******************************************************************************/
#include "EmulatorSettingsReader.h"
//Default constructor


EmulatorSettingsReader::EmulatorSettingsReader(QObject *parent) :
    QObject(parent), mProcess(nullptr)
{

}
//Destructor
EmulatorSettingsReader::~EmulatorSettingsReader()
{
    delete mProcess;
    mProcess = nullptr;
}

void EmulatorSettingsReader::setPythonInterpreter(const QString& py)
{
    mPythonInterpreter=py;
}
void EmulatorSettingsReader::stop()
{
    if(mProcess != nullptr)
    {
        mProcess->close();
        mProcess->waitForFinished(50);
        delete mProcess;
        mProcess= nullptr;
    }
}

/******************************************************************************
*	loadEmulator
*** OVERVIEW **
* 	Loads a specific emulator system python with a game.
*** INPUT **
*   Takes a string of the emulator system type, the emulator python file name,
* and the path to the game to load after system information is gathered.
*** OUTPUT **
*   Returns a boolean value. If the emulator is python file was started with
* python true is returned, however in the event that the python file could not
* be started the return value is false.
******************************************************************************/
QString EmulatorSettingsReader::ReadEmuLaunchCommand( const QString& emuPyFile )
{
    QString build ="";
    if(mProcess != nullptr)//Check for a running process
    {
        qDebug() << "already Running: " << mProcess->program();
    }
    else if((QFile(emuPyFile).exists()))//check if the python file exists
    {
        //check if the python interpreter is installed
        qDebug () << mPythonInterpreter;
        if((QFile::exists(mPythonInterpreter)))
        {
            mProcess = new QProcess;
            mProcess->setProcessChannelMode(QProcess::MergedChannels);
            qDebug() << "System Loading using "+ mPythonInterpreter +" \"" + emuPyFile + "\"";
            mProcess->start(mPythonInterpreter+" \"" + emuPyFile + "\"");
            if(mProcess->waitForStarted(500) && mProcess->waitForReadyRead(500))
            {
                QString str (mProcess->readAll());
                qDebug() << str;
                //check if the python file gave bad data
                if(!str.startsWith("$%$"))
                {
                    stop();
                    emit BadPyDataProcessed();
                    qDebug() << "Python File is not in the correct format.";
                }
                else
                {//format the data and propigate fields
                    QStringList dataIn (str.split('\n'));
                    if(dataIn.length() < 3)
                    {
                        qDebug() << "Error - Python file didn't contain enough data or in a bad format.";
                        emit BadPyDataProcessed();
                    }
                    else
                    {
                        QString launcher = dataIn[1].split('=').last();
                        qDebug() << launcher << " : " << QFile::exists(launcher);
                        QStringList Arg(dataIn[2].split('=').last().split("\""));

                        build = (launcher+ " " + (Arg.length() < 1?Arg[1] + " ":""));
                        qDebug() << build;
                    }
                }
                stop();

            }else
                qDebug() << "Python Core timed out.";
            //emit EmulatorStarted(mLastPlayedSystem,mLastPlayedGame);
        }else
        {
            qDebug() << "Unable to find python interpreter @ " + mPythonInterpreter;
        }
    }else
    {
        qDebug() << "Unable to Locate the python file @\"" + emuPyFile + "\"";
    }
    return build;//indicate if the launcher configuration is started
}

bool EmulatorSettingsReader::ReadSettings(const QString &emuPyFile)
{
    bool ret(false);//Return value
    if(mProcess != nullptr)//Check for a running process
    {
        qDebug() << "already Running";
    }
    else if((ret = QFile(emuPyFile).exists()))//check if the python file exists
    {
        //check if the python interpreter is installed
        if((ret = QFile(mPythonInterpreter).exists()))
        {
            try
            {
                mProcess = new QProcess;
                mProcess->setProcessChannelMode(QProcess::MergedChannels);
                connect(mProcess,SIGNAL(readyRead()),this,SLOT(RxSettingsData()));
                mProcess->start(mPythonInterpreter+" \"" + emuPyFile + "\" -t s");
            }catch (const QException& etc)
            {
                qDebug() << etc.what();
            }
        }else
        {
            qDebug() << "Unable to find python interpreter @ " + mPythonInterpreter;
        }
    }else
    {
        qDebug() << "Unable to Locate the python file @\"" + emuPyFile + "\"";
    }
    return ret;//indicate if the launcher configuration is started
}
void EmulatorSettingsReader::AddSetting(const QString& category,const QString &rawSetting)
{
    QStringList settingParts(rawSetting.split("': ('"));
    QString name(settingParts[0].remove("'"));
    QString value("");
    QStringList availSettings;
    QString foo;
    if (settingParts.length() == 2)
    {
        name = settingParts[0].remove("'");

        settingParts = (foo = settingParts[1]).split("', {'");
        if (settingParts.length() == 2)
        {
            value = settingParts[0];
            settingParts = settingParts[1].split("', '");
            availSettings.clear();
            qDebug() <<"\t"<< name;
            foreach(const QString& str, settingParts)
            {
                availSettings.append(str.split("': '")[0]);
                qDebug() <<"\t\t"<< availSettings.last();
            }

            SettingValuePair svp(name, value);
            FullSettingPair fsp(svp,availSettings);
            mSettings[category].append(fsp);

        }else
        {
            qDebug() << "Broken";
        }
    }
    else
    {
        qDebug() << rawSetting;
    }
}

void EmulatorSettingsReader::ProcessSettingsData(const QString& rawData)
{

    QString tmp(rawData);
    tmp = tmp.replace("$%$DUMP&ALLSETTINGS\n","").replace("\n$&$","");
    tmp = tmp.mid(1,tmp.length()-4);
    QStringList categories(tmp.split("'})}, '"));
    //categories[categories.length()-1].replace("})", "");
    mSettings.clear();
    foreach (const QString categoryIn, categories)
    {  
        QStringList settings(categoryIn.split("'}), '"));
        QString category(settings[0].split(": {")[0].remove("'").remove("{"));
        foreach (const QString settingIn, settings)
        {
            settings.length();
            QStringList tmpSetting(settingIn.split("': {'"));
            if(tmpSetting.length() == 1)
            {

                AddSetting(category,tmpSetting[0]);
            }else if(tmpSetting.length() == 2)
            {
                category = tmpSetting[0].replace("'","").replace(", ","");
                qDebug() << category;
                AddSetting(category,tmpSetting[1]);
            }else
            {
                qDebug() << "Error - Input uninterpretable.";
                //qDebug() << tmpSetting.length();
                //qDebug() << rawData;
                throw (QException());
            }
        }
    }
}

void EmulatorSettingsReader::RxSettingsData()
{
    QString rawData (mProcess->readAll());
    mProcess->disconnect();
    mProcess->close();
    mProcess->kill();
    try{
        ProcessSettingsData(rawData);
    }catch(const QException&)
    {
        qDebug() << "Bad python data";
    }

    delete mProcess;
    mProcess = nullptr;

    //qDebug() << str;
}
