# AceDataCloud Homebrew tap

[Homebrew](https://brew.sh/) tap for AceDataCloud command-line tools (macOS & Linux).

## Usage

```bash
brew tap acedatacloud/tap
brew install coding-bridge
```

## Formulae

| Formula | Description |
|---|---|
| `coding-bridge` | Run Claude Code / Codex on your own machine and drive it from the web. |

### Run coding-bridge as a background service

The formula ships a service definition, so after pairing once you can keep the
daemon running across logout/reboot:

```bash
coding-bridge pair                    # once, interactively (a service can't pair)
brew services start coding-bridge
```

It runs as **your** user, so it keeps your Claude/Codex login. Equivalent to the
built-in `coding-bridge service install`.

## Maintenance

`Formula/coding-bridge.rb` tracks [PyPI](https://pypi.org/project/coding-bridge/).
The `url`/`sha256`/version are bumped automatically by CI in
[AceDataCloud/CodingBridge](https://github.com/AceDataCloud/CodingBridge) on each
release. When the dependency tree changes, regenerate the `resource` blocks:

```bash
brew update-python-resources acedatacloud/tap/coding-bridge
```

