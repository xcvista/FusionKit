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
#import "WFPreferenceKeys.h"

@interface WFLoginWindowController () <NSWindowDelegate>

@property (weak) IBOutlet NSTextField *usernameField;
@property (weak) IBOutlet NSTextField *passwordField;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSBox *everythingBox;
@property (weak) IBOutlet NSButton *loginButton;
@property BOOL blockExit;
@property BOOL overrideAutologon;

- (IBAction)login:(id)sender;
- (IBAction)signUp:(id)sender;

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
    
    [self.window setDefaultButtonCell:self.loginButton.cell];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([[NSApp delegate] override])
    {
        NSString *username = [userDefaults objectForKey:WFUsername];
        NSString *password = [userDefaults objectForKey:WFPassword];
        
        if (username)
            [self.usernameField setStringValue:username];
        if (password)
            [self.passwordField setStringValue:password];
        
        [self.window setTitle:NSLocalizedString(@"WebFusion (Override)", @"")];
        
        if ([username length] && [password length])
        {
            self.overrideAutologon = YES;
        }
    }
    else
    {
        if ([userDefaults boolForKey:WFSaveUsername])
        {
            NSString *oldUsername = [userDefaults objectForKey:WFUsername];
            if ([oldUsername length])
                [self.usernameField setStringValue:oldUsername];
        }
        else
        {
            [userDefaults removeObjectForKey:WFUsername];
        }
        
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
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       // Load bundles
                       [WFAppLoader appLoader];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [self.loginButton setEnabled:YES];
                                          if (self.overrideAutologon)
                                          {
                                              [self login:self];
                                          }
                                      });
                   });
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
                       NSString *serverRoot = [[NSUserDefaults standardUserDefaults] objectForKey:WFServerRoot];
                       
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
                                              if (!delegate.override)
                                              {
                                                  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                                  if ([userDefaults boolForKey:WFSaveUsername])
                                                  {
                                                      [userDefaults setObject:username forKey:WFUsername];
                                                  }
                                                  else
                                                  {
                                                      [userDefaults removeObjectForKey:WFSaveUsername];
                                                  }
                                              }
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
                                              NSAlert *alert = [NSAlert alertWithError:err];
                                              [alert beginSheetModalForWindow:self.window
                                                                modalDelegate:self
                                                               didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)
                                                                  contextInfo:nil];
                                          });
                       }
                   });
}

- (void)signUp:(id)sender
{
    
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    if (self.overrideAutologon)
    {
        [self.loginButton setEnabled:YES];
    }
    else
    {
        for (NSControl *control in [[self.everythingBox subviews][0] subviews])
        {
            if ([control respondsToSelector:@selector(setEnabled:)])
                [control setEnabled:YES];
        }
        [self.passwordField becomeFirstResponder];
        [self.passwordField selectText:self];
    }
}

@end
