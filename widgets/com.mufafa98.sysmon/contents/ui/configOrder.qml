import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.20 as Kirigami
import QtQuick.Controls 2.15 as QQC2
import org.kde.plasma.plasmoid

QQC2.ScrollView {
    id: root
    anchors.fill: parent
    clip: true
    contentWidth: availableWidth

    // A list model that holds the sensors in the current order
    ListModel {
        id: sensorModel

        // Initialise from configuration
        function load() {
            clear()
            var order = Plasmoid.configuration.sensorOrder || "cpu,ram,bat"
            var ids = order.split(",").map(s => s.trim())
            // Ensure we have exactly three entries (cpu, ram, bat)
            var allIds = ["cpu", "ram", "bat"]
            // Add missing ones at the end
            ids = ids.concat(allIds.filter(id => !ids.includes(id)))
            // Remove duplicates
            ids = ids.filter((id, index) => ids.indexOf(id) === index)
            // Build model
            var labels = {
                "cpu": "CPU",
                "ram": "RAM",
                "bat": "Battery"
            }
            for (var i = 0; i < ids.length; i++) {
                var id = ids[i]
                var enabled = Plasmoid.configuration[id + "Enabled"]
                if (enabled === undefined) enabled = true
                append({ sensorId: id, label: labels[id] || id, enabled: enabled })
            }
        }

        // Save the order back to configuration
        function saveOrder() {
            var order = []
            for (var i = 0; i < count; i++) {
                order.push(get(i).sensorId)
            }
            Plasmoid.configuration.sensorOrder = order.join(",")
        }

        // Toggle enabled state and save
        function toggleEnabled(index, enabled) {
            var entry = get(index)
            entry.enabled = enabled
            set(index, entry)
            // Save to config
            Plasmoid.configuration[entry.sensorId + "Enabled"] = enabled
        }

        // Move an item up or down
        function moveItem(from, to) {
            if (to < 0 || to >= count || from === to) return
            move(from, to, 1)
            saveOrder()
        }
    }

    ColumnLayout {
        width: root.availableWidth

        QQC2.Label {
            text: "Enable / reorder sensors"
            font.bold: true
            Layout.fillWidth: true
            Layout.margins: Kirigami.Units.smallSpacing
        }

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.preferredHeight: contentHeight
            interactive: false   // we use buttons for reorder
            model: sensorModel
            delegate: QQC2.ItemDelegate {
                width: listView.width
                // height: implicitHeight + Kirigami.Units.smallSpacing

                contentItem: RowLayout {
                    anchors.fill: parent
                    spacing: Kirigami.Units.smallSpacing
                    anchors.margins: 10 // Pushes everything slightly inward

                    QQC2.CheckBox {
                        id: enableCheck
                        checked: model.enabled
                        onCheckedChanged: {
                            sensorModel.toggleEnabled(index, checked)
                        }
                        Layout.alignment: Qt.AlignVCenter
                    }

                    QQC2.Label {
                        text: model.label
                        font.bold: true
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                    }

                    QQC2.ToolButton {
                        text: "▲"
                        enabled: index > 0
                        onClicked: sensorModel.moveItem(index, index - 1)
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredHeight: 35 // Add this
                        Layout.preferredWidth: 35  // Add this
                    }

                    QQC2.ToolButton {
                        text: "▼"
                        enabled: index < sensorModel.count - 1
                        onClicked: sensorModel.moveItem(index, index + 1)
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredHeight: 35 // Add this
                        Layout.preferredWidth: 35  // Add this
                    }
                }
            }
        }

        // Button to reset to default order
        QQC2.Button {
            text: "Reset to default"
            onClicked: {
                Plasmoid.configuration.sensorOrder = "cpu,ram,bat"
                sensorModel.load()
            }
            Layout.alignment: Qt.AlignHCenter
        }
    }

    Component.onCompleted: {
        sensorModel.load()
    }
}