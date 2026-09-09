# Mac SKP Icon Repair & Keeper

![Mac SKP Icon Repair & Keeper](assets/extension-warehouse-listing-mac-skp.png)

SketchUp files on macOS can lose their useful Finder and Quick Look previews, leaving a large model library full of generic file icons. **SketchUp Icon Repair** restores each model's own embedded thumbnail as its Finder icon.

It includes two complementary tools:

- **SketchUp Icon Keeper** — a SketchUp extension that automatically restores the Finder icon after an ordinary `.skp` save. It also supplies **Extensions → Repair current SketchUp Finder icon** for an immediate repair.
- **Folder repair** — choose one folder from SketchUp and recursively repair `.skp` files in its normal subfolders.

## Download and install

### Current version: 0.1.5

Download [Mac SKP Icon Repair & Keeper 0.1.5](release/Mac%20SKP%20Icon%20Repair%20and%20Keeper%200.1.5.rbz?raw=true), or get [Mac SKP Icon Repair from SketchUcation](https://sketchucation.com/pluginstore?pln=MacSKPIconRepair). SketchUcation requires a login. The RBZ contains both automatic after-save repair and recursive folder repair; no separate app is needed.

In SketchUp, open **Extension Manager → Install Extension**, select the downloaded RBZ, and restart SketchUp if requested. See the [checksum](release/SHA256SUMS-0.1.5.txt) and [release notes](RELEASE_NOTES.md).

After installation, use SketchUp's **Extensions** menu:

- **Repair current SketchUp Finder icon** repairs the open model immediately.
- **Repair a folder of SketchUp Finder icons…** asks for a model-library folder and starts the repair in the background.

Progress is written to `SketchUp Icon Repair - DeleteMe.txt` in the selected folder. That report can be safely deleted after the repair.

### Keep newly saved models discoverable

1. In SketchUp, open **Extension Manager**.
2. Choose **Install Extension** and select `Mac SKP Icon Repair and Keeper 0.1.5.rbz`.
3. Enable **Mac SKP Icon Repair & Keeper** if asked, then restart SketchUp.

The extension is independently distributed and therefore shown as unsigned by SketchUp. It operates after normal saves; SketchUp backup (`~.skp`) files preserve the custom icon when they are created.

### Repair an existing model library

Choose **Extensions → Repair a folder of SketchUp Finder icons…** in SketchUp.

1. Choose **Extensions → Repair a folder of SketchUp Finder icons…**.
2. Choose a user, project, or model-library folder — not the whole Macintosh HD.
3. The scan starts in the background; follow its DeleteMe report if desired.

The repair scans normal subfolders, stays on the selected disk, does not follow aliases or symbolic links, and only reads `.skp` files. It may request access to protected folders. It writes a running report named `SketchUp Icon Repair - DeleteMe.txt` into the chosen folder; delete it when you no longer need it.

## What it changes

The tools extract the thumbnail already stored at `meta/model_thumbnail.png` inside a SketchUp model. They do not render the model, alter geometry, or rewrite the `.skp` file contents. They add macOS Finder custom-icon metadata and restore the file's modification and access times.

If a processed model has no embedded preview, no icon can be generated and the report identifies that file.

## Compatibility

- macOS on Apple-silicon or Intel Macs; the package contains no processor-specific executable code
- Confirmed testing: SketchUp 2026 on Apple silicon. Other version compatibility should not be confused with a completed hardware/runtime test.
- Intel compatibility is expected from the processor-neutral implementation but still requires confirmation on Intel hardware
- Python 3 at `/usr/bin/python3` is required for recursive folder repair. Repairing the current model does not require Python.

This repairs Finder custom icons; it does not replace or fix the Quick Look service, render missing previews, or support Windows, iOS/iPadOS or LayOut files. Automatic repair runs after normal saves, not as a continuous monitor of every file.

The historical `v1.0.1` release is the older standalone-app distribution. Its numbering predates the unified extension series; use **0.1.5** for the current self-contained extension. Warehouse submission documents describe review history, not proof of current approval.

## Support

Please report problems or improvement ideas in [Issues](../../issues).

If this free tool helps your work, you can [buy me a coffee on Ko-fi](https://ko-fi.com/samtsham). Contributions are entirely optional and help keep all three plugins free and maintained.

## License and trademarks

Released under the [Apache License 2.0](LICENSE). SketchUp is a trademark of Trimble Inc. This independent project is not affiliated with or endorsed by Trimble.
