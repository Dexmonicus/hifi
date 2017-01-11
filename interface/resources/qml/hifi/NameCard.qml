//
//  NameCard.qml
//  qml/hifi
//
//  Created by Howard Stearns on 12/9/2016
//  Copyright 2016 High Fidelity, Inc.
//
//  Distributed under the Apache License, Version 2.0.
//  See the accompanying file LICENSE or http://www.apache.org/licenses/LICENSE-2.0.html
//

import QtQuick 2.5
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0
import "../styles-uit"

Row {
    id: thisNameCard
    // Spacing
    spacing: 10
    // Anchors
    anchors.top: parent.top
    anchors {
        topMargin: (parent.height - contentHeight)/2
        bottomMargin: (parent.height - contentHeight)/2
        leftMargin: 10
        rightMargin: 10
    }

    // Properties
    property int contentHeight: isMyCard ? 50 : 70
    property string uuid: ""
    property string displayName: ""
    property string userName: ""
    property int displayTextHeight: 18
    property int usernameTextHeight: 12
    property real audioLevel: 0.0
    property bool isMyCard: false

    /* User image commented out for now - will probably be re-introduced later.
    Column {
        id: avatarImage
        // Size
        height: contentHeight
        width: height
        Image {
            id: userImage
            source: "../../icons/defaultNameCardUser.png"
            // Anchors
            width: parent.width
            height: parent.height
        }
    }
    */
    Column {
        id: textContainer
        // Size
        width: parent.width - /*avatarImage.width - */parent.anchors.leftMargin - parent.anchors.rightMargin - parent.spacing
        height: contentHeight

        // DisplayName Text
        FiraSansSemiBold {
            id: displayNameText
            // Properties
            text: thisNameCard.displayName
            elide: Text.ElideRight
            // Size
            width: parent.width
            // Text Size
            size: thisNameCard.displayTextHeight
            // Text Positioning
            verticalAlignment: Text.AlignVCenter
            // Style
            color: hifi.colors.darkGray
        }

        // UserName Text
        FiraSansRegular {
            id: userNameText
            // Properties
            text: thisNameCard.userName
            elide: Text.ElideRight
            visible: thisNameCard.displayName
            // Size
            width: parent.width
            // Text Size
            size: thisNameCard.usernameTextHeight
            // Text Positioning
            verticalAlignment: Text.AlignVCenter
            // Style
            color: hifi.colors.baseGray
        }

        // Spacer
        Item {
            height: 4
            width: parent.width
        }

        // VU Meter
        Rectangle { // CHANGEME to the appropriate type!
            id: nameCardVUMeter
            // Size
            width: parent.width
            height: 8
            // Style
            radius: 4
            // Rectangle for the VU meter base
            Rectangle {
                id: vuMeterBase
                // Anchors
                anchors.fill: parent
                // Style
                color: "#c5c5c5"
                radius: parent.radius
            }
            // Rectangle for the VU meter audio level
            Rectangle {
                id: vuMeterLevel
                // Size
                width: (thisNameCard.audioLevel) * parent.width
                // Style
                color: "#c5c5c5"
                radius: parent.radius
                // Anchors
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                anchors.left: parent.left
            }
            // Gradient for the VU meter audio level
            LinearGradient {
                anchors.fill: vuMeterLevel
                source: vuMeterLevel
                start: Qt.point(0, 0)
                end: Qt.point(parent.width, 0)
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#2c8e72" }
                    GradientStop { position: 0.9; color: "#1fc6a6" }
                    GradientStop { position: 0.91; color: "#ea4c5f" }
                    GradientStop { position: 1.0; color: "#ea4c5f" }
                }
            }
        }

        // Per-Avatar Gain Slider Spacer
        Item {
            width: parent.width
            height: 4
            visible: !isMyCard
        }
        // Per-Avatar Gain Slider 
        Slider {
            id: gainSlider
            visible: !isMyCard
            width: parent.width
            height: 16
            value: 1.0
            minimumValue: 0.0
            maximumValue: 1.5
            stepSize: 0.1
            updateValueWhileDragging: false
            onValueChanged: updateGainFromQML(uuid, value)
        }
    }

    function updateGainFromQML(avatarUuid, gainValue) {
        var data = {
            sessionId: avatarUuid,
            gain: (Math.exp(gainValue) - 1) / (Math.E - 1)
        };
        pal.sendToScript({method: 'updateGain', params: data});
    }
}
