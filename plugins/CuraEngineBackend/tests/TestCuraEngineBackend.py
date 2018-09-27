import pytest #This module contains automated tests.
import unittest.mock #For the mocking and monkeypatching functionality.

from plugins.CuraEngineBackend.ProcessSlicedLayersJob import colorCodeToRGBA

def test_colorCodeToRGBA():
    assert colorCodeToRGBA("#FFFFFF") == [1., 1., 1., 1.]

