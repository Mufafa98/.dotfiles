import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.ksysguard.sensors as Sensors
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents

PlasmoidItem {
    id: root

    width: 180
    height: 60
    
    Layout.preferredWidth: mainLayout.implicitWidth + (Kirigami.Units.gridUnit * 2)
    Layout.minimumWidth: Layout.preferredWidth

    // --- Sensors ---
    Sensors.Sensor { id: cpuSensor; sensorId: "cpu/all/usage" }
    Sensors.Sensor { id: ramSensor; sensorId: "memory/physical/usedPercent" }
    Sensors.Sensor { id: batSensor; sensorId: "power/SerialNumber/chargePercentage" }
    Sensors.Sensor { id: batChargeSensor; sensorId: "power/SerialNumber/chargeRate" }

    // --- Utilities ---
    function cfg(key, fallback) {
        let v = Plasmoid.configuration[key];
        return (v === undefined || v === null || v === "") ? fallback : v;
    }

    function parseUnicode(str) {
        if (!str) return "";
        return str.replace(/\\u([0-9a-fA-F]{4,5})|U\+([0-9a-fA-F]{4,5})|0x([0-9a-fA-F]{4,5})/gi, function(match, p1, p2, p3) {
            return String.fromCodePoint(parseInt(p1 || p2 || p3, 16));
        });
    }

    function getColorForValue(value, stepsArray, colorsArray) {
        if (value === undefined || isNaN(value) || stepsArray.length === 0 || colorsArray.length === 0) {
            return "gray";
        }
        
        let result = colorsArray[0];
        for (let i = 0; i < stepsArray.length; i++) {
            if (value > stepsArray[i]) {
                result = colorsArray[i] || result;
            }
        }
        return result;
    }

    function batIcon() {
        return parseUnicode(cfg(batChargeSensor.value > 0 ? "batChargingUnicode" : "batUnicode", batChargeSensor.value > 0 ? "\udb80\udc84" : "\udb80\udc79"));
    }

    // --- Cached Configurations ---
    property var cpuColors: cfg("cpuColor", "#ffff00,#ff8800,#ff0000").split(",").map(s => s.trim())
    property var cpuSteps: cfg("cpuLevel", "50,75,90").split(",").map(s => parseFloat(s.trim()))
    
    property var ramColors: cfg("ramColor", "#ffff00,#ff8800,#ff0000").split(",").map(s => s.trim())
    property var ramSteps: cfg("ramLevel", "50,75,90").split(",").map(s => parseFloat(s.trim()))
    
    property var batColors: cfg("batColor", "#ff8800,#00ff00,#ffff00").split(",").map(s => s.trim())
    property var batSteps: cfg("batLevel", "10,25,80").split(",").map(s => parseFloat(s.trim()))

    property var sensorIds: cfg("sensorOrder", "cpu,ram,bat").split(",").map(s => s.trim())

    RowLayout {
        id: mainLayout
        anchors.centerIn: parent
        spacing: root.cfg("sensorGap", 10)

        Repeater {
            model: root.sensorIds
            delegate: Row {
                visible: root.cfg(modelData + "Enabled", true)
                spacing: 5

                property var sensorConfig: {
                    switch(modelData) {
                        case "cpu": return { ref: cpuSensor, colors: root.cpuColors, steps: root.cpuSteps, unicode: root.cfg("cpuUnicode", "\uf4bc") };
                        case "ram": return { ref: ramSensor, colors: root.ramColors, steps: root.ramSteps, unicode: root.cfg("ramUnicode", "\uefc5") };
                        case "bat": return { ref: batSensor, colors: root.batColors, steps: root.batSteps, unicode: "" };
                        default: return { ref: null, colors: ["gray"], steps: [50], unicode: "" };
                    }
                }

                property real currentValue: (sensorConfig.ref && sensorConfig.ref.value !== undefined) ? sensorConfig.ref.value : 0
                property string activeColor: root.getColorForValue(currentValue, sensorConfig.steps, sensorConfig.colors)

                PlasmaComponents.Label {
                    text: modelData === "bat" ? root.batIcon() : root.parseUnicode(sensorConfig.unicode)
                    font.family: root.cfg("iconFont", "sans-serif")
                    font.pixelSize: Kirigami.Units.gridUnit * (root.cfg("fontSize", 12) / 15.0)
                    color: activeColor
                }

                PlasmaComponents.Label {
                    text: Math.round(currentValue) + "%"
                    font.family: root.cfg("textFont", "sans-serif")
                    font.pixelSize: Kirigami.Units.gridUnit * (root.cfg("fontSize", 12) / 15.0)
                    color: activeColor
                }
            }
        }
    }
}