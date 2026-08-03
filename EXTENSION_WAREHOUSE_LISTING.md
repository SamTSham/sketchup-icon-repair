# SketchUp Icon Repair for Mac

## Short description

Restores embedded SketchUp model previews as Finder icons on macOS.

## Full description

For years, SketchUp model libraries on macOS have intermittently displayed generic file icons instead of the model preview image. That makes large libraries unnecessarily hard to browse, especially when filenames are not descriptive.

SketchUp Icon Repair for Mac restores the preview image already stored in a `.skp` file and applies it as that file's Finder icon. It has two parts:

- **SketchUp Icon Keeper** is installed once as a SketchUp extension. After each normal save it restores the current model's Finder icon automatically. A manual **Extensions → Repair current SketchUp Finder icon** command is also available.
- **SketchUp Icon Repair.app** repairs a selected folder and all normal subfolders, so an existing library can be restored in one operation. It skips application/library packages such as Lightroom preview caches and only opens `.skp` files.

The tools use the model's existing embedded thumbnail (`meta/model_thumbnail.png`). They do not render geometry, alter model contents, or rewrite SketchUp files. They add only Finder custom-icon metadata and preserve the model file's original access and modification times.

## Key features

- Restores a SketchUp model's own embedded preview as its macOS Finder icon
- Automatic icon repair after normal saves
- Manual repair command for the active model
- Recursive folder repair for existing model libraries
- Stops safely and writes a plain-text progress report in the selected folder
- Avoids package folders such as Lightroom preview caches
- Preserves file access and modification times
- Works entirely locally; no analytics or network connection

## Setup

1. In SketchUp, open **Extension Manager**.
2. Install **SketchUp Mac Icon Repair & Keeper** from Extension Warehouse, or select **Install Extension** and choose the downloaded RBZ.
3. Enable the extension if asked, then restart SketchUp.

For an existing library, choose **Extensions → Repair a folder of SketchUp Finder icons…**. The included application opens directly; users do not need to find it inside the hidden macOS Library folder. Select a project or model-library folder, then select **Start Repair**. Do not choose the entire Macintosh HD.

The GitHub release also provides a normal ZIP containing the visible **SketchUp Icon Repair.app** and the RBZ side by side.

## Compatibility

macOS only. Tested with SketchUp 2026; developed using long-established SketchUp APIs and expected to work with other recent desktop SketchUp versions. The included one-time repair app requires macOS `python3`.

## Privacy

SketchUp Icon Repair works locally. It does not transmit user data, use analytics, or require a network connection.

## Version

1.0.1 (SketchUp Icon Keeper 0.1.2)

## Price and licence

Freeware. Released under the Apache License 2.0.

## Author

Sam Madwar

## Suggested categories and search terms

Productivity; Utilities; File Management; macOS; Finder; Icon; Preview; Thumbnail; SketchUp Library; Asset Management

## Public links

- Website: `https://github.com/SamTSham/sketchup-icon-repair`
- Support: `https://github.com/SamTSham/sketchup-icon-repair/issues`
