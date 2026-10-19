import re


_LOCATION_BODY = (
    "The signed IPA for this build has been inspected before this submission. "
    "The main application's Info.plist declares location in UIBackgroundModes. "
    "No embedded bundle declares this mode, and no bundle declares Always location access. "
    "The permission prompt requests When In Use access only. "
    "In Friends on the map, users explicitly enable Share my location in Location sharing settings "
    "and choose whether friends or students at their university can see it. "
    "This starts continuous location sharing with the iOS location indicator, "
    "including while the app is minimized or the screen is locked. "
    "Turning sharing off, selecting No one, enabling Ghost mode, or signing out stops background sharing. "
    "Viewing the map without sharing uses location only while the app is in the foreground. "
    "If iOS terminates the app or the user swipes it away, sharing stops until the app is reopened. "
    "Please review the build number above for this submission."
)
_LEGACY_LOCATION_BODY = (
    "The signed IPA for this build has been inspected before this submission. "
    "The main application's Info.plist does not declare location in UIBackgroundModes. "
    "No embedded bundle declares the location background mode or an Always location usage description. "
    "Location is used only while the app is open, for the map and optional location sharing. "
    "Location updates stop when the app enters the background. "
    "The permission prompt requests When In Use access only. "
    "Please review the build number above for this submission."
)
_LOCATION_CLARIFICATION = re.compile(
    r"^Location clarification for version [0-9]+\.[0-9]+\.[0-9]+ "
    r"\(build [0-9]+(?:\.[0-9]+){0,2}\), guideline 2\.5\.4:\r?\n(?:"
    + "|".join(re.escape(body) for body in (_LOCATION_BODY, _LEGACY_LOCATION_BODY))
    + r")(?=\r?\n|\Z)",
    re.MULTILINE,
)


def create_location_review_note(marketing_version: str, build_number: str) -> str:
    return (
        f"Location clarification for version {marketing_version} "
        f"(build {build_number}), guideline 2.5.4:\n{_LOCATION_BODY}"
    )


def merge_review_notes(existing: str, note: str) -> str:
    if _LOCATION_CLARIFICATION.fullmatch(note):
        updated = _LOCATION_CLARIFICATION.sub("", existing)
        if updated != existing:
            existing = updated.strip("\r\n")
    combined = existing if note in existing else existing + ("\n\n" if existing else "") + note
    if len(combined.encode("utf-8")) > 4000:
        raise ValueError("Combined App Store review notes exceed 4000 bytes")
    return combined
