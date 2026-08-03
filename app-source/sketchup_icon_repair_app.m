#import <Cocoa/Cocoa.h>

@interface RepairController : NSObject <NSApplicationDelegate>
@property (strong) NSWindow *window;
@property (strong) NSTextField *folderLabel;
@property (strong) NSTextField *statusLabel;
@property (strong) NSTextView *logView;
@property (strong) NSButton *chooseButton;
@property (strong) NSButton *startButton;
@property (strong) NSButton *stopButton;
@property (strong) NSURL *folderURL;
@property (strong) NSTask *task;
@property (strong) NSFileHandle *logFile;
@property NSInteger recovered;
@end

@implementation RepairController

- (void)applicationDidFinishLaunching:(NSNotification *)note {
  self.window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 760, 520)
                                             styleMask:(NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable)
                                               backing:NSBackingStoreBuffered
                                                 defer:NO];
  self.window.title = @"SketchUp Icon Repair";
  NSView *content = self.window.contentView;

  self.folderLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(24, 468, 712, 22)];
  self.folderLabel.editable = NO;
  self.folderLabel.bezeled = NO;
  self.folderLabel.drawsBackground = NO;
  self.folderLabel.stringValue = @"Choose a library folder or volume to begin.";
  [content addSubview:self.folderLabel];

  self.chooseButton = [[NSButton alloc] initWithFrame:NSMakeRect(24, 428, 160, 30)];
  self.chooseButton.title = @"Choose Folder…";
  self.chooseButton.target = self;
  self.chooseButton.action = @selector(chooseFolder:);
  [content addSubview:self.chooseButton];

  self.startButton = [[NSButton alloc] initWithFrame:NSMakeRect(194, 428, 160, 30)];
  self.startButton.title = @"Start Repair";
  self.startButton.enabled = NO;
  self.startButton.target = self;
  self.startButton.action = @selector(startRepair:);
  [content addSubview:self.startButton];

  self.stopButton = [[NSButton alloc] initWithFrame:NSMakeRect(364, 428, 120, 30)];
  self.stopButton.title = @"Stop";
  self.stopButton.enabled = NO;
  self.stopButton.target = self;
  self.stopButton.action = @selector(stopRepair:);
  [content addSubview:self.stopButton];

  self.statusLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(24, 394, 712, 20)];
  self.statusLabel.editable = NO;
  self.statusLabel.bezeled = NO;
  self.statusLabel.drawsBackground = NO;
  self.statusLabel.stringValue = @"Idle";
  [content addSubview:self.statusLabel];

  NSScrollView *scroll = [[NSScrollView alloc] initWithFrame:NSMakeRect(24, 24, 712, 352)];
  scroll.hasVerticalScroller = YES;
  self.logView = [[NSTextView alloc] initWithFrame:scroll.bounds];
  self.logView.editable = NO;
  self.logView.font = [NSFont monospacedSystemFontOfSize:11 weight:NSFontWeightRegular];
  scroll.documentView = self.logView;
  [content addSubview:scroll];

  [self.window center];
  [self.window makeKeyAndOrderFront:nil];
  [NSApp activateIgnoringOtherApps:YES];
}

- (void)chooseFolder:(id)sender {
  NSOpenPanel *panel = [NSOpenPanel openPanel];
  panel.canChooseFiles = NO;
  panel.canChooseDirectories = YES;
  panel.allowsMultipleSelection = NO;
  panel.directoryURL = [NSURL fileURLWithPath:NSHomeDirectory()];
  panel.prompt = @"Use This Folder";
  panel.message = @"Choose your user or library folder — not Macintosh HD. Every .skp file below it will be checked. Other mounted volumes are not followed.";
  if ([panel runModal] == NSModalResponseOK) {
    NSString *path = panel.URL.path;
    NSSet<NSString *> *unsafeRoots = [NSSet setWithArray:@[@"/", @"/System", @"/System/Volumes/Data", @"/Users", @"/Volumes"]];
    if ([unsafeRoots containsObject:path]) {
      NSAlert *alert = [NSAlert new];
      alert.messageText = @"Please choose your user folder or model library, not Macintosh HD";
      alert.informativeText = @"Scanning the whole startup disk causes macOS permission requests and can spend hours in unrelated system folders. Choose the folder named for you (for example, sammadwar) or the project/library folder containing the models.";
      [alert runModal];
      return;
    }
    self.folderURL = panel.URL;
    self.folderLabel.stringValue = self.folderURL.path;
    self.startButton.enabled = YES;
    self.statusLabel.stringValue = @"Ready. The repair writes a live DeleteMe log in this folder.";
  }
}

