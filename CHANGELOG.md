# Changelog

## 0.1.5 — 2026-09-06

- Clarified that existing model libraries can be repaired recursively in one operation.
- Removed standalone-app setup instructions from the Extension Warehouse presentation.
- Removed the obsolete Apple-silicon-only restriction. The Warehouse package contains no processor-specific executable code and is intended for both Apple-silicon and Intel Macs.

## 0.1.4 — 2026-09-02

- Replaced the compiled Finder-icon helper with readable JavaScript for Automation source.
- Replaced the bundled compiled folder-repair app in the Extension Warehouse build with a SketchUp folder chooser and readable Python worker.
- Kept recursive repair in the background with a removable progress report in the selected folder.
- Reports models that contain no usable embedded preview.

## 1.0.1 — 2026-08-03

- First public release of the macOS folder-repair helper.
- SketchUp Icon Keeper 0.1.2 repairs Finder icons after a save and includes a manual repair command.
- Preserves original model access and modification times.
