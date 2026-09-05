import importlib.util
import tempfile
import unittest
from pathlib import Path

from PIL import Image, ImageDraw


SPEC = importlib.util.spec_from_file_location(
    'ios_startup_check', Path(__file__).resolve().parents[2] / 'tool/ios_startup_check.py',
)
CHECK = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(CHECK)


class ScreenshotColorsTest(unittest.TestCase):
    def classify(self, image):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'screen.png'
            image.save(path)
            return CHECK.screenshot_colors(path)

    def test_black_screen_fails(self):
        self.assertFalse(self.classify(Image.new('RGB', (300, 600)))['visible'])

    def test_single_color_screen_fails(self):
        self.assertFalse(self.classify(Image.new('RGB', (300, 600), '#00c853'))['visible'])

    def test_probe_with_status_bar_passes(self):
        image = Image.new('RGB', (300, 600), '#00c853')
        draw = ImageDraw.Draw(image)
        draw.rectangle((150, 0, 299, 599), fill='#ff00ff')
        draw.rectangle((0, 0, 299, 40), fill='black')
        self.assertTrue(self.classify(image)['visible'])


if __name__ == '__main__':
    unittest.main()
