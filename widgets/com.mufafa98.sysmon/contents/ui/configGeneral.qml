import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import org.kde.kirigami 2.20 as Kirigami
import org.kde.ki18n
import org.kde.plasma.plasmoid

Kirigami.FormLayout {
    id: generalPage

    property alias cfg_sensorGap: sensorGapSpinBox.value
    property alias cfg_updateInterval: updateIntervalSpinBox.value
    property alias cfg_fontSize: fontSizeSpinBox.value

    property alias cfg_textFont: textFontCombo.currentText
    property alias cfg_iconFont: iconFontCombo.currentText

    QQC2.SpinBox {
        id: sensorGapSpinBox
        Kirigami.FormData.label: KI18n.i18n("Gap between sensors (px):")
        from: 0
        to: 100
        stepSize: 1
    }

    QQC2.SpinBox {
        id: updateIntervalSpinBox
        Kirigami.FormData.label: KI18n.i18n("Update interval (ms):")
        from: 100
        to: 10000
        stepSize: 100
    }

    QQC2.SpinBox {
        id: fontSizeSpinBox
        Kirigami.FormData.label: KI18n.i18n("Font size:")
        from: 6
        to: 72
        stepSize: 1
    }

    QQC2.ComboBox {
        id: textFontCombo
        Kirigami.FormData.label: KI18n.i18n("Text Font:")
        model: Qt.fontFamilies()
        Component.onCompleted: currentIndex = indexOfValue(Plasmoid.configuration.textFont)
    }

    QQC2.ComboBox {
        id: iconFontCombo
        Kirigami.FormData.label: KI18n.i18n("Icon Font:")
        model: Qt.fontFamilies()
        Component.onCompleted: currentIndex = indexOfValue(Plasmoid.configuration.iconFont)
    }
}
