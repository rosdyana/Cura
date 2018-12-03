import QtQuick 2.7
import QtQuick.Controls 2.3

import UM 1.2 as UM
import Cura 1.0 as Cura

import QtGraphicalEffects 1.0 // For the dropshadow

// The expandable component has 3 major sub components:
//      * The headerItem; Always visible and should hold some info about what happens if the component is expanded
//      * The popupItem; The content that needs to be shown if the component is expanded.
//      * The icon; An icon that is displayed on the right of the drawer.
Item
{
    id: base

    // Enumeration with the different possible alignments of the popup with respect of the headerItem
    enum PopupAlignment 
    {
        AlignLeft,
        AlignRight
    }

    // The headerItem holds the QML item that is always displayed.
    property alias headerItem: headerItemLoader.sourceComponent

    // The popupItem holds the QML item that is shown when the "open" button is pressed
    property var popupItem

    property color popupBackgroundColor: UM.Theme.getColor("action_button")

    property color headerBackgroundColor: UM.Theme.getColor("action_button")
    property color headerHoverColor: UM.Theme.getColor("action_button_hovered")

    // Defines the alignment of the popup with respect of the headerItem, by default to the right
    property int popupAlignment: ExpandableComponent.PopupAlignment.AlignRight

    // How much spacing is needed around the popupItem
    property alias popupPadding: popupLoader.loaderPadding

    // How much spacing is needed for the popupItem by Y coordinate
    property var popupSpacingY: 0

    // How much padding is needed around the header & button
    property alias headerPadding: background.padding

    // What icon should be displayed on the right.
    property alias iconSource: collapseButton.source

    property alias iconColor: collapseButton.color

    // The icon size (it's always drawn as a square)
    property alias iconSize: collapseButton.height

    // Is the "drawer" open?
    readonly property alias expanded: popupLoader.loaderVisible

    property alias expandedHighlightColor: expandedHighlight.color

    // What should the radius of the header be. This is also influenced by the headerCornerSide
    property alias headerRadius: background.radius

    // On what side should the header corners be shown? 1 is down, 2 is left, 3 is up and 4 is right.
    property alias headerCornerSide: background.cornerSide

    // Change the popupItem close behaviour
    property var isPopupModeContainer: false

    property alias headerShadowColor: shadow.color

    property alias enableHeaderShadow: shadow.visible

    property int shadowOffset: 2

    function togglePopup()
    {
        popupLoader.togglePopupVisibility()
    }

    onPopupItemChanged:
    {
        // Since we want the size of the popup to be set by the size of the content,
        // we need to do it like this.
//        popupLoader.width = popupItem.width + 2 * popupLoader.padding
//        popupLoader.height = popupItem.height + 2 * popupLoader.padding
//        popupLoader.loaderItem = popupItem
    }

    Connections
    {
        // Since it could be that the popup is dynamically populated, we should also take these changes into account.
        target: popupItem
        onWidthChanged: popupLoader.width = popupItem.width + 2 * popupLoader.padding
        onHeightChanged: popupLoader.height = popupItem.height + 2 * popupLoader.padding
    }

    implicitHeight: 100 * screenScaleFactor
    implicitWidth: 400 * screenScaleFactor

    RoundedRectangle
    {
        id: background
        property real padding: UM.Theme.getSize("default_margin").width

        color: headerBackgroundColor
        anchors.fill: parent

        Loader
        {
            id: headerItemLoader
            anchors
            {
                left: parent.left
                right: collapseButton.visible ? collapseButton.left : parent.right
                top: parent.top
                bottom: parent.bottom
                margins: background.padding
            }
        }

        // A highlight that is shown when the popup is expanded
        Rectangle
        {
            id: expandedHighlight
            width: parent.width
            height: UM.Theme.getSize("thick_lining").height
            color: UM.Theme.getColor("primary")
            visible: expanded
            anchors.bottom: parent.bottom
        }

        UM.RecolorImage
        {
            id: collapseButton
            anchors
            {
                right: parent.right
                verticalCenter: parent.verticalCenter
                margins: background.padding
            }
            sourceSize.width: width
            sourceSize.height: height
            visible: source != ""
            width: height
            height: Math.round(0.2 * base.height)
            color: UM.Theme.getColor("text")
        }

        MouseArea
        {
            id: mouseArea
            anchors.fill: parent
            onClicked: togglePopup()
            hoverEnabled: true
            onEntered: background.color = headerHoverColor
            onExited: background.color = headerBackgroundColor
        }
    }

    DropShadow
    {
        id: shadow
        // Don't blur the shadow
        radius: 0
        anchors.fill: background
        source: background
        verticalOffset: base.shadowOffset
        visible: true
        color: UM.Theme.getColor("action_button_shadow")
        // Should always be drawn behind the background.
        z: background.z - 1
    }

    Loader
    {
        property real loaderPadding: UM.Theme.getSize("default_margin").width
        property bool loaderVisible: false
        property color loaderPopupBackgroundColor: popupBackgroundColor

        function togglePopupVisibility()
        {
            if(isPopupModeContainer)
            {
                loaderVisible = !loaderVisible
            }
            else
            {
                item.open()
            }
        }

        height: popupItem.height + 2 * loaderPadding
        width: popupItem.width  + 2 * loaderPadding

        id: popupLoader
        sourceComponent: isPopupModeContainer ? loaderPopupContainerComponent : loaderPopupComponent

        y: background.height + base.shadowOffset + popupSpacingY
        x: popupAlignment == ExpandableComponent.PopupAlignment.AlignRight ? -popupItem.width + collapseButton.width + headerItemLoader.width + 3 * background.padding - 2 * loaderPadding: 0
    }

    Component
    {
        id: loaderPopupComponent

        Popup
        {
            id: loaderPopup
            padding: loaderPadding
            contentItem: popupItem

            background: Cura.RoundedRectangle
            {
                cornerSide: Cura.RoundedRectangle.Direction.Down
                color: popupBackgroundColor
                border.width: UM.Theme.getSize("default_lining").width
                border.color: UM.Theme.getColor("lining")
                radius: UM.Theme.getSize("default_radius").width
            }
        }
    }

    Component
    {
        id: loaderPopupContainerComponent

        Container
        {
            id: loaderContainer

            visible: loaderVisible
            contentItem: popupItem

            background: Cura.RoundedRectangle
            {
                cornerSide: Cura.RoundedRectangle.Direction.Down
                color: loaderPopupBackgroundColor
                border.width: UM.Theme.getSize("default_lining").width
                border.color: UM.Theme.getColor("lining")
                radius: UM.Theme.getSize("default_radius").width
            }
        }
    }
}