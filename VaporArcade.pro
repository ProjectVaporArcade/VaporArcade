# Add more folders to ship with the application, here
folder_01.source = qml/VaporArcade
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH = Database

CONFIG += embed_manifest_dll \
embed_manifest_exe \
C++11
# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    Emulator/EmulatorSettingsReader.cpp \
    Emulator/EmulatorCore.cpp \
    Emulator/EmulatorServices.cpp \
    filebrowser.cpp \
    AppSettings/applicationsettings.cpp

# Installation path
# target.path =

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()

HEADERS += \
    Emulator/EmulatorSettingsReader.h \
    Emulator/EmulatorCore.h \
    Emulator/EmulatorServices.h \
    filebrowser.h \
    AppSettings/applicationsettings.h

OTHER_FILES +=
