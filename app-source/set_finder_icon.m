#import <Cocoa/Cocoa.h>

int main(int argc, const char *argv[]) {
  if (argc != 3) return 64;
  @autoreleasepool {
    NSString *imagePath = [NSString stringWithUTF8String:argv[1]];
    NSString *targetPath = [NSString stringWithUTF8String:argv[2]];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
    if (image == nil) return 65;
    BOOL succeeded = [[NSWorkspace sharedWorkspace] setIcon:image forFile:targetPath options:0];
    return succeeded ? 0 : 1;
  }
}
