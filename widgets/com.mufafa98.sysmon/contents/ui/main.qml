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

    Sensors.Sensor {
        id: cpuSensor
        sensorId: "cpu/all/usage"
    }
     
    Sensors.Sensor {
        id: ramSensor
        sensorId: "memory/physical/usedPercent"
    }

    Sensors.Sensor {
        id: batSensor
        sensorId: "power/SerialNumber/chargePercentage"
    }

    Sensors.Sensor {
        id: batChargeSensor
        sensorId: "power/SerialNumber/chargeRate"
    }

    function getColorForValue(value: real, stepsString: string, colorsString: string): string {
        if (value === undefined || isNaN(value)) return "gray"

        var steps = stepsString.split(",").map(function(s) { return parseFloat(s.trim()); });
        var colors = colorsString.split(",").map(function(s) { return s.trim(); });

        if (steps.length === 0 || colors.length === 0) return "gray"

        var result = colors[0];
        for (var i = 0; i < steps.length; i++) {
            if (value > steps[i]) {
                result = colors[i] || result;
            }
        }
        return result;
    }
    

    // Convert unicode escape strings like "\uEBF0" or "U+EBF0" to actual characters
    function parseUnicode(str: string): string {
        if (!str) return "";
        // Handle \uXXXX format
        var result = str.replace(/\\u([0-9a-fA-F]{4,5})/g, function(match, hex) {
            return String.fromCodePoint(parseInt(hex, 16));
        });
        // Handle U+XXXX format
        result = result.replace(/U\+([0-9a-fA-F]{4,5})/gi, function(match, hex) {
            return String.fromCodePoint(parseInt(hex, 16));
        });
        // Handle 0xXXXX format
        result = result.replace(/0x([0-9a-fA-F]{4,5})/gi, function(match, hex) {
            return String.fromCodePoint(parseInt(hex, 16));
        });
        return result;
    }

    // utility: read configuration with fallback default
    function cfg(key: string, fallback: var): var {
        var v = Plasmoid.configuration[key];
        if (v === undefined || v === null || v === "") return fallback;
        return v;
    }

    function batIcon(value: int): string {
        if (batChargeSensor.value > 0) {
            return parseUnicode(cfg("batChargingUnicode", "\udb80\udc84"));
        }
        return parseUnicode(cfg("batUnicode", "\udb80\udc79"));
    }

    RowLayout {
        id: mainLayout
        anchors.centerIn: parent
        spacing: root.cfg("sensorGap", 10)

        // Get the ordered list of sensor IDs
        property var sensorIds: {
            var order = root.cfg("sensorOrder", "cpu,ram,bat")
            return order.split(",").map(s => s.trim())
        }

        Repeater {
            model: mainLayout.sensorIds
            delegate: Row {
                // Create a row for each sensor in order
                visible: root.cfg(modelData + "Enabled", true)
                spacing: 5

                // Determine which sensor to show based on modelData ("cpu", "ram", "bat")
                property var sensorRef: {
                    if (modelData === "cpu") return cpuSensor
                    if (modelData === "ram") return ramSensor
                    if (modelData === "bat") return batSensor
                    return null
                }
                property var colorConfig: {
                    if (modelData === "cpu") return { color: root.cfg("cpuColor", "#ffff00,#ff8800,#ff0000"), level: root.cfg("cpuLevel", "50,75,90"), unicode: root.cfg("cpuUnicode", "\uf4bc") }
                    if (modelData === "ram") return { color: root.cfg("ramColor", "#ffff00,#ff8800,#ff0000"), level: root.cfg("ramLevel", "50,75,90"), unicode: root.cfg("ramUnicode", "\uefc5") }
                    if (modelData === "bat") return { color: root.cfg("batColor", "#ff8800,#00ff00,#ffff00"), level: root.cfg("batLevel", "10,25,80"), unicode: root.cfg("batUnicode", "\udb80\udc79") }
                    return { color: "gray", level: "50", unicode: "" }
                }

                PlasmaComponents.Label {
                    text: modelData === "bat" ? root.batIcon(0) : root.parseUnicode(colorConfig.unicode)
                    font.family: root.cfg("iconFont", "sans-serif")
                    font.pixelSize: Kirigami.Units.gridUnit * (root.cfg("fontSize", 12) / 15.0)
                    color: root.getColorForValue(sensorRef ? sensorRef.value : 0, colorConfig.level, colorConfig.color)
                }

                PlasmaComponents.Label {
                    text: Math.round(sensorRef ? sensorRef.value : 0) + "%"
                    font.family: root.cfg("textFont", "sans-serif")
                    font.pixelSize: Kirigami.Units.gridUnit * (root.cfg("fontSize", 12) / 15.0)
                    color: root.getColorForValue(sensorRef ? sensorRef.value : 0, colorConfig.level, colorConfig.color)
                }
            }
        }
    }
}
