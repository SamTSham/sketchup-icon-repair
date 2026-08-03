# Publish from Safari — one-time bridge

The release is prepared in this folder. If GitHub access is available in Safari but not to the local publishing helper, use this short browser route.

## 1. Create the public repository

In GitHub, choose **+ → New repository**.

- Owner: `SamTSham`
- Repository name: `sketchup-icon-repair`
- Description: `Restore embedded SketchUp model previews as Finder icons on macOS.`
- Visibility: **Public**
- Do **not** initialise it with a README, `.gitignore`, or licence.

## 2. Upload the prepared source

Open the new repository, then **Add file → Upload files**. Upload the contents of this folder, excluding `.git`:

`/Users/sammadwar/Documents/Codex/2026-07-28/realtime-voice-chat/github/sketchup-icon-repair`

Commit message: `Release SketchUp Icon Repair for Mac 1.0.1`.

## 3. Create the release

Choose **Releases → Draft a new release**.

- Tag: `v1.0.1`
- Title: `SketchUp Icon Repair for Mac 1.0.1`
- Description: copy `RELEASE_NOTES.md`
- Attach `release/SketchUp Icon Repair for Mac 1.0.1.zip`
- Publish release

Enable Issues in the repository settings and keep Wiki disabled, matching the two previous releases.

The Extension Warehouse listing material is in `EXTENSION_WAREHOUSE_LISTING.md`; use `assets/extension-warehouse-listing.png` as the listing image.
