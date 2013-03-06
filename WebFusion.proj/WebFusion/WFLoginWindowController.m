//
//  WFLoginWindowController.m
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-4.
//
//

#import "WFLoginWindowController.h"
#import "WFAppDelegate.h"
#import "WFMainWindowController.h"

@interface WFLoginWindowController () <NSWindowDelegate>

@property (weak) IBOutlet NSTextField *usernameField;
@property (weak) IBOutlet NSTextField *passwordField;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSBox *everythingBox;
@property (weak) IBOutlet NSButton *loginButton;
@property BOOL blockExit;

@property IBOutlet NSPanel *advancedSheet;
@property (weak) IBOutlet NSUserDefaultsController *sharedUDC;

- (IBAction)login:(id)sender;
- (IBAction)signUp:(id)sender;
- (IBAction)advanced:(id)sender;

- (IBAction)acceptChanges:(id)sender;
- (IBAction)rejectChanges:(id)sender;

@end

@implementation WFLoginWindowController

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
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *oldUsername = [userDefaults objectForKey:@"username"];
    if ([oldUsername length])
        [self.usernameField setStringValue:oldUsername];
    
    NSString *username = [self.usernameField stringValue];
    NSString *password = [self.passwordField stringValue];
    if (![username length])
    {
        [self.usernameField becomeFirstResponder];
    }
    else if (![password length])
    {
        [self.passwordField becomeFirstResponder];
    }
    
    [self.window setDefaultButtonCell:self.loginButton.cell];
}

- (BOOL)windowShouldClose:(id)sender
{
    return !self.blockExit;
}

- (void)windowWillClose:(NSNotification *)notification
{
    if (![[notification object] isEqual:self.window])
        return;
    WFAppDelegate *delegate = [NSApp delegate];
    if (!delegate.connection)
        [[NSApplication sharedApplication] terminate:self];
}

- (void)login:(id)sender
{
    NSString *username = [self.usernameField stringValue];
    NSString *password = [self.passwordField stringValue];
    
    if (![username length])
    {
        [self.usernameField becomeFirstResponder];
        return;
    }
    else if (![password length])
    {
        [self.passwordField becomeFirstResponder];
        return;
    }
    
    for (NSControl *control in [[self.everythingBox subviews][0] subviews])
    {
        if ([control respondsToSelector:@selector(setEnabled:)])
            [control setEnabled:NO];
    }
    self.blockExit = YES;
    [self.progressIndicator startAnimation:self];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSString *serverRoot = [[NSUserDefaults standardUserDefaults] objectForKey:@"server"];
                       
                       if (![serverRoot hasSuffix:@"/"])
                           serverRoot = [serverRoot stringByAppendingString:@"/"];
                       
                       FKConnection *connection = [[FKConnection alloc] initWithServerRoot:[NSURL URLWithString:serverRoot]];
                       
                       NSError *err = nil;
                       
                       if ([connection loginWithUsername:username
                                                password:password
                                                   error:&err])
                       {
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              WFAppDelegate *delegate = [NSApp delegate];
                                              [delegate finishLoginWithConnection:connection];
                                              [self.window close];
                                              NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                              [userDefaults setObject:username forKey:@"username"];
                                              [delegate showMainWindow:self];
                                              [delegate releaseWindowController:self];
                                          });
                       }
                       else
                       {
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              self.blockExit = NO;
                                              [self.progressIndicator stopAnimation:self];
                                              for (NSControl *control in [[self.everythingBox subviews][0] subviews])
                                              {
                                                  if ([control respondsToSelector:@selector(setEnabled:)])
                                                      [control setEnabled:YES];
                                              }
                                              NSAlert *alert = [NSAlert alertWithError:err];
                                              [alert beginSheetModalForWindow:self.window
                                                                modalDelegate:nil
                                                               didEndSelector:nil
                                                                  contextInfo:nil];
                                              [self.passwordField becomeFirstResponder];
                                              [self.passwordField selectText:self];
                                          });
                       }
                   });
}

- (void)signUp:(id)sender
{
    
}

- (void)advanced:(id)sender
{    
    [NSApp beginSheet:self.advancedSheet
       modalForWindow:self.window
        modalDelegate:nil
       didEndSelector:nil
          contextInfo:nil];
    [NSApp runModalForWindow:self.advancedSheet];
    
    [NSApp endSheet:self.advancedSheet];
    [self.advancedSheet orderOut:self];
}

- (void)acceptChanges:(id)sender
{
    [self.sharedUDC save:sender];
    [NSApp stopModal];
}

- (void)rejectChanges:(id)sender
{
    [self.sharedUDC revert:sender];
    [NSApp stopModal];
}

@end
