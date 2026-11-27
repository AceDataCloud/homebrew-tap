# AceDataCloud Homebrew tap

[Homebrew](https://brew.sh/) tap for AceDataCloud command-line tools (macOS & Linux).

## Ace Data Cloud CLI

Install the `adc` command from this tap on macOS or Linux.

```bash
brew install acedatacloud/tap/acedatacloud-cli
adc services
adc packages "gpt image" --json
```

`adc services` lists the built-in routes. `adc packages` searches the catalog of separately installable service CLIs and MCP servers. Both commands work without an account. For API calls, use `adc auth login` with an [application key](https://platform.acedata.cloud/console/applications?utm_source=github&utm_medium=referral&utm_campaign=evergreen) for the service you plan to use.

| Built-in command | Services |
| --- | --- |
| `adc music` | <img src="https://cdn.acedata.cloud/l3ffw7.jpg" width="20" height="20" alt=""> Suno, <img src="https://cdn.acedata.cloud/acemusic-icon-52deddfc87b9.png" width="20" height="20" alt=""> ACE Music |
| `adc image` | <img src="https://cdn.acedata.cloud/859plc.jpg" width="20" height="20" alt=""> Nano Banana, <img src="https://cdn.acedata.cloud/9egrbn.png" width="20" height="20" alt=""> Seedream, <img src="https://cdn.acedata.cloud/ogm2oa.png" width="20" height="20" alt=""> FLUX, <img src="https://raw.githubusercontent.com/AceDataCloud/GPTImageDify/6916f7f1ee7fdb9531abf1c3ef1c57a34061eaf7/_assets/icon.png" width="20" height="20" alt=""> GPT Image |
| `adc video` | <img src="https://cdn.acedata.cloud/9q90dl.png" width="20" height="20" alt=""> Seedance, <img src="https://cdn.acedata.cloud/8nxyy9.jpg" width="20" height="20" alt=""> Veo, <img src="https://cdn.acedata.cloud/ahjfwi.png" width="20" height="20" alt=""> Luma, <img src="https://cdn.acedata.cloud/qpbbbb.jpg" width="20" height="20" alt=""> Kling |
| `adc search` | <img src="https://cdn.acedata.cloud/27e11e555d.png" width="20" height="20" alt=""> Google Search |

For GPT Image, supply the model and use `--async` when you need a task ID. A normal request returns the image results. Kling accepts a prompt or an opening reference image and returns a video task ID.

```bash
adc image "A red fox in the snow" --service gpt-image --model gpt-image-2 --size 1024x1024
adc video "A heron lands by the lake" --service kling --model kling-v3 --mode pro --duration 5
```

Use `adc task <task-id> --service <service>` to retrieve an existing media task. See the [CLI documentation](https://github.com/AceDataCloud/AceDataCloudCli) for command options.

## coding-bridge

Run Claude Code / Codex on your own machine and drive it from the web.

```bash
brew tap acedatacloud/tap
brew install coding-bridge
```

Then pair the machine once — this prints a code you enter in the web app:

```bash
coding-bridge pair
```

### Keep it running in the background

```bash
brew services start coding-bridge
```

The formula ships a service definition, so the daemon starts at login and
restarts if it crashes. It runs as **your** user, which is what lets it use your
existing Claude/Codex login and find CLIs installed via nvm/volta.

```bash
brew services info coding-bridge     # is it running?
brew services stop coding-bridge
```

> **Pair before you start the service.** A background service can't do the
> interactive pairing step, so an unpaired daemon just exits and retries.

> **Don't also run `coding-bridge up` in a terminal** while the service is
> running — two daemons share one node token and fight over the connection.

`coding-bridge service install` does the same thing without Homebrew (and is
what you'd use on a pip/pipx/uv install). Full docs:
[AceDataCloud/CodingBridge](https://github.com/AceDataCloud/CodingBridge).

## Maintenance

`Formula/coding-bridge.rb` tracks [PyPI](https://pypi.org/project/coding-bridge/).
The `url` / `sha256` are bumped automatically by CI in
[AceDataCloud/CodingBridge](https://github.com/AceDataCloud/CodingBridge) after
each release.

The `resource` blocks are **not** auto-updated. When the dependency tree
changes, regenerate them and keep the `python@` pin in sync with the interpreter
that generated them:

```bash
brew update-python-resources acedatacloud/tap/coding-bridge
```

CI (`.github/workflows/tests.yml`) runs `brew test-bot` plus a real
`brew install --build-from-source` on macOS and Ubuntu for every push, so a
broken formula fails loudly rather than silently.
