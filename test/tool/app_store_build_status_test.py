import importlib.util
import unittest
from pathlib import Path


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
