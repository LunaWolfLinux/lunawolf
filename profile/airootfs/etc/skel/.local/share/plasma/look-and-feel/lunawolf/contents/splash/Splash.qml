import QtQuick
import QtQuick.Shapes
import QtCore
import org.kde.kirigami 2 as Kirigami

Rectangle {
    id: root
    color: "#181825"
    property int stage
    
    property string userName:
    StandardPaths.writableLocation(StandardPaths.HomeLocation)
        .toString()
        .replace("file://", "")
        .split("/")
        .pop()

    //Component.onCompleted: {
     //   introAnimation.running = true
    //}

    onStageChanged: {
        if (stage == 2) {
            introAnimation.running = true
        } else if (stage == 5) {
            fadeOutAnimation.running = true
        }
    }
    
    Image {
        anchors.fill: parent
        source: "images/background.jpg"
        fillMode: Image.PreserveAspectCrop
    }

    Item {
        id: content

        anchors.fill: parent
        opacity: 0

        // CENTER LOGO
        Image {
            id: logo

            readonly property real size: Kirigami.Units.gridUnit * 8

            anchors.centerIn: parent

            source: "images/lunawolf.svg"

            sourceSize.width: size
            sourceSize.height: size

            smooth: true
            visible: true
        }

        // SPINNER CONTAINER
        Item {
            id: spinnerContainer

            anchors.centerIn: logo

            width: logo.width + 64
            height: logo.height + 64

            property color spinnerColor: "#89b4fa"

            rotation: 0

            // ROTATION
            RotationAnimator on rotation {
                from: 0
                to: 360

                duration: 2200
                loops: Animation.Infinite

                running: true
            }

            // COLOR CYCLING
            SequentialAnimation {
                loops: Animation.Infinite
                running: true

                ColorAnimation {
                    target: spinnerContainer
                    property: "spinnerColor"

                    to: "#f38ba8"
                    duration: 1200
                }

                ColorAnimation {
                    target: spinnerContainer
                    property: "spinnerColor"

                    to: "#a6e3a1"
                    duration: 1200
                }

                ColorAnimation {
                    target: spinnerContainer
                    property: "spinnerColor"

                    to: "#89b4fa"
                    duration: 1200
                }
            }

            // SPINNER SHAPE
            Shape {
                id: spinnerShape

                anchors.fill: parent
                antialiasing: true
				smooth: true

                ShapePath {
                    strokeWidth: 4
                    strokeColor: spinnerContainer.spinnerColor

                    fillColor: "transparent"

                    capStyle: ShapePath.RoundCap
                    joinStyle: ShapePath.RoundJoin

                    PathAngleArc {
                        centerX: spinnerContainer.width / 2
                        centerY: spinnerContainer.height / 2

                        radiusX: logo.width / 2 + 20
                        radiusY: logo.height / 2 + 20

                        startAngle: 0
                        sweepAngle: 350
                    }
                }
            }
        }

        // WELCOME TEXT
        Text {
            text: "Welcome " + userName + "!"

            color: "#cdd6f4"

            font.pixelSize: 20
            font.bold: true

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 50

            opacity: 1
        }
    }

    // INTRO FADE IN
    OpacityAnimator {
        id: introAnimation

        running: false

        target: content

        from: 0
        to: 1

        duration: Kirigami.Units.veryLongDuration * 2

        easing.type: Easing.InOutQuad
    }

    // EXIT FADE OUT
    OpacityAnimator {
        id: fadeOutAnimation

        running: false

        target: content

        from: 1
        to: 0

        duration: 800

        easing.type: Easing.InOutQuad
    }
}
