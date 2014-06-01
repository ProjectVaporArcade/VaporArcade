import QtQuick 2.0
/******************************************************************************
*Author Aaron Lindberg
*Contributers Aaron Lindberg
******************************************************************************/
VaporRectangle {
    implicitWidth: 100
    implicitHeight: 62
    function setDefaultFocus()
    {

    }

    gradient: Gradient
    {
        GradientStop { position: 0.0; color: vaporTheme.mid }
        GradientStop { position: 0.3; color: vaporTheme.midlight }
        GradientStop { position: 1.0; color: vaporTheme.mid }
    }
}
