# AceDataCloud Homebrew tap

[Homebrew](https://brew.sh/) tap for AceDataCloud command-line tools (macOS & Linux).

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
