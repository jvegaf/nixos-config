# OpenCode

This feature owns the complete standalone OpenCode wrapper.

## Usage

```bash
nix run .#opencode
```

The Home Manager module installs the same package through `home.packages`; it
does not configure `programs.opencode` separately.

## Configuration

The wrapper generates an immutable configuration directory containing:

- OpenCode JSON settings, including plugins, permissions, and LSP definitions.
- Local commands and agents in OpenCode's native Markdown layout.
- The local skill tree and `AGENTS.md` context.
- `superpowers` skills under `skills/superpowers`.
- All Matt Pocock skills under `skills/matt-pocock/engineering` and
  `skills/matt-pocock/productivity`.

Only the upstream `skills/` subtree from the Matt Pocock input is exposed.
Repository metadata, plugin manifests, and package files are not included.
The `setup-matt-pocock-skills` skill is available but is never run
automatically.

The wrapper sets both `OPENCODE_CONFIG` and `OPENCODE_CONFIG_DIR`. Runtime LSP
executables are supplied through the wrapper's package environment.

## Updates

Update external content intentionally with `nix flake lock --update-input
<input>`. The lock file pins `llm-agents`, `superpowers`, and
`matt-pocock-skills`; no external skill tree is copied into this repository.
