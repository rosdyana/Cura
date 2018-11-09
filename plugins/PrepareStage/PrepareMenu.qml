import QtQuick 2.7

import QtQuick.Controls 1.4

import UM 1.3 as UM
import Cura 1.1 as Cura


Item
{
    id: prepareMenu
    // This widget doesn't show tooltips by itself. Instead it emits signals so others can do something with it.
    signal showTooltip(Item item, point location, string text)
    signal hideTooltip()

    UM.I18nCatalog
    {
        id: catalog
        name: "cura"
    }

    Row
    {
        anchors.horizontalCenter: parent.horizontalCenter

        Button
        {
            id: openFileButton
            text: catalog.i18nc("@action:button", "Open File")
            iconSource: UM.Theme.getIcon("load")
            style: UM.Theme.styles.tool_button
            tooltip: ""
            action: Cura.Actions.open
        }

        Item
        {
            id: spacing
            width: UM.Theme.getSize("default_margin").width
            height: prepareMenu.height
        }

        Cura.MachineSelector
        {
            id: machineSelection
            width: UM.Theme.getSize("machine_selector_widget").width - configSelection.width
            height: prepareMenu.height
            z: openFileButton.z - 1
        }

        Cura.QuickConfigurationSelector
        {
            height: prepareMenu.height
            width: UM.Theme.getSize("configuration_selector_widget").width
            /*id: configSelection
            width: visible ? UM.Theme.getSize("machine_selector_widget").width * 0.2 : 0
            panelWidth: UM.Theme.getSize("machine_selector_widget").width
            height: prepareMenu.height*/
        }

        /*Cura.CustomConfigurationSelector
        {
            width: UM.Theme.getSize("configuration_selector_widget").width
        }*/

        Cura.PrintSetupSelector
        {
            width: UM.Theme.getSize("print_setup_widget").width
            onShowTooltip: prepareMenu.showTooltip(item, location, text)
            onHideTooltip: prepareMenu.hideTooltip()
        }
    }
}