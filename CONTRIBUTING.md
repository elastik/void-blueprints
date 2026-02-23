# Contributing to Void Blueprints

> Guidelines for contributing to The Void Grows open-source project.
> Void Blueprints is a free, open-source mushroom cultivation dome that anyone can print, build, and modify.
> For build instructions, see BUILD-GUIDE.md. For electronics, see FIRMWARE-DOCS.md. For parts, see PARTS-GUIDE.md.

---

## 1. Welcome

Thank you for your interest in Void Blueprints.

The Void is a UV-lit mushroom cultivation dome -- an open-source growing chamber that doubles as a living art piece. It is designed to be printed on any consumer 3D printer, assembled with readily available components, and modified by the community.

Whether you are fixing a typo, sharing print settings for a new printer, designing a PCB, or writing Void Core firmware, your contribution makes the project better for every builder.

**Key project documents:**

| Document | What It Covers |
|---|---|
| [BUILD-GUIDE.md](BUILD-GUIDE.md) | STL files, print settings, step-by-step assembly (22 steps) |
| [FIRMWARE-DOCS.md](FIRMWARE-DOCS.md) | Electronics behavior for all three variants |
| [PARTS-GUIDE.md](PARTS-GUIDE.md) | Complete component sourcing with suppliers and costs |
| [PRODUCT-SPEC.md](PRODUCT-SPEC.md) | Full engineering specification |

---

## 2. License

Void Blueprints uses three open-source licenses, one for each type of content.

### Hardware: CERN Open Hardware Licence v2 -- Permissive (CERN-OHL-P-2.0)

All hardware designs -- STL files, STEP files, PCB layouts, mechanical drawings, and schematics -- are licensed under [CERN-OHL-P-2.0](https://ohwr.org/cern_ohl_p_v2.txt).

**What this means:**
- You can use, modify, and distribute the hardware designs freely
- You can use them for commercial purposes
- You must give attribution (credit The Void Grows as the original designer)
- You do NOT need to share your modifications under the same license (this is permissive, not copyleft)

**Why CERN-OHL-P:** This is the standard license for open-source hardware projects. The permissive variant encourages maximum adoption without copyleft friction. We want people to build, sell, and remix Void domes without legal barriers -- attribution is the only requirement.

### Documentation: Creative Commons Attribution 4.0 International (CC BY 4.0)

All documentation -- build guides, firmware docs, parts guides, specifications, and this contributing guide -- is licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).

**What this means:**
- You can copy, redistribute, remix, and build upon the documentation
- You can use it for commercial purposes
- You must give attribution

### Firmware: MIT License

