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
