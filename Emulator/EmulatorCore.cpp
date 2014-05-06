#include "EmulatorCore.h"
#include <QException>
#include <stdlib.h>

/******************************************************************************
* Default Constructor
******************************************************************************/
EmulatorCore::EmulatorCore(QObject* parent):QObject(parent),
              mProcess(nullptr){}
/******************************************************************************
* Destructor - cleans up any processes allocated to the Emulator core
******************************************************************************/
EmulatorCore::~EmulatorCore()
{stop();}

/******************************************************************************
*	start
*** OVERVIEW **
* 	If no process is running start a new python file to load emulator launcher
* configuration, and command line arguments to send to the emulator.
*** INPUT **
*   Takes a string of the emulator system and a string of the path to the game.
*** OUTPUT ***
*   On completion of loading emulator launcher configuration
******************************************************************************/
void EmulatorCore::start(const QString & emuexe, const QString & game)
{

    if(mProcess == nullptr)
    {
        mProcess = new QProcess(nullptr);
        //connect(mProcess,SIGNAL(stateChanged(QProcess::ProcessState,QPrivateSignal)),this,SLOT(emulatorStateChange(QProcess::ProcessState,QPrivateSignal)));
        //connect(mProcess,SIGNAL(started(QPrivateSignal)),this,SLOT(emulatorStarted(QPrivateSignal)));
        connect(mProcess,SIGNAL(finished(int,QProcess::ExitStatus)),this,SLOT(emuStopped(int,QProcess::ExitStatus)));
        connect(mProcess,SIGNAL(error(QProcess::ProcessError)),this,SLOT(emuError(QProcess::ProcessError)));

        QDir f (emuexe + game);
        qDebug() << f.path() ;//emuexe + game;
        mProcess->start(f.path());
        mProcess->waitForStarted();
        QProcess::ProcessState state = mProcess->state();
        if(state == QProcess::Running || state == QProcess::Starting)
        {
            qDebug() << "Emulator Started Running";
            emit EmulatorStarted(emuexe,game);
        }else
        {
            emit Error("unable to start the emulator");
            mProcess->disconnect(this);
            mProcess->kill();
            mProcess->waitForFinished();
            delete mProcess;
            mProcess = nullptr;
            qDebug() << "unable to start process";
        }
    }else
        qDebug() << mProcess->program();
}
/******************************************************************************
*	setRomsDir
*** OVERVIEW **
* 	Sets the path to all roms to launch.
*** INPUT **
* 	Take a QString by constant reference to set the executable path to.
******************************************************************************/
void EmulatorCore::setRomsDir(const QString& RomsDir)
{
    mRomsDir = RomsDir;
}
/******************************************************************************
*	setEmulatorSystemDir
*** OVERVIEW **
* 	Sets the path to the emulator to launch.
*** INPUT **
* 	Take a QString by constant reference to set the executable path to.
******************************************************************************/
void EmulatorCore::setEmulatorSystemDir(const QString& EmuDir)
{
    mEmulatorDir = EmuDir;
}
void EmulatorCore::setPythonInterpreter(const QString& py)
{
    mPythonInterpreter=py;
}
void EmulatorCore::emuStopped(int status, QProcess::ExitStatus etc)
{
    qDebug() << "Emulator " + mLastPlayedSystem + " Stopped Playing " + mLastPlayedGame;
    stop(status, etc);
}
void EmulatorCore::emuError(QProcess::ProcessError status)
{
    QString msg;
    if(status == QProcess::FailedToStart)
    {
        msg = "Failed to start emulator";
        emit Error(msg);
    }
}
/******************************************************************************
*	stop
*** OVERVIEW **
* 	Stops and deletes the emulator process if it exists, running or not.
*** INPUT **
*   Takes a optional exit code to return.
*** OUTPUT **
*   Return the exit code.
******************************************************************************/
int EmulatorCore::stop(int status, QProcess::ExitStatus etc)
{
        if(mProcess != nullptr)
        {
            mProcess->disconnect();
            emit EmulatorStopped();
            mProcess->close();
            mProcess->waitForFinished(0);
            QProcess::ProcessState state = mProcess->state();
            if(state != QProcess::NotRunning)
            {
                if(mProcess->error() == QProcess::Timedout)
                do
                {
                    mProcess->kill();
                    mProcess->waitForFinished(3000);
                }while(mProcess->state() != QProcess::NotRunning);
            }
            delete mProcess;
            mProcess = nullptr;
        }
    return status;
}
