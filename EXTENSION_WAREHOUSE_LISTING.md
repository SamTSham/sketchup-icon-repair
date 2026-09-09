# Mac SKP Icon Repair & Keeper

## Short description

Restores embedded SketchUp model previews as Finder icons on macOS, automatically after saves or across an entire model library.

## Full description

For years, SketchUp model libraries on macOS have intermittently displayed generic file icons instead of the model preview image. That makes large libraries unnecessarily hard to browse, especially when filenames are not descriptive.

Mac SKP Icon Repair & Keeper restores the preview image already stored in a `.skp` file and applies it as that file's Finder icon. It has two parts:

- **SketchUp Icon Keeper** is installed once as a SketchUp extension. After each normal save it restores the current model's Finder icon automatically. A manual **Extensions → Repair current SketchUp Finder icon** command is also available.
- **Folder repair** selects a folder from SketchUp and repairs its `.skp` files and normal subfolders in the background. It stays on the selected disk and does not follow aliases or symbolic links.

The tools use the model's existing embedded thumbnail (`meta/model_thumbnail.png`). They do not render geometry, alter model contents, or rewrite SketchUp files. They add only Finder custom-icon metadata and preserve the model file's original access and modification times.

## Key features

- Restores a SketchUp model's own embedded preview as its macOS Finder icon
- Automatic icon repair after normal saves
- Manual repair command for the active model
- Recursive folder repair for existing model libraries
- Runs in the background and writes a plain-text progress report in the selected folder
- Does not follow aliases or symbolic links and does not cross onto another mounted volume
- Preserves file access and modification times
- Works entirely locally; no analytics or network connection

## Setup

1. In SketchUp, open **Extension Manager**.
2. Install **Mac SKP Icon Repair & Keeper** from Extension Warehouse, or select **Install Extension** and choose the downloaded RBZ.
3. Enable the extension if asked, then restart SketchUp.

For an existing library, choose **Extensions → Repair a folder of SketchUp Finder icons…**, then select a project or model-library folder. Do not choose the entire Macintosh HD. The repair runs in the background and writes progress to `SketchUp Icon Repair - DeleteMe.txt` in the selected folder; that report can be safely removed afterwards.

If a model contains no valid embedded preview, no icon can be generated; the file is reported and left unchanged.

## Compatibility

macOS only, on Apple-silicon or Intel Macs. Tested on Apple silicon with SketchUp 2026; the package contains no processor-specific executable code. It uses long-established SketchUp and macOS interfaces and is expected to work with other recent desktop SketchUp versions. Recursive folder repair requires Python 3 at `/usr/bin/python3`; current-model and automatic after-save repair do not.

## Privacy

SketchUp Icon Repair works locally. It does not transmit user data, use analytics, or require a network connection.

## Version

0.1.5

## Price and licence

Freeware. Released under the Apache License 2.0.

## Author

Sam Madwar

## Suggested categories and search terms

Productivity; Utilities; File Management; macOS; Finder; Icon; Preview; Thumbnail; SketchUp Library; Asset Management

## Public links

- Website: `https://github.com/SamTSham/sketchup-icon-repair`
- Support: `https://github.com/SamTSham/sketchup-icon-repair/issues`
