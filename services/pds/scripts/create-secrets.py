#!/usr/bin/python3
"""Create PDS keys once, without printing them or replacing existing keys."""
import os
import secrets
from pathlib import Path

from cryptography.hazmat.primitives.asymmetric import ec

destination = Path('/opt/pds/secrets.env')
if not destination.exists():
    if any(Path('/pds').glob('*.sqlite*')):
        raise SystemExit('Existing PDS database found: restore secrets.env from backup.')
    rotation_key = ec.generate_private_key(ec.SECP256K1())
    values = {
        'PDS_JWT_SECRET': secrets.token_hex(32),
        'PDS_ADMIN_PASSWORD': secrets.token_hex(32),
        'PDS_PLC_ROTATION_KEY_K256_PRIVATE_KEY_HEX':
            f'{rotation_key.private_numbers().private_value:064x}',
    }
    with open(destination, 'x', opener=lambda p, f: os.open(p, f, 0o600)) as output:
        output.write(''.join(f'{key}={value}\n' for key, value in values.items()))
