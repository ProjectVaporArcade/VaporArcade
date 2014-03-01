import QtQuick 2.0

Rectangle {
    height:parent.height
    width:parent.width
    visible: false
    Gradient
    {
        GradientStop { position: 0.0; color: vaporTheme.mid }
        GradientStop { position: 0.3; color: vaporTheme.midlight }
        GradientStop { position: 1.0; color: vaporTheme.mid }
    }
    function setDefaultFocus()
    {

    }
}
