# Nix Flakes

Reusable Nix flake templates for reproducible development environments.

## Templates

| Template | Description |
|----------|-------------|
| `python` | Python 3.13 + numpy, pandas, matplotlib, ruff, uv |
| `r` | R + ggplot2, dplyr, tidyr, devtools |
| `quarto` | Quarto + Python + R + pandoc + texlive |
| `nodejs` | Node.js + corepack + TypeScript |
| `rust` | Rust (stable via rust-overlay) + rust-analyzer |

## Usage

Copy a template's `flake.nix` and `.envrc` into your project directory:

```bash
cp ~/nix-flakes/python/flake.nix ~/nix-flakes/python/.envrc ./
direnv allow
```

Or enter the shell directly:

```bash
nix develop ~/nix-flakes/python
```
