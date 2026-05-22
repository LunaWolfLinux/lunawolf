import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls

import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: clockWidget

    property var currentDateTime: new Date()

    compactRepresentation: MouseArea {
        id: compactView

        Layout.preferredWidth: implicitWidth
        implicitWidth: panelLayout.implicitWidth + (Kirigami.Units.smallSpacing * 2)

        onClicked: {
            Plasmoid.activated();
        }

        ColumnLayout {
            id: panelLayout

            anchors.centerIn: parent
            spacing: 0

            Controls.Label {
                Layout.alignment: Qt.AlignRight
                Layout.preferredHeight: 14
                text: clockWidget.currentDateTime.toLocaleTimeString(Qt.locale(), Locale.ShortFormat)
            }
            Controls.Label {
                Layout.alignment: Qt.AlignRight
                Layout.preferredHeight: 14
                text: clockWidget.currentDateTime.toLocaleDateString(Qt.locale(), Locale.ShortFormat)
            }
        }
    }
    fullRepresentation: ColumnLayout {
        id: fullView

        readonly property int firstDayOfWeek: Qt.locale().firstDayOfWeek
        property var viewDate: new Date()

        function shiftMonth(delta) {
            let d = new Date(viewDate.getFullYear(), viewDate.getMonth() + delta, 1);
            let today = new Date();
            if (d.getMonth() === today.getMonth() && d.getFullYear() === today.getFullYear()) {
                viewDate = today;
            } else {
                viewDate = d;
            }
        }

        Layout.maximumHeight: 440
        Layout.maximumWidth: 300
        Layout.minimumHeight: 440
        Layout.minimumWidth: 300

        Component.onCompleted: {
            fullView.viewDate = new Date();
        }

        Connections {
            function onStatusChanged(status) {
                if (plasmoid.status === 4) {
                    fullView.viewDate = new Date();
                }
            }

            target: plasmoid
        }
        ColumnLayout {
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Layout.margins: 10
            spacing: 10

            Controls.Label {
                Layout.alignment: Qt.AlignTop
                Layout.preferredHeight: 36
                font.family: "sans"
                font.pixelSize: 36
                font.weight: 100
                text: clockWidget.currentDateTime.toLocaleTimeString(Qt.locale(), "HH:mm:ss")
            }
            Controls.Label {
                Layout.alignment: Qt.AlignTop
                Layout.bottomMargin: 15
                Layout.preferredHeight: 14
                font.pixelSize: 14
                font.weight: 300
                text: clockWidget.currentDateTime.toLocaleDateString(Qt.locale(), Locale.LongFormat)
            }
            Rectangle {
                Layout.fillWidth: true
                color: Kirigami.Theme.textColor
                height: 1
                opacity: 0.2
            }
            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 10

                Controls.Label {
                    Layout.leftMargin: 8
                    font.weight: 300
                    text: fullView.viewDate.toLocaleDateString(Qt.locale(), "MMM yyyy")
                }
                Item {
                    Layout.fillWidth: true
                }
                PlasmaComponents.ToolButton {
                    icon.name: "arrow-up"

                    onClicked: {
                        shiftMonth(-1);
                    }
                }
                PlasmaComponents.ToolButton {
                    icon.name: "arrow-down"

                    onClicked: {
                        shiftMonth(1);
                    }
                }
            }
            Grid {
                Layout.fillWidth: true
                Layout.topMargin: 5
                columns: 7

                Repeater {
                    model: 7

                    delegate: Controls.Label {
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        opacity: 0.7
                        text: Qt.locale().standaloneDayName((fullView.firstDayOfWeek + index) % 7, Locale.ShortFormat)
                        width: parent.width / 7
                    }
                }
            }
            Grid {
                id: daysGrid

                readonly property int daysInMonth: new Date(fullView.viewDate.getFullYear(), fullView.viewDate.getMonth() + 1, 0).getDate()
                readonly property int firstDayOffset: {
                    let firstOfMonth = new Date(fullView.viewDate.getFullYear(), fullView.viewDate.getMonth(), 1).getDay();
                    return (firstOfMonth - fullView.firstDayOfWeek + 7) % 7;
                }

                function isHighlighted(dayNumber, isActualDay) {
                    if (!isActualDay)
                        return false;

                    let today = new Date();
                    // Prüfe: Ist die Zelle heute UND sind wir im aktuellen Monat/Jahr?
                    return dayNumber === today.getDate() &&
                        viewDate.getMonth() === today.getMonth() &&
                        viewDate.getFullYear() === today.getFullYear();
                }

                Layout.fillHeight: true
                Layout.fillWidth: true
                columns: 7

                Repeater {
                    model: daysGrid.firstDayOffset + daysGrid.daysInMonth

                    delegate: Item {
                        id: dayItem

                        readonly property int dayNumber: index - daysGrid.firstDayOffset + 1
                        readonly property bool isActualDay: index >= daysGrid.firstDayOffset

                        height: width // Quadratische Zellen
                        width: daysGrid.width / 7

                        Rectangle {
                            anchors.fill: parent // Füllt die komplette Zelle (Item) aus
                            anchors.margins: 3
                            color: Kirigami.Theme.highlightColor
                            opacity: daysGrid.isHighlighted(dayNumber, isActualDay) ? 1 : 0
                            radius: parent.width
                            visible: daysGrid.isHighlighted(dayNumber, isActualDay)
                        }
                        Controls.Label {
                            anchors.centerIn: parent
                            color: font.bold ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.textColor
                            font.bold: daysGrid.isHighlighted(dayItem.dayNumber, dayItem.isActualDay)
                            text: dayItem.isActualDay ? dayItem.dayNumber : ""
                        }
                    }
                }
            }
            Item {
                Layout.fillHeight: true
            }
        }
    }

    Timer {
        id: popupClockTimer

        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: {
            var now = new Date();
            clockWidget.currentDateTime = now;
        }
    }
}
