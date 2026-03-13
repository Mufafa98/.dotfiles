import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.20 as Kirigami
import org.kde.kquickcontrols 2.0 as KQC
import org.kde.plasma.plasmoid

ScrollView {
    id: root
    anchors.fill: parent
    contentWidth: availableWidth 
    clip: true

    property string cfg_cpuColor
    property string cfg_cpuLevel
    property string cfg_ramColor
    property string cfg_ramLevel
    property string cfg_batColor
    property string cfg_batLevel

    property var cpuColors: (Plasmoid.configuration.cpuColor || "#ffff00,#ff8800,#ff0000").split(",")
    property var cpuSteps: (Plasmoid.configuration.cpuLevel || "50,75,90").split(",")
    property var ramColors: (Plasmoid.configuration.ramColor || "#ffff00,#ff8800,#ff0000").split(",")
    property var ramSteps: (Plasmoid.configuration.ramLevel || "50,75,90").split(",")
    property var batColors: (Plasmoid.configuration.batColor || "#00ff00,#ffff00,#ff8800").split(",")
    property var batSteps: (Plasmoid.configuration.batLevel || "90,75,50").split(",")
 
    function updateConfig() {
        root.cfg_cpuColor = row1_1.color + "," + row1_2.color + "," + row1_3.color
        root.cfg_cpuLevel = String(row1_1.threshold) + "," + String(row1_2.threshold) + "," + String(row1_3.threshold)
        
        root.cfg_ramColor = row2_1.color + "," + row2_2.color + "," + row2_3.color
        root.cfg_ramLevel = String(row2_1.threshold) + "," + String(row2_2.threshold) + "," + String(row2_3.threshold)
        
        root.cfg_batColor = row3_1.color + "," + row3_2.color + "," + row3_3.color
        root.cfg_batLevel = String(row3_1.threshold) + "," + String(row3_2.threshold) + "," + String(row3_3.threshold)
    }

    Kirigami.FormLayout {
        width: root.availableWidth
        
        component FilterRow : ColumnLayout {
            id: filterRowRoot 
            property alias color: colorBtn.color
            property alias threshold: spin.value
            property string initialColor: ""
            property int initialThreshold: 0
            
            signal changed()

            spacing: 5
            FontMetrics { id: fm; font: colorTxt.font }

            RowLayout {
                spacing: 5
                KQC.ColorButton {
                    id: colorBtn
                    Layout.preferredWidth: 30
                    Layout.preferredHeight: 30
                    onColorChanged: filterRowRoot.changed()
                    Component.onCompleted: if (filterRowRoot.initialColor !== "") colorBtn.color = filterRowRoot.initialColor
                }
                TextField {
                    id: colorTxt
                    text: colorBtn.color.toString()
                    onEditingFinished: {
                        colorBtn.color = text
                        filterRowRoot.changed()
                    }
                    Layout.preferredWidth: fm.advanceWidth("XXXXXXX") + (leftPadding + rightPadding)
                    Layout.fillWidth: false 
                    maximumLength: 7 
                }
            }
            SpinBox {
                id: spin
                from: 0
                to: 10000
                editable: true
                Layout.preferredWidth: 30 + 5 + colorTxt.Layout.preferredWidth
                onValueModified: filterRowRoot.changed()
                Component.onCompleted: if (!isNaN(filterRowRoot.initialThreshold)) spin.value = filterRowRoot.initialThreshold
            }
        }

        Kirigami.Separator { Kirigami.FormData.label: "Cpu"; Kirigami.FormData.isSection: true }
        RowLayout {
            FilterRow { id: row1_1; initialColor: root.cpuColors[0]; initialThreshold: Number(root.cpuSteps[0]); onChanged: root.updateConfig() }
            FilterRow { id: row1_2; initialColor: root.cpuColors[1]; initialThreshold: Number(root.cpuSteps[1]); onChanged: root.updateConfig() }
            FilterRow { id: row1_3; initialColor: root.cpuColors[2]; initialThreshold: Number(root.cpuSteps[2]); onChanged: root.updateConfig() }
        }

        Kirigami.Separator { Kirigami.FormData.label: "Ram"; Kirigami.FormData.isSection: true }
        RowLayout {
            FilterRow { id: row2_1; initialColor: root.ramColors[0]; initialThreshold: Number(root.ramSteps[0]); onChanged: root.updateConfig() }
            FilterRow { id: row2_2; initialColor: root.ramColors[1]; initialThreshold: Number(root.ramSteps[1]); onChanged: root.updateConfig() }
            FilterRow { id: row2_3; initialColor: root.ramColors[2]; initialThreshold: Number(root.ramSteps[2]); onChanged: root.updateConfig() }
        }

        Kirigami.Separator { Kirigami.FormData.label: "Battery"; Kirigami.FormData.isSection: true }
        RowLayout {
            FilterRow { id: row3_1; initialColor: root.batColors[0]; initialThreshold: Number(root.batSteps[0]); onChanged: root.updateConfig() }
            FilterRow { id: row3_2; initialColor: root.batColors[1]; initialThreshold: Number(root.batSteps[1]); onChanged: root.updateConfig() }
            FilterRow { id: row3_3; initialColor: root.batColors[2]; initialThreshold: Number(root.batSteps[2]); onChanged: root.updateConfig() }
        }
    }
}
