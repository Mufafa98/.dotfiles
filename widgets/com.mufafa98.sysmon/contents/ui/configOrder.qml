import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid

QQC2.ScrollView {
    id: root
    anchors.fill: parent
    clip: true
    contentWidth: availableWidth

    ListModel {
        id: sensorModel

        function load() {
            clear();
            let orderConfig = Plasmoid.configuration.sensorOrder || "cpu,ram,bat";
            
            let rawIds = orderConfig.split(",").map(s => s.trim());
            let ids = [...new Set([...rawIds, "cpu", "ram", "bat"])]; 

            const labels = { "cpu": "CPU", "ram": "RAM", "bat": "Battery" };

            ids.forEach(id => {
                let enabled = Plasmoid.configuration[id + "Enabled"];
                append({ 
                    sensorId: id, 
                    label: labels[id] || id, 
                    enabled: enabled !== undefined ? enabled : true 
                });
            });
        }

        function saveOrder() {
            let order = [];
            for (let i = 0; i < count; i++) {
                order.push(get(i).sensorId);
            }
            Plasmoid.configuration.sensorOrder = order.join(",");
        }

        function toggleEnabled(index, isEnabled) {
            let entry = get(index);
            entry.enabled = isEnabled;
            set(index, entry);
            Plasmoid.configuration[entry.sensorId + "Enabled"] = isEnabled;
        }

        function moveItem(from, to) {
            if (to < 0 || to >= count || from === to) return;
            move(from, to, 1);
            saveOrder();
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
            interactive: false
            model: sensorModel
            
            delegate: QQC2.ItemDelegate {
                width: listView.width

                contentItem: RowLayout {
                    anchors.fill: parent
                    spacing: Kirigami.Units.smallSpacing
                    anchors.margins: 10 

                    QQC2.CheckBox {
                        checked: model.enabled
                        onCheckedChanged: sensorModel.toggleEnabled(index, checked)
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
                        Layout.preferredHeight: 35
                        Layout.preferredWidth: 35
                    }

                    QQC2.ToolButton {
                        text: "▼"
                        enabled: index < sensorModel.count - 1
                        onClicked: sensorModel.moveItem(index, index + 1)
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredHeight: 35
                        Layout.preferredWidth: 35
                    }
                }
            }
        }

        QQC2.Button {
            text: "Reset to default"
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                Plasmoid.configuration.sensorOrder = "cpu,ram,bat";
                sensorModel.load();
            }
        }
    }

    Component.onCompleted: sensorModel.load()
}