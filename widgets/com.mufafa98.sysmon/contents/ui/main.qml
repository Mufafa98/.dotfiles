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


        Row {
            visible: root.cfg("cpuEnabled", true)
            spacing: 5

            PlasmaComponents.Label {
                text: root.parseUnicode(root.cfg("cpuUnicode", "\uf4bc"))
                font.family: root.cfg("iconFont", "sans-serif")
                font.pixelSize: Kirigami.Units.gridUnit * (root.cfg("fontSize", 12) / 15.0)
                color: root.getColorForValue(cpuSensor.value, root.cfg("cpuLevel", "50,75,90"), root.cfg("cpuColor", "#ffff00,#ff8800,#ff0000"))
            }

            PlasmaComponents.Label {
                text: Math.round(cpuSensor.value) + "%"
                font.family: root.cfg("textFont", "sans-serif")
                font.pixelSize: Kirigami.Units.gridUnit * (root.cfg("fontSize", 12) / 15.0)
                color: root.getColorForValue(cpuSensor.value, root.cfg("cpuLevel", "50,75,90"), root.cfg("cpuColor", "#ffff00,#ff8800,#ff0000"))
            }
        }

        Row {
            visible: root.cfg("ramEnabled", true)
            spacing: 5

            PlasmaComponents.Label {
                text: root.parseUnicode(root.cfg("ramUnicode", "\uefc5"))
                font.family: root.cfg("iconFont", "sans-serif")
                font.pixelSize: Kirigami.Units.gridUnit * (root.cfg("fontSize", 12) / 15.0)
                color: root.getColorForValue(ramSensor.value, root.cfg("ramLevel", "50,75,90"), root.cfg("ramColor", "#ffff00,#ff8800,#ff0000"))
            }

            PlasmaComponents.Label {
                text: Math.round(ramSensor.value) + "%"
                font.family: root.cfg("textFont", "sans-serif")
                font.pixelSize: Kirigami.Units.gridUnit * (root.cfg("fontSize", 12) / 15.0)
                color: root.getColorForValue(ramSensor.value, root.cfg("ramLevel", "50,75,90"), root.cfg("ramColor", "#ffff00,#ff8800,#ff0000"))
            }
        }

        Row {
            visible: root.cfg("batEnabled", true)
            spacing: 5

            PlasmaComponents.Label {
                text: root.batIcon(0)
                font.family: root.cfg("iconFont", "sans-serif")
                font.pixelSize: Kirigami.Units.gridUnit * (root.cfg("fontSize", 12) / 15.0)
                color: root.getColorForValue(batSensor.value, root.cfg("batLevel", "10, 25, 80"), root.cfg("batColor", "#ff8800,#00ff00,#ffff00"))
            }

            PlasmaComponents.Label {
                text: Math.round(batSensor.value) + "%"
                font.family: root.cfg("textFont", "sans-serif")
                font.pixelSize: Kirigami.Units.gridUnit * (root.cfg("fontSize", 12) / 15.0)
                color: root.getColorForValue(batSensor.value, root.cfg("batLevel", "10, 25, 80"), root.cfg("batColor", "#ff8800,#00ff00,#ffff00"))
            }
        }
    }
}
