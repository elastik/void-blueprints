# Claude CLI — Void Blueprints (PUBLIC)

## Repo Map

| Repository | Visibility | Contents |
|-----------|------------|----------|
| `elastik/void-blueprints` | **Public** | Open-source hardware, firmware, build docs (this repo) |
| `elastik/thevoidgrows` | **Private** | Business strategy, marketing, operations |
| `elastik/thevoidgrows-web` | **Private** | Marketing website (Next.js) |
| `elastik/thevoidgrows-app` | **Public** | Companion app (React + Capacitor) |

## Critical Rules

- **NEVER commit business strategy, pricing, marketing, or partner documents here.** This repo is PUBLIC.
- This repo contains ONLY: CAD source, STL exports, firmware, and build documentation.
- All content here is open-source licensed (CERN-OHL-P-2.0, MIT, CC BY 4.0).
- Business docs belong in `elastik/thevoidgrows` (private).

## Structure

```
cad/              — OpenSCAD source files
cad/export/stl/   — Exported STL files for 3D printing
firmware/         — ESP32 PlatformIO project
*.md              — Build documentation (BOM, assembly, print settings, etc.)
```

## Release Process

- Tag format: `v{major}.{minor}.{patch}` (e.g., `v0.1.0`)
- GitHub Actions auto-uploads STL files from `cad/export/stl/` as release assets on new tags
- Release asset URL pattern: `https://github.com/elastik/void-blueprints/releases/download/{tag}/{filename}.stl`
- The website (`thevoidgrows-web`) links to these release assets for STL downloads

## Licenses

- Hardware (CAD, STLs): CERN-OHL-P-2.0 → `LICENSE-HARDWARE`
- Firmware: MIT → `LICENSE-FIRMWARE`
- Documentation: CC BY 4.0 → `LICENSE-DOCS`