- (void)append:(NSString *)message {
  if (message.length == 0) return;
  [[self.logView textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:message]];
  [self.logView scrollRangeToVisible:NSMakeRange(self.logView.string.length, 0)];
  if (self.logFile) {
    [self.logFile writeData:[message dataUsingEncoding:NSUTF8StringEncoding]];
  }
}

- (void)startRepair:(id)sender {
  NSString *python = @"/usr/bin/python3";
  NSString *script = [[NSBundle mainBundle] pathForResource:@"repair_sketchup_icons" ofType:@"py"];
  if (![[NSFileManager defaultManager] isExecutableFileAtPath:python] || !script) {
    NSAlert *alert = [NSAlert new];
    alert.messageText = @"The repair tool is incomplete";
    alert.informativeText = @"Python 3 or the bundled repair script could not be found.";
    [alert runModal];
    return;
  }

  NSString *logPath = [self.folderURL.path stringByAppendingPathComponent:@"SketchUp Icon Repair - DeleteMe.txt"];
  [[NSFileManager defaultManager] createFileAtPath:logPath contents:nil attributes:nil];
  self.logFile = [NSFileHandle fileHandleForWritingAtPath:logPath];
  self.recovered = 0;
  self.logView.string = @"";
  [self append:[NSString stringWithFormat:@"Started: %@\nRoot: %@\n\n", [NSDate date], self.folderURL.path]];

  self.chooseButton.enabled = NO;
  self.startButton.enabled = NO;
  self.stopButton.enabled = YES;
  self.statusLabel.stringValue = @"Scanning for .skp files…";

  NSPipe *pipe = [NSPipe pipe];
  self.task = [NSTask new];
  self.task.launchPath = python;
  self.task.arguments = @[@"-u", script, self.folderURL.path, @"--apply"];
  self.task.standardOutput = pipe;
  self.task.standardError = pipe;

  __weak RepairController *weakSelf = self;
  pipe.fileHandleForReading.readabilityHandler = ^(NSFileHandle *handle) {
    NSData *data = handle.availableData;
    if (data.length == 0) return;
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    dispatch_async(dispatch_get_main_queue(), ^{
      RepairController *strongSelf = weakSelf;
      if (!strongSelf || !text) return;
      [strongSelf append:text];
      NSUInteger count = [[text componentsSeparatedByString:@"preview recovered:"] count] - 1;
      strongSelf.recovered += count;
      NSRange marker = [text rangeOfString:@"scanning: " options:NSBackwardsSearch];
      if (marker.location != NSNotFound) {
        NSString *remainder = [text substringFromIndex:marker.location + marker.length];
        NSString *path = [[remainder componentsSeparatedByString:@"\n"] firstObject];
        strongSelf.statusLabel.stringValue = [NSString stringWithFormat:@"Scanning %@ — %ld preview(s) recovered.", path, (long)strongSelf.recovered];
      } else {
        strongSelf.statusLabel.stringValue = [NSString stringWithFormat:@"Working: %ld usable SketchUp preview(s) recovered so far.", (long)strongSelf.recovered];
      }
    });
  };

  self.task.terminationHandler = ^(NSTask *task) {
    dispatch_async(dispatch_get_main_queue(), ^{
      RepairController *strongSelf = weakSelf;
      if (!strongSelf) return;
      pipe.fileHandleForReading.readabilityHandler = nil;
      [strongSelf.logFile closeFile];
      strongSelf.logFile = nil;
      strongSelf.chooseButton.enabled = YES;
      strongSelf.startButton.enabled = strongSelf.folderURL != nil;
      strongSelf.stopButton.enabled = NO;
      BOOL completed = task.terminationStatus == 0;
      strongSelf.statusLabel.stringValue = completed ? @"Finished — see the log for the complete record." : @"Stopped or failed — the log contains the partial record.";
      [strongSelf append:[NSString stringWithFormat:@"\n%@\n", completed ? @"Repair finished." : @"Repair stopped."]];
    });
  };
  [self.task launch];
}

- (void)stopRepair:(id)sender {
  if (self.task.running) {
    [self append:@"\nStop requested. The current file will finish before the process exits.\n"];
    self.statusLabel.stringValue = @"Stopping…";
    [self.task terminate];
  }
}
@end

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    NSApplication *application = [NSApplication sharedApplication];
    RepairController *controller = [RepairController new];
    application.delegate = controller;
    [application run];
  }
  return 0;
}
