# Void Blueprints

Open-source mushroom cultivation dome — CAD designs, firmware, and build documentation.

The Void is a UV-lit mushroom cultivation chamber that doubles as a living art piece. Print it on any consumer 3D printer, assemble it with readily available components, and grow gourmet mushrooms at home.

## What's Inside

| Directory | Contents | License |
|-----------|----------|---------|
| `cad/` | OpenSCAD source files and exported STLs | [CERN-OHL-P-2.0](LICENSE-HARDWARE) |
| `firmware/` | ESP32 PlatformIO project (Void Core) | [MIT](LICENSE-FIRMWARE) |
| `*.md` | Build guides, BOM, assembly instructions | [CC BY 4.0](LICENSE-DOCS) |

## Quick Start

1. **Download STLs** from the [latest release](https://github.com/elastik/void-blueprints/releases/latest)
2. **Print** using settings in [PRINT-SETTINGS.md](PRINT-SETTINGS.md)
3. **Source parts** from [BOM.md](BOM.md) (~$35-85 depending on variant)
4. **Assemble** following [ASSEMBLY-GUIDE.md](ASSEMBLY-GUIDE.md)
5. **Flash firmware** per [FIRMWARE-DOCS.md](FIRMWARE-DOCS.md) (Void Core variant only)

## Variants

| Variant | Description | Electronics | Price Range |
|---------|-------------|-------------|-------------|
| **The Void** | Base dome, passive humidity | None | ~$35 |
| **Void Core** | Smart dome with sensors, fans, UV-C | ESP32 + sensors | ~$85 |
| **Dark Dome** | Simplified Void Core, no UV-C | ESP32 + sensors | ~$65 |

## Documentation

- [BUILD-GUIDE.md](BUILD-GUIDE.md) — Complete build walkthrough
- [PARTS-GUIDE.md](PARTS-GUIDE.md) — Component sourcing with suppliers
- [BOM.md](BOM.md) — Bill of materials with prices
- [ASSEMBLY-GUIDE.md](ASSEMBLY-GUIDE.md) — Step-by-step assembly
- [PRINT-SETTINGS.md](PRINT-SETTINGS.md) — 3D printing parameters
- [FIRMWARE-DOCS.md](FIRMWARE-DOCS.md) — Electronics and firmware
- [PRODUCT-SPEC.md](PRODUCT-SPEC.md) — Full engineering specification
- [SPECIES-REQUIREMENTS.md](SPECIES-REQUIREMENTS.md) — Mushroom growing conditions
- [CONTRIBUTING.md](CONTRIBUTING.md) — How to contribute

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines. All skill levels welcome — from fixing typos to designing PCBs.

## Community

- Website: [thevoidgrows.com](https://thevoidgrows.com)
- Companion App: [github.com/elastik/thevoidgrows-app](https://github.com/elastik/thevoidgrows-app)
- Social: #VoidGrows #VoidBlueprints

## License

- **Hardware** (CAD, STLs): [CERN-OHL-P-2.0](LICENSE-HARDWARE)
- **Firmware**: [MIT](LICENSE-FIRMWARE)
- **Documentation**: [CC BY 4.0](LICENSE-DOCS)
