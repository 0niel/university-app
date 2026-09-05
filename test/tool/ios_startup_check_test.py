import datetime
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


class FirstFrameLogTest(unittest.TestCase):
    def setUp(self):
        self.started_at = datetime.datetime(2026, 9, 5, 7, 56, 30)
        self.line = (
            '2026-09-05 07:56:34.915 Df Runner[40423:5638f] '
            '(Flutter) flutter: IOS_STARTUP_PROBE_FIRST_FRAME_V1\n'
        )

    def test_unified_log_detects_marker_missing_from_console(self):
        console = 'pro.oniel.it.university: 40423\n'
        pid = CHECK.launch_pid(console, 'pro.oniel.it.university')
        self.assertNotIn(CHECK.MARKER, console)
        self.assertTrue(CHECK.has_first_frame(self.line, pid, self.started_at))

    def test_other_process_marker_is_rejected(self):
        self.assertFalse(CHECK.has_first_frame(self.line, 43298, self.started_at))

    def test_reused_pid_before_launch_is_rejected(self):
        self.assertFalse(CHECK.has_first_frame(
            self.line, 40423, datetime.datetime(2026, 9, 5, 7, 57),
        ))

    def test_marker_without_process_and_timestamp_is_rejected(self):
        self.assertFalse(CHECK.has_first_frame(CHECK.MARKER, 40423, self.started_at))

    def test_other_bundle_pid_is_rejected(self):
        with self.assertRaises(RuntimeError):
            CHECK.launch_pid('other.application: 40423\n', 'pro.oniel.it.university')


class CounterfactualTest(unittest.TestCase):
    def test_rendered_callback_without_visible_window_reproduces_failure(self):
        baseline = {'launches': [{'first_frame_marker': True, 'visible': False}] * 3}
        fixed = {'launches': [{'first_frame_marker': True, 'visible': True}] * 3}
        self.assertTrue(CHECK.hypothesis_reproduced(baseline, fixed))

    def test_visible_baseline_does_not_reproduce_failure(self):
        visible = {'launches': [{'first_frame_marker': True, 'visible': True}] * 3}
        self.assertFalse(CHECK.hypothesis_reproduced(visible, visible))

    def test_fixed_without_first_frame_does_not_pass(self):
        baseline = {'launches': [{'first_frame_marker': True, 'visible': False}] * 3}
        fixed = {'launches': [{'first_frame_marker': False, 'visible': True}] * 3}
        self.assertFalse(CHECK.hypothesis_reproduced(baseline, fixed))

    def test_missing_evidence_does_not_pass(self):
        self.assertFalse(CHECK.hypothesis_reproduced({}, {}))


if __name__ == '__main__':
    unittest.main()
