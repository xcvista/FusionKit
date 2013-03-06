//
//  WFAboutBoxWindowController.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-7.
//
//

#import "WFAboutBoxWindowController.h"

@interface WFAboutBoxWindowController ()

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

@end
