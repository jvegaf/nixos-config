# OpenCode Wrapper Migration

## Goal

Migrate the OpenCode configuration from `~/nixdots` into `nixos-config` so
that the complete configuration is available as a portable flake package:

```bash
nix run .#opencode
```

The same package must be installable through the existing Home Manager
integration without maintaining a second OpenCode configuration.

## Scope

The migration includes:

- OpenCode package selection from `numtide/llm-agents.nix`.
- JSON settings, including plugins, permissions, and custom LSP servers.
- Commands from `modules/home/ai-tools/commands`.
- Agents from `modules/home/ai-tools/agents` in OpenCode's native Markdown
  layout.
- Skills from the AI tools tree, the external `superpowers` input, and the
  complete `mattpocock/skills` repository.
- Global context from `base.md`.
- Runtime packages required by configured LSP commands.

The migration does not redesign the agent prompts, command templates,
permission policy, or LSP definitions. Their behavior should remain equivalent
to `nixdots` unless a package is unavailable on a declared platform.

## Architecture

`modules/features/opencode/default.nix` remains a flake-parts module and owns
the OpenCode feature. It will expose two outputs:

1. `perSystem.packages.opencode`, a wrapped OpenCode executable.
2. `flake.homeModules.opencode`, a Home Manager module that installs that
   package in `home.packages`.

The wrapper will use:

```nix
inputs.wrapper-modules.wrappers.opencode.wrap
```

The built-in wrapper module generates the main JSON configuration and exports
it through `OPENCODE_CONFIG`. A separate Nix derivation will provide the
OpenCode configuration directory. It will contain `commands/`, `agents/`,
`skills/`, and `AGENTS.md`; the wrapper will set
`OPENCODE_CONFIG_DIR` to that derivation. This keeps `nix run` independent of
the user's home directory while preserving OpenCode's native file layout.

The settings, generated Markdown, and configuration directory will be derived
from shared Nix values in the feature module. Home Manager will not invoke
`programs.opencode` for this feature, avoiding duplicate files and conflicting
configuration sources.

## Inputs

The destination flake will add:

- `llm-agents.url = "github:numtide/llm-agents.nix"`.
- A non-flake `superpowers` input pointing to `github:obra/superpowers`.
- A non-flake `matt-pocock-skills` input pointing to
  `github:mattpocock/skills`.

All three inputs will be locked in `flake.lock`. Existing input-follow
relationships will be preserved where applicable.

## Configuration Mapping

The current `nixdots` values map as follows:

| Source | Destination |
| --- | --- |
| `programs.opencode.settings` | wrapper `settings` |
| `opencode/lsp.nix` | `settings.lsp` |
| `opencode/permission.nix` | `settings.permission` |
| `ai-tools/commands/` | `commands/*.md` |
| `ai-tools/agents/` | `agents/*.md` |
| `ai-tools/skills/` | generated `skills/` content |
| `ai-tools/base.md` | `AGENTS.md` in the config directory |
| `superpowers/skills` | `skills/superpowers/` |
| `matt-pocock-skills/skills/engineering` | `skills/matt-pocock/engineering/` |
| `matt-pocock-skills/skills/productivity` | `skills/matt-pocock/productivity/` |

Only the upstream `skills/` subtree will be exposed. Repository metadata,
plugin manifests, package files, and documentation outside that subtree will
not be copied into the OpenCode configuration. The complete upstream skills
set will be included, preserving the engineering/productivity categories and
their Markdown `SKILL.md` layout. The `setup-matt-pocock-skills` skill is
available but will not be run automatically; it remains an explicitly
user-invoked workflow that may create repository-specific configuration.

The `superpowers` plugin path will only be added to the plugin configuration
if the migrated feature explicitly includes it. The current `nixdots` plugin
list is the behavioral source of truth; an unused local path binding must not
be silently turned into an active plugin.

## Runtime Dependencies

The wrapper will add the executables referenced by the LSP configuration to
`runtimePkgs`, including the Nix, HTML/CSS/JSON, Svelte, Emmet, Haskell,
Python, Lua, and YAML language servers where those packages are available.

Platform-specific package availability will be handled with conditional
`lib.optionals` or equivalent attribute checks rather than making the entire
flake fail on Darwin. The generated configuration may still reference an LSP
whose executable is supplied externally on a platform where its package is not
available; this limitation must be documented if encountered during checks.

## User-Facing Outputs

The following commands are acceptance criteria:

```bash
nix build .#opencode
nix run .#opencode -- --version
nix flake check
```

The package must also be available to the existing Home Manager feature import
through `self.homeModules.opencode`.

## Verification

Verification will inspect the built wrapper and generated store paths to ensure
that:

- `OPENCODE_CONFIG` points to a generated JSON file.
- `OPENCODE_CONFIG_DIR` points to the generated config directory.
- Commands and agents are present with the expected names.
- Skills and `AGENTS.md` are present.
- Configured LSP executables are reachable through the wrapper's runtime PATH.
- The wrapper launches the selected OpenCode package.

The flake's declared Linux and Darwin systems will be evaluated. A full
interactive OpenCode session is not required for the build verification, since
provider credentials are intentionally outside the Nix configuration.

## Risks and Constraints

- OpenCode's external plugins are resolved by OpenCode at runtime, so a
  network connection may still be required on first launch.
- `OPENCODE_CONFIG_DIR` is intentionally immutable. Runtime state must remain
  in OpenCode's cache, state, or data directories rather than this directory.
- The `superpowers` input and npm plugin references are independently updated;
  the flake lock fixes only the Git input revisions. Matt Pocock's skills will
  likewise change only when the flake input is intentionally updated.
- Upstream skill names and instructions may overlap conceptually with local
  skills. The dedicated `skills/matt-pocock/` namespace prevents path
  collisions, while OpenCode may still expose all installed skills to model
  discovery.
- No existing unrelated Home Manager, Niri, or Nixvim modules will be changed.
