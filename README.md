# semicolab-ip-tile-precheck

GitHub Actions workflow for SemiCoLab IP tile repositories. Runs connectivity check and synthesis on every push to `main`, generates documentation, and commits results back to the repo.

Part of the [SemiCoLab](https://github.com/serolugo) ecosystem.

---

## How It Works

On every push to `main`:

1. Installs OSS CAD Suite (iverilog + yosys)
2. Clones [veriflow-precheck](https://github.com/serolugo/veriflow-precheck)
3. Runs connectivity check + synthesis on the tile RTL
4. Generates run artifacts, updates README and records
5. Commits results back to the repo with `[skip ci]`

---

## Usage

### 1. Create your tile repo

Name it following the convention:

```
ip_<design_name>
```

Example: `ip_adder_tile`, `ip_shift_register`

### 2. Set up the repo structure

```
ip_<design_name>/
├── tile_config.yaml
├── src/
│   └── top_module.v
└── .github/
    └── workflows/
        └── precheck.yml
```

### 3. Copy the workflow

Create `.github/workflows/precheck.yml` in your tile repo with the following content:

```yaml
name: SemiCoLab Precheck

on:
  push:
    branches:
      - main

permissions:
  contents: write

jobs:
  precheck:
    uses: serolugo/semicolab-ip-tile-precheck/.github/workflows/precheck.yml@main
```

### 4. Fill in tile_config.yaml

```yaml
tile_name: ""
tile_author: ""
top_module: ""      # must match your RTL filename

shuttle: ""         # optional

description: |

ports: |

usage_guide: |

tb_description: |
```

### 5. Push

Every push to `main` triggers the precheck automatically.

---

## What Gets Generated

```
ip_<design_name>/
├── README.md              ← updated with badge + results
├── docs/
│   ├── records.csv        ← full run history
│   ├── results.json       ← structured output for integration
│   ├── netlist.svg        ← synthesized netlist diagram
│   └── datasheet.pdf      ← tile datasheet
└── runs/
    └── run-NNN/
        ├── manifest.yaml
        ├── summary.md
        └── src/           ← RTL snapshot
```

---

## Exit Codes

| Code | Meaning |
|------|---------|
| `0` | Precheck PASS |
| `1` | Precheck FAIL |

A failed precheck marks the workflow as failed in GitHub — useful as a merge gate.

---

## SemiCoLab Ecosystem

```
TileWizard              → wraps generic IP RTL into SemiCoLab tile
VeriFlow (local)        → full functional verification with waveforms
veriflow-precheck       → CI verification engine
semicolab-ip-tile-precheck → this repo, the workflow
Docker Suite            → TileWizard + VeriFlow in a container (coming soon)
```

---

## Related Repos

- [veriflow](https://github.com/serolugo/veriflow) — local verification tool
- [veriflow-precheck](https://github.com/serolugo/veriflow-precheck) — CI verification engine
