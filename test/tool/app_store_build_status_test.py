import importlib.util
import unittest
from pathlib import Path
from unittest.mock import patch


def load_module():
    path = Path("tool/app_store_build_status.py")
    spec = importlib.util.spec_from_file_location("app_store_build_status", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class AppStoreBuildStatusTest(unittest.TestCase):
    def setUp(self):
        self.module = load_module()

    def test_base64url(self):
        self.assertEqual(self.module.base64url(b"\xfb\xff"), "-_8")

    def test_der_signature_to_raw(self):
        signature = bytes.fromhex("3006020101020102")
        expected = b"\0" * 31 + b"\1" + b"\0" * 31 + b"\2"
        self.assertEqual(self.module.der_signature_to_raw(signature), expected)

    def test_der_signature_rejects_trailing_data(self):
        with self.assertRaises(ValueError):
            self.module.der_signature_to_raw(bytes.fromhex("300602010102010200"))

    def test_der_signature_rejects_negative_integer(self):
        with self.assertRaises(ValueError):
            self.module.der_signature_to_raw(bytes.fromhex("3006020180020102"))

    def test_der_signature_rejects_non_minimal_integer(self):
        with self.assertRaises(ValueError):
            self.module.der_signature_to_raw(bytes.fromhex("300702020001020102"))

    def test_wait_for_build_is_bound_to_marketing_version(self):
        responses = {
            "/v1/apps": {"data": [{"id": "app-id"}]},
            "/v1/preReleaseVersions": {"data": [{"id": "version-id"}]},
            "/v1/builds": {
                "data": [
                    {
                        "id": "build-id",
                        "attributes": {
                            "iconAssetToken": {"templateUrl": "icon"},
                            "processingState": "VALID",
                            "uploadedDate": "2026-09-01T10:00:00Z",
                            "version": "2435.13.10",
                        },
                    }
                ]
            },
        }
        client = RecordingClient(responses)

        result = self.module.wait_for_build(
            client,
            "pro.oniel.it.university",
            "5.2.0",
            "2435.13.10",
            1,
            1,
        )

        self.assertEqual(result["marketing_version"], "5.2.0")
        self.assertEqual(
            client.queries[1],
            (
                "/v1/preReleaseVersions",
                {
                    "filter[app]": "app-id",
                    "filter[platform]": "IOS",
                    "filter[version]": "5.2.0",
                    "limit": "1",
                },
            ),
        )
        self.assertEqual(
            client.queries[2][1]["filter[preReleaseVersion]"],
            "version-id",
        )

    def test_wait_for_build_polls_until_marketing_version_exists(self):
        responses = {
            "/v1/apps": {"data": [{"id": "app-id"}]},
            "/v1/preReleaseVersions": [
                {"data": []},
                {"data": [{"id": "version-id"}]},
            ],
            "/v1/builds": {
                "data": [
                    {
                        "id": "build-id",
                        "attributes": {
                            "processingState": "VALID",
                            "version": "2435.13.10",
                        },
                    }
                ]
            },
        }
        client = RecordingClient(responses)

        result = self.module.wait_for_build(
            client,
            "pro.oniel.it.university",
            "5.2.0",
            "2435.13.10",
            1,
            0,
        )

        self.assertEqual(result["processing_state"], "VALID")
        version_queries = [
            query
            for path, query in client.queries
            if path == "/v1/preReleaseVersions"
        ]
        self.assertEqual(len(version_queries), 2)

    def release_client(self, state="WAITING_FOR_REVIEW"):
        return RecordingClient({
            "/v1/apps": {"data": [{"id": "app-id"}]},
            "/v1/apps/app-id/appStoreVersions": {
                "data": [{
                    "id": "store-version-id",
                    "attributes": {
                        "platform": "IOS",
                        "versionString": "5.2.0",
                        "appVersionState": state,
                        "releaseType": "AFTER_APPROVAL",
                        "downloadable": False,
                    },
                    "relationships": {
                        "build": {"data": {"type": "builds", "id": "build-id"}},
                        "appStoreVersionPhasedRelease": {"data": None},
                    },
                }],
            },
        })

    def release_status(self, client):
        return self.module.get_release_status(client, "bundle-id", "5.2.0", "build-id")

    def test_release_status_preserves_pending_and_live_states(self):
        for state in ("WAITING_FOR_REVIEW", "IN_REVIEW", "REJECTED", "READY_FOR_DISTRIBUTION"):
            with self.subTest(state=state):
                client = self.release_client(state)
                result = self.release_status(client)
                self.assertEqual(result["app_version_state"], state)
                self.assertEqual(result["selected_build_id"], "build-id")
                self.assertFalse(result["downloadable"])
                self.assertIsNone(result["phased_release_state"])
                self.assertEqual(client.queries[1][1]["filter[versionString]"], "5.2.0")
                self.assertEqual(client.queries[1][1]["filter[platform]"], "IOS")

    def test_release_status_rejects_missing_or_ambiguous_version(self):
        for data in ([], [{}, {}]):
            client = self.release_client()
            client.responses["/v1/apps/app-id/appStoreVersions"]["data"] = data
            with self.assertRaisesRegex(RuntimeError, "version is unavailable"):
                self.release_status(client)

    def test_release_status_rejects_wrong_platform_or_version(self):
        for key, value in (("platform", "MAC_OS"), ("versionString", "5.1.0")):
            client = self.release_client()
            client.responses["/v1/apps/app-id/appStoreVersions"]["data"][0]["attributes"][key] = value
            with self.assertRaisesRegex(RuntimeError, "does not match"):
                self.release_status(client)

    def test_release_status_rejects_missing_or_wrong_build(self):
        for data in (None, {"id": "another-build"}):
            client = self.release_client()
            client.responses["/v1/apps/app-id/appStoreVersions"]["data"][0]["relationships"]["build"]["data"] = data
            with self.assertRaisesRegex(RuntimeError, "does not select"):
                self.release_status(client)

    def test_release_status_requires_state_and_supports_legacy_state(self):
        client = self.release_client(None)
        with self.assertRaisesRegex(RuntimeError, "state is unavailable"):
            self.release_status(client)
        client.responses["/v1/apps/app-id/appStoreVersions"]["data"][0]["attributes"]["appStoreState"] = "READY_FOR_SALE"
        self.assertEqual(self.release_status(client)["app_version_state"], "READY_FOR_SALE")

    def test_release_status_reports_phased_release(self):
        client = self.release_client()
        response = client.responses["/v1/apps/app-id/appStoreVersions"]
        response["data"][0]["relationships"]["appStoreVersionPhasedRelease"]["data"] = {"id": "phase-id"}
        with self.assertRaisesRegex(RuntimeError, "phased release status is unavailable"):
            self.release_status(client)
        response["included"] = [{
            "id": "phase-id",
            "type": "appStoreVersionPhasedReleases",
            "attributes": {"phasedReleaseState": "ACTIVE"},
        }]
        self.assertEqual(self.release_status(client)["phased_release_state"], "ACTIVE")

    def test_release_status_is_opt_in_and_uses_verified_build(self):
        argv = ["status", "--bundle-id", "bundle-id", "--build-number", "123",
                "--marketing-version", "5.2.0", "--key-id", "key-id",
                "--issuer-id", "issuer-id", "--private-key", "unused.p8"]
        for enabled in (False, True):
            with patch("sys.argv", argv + (["--release-status"] if enabled else [])), \
                 patch.object(self.module, "wait_for_build", return_value={"build_id": "verified-build"}), \
                 patch.object(self.module, "get_release_status", return_value={}) as status, \
                 patch("builtins.print"):
                self.module.main()
                if enabled:
                    self.assertEqual(status.call_args.args[1:], ("bundle-id", "5.2.0", "verified-build"))
                else:
                    status.assert_not_called()


class RecordingClient:
    def __init__(self, responses):
        self.responses = responses
        self.queries = []

    def get(self, path, query):
        self.queries.append((path, query))
        response = self.responses[path]
        if isinstance(response, list):
            return response.pop(0)
        return response


if __name__ == "__main__":
    unittest.main()
