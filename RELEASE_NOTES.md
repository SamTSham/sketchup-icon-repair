# Mac SKP Icon Repair & Keeper 0.1.5

This point release presents the Extension Warehouse package as one self-contained SketchUp extension, without the former standalone application. It is intended for both Apple-silicon and Intel Macs: the package contains no processor-specific executable code. Intel hardware confirmation remains pending.

- Automatically restores a model's Finder icon after an ordinary save.
- Repairs an entire existing model library recursively from one folder selection.
- Removes obsolete standalone-app and Apple-silicon-only instructions.

## 0.1.4 review changes

This review build contains no compiled, encrypted or obfuscated code. The automatic save repair and current-model command use readable Ruby and JavaScript for Automation source. Recursive folder repair is started from SketchUp and uses the included readable Python source.

- **Extensions → Repair current SketchUp Finder icon** repairs the open model.
- **Extensions → Repair a folder of SketchUp Finder icons…** selects and repairs a library in the background.
- Progress is written to `SketchUp Icon Repair - DeleteMe.txt` in the selected folder; it can be deleted afterwards.
- Models without an embedded preview are reported and left unchanged.
- Model contents and original access/modification times are preserved.

Download `Mac SKP Icon Repair and Keeper 0.1.5.rbz` for the current self-contained extension. Tested on Apple silicon with SketchUp 2026; Intel compatibility is expected but not hardware-verified. Folder repair requires Python 3; current-model and automatic after-save repair do not.

The historical GitHub 1.0.1 standalone-app distribution is retained for reference. It is not the current unified extension despite its higher version number.

---

# SketchUp Icon Repair for Mac 1.0.1

This first public release provides a practical repair for the long-running macOS Finder-preview problem affecting SketchUp model libraries.

- Install `SketchUp Icon Keeper.rbz` once to repair the Finder icon automatically after normal saves.
- Run `SketchUp Icon Repair.app` once on a chosen library folder to repair existing `.skp` files in subfolders.
- The unified Extension Warehouse RBZ includes both components. Launch the folder-repair app from **Extensions → Repair a folder of SketchUp Finder icons…** without navigating the hidden Library folder.
- Finder metadata is added without changing SketchUp model contents, and the original file times are preserved.

The zip includes the app, the SketchUp extension, and setup instructions.
