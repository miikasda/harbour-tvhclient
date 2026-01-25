import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    property bool recording: false
    property date start
    property date stop
    property int timeLeftMinutes: 0
    property real progress: 0
    property bool active: true

    height: contentColumn.height

    Component.onCompleted: updateTimeLeft()
    onStartChanged: updateTimeLeft()
    onStopChanged: updateTimeLeft()
    onActiveChanged: {
        if (active)
            updateTimeLeft()
    }

    Timer {
        id: timeLeftTimer
        interval: 60000
        repeat: true
        running: active && timeLeftMinutes > 0
        onTriggered: updateTimeLeft()
    }

    Column {
        id: contentColumn
        width: parent.width
        spacing: Theme.paddingSmall

        Item {
            width: parent.width
            height: Theme.paddingSmall

            Rectangle {
                id: backgroundRect
                anchors.fill: parent

                color: Theme.primaryColor

                Rectangle {
                    width: parent.width * getPercentage()
                    height: parent.height

                    color: recording ? Theme.errorColor : Theme.highlightColor
                }
            }
        }

        Item {
            height: startTimeLabel.height
            width: parent.width

            Label {
                id: startTimeLabel
                anchors.left: parent.left
                text: start.toLocaleTimeString(Qt.locale(), "hh:mm")
                font.pixelSize: Theme.fontSizeTiny
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("%n min(s) left", "", timeLeftMinutes)
                font.pixelSize: Theme.fontSizeTiny
            }

            Label {
                anchors.right: parent.right
                text: stop.toLocaleTimeString(Qt.locale(), "hh:mm")
                font.pixelSize: Theme.fontSizeTiny
            }
        }
    }

    function getDuration() {
        return stop.getTime() - start.getTime()
    }

    function getTimeLeft() {
        return (stop.getTime() - new Date().getTime())
    }

    function updateTimeLeft() {
        var duration = getDuration()
        var remaining = Math.max(0, getTimeLeft())
        timeLeftMinutes = remaining > 0 ? Math.ceil(remaining / 60000) : 0
        progress = duration > 0 ? Math.min(1, Math.max(0, 1.0 - (remaining / duration))) : 0
        timeLeftTimer.running = active && remaining > 0
    }

    function getPercentage() {
        return progress
    }
}
