import importlib.util
from pathlib import Path
import unittest


SPEC = importlib.util.spec_from_file_location('resolve_android_release', Path(__file__).resolve().parents[2] / 'tool/resolve_android_release.py')
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class ResolveAndroidReleaseTest(unittest.TestCase):
    def release(self, identity=1, **values):
        return dict(id=identity, tag_name=f'v12.7.3-beta.{identity}', target_commitish='a' * 40,
                    prerelease=True, draft=False, assets=[{'name': 'application.aab'}, {'name': 'SHA256SUMS'}], **values)

    def test_newer_registry_entry_cannot_shadow_application(self):
        binary = self.release()
        registry = {**self.release(99), 'tag_name': 'shorebird-android-12.7.3+99', 'assets': [{'name': 'release-manifest.json'}]}
        self.assertEqual(MODULE.select_release([registry, binary], 'a' * 40), binary['tag_name'])

    def test_newest_complete_build_selected_regardless_of_listing_order(self):
        builds = [self.release(8), self.release(2), self.release(5)]
        self.assertEqual(MODULE.select_release(builds, 'a' * 40), 'v12.7.3-beta.8')

    def test_incomplete_ambiguous_draft_or_unrelated_release_rejected(self):
        for changes in ({'draft': True}, {'prerelease': False}, {'target_commitish': 'b' * 40},
                        {'assets': [{'name': 'application.aab'}]},
                        {'assets': [{'name': 'a.aab'}, {'name': 'b.aab'}, {'name': 'SHA256SUMS'}]}):
            with self.subTest(changes=changes), self.assertRaises(ValueError):
                MODULE.select_release([{**self.release(), **changes}], 'a' * 40)

    def test_invalid_source_or_tag_rejected(self):
        with self.assertRaises(ValueError):
            MODULE.select_release([self.release()], 'master')
        with self.assertRaises(ValueError):
            MODULE.select_release([{**self.release(), 'tag_name': 'unsafe\nvalue'}], 'a' * 40)


if __name__ == '__main__':
    unittest.main()
