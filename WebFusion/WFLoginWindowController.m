//
//  WFLoginWindowController.m
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-4.
//
//

#import "WFLoginWindowController.h"

@interface WFLoginWindowController ()

@property (weak) IBOutlet NSTextField *usernameField;
@property (weak) IBOutlet NSTextField *passwordField;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSBox *everythingBox;
@property (weak) IBOutlet NSButton *loginButton;

- (IBAction)login:(id)sender;
- (IBAction)signUp:(id)sender;

@end

@implementation WFLoginWindowController

- (id)init
{
    return [self initWithWindowNibName:NSStringFromClass([self class])];
}

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
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
}

- (void)login:(id)sender
{
    NSString *username = [self.usernameField stringValue];
    NSString *password = [self.passwordField stringValue];
    
    if (![username length] || ![password length])
        return;
    
    for (NSControl *control in [[self.everythingBox subviews][0] subviews])
    {
        if ([control respondsToSelector:@selector(setEnabled:)])
            [control setEnabled:NO];
    }
    [self.progressIndicator startAnimation:self];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       sleep(5);
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [self.progressIndicator stopAnimation:self];
                                          for (NSControl *control in [[self.everythingBox subviews][0] subviews])
                                          {
                                              if ([control respondsToSelector:@selector(setEnabled:)])
                                                  [control setEnabled:YES];
                                          }
                                      });
                   });
}

- (void)signUp:(id)sender
{
    
}

@end
