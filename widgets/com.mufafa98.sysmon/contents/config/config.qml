import QtQuick 2.0
import org.kde.plasma.configuration 2.0
ConfigModel {
    ConfigCategory {
        name: i18n("General")
        icon: "configure"
        source: "configGeneral.qml"
    }
    ConfigCategory {
        name: i18n("Colors")
        icon: "color-management"
        source: "configSteps.qml"
    }
    ConfigCategory {
        name: i18n("Order")
        icon: "view-list-order"
        source: "configOrder.qml"
    }
}
