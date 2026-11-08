# Matrix bridges

Telegram uses mautrix-telegram v26.10 with persistent SQLite storage in
`/opt/continuwuity/telegram`. Existing tokens, encryption keys and login sessions
are preserved on subsequent deployments. Only the configured administrator may
use the bridge; bridged rooms use encryption and disable federation.

Create a Telegram application at https://my.telegram.org/apps and add its
credentials to the repository's private `.env` file:

```dotenv
TELEGRAM_API_ID='your_numeric_api_id'
TELEGRAM_API_HASH='your_32_character_api_hash'
TELEGRAM_BRIDGE_ADMIN='@vieira:quati.xyz'
```

The application credentials are separate from a BotFather bot token. Environment
variables override `.env`; the administrator defaults to `@vieira` on the deployed
Matrix domain.

Deploy the bridge on the existing Matrix host:

```sh
ansible-playbook services/matrix/ansible/telegram.yml
```

The main Matrix playbook also includes Telegram. On first deployment, paste the
printed appservice registration command into the private Continuwuity admin room.
The registration contains secret tokens: keep it private. Confirm registration
with `!admin appservices list`.

Open a private chat with `@telegrambot:quati.xyz`, send `login qr`, and scan the
code from Telegram **Settings > Devices > Link Desktop Device**. Complete any
Telegram two-step verification prompt. The bot will then invite you to bridged
chats. Use your configured Matrix domain if it differs from `quati.xyz`.

Upstream documentation:
- https://docs.mau.fi/bridges/general/docker-setup.html?bridge=telegram
- https://docs.mau.fi/bridges/go/telegram/authentication.html
