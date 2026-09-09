/*
 * Apply a PNG as a custom Finder icon.
 *
 * This script is intentionally distributed as readable source. macOS runs it
 * through its built-in JavaScript for Automation interpreter.
 */
ObjC.import('AppKit');

function run(argv) {
  if (argv.length !== 2) {
    throw new Error('Expected a preview image and a target file.');
  }

  const imagePath = $(argv[0]).stringByStandardizingPath;
  const targetPath = $(argv[1]).stringByStandardizingPath;
  const image = $.NSImage.alloc.initWithContentsOfFile(imagePath);

  if (!image) {
    throw new Error('The embedded preview is not a valid image.');
  }

  const succeeded = $.NSWorkspace.sharedWorkspace
    .setIconForFileOptions(image, targetPath, 0);

  if (!succeeded) {
    throw new Error('macOS could not set the Finder icon.');
  }
}
