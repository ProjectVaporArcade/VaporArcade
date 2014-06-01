#include <QtGui/QGuiApplication>
#include <QtGui/QScreen>
#include <QQmlContext>
#include <QQmlEngine>
#include <QQmlComponent>
#include "qtquick2applicationviewer.h"
#include "AppSettings/applicationsettings.h"
#include "Emulator/EmulatorServices.h"
/******************************************************************************
 *Author Christopher Dean
 *Contributers Christopher Dean, Aaron Lindberg, Jack Sanchez, & Eli Kloft
 *Vapor Arcade: Emulator and Rom management system
 *****************************************************************************/
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QScreen * screen = app.primaryScreen();
    QtQuick2ApplicationViewer viewer;
    viewer.engine()->setOfflineStoragePath(QDir::homePath() + "/config/VaporArcade");
    ApplicationSettings settings;
    //EmulatorServices emulatorManager;
    //settings.setPythonIntrpreter("/python27/python.exe");
    viewer.setScreen(screen);
    bool showExpanded(true);
    //showExpanded = false;//set to false for full screen
    int screen_width;
    int screen_height;
    if (!showExpanded)
    {
        screen_width = screen->size().width();
        screen_height = screen->size().height();
    }
    else
    {
        screen_width = screen->availableGeometry().width();
        screen_height = screen->availableGeometry().height();
    }
/************ Expose Properties to qml *****************/
    viewer.rootContext()->setContextProperty("DefaultDirectory", viewer.engine()->offlineStoragePath());
    viewer.rootContext()->setContextProperty("ScreenWidth", screen_width);
    viewer.rootContext()->setContextProperty("ScreenHeight", screen_height);
    viewer.rootContext()->setContextProperty("AppSettings", &settings);
    //viewer.rootContext()->setContextProperty("Emulators",&emulatorManager);
    qmlRegisterType<EmulatorServices>("com.vapor.project", 1, 0, "EmulatorServices");
/*******************************************************/
    viewer.setMainQmlFile(QStringLiteral("qml/VaporArcade/main.qml"));

    if (!showExpanded)
        viewer.showFullScreen();
    else
        viewer.showExpanded();

    return app.exec();
}
