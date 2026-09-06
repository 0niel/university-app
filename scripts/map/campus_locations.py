import hashlib
import math
from pathlib import Path
import re


ROOT = Path(__file__).resolve().parents[2]
SOURCE_PATH = 'packages/rtu_mirea_schedule_api_client/lib/src/campuses.dart'


def location_for(short_name):
    source_bytes = (ROOT / SOURCE_PATH).read_bytes()
    source = source_bytes.decode('utf-8')
    matches = []
    for block in re.findall(r'const\s+Campus\s*\((.*?)\)', source, re.DOTALL):
        name = re.search(r"\bshortName\s*:\s*'([^']+)'", block)
        if name is None or name.group(1) != short_name:
            continue
        values = {}
        for key, limit in (('latitude', 90), ('longitude', 180)):
            value = re.search(rf'\b{key}\s*:\s*([-+]?(?:\d+(?:\.\d*)?|\.\d+))\s*,', block)
            if value is None:
                raise ValueError(f'Campus {short_name} needs explicit {key}')
            coordinate = float(value.group(1))
            if not math.isfinite(coordinate) or not -limit <= coordinate <= limit:
                raise ValueError(f'Invalid {key} for campus {short_name}')
            values[key] = coordinate
        matches.append(values)
    if len(matches) != 1:
        raise ValueError(f'Campus location must match one existing catalog entry: {short_name}')
    return {
        **matches[0],
        'location_source': {
            'type': 'existing_application_catalog', 'path': SOURCE_PATH,
            'sha256': hashlib.sha256(source_bytes).hexdigest(),
            'short_name': short_name,
        },
    }
