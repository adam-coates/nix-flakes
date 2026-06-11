# Nix Flakes

Reusable Nix flake templates for reproducible development environments.

Clone using:

```bash
git clone --recurse-submodules https://github.com/adam-coates/nix-flakes.git
```

## Templates

| Template | Description |
|----------|-------------|
| `python` | Python 3.13 + numpy, pandas, matplotlib, ruff, uv |
| `r` | R + ggplot2, dplyr, tidyr, devtools |
| `quarto` | Quarto + Python + R + pandoc + texlive |
| `nodejs` | Node.js + corepack + TypeScript |
| `rust` | Rust (stable via rust-overlay) + rust-analyzer |
| `psychopy` | Psychopy running using prebuilt-wheel  |

## Usage

### Use init-project.sh

Script will automatically clone tracked submodules. 

Then, run the script by specifying the template + the directory/ project you wish to work in. 

#### Examples:

```bash   
init-project python ~/projects/my-app
```

```bash
init-project rust ~/code/my-crate
```

#### List flakes:

```bash
init-project --list
```

#### Update:

```bash
init-project --update
```

#### Special: 

PsychoPy raises its scheduling priority for better stimulus/response timing. Check the repo [https://github.com/adam-coates/nix-flakes-psychopy](https://github.com/adam-coates/nix-flakes-psychopy#nixos-configuration-recommended-realtime-priority)


### Manually

Copy a template's `flake.nix` and `.envrc` into your project directory:

```bash
cp ~/nix-flakes/python/flake.nix ~/nix-flakes/python/.envrc ./
direnv allow
```

Or enter the shell directly:

```bash
nix develop ~/nix-flakes/python
```
