#!/usr/bin/env python3
"""Restore Finder icons from embedded SketchUp model thumbnails.

Reads only the .skp files under the chosen folder. It does not follow aliases or
symbolic links, and it never opens SketchUp or GraphicConverter.
"""

from __future__ import annotations

import argparse
import os
import subprocess
import sys
import tempfile
import zipfile
from pathlib import Path

PNG_SIGNATURE = b"\x89PNG\r\n\x1a\n"
THUMBNAIL_NAME = "meta/model_thumbnail.png"


def embedded_thumbnail(model: Path) -> bytes | None:
    try:
        with zipfile.ZipFile(model) as archive:
            data = archive.read(THUMBNAIL_NAME)
    except (KeyError, OSError, zipfile.BadZipFile):
        return None
    return data if data.startswith(PNG_SIGNATURE) else None


def models_below(root: Path):
    root_device = root.stat().st_dev

    def descendable(candidate: Path) -> bool:
        try:
            return not candidate.is_symlink() and candidate.stat().st_dev == root_device
        except OSError:
            return False

    for directory, subdirectories, filenames in os.walk(root, followlinks=False):
        current = Path(directory)
        print(f"scanning: {current}", flush=True)
        subdirectories[:] = [name for name in subdirectories if descendable(current / name)]
        for filename in filenames:
            candidate = Path(directory) / filename
            if filename.lower().endswith(".skp") and not candidate.is_symlink():
                yield candidate


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Restore Finder icons from the thumbnails stored inside SketchUp models."
    )
    parser.add_argument("folder", type=Path, help="The library folder to process, including its subfolders")
    parser.add_argument("--apply", action="store_true", help="Actually set Finder icons (default: report only)")
    parser.add_argument("--limit", type=int, help="Process no more than this many models")
    args = parser.parse_args()

    root = args.folder.expanduser().resolve()
    if not root.is_dir():
        parser.error(f"Not a folder: {root}")

    helper = Path(__file__).with_name("set_finder_icon")
    if args.apply and not helper.is_file():
        parser.error("The Finder-icon helper is missing from this folder.")

    found = recovered = applied = 0
    with tempfile.TemporaryDirectory(prefix="skp-icon-repair-") as temporary:
        temporary_folder = Path(temporary)
        for model in models_below(root):
            if args.limit and found >= args.limit:
                break
            found += 1
            thumbnail = embedded_thumbnail(model)
            if thumbnail is None:
                continue
            recovered += 1
            print(f"preview recovered: {model}", flush=True)
            if args.apply:
                preview_path = temporary_folder / f"{recovered}.png"
                preview_path.write_bytes(thumbnail)
                original_times = model.stat()
                result = subprocess.run([str(helper), str(preview_path), str(model)])
                if result.returncode == 0:
                    os.utime(model, ns=(original_times.st_atime_ns, original_times.st_mtime_ns))
                    applied += 1
                else:
                    print(f"could not set icon: {model}", file=sys.stderr, flush=True)

    print(f"Scanned {found} .skp file(s); recovered {recovered} embedded thumbnail(s).", flush=True)
    if args.apply:
        print(f"Set {applied} Finder icon(s).", flush=True)
    else:
        print("Dry run only. Re-run with --apply to set Finder icons.", flush=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
