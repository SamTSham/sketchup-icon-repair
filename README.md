# SketchUp Icon Repair for Mac

![SketchUp Icon Repair](assets/extension-warehouse-listing.png)

SketchUp files on macOS can lose their useful Finder and Quick Look previews, leaving a large model library full of generic file icons. **SketchUp Icon Repair** restores each model's own embedded thumbnail as its Finder icon.

It includes two complementary tools:

- **SketchUp Icon Keeper** — a SketchUp extension that automatically restores the Finder icon after an ordinary `.skp` save. It also supplies **Extensions → Repair current SketchUp Finder icon** for an immediate repair.
- **SketchUp Icon Repair.app** — a macOS helper for an existing library: choose one folder and it recursively repairs `.skp` files in its normal subfolders.

## Download and install

### Install from Extension Warehouse

Install **SketchUp Mac Icon Repair & Keeper** from Extension Warehouse. The extension includes both the automatic Keeper and the full folder-repair application.

After installation, use SketchUp's **Extensions** menu:

- **Repair current SketchUp Finder icon** repairs the open model immediately.
- **Repair a folder of SketchUp Finder icons…** opens the included folder-repair application.

The application is launched directly from SketchUp. You do not need to locate it inside the hidden macOS Library folder.

### Download from GitHub

Download **SketchUp Icon Repair for Mac 1.0.1.zip** from the [latest release](../../releases/latest), then unzip it.

The unzipped folder visibly contains both **SketchUp Icon Repair.app** and **SketchUp Icon Keeper.rbz**. You can open the app directly or install the RBZ through Extension Manager.

### Keep newly saved models discoverable

1. In SketchUp, open **Extension Manager**.
2. Choose **Install Extension** and select `SketchUp Icon Keeper.rbz`.
3. Enable **SketchUp Icon Keeper** if asked, then restart SketchUp.

The extension is independently distributed and therefore shown as unsigned by SketchUp. It operates after normal saves; SketchUp backup (`~.skp`) files preserve the custom icon when they are created.

### Repair an existing model library

If installed from Extension Warehouse, choose **Extensions → Repair a folder of SketchUp Finder icons…** in SketchUp. If downloaded from GitHub, open **SketchUp Icon Repair.app** from the unzipped release folder.

1. Open **SketchUp Icon Repair.app**.
2. Choose a user, project, or model-library folder — not the whole Macintosh HD.
3. Select **Start Repair**.

The app scans normal subfolders, avoids macOS application/library packages such as Lightroom preview caches, and only opens `.skp` files. It may request access to protected folders. It writes a running report named `SketchUp Icon Repair - DeleteMe.txt` into the chosen folder; delete it when you no longer need it. Use **Stop** to finish a scan safely.

## What it changes

The tools extract the thumbnail already stored at `meta/model_thumbnail.png` inside a SketchUp model. They do not render the model, alter geometry, or rewrite the `.skp` file contents. They add macOS Finder custom-icon metadata and restore the file's modification and access times.

## Compatibility

- macOS
- SketchUp 2023 and later tested; version 2026 tested during development
- Python 3 is required for the one-time folder repair helper. macOS may prompt before opening it; Control-click the app and choose **Open** if necessary.

## Support

Please report problems or improvement ideas in [Issues](../../issues).

## License and trademarks

Released under the [Apache License 2.0](LICENSE). SketchUp is a trademark of Trimble Inc. This independent project is not affiliated with or endorsed by Trimble.
