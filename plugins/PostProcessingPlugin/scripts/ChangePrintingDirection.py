# Change printing direction
# Author : Rosdyana Kusuma
# Date : January, 7th 2019

# Description : custom plugin to change printing direction.

from ..Script import Script
from UM.Logger import Logger


class ChangePrintingDirection(Script):
    def __init__(self):
        super().__init__()

    def getSettingDataString(self):
        return """{
            "name": "Change printing direction",
            "key": "ChangePrintingDirection",
            "metadata": {},
            "version": 2,
            "settings":
            {
                "isOneDirection":
                {
                    "label": "Enable",
                    "description": "By default the printing direction will go back and forth, by enabling this setting will make printer only print in same direction.",
                    "type": "bool",
                    "default_value": false
                }
            }
        }"""

    def execute(self, data):
        if self.getSettingValueByKey("isOneDirection"):
            Logger.log("d", "Change printing direction is enable.")

        return data
