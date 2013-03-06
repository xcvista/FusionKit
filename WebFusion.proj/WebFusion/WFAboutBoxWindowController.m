//
//  WFAboutBoxWindowController.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-7.
//
//

#import "WFAboutBoxWindowController.h"
#import "WFAppDelegate.h"

@interface WFAboutBoxWindowController () <NSWindowDelegate>

@property (weak) IBOutlet NSTextField *aboutTextField;

@end

@implementation WFAboutBoxWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    NSString *mainVersion = [[NSBundle mainBundle] infoDictionary][(NSString *)kCFBundleVersionKey];
    NSString *gitVersion = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"git-version" withExtension:@"plist"]][@"git-version"];
    [self.aboutTextField setStringValue:[NSString stringWithFormat:NSLocalizedString(@"Version %@ (git %@)", @""), mainVersion, gitVersion]];
}

- (void)windowWillClose:(NSNotification *)notification
{
    [[NSApp delegate] releaseWindowController:self];
}

@end
