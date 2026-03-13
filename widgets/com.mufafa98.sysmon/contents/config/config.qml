import QtQuick 2.0
import org.kde.plasma.configuration 2.0
import org.kde.ki18n
ConfigModel {
    ConfigCategory {
        name: KI18n.i18n("General")
        icon: "configure"
        source: "configGeneral.qml"
    }
    ConfigCategory {
        name: KI18n.i18n("Colors")
        icon: "color-management"
        source: "configSteps.qml"
    }
}