All firmware and software -- ATtiny85 code, Void Core Python daemon, configuration files, and scripts -- is licensed under the [MIT License](https://opensource.org/licenses/MIT).

**What this means:**
- You can use, copy, modify, merge, publish, distribute, sublicense, and sell the software
- You must include the copyright notice and license text
- No warranty is provided

### License Summary

| Content Type | License | Commercial Use | Attribution Required | Share-Alike Required |
|---|---|---|---|---|
| Hardware designs (STL, STEP, PCB, schematics) | CERN-OHL-P-2.0 | Yes | Yes | No |
| Documentation (guides, specs, this file) | CC BY 4.0 | Yes | Yes | No |
| Firmware and software (C, Python, scripts) | MIT | Yes | Yes | No |

All three licenses are permissive and attribution-required. This keeps the project maximally open while ensuring original creators are credited.

---

## 3. How to Contribute

### 3.1 Report Issues

Found a problem, unclear instruction, or something that could be better? Open a GitHub Issue.

**When reporting an issue, include:**
- **Variant:** Which variant are you building? (The Void / Void Core / Dark Dome)
- **Section:** Which document and section is affected?
- **Printer model:** (if it is a print quality issue) Your printer make and model
- **Description:** What is wrong or unclear?
- **Photos:** Attach photos if relevant (failed prints, wiring issues, assembly problems)

Good issue titles are specific:
- "BUILD-GUIDE Step 8: Reed switch placement unclear for base housing v2"
- "PARTS-GUIDE: BME280 module link returns BMP280 on AliExpress"
- "Dome warping at 0.2mm layer height on Ender 3 V2 with Overture PETG"

### 3.2 Submit Improvements

Want to fix or improve something? Submit a Pull Request.

**Process:**
1. Fork the Void Blueprints repository
2. Create a branch for your changes (`git checkout -b fix/reed-switch-placement`)
3. Make your changes
4. Test your changes (print the part, verify the instructions, run the firmware)
5. Submit a Pull Request with a clear description of what you changed and why

**Pull Request guidelines:**
- **For design changes** (STL/STEP modifications): include your rationale, photos of the printed result, and measurements showing the change works. Design changes require testing -- do not submit untested modifications.
- **For documentation changes:** follow the existing formatting style (Markdown tables, step numbering, What/How/Check format for assembly steps). Check that cross-references to other Phase 4 documents are correct.
- **For firmware contributions:** include pseudocode or commented code, testing results, and the hardware configuration you tested on.
- **Keep PRs focused:** one change per PR. A documentation fix and a design change should be separate PRs.

### 3.3 Share Your Build

Built a Void? Share it with the community.

- **Post photos and videos** with #VoidGrows and #VoidBlueprints on social media
- **Share your print settings** -- different printers and filaments produce different results. Document what worked for your specific setup.
- **Document species results** -- which mushroom species grew well in your dome? How long from inoculation to harvest? What conditions did you observe? Grow logs from real builds are invaluable for the community.
- **Post timelapse videos** -- if you have a Void Core or external camera, capture the growth process. The community loves watching mushrooms grow under UV.

---

## 4. Contribution Areas

There is something to contribute at every skill level.

| Area | Description | Skill Level | Status |
|---|---|---|---|
| **Documentation improvements** | Fix typos, clarify steps, add photos, improve diagrams | Beginner | Always welcome |
| **Print profiles** | Test on different printers (Bambu, Voron, Prusa XL, etc.), share settings and results | Beginner | Needed for printer diversity |
| **Grow logs** | Document mushroom species results with photos, timelines, and conditions | Beginner | Needed for species coverage |
| **Troubleshooting entries** | Encountered a problem and solved it? Document the fix for others | Beginner | Always welcome |
| **PCB design** | Create Gerber files for the Void PCB (schematic exists in PRODUCT-SPEC.md and FIRMWARE-DOCS.md) | Intermediate | Not yet started |
| **ATtiny85 firmware** | Implement the firmware from pseudocode in FIRMWARE-DOCS.md Section 3 | Intermediate | Not yet started |
| **Void Core Python daemon** | Implement the software architecture described in FIRMWARE-DOCS.md Section 4 | Intermediate-Advanced | Not yet started |
| **CAD modifications** | Modify STEP files for improvements, remixes, or new features | Advanced | Community-driven |
| **Void Core web dashboard** | Build the web interface for the Pi Zero W 2 API (FIRMWARE-DOCS.md Section 4.4) | Advanced | Not yet started |
| **Alternative controller ports** | Port Void Core software to ESP32-S3 or other platforms | Advanced | Exploratory |

### High-Impact First Contributions

If you want to make a meaningful impact quickly:

1. **Create the PCB Gerber files** -- the schematic and component list are fully specified. The community needs a PCB layout that can be ordered from JLCPCB.
2. **Implement ATtiny85 firmware** -- the pseudocode is complete in FIRMWARE-DOCS.md. This just needs to be translated to C and tested.
3. **Test and document print settings** for printers other than Ender 3 and Prusa i3 -- especially Bambu Lab, Voron, and Anycubic.
4. **Write grow logs** with photos for Lion's Mane, Oyster, and Reishi species in printed Void domes.

---

## 5. Community Guidelines

### Be Respectful and Constructive

- Treat all community members with respect
- Provide constructive feedback -- explain what could be improved and how
- Assume good intent
- Help newcomers -- everyone starts somewhere

### Gourmet and Medicinal Cultivation Only

**Void Blueprints is exclusively for gourmet and medicinal mushroom cultivation. No psilocybin content.**

This is a legal requirement, not a preference. Do not:
- Submit content related to psilocybin-containing species
- Post grow logs for controlled substances
- Discuss cultivation of illegal species in any project channel
- Submit modifications designed for controlled substance cultivation

Violations will result in content removal and may result in a ban. This policy exists to keep the project legal, safe, and focused on its mission: making gourmet mushroom growing accessible to everyone.

**Species in scope:** Lion's Mane, Blue Oyster, Pink Oyster, King Oyster, Golden Oyster, Shiitake, Reishi (antler and conk forms), Panellus stipticus (bioluminescent), Maitake, Chestnut, Pioppino, Enoki, and other legal gourmet/medicinal species.

### Share Knowledge Freely

The open-source model works when people share:
- What worked and what did not
- Print settings, modifications, and fixes
- Species results, grow conditions, and timelines
- Design improvements and new ideas

### Credit Prior Work

If your contribution builds on someone else's work (a community member's modification, an external design, a published technique), credit them. Open source runs on attribution.

### Safety First

- **Never suggest disabling the UV-C safety interlock.** The hardware interlock (reed switch in series with UV-C power) exists to prevent UV-C exposure to humans. It is not optional, not tunable, and not to be bypassed.
- **Always include safety warnings** when documenting UV-C related modifications or procedures.
- **Test safety-critical features** before sharing. If you modify the electronics, verify the interlock works before telling others to build your modification.

---

## 6. Contact

### Technical Questions

- **GitHub Issues** -- for bugs, unclear documentation, and technical questions about the build
- **GitHub Discussions** -- for general questions, ideas, and show-and-tell

### Community

- **Discord** -- [link TBD] -- real-time chat, build help, species discussion, and timelapse sharing
- **Social media** -- follow #VoidGrows and #VoidBlueprints for community builds

### Project Maintainers

- **Email** -- [TBD]
- **GitHub** -- via Issues and Pull Requests

For general questions about The Void Grows products (Void Packs, Void Feed subscription, Void Core availability), visit [thevoidgrows.com](https://thevoidgrows.com).

---

*Contributing Guidelines version: 1.0*
*Part of the Void Blueprints open-source package.*
