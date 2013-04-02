//
//  WFReplyWindowController.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-23.
//
//

#import "WFReplyWindowController.h"
#import "NSData+Cache.h"
#import "NSImage+Rounding.h"
#import "FKNews+NwsDisplay.h"

@interface WFReplyWindowController () <NSWindowDelegate>

@property (weak) IBOutlet NSTextField *authorField;
@property (weak) IBOutlet NSTextField *timeField;
@property (weak) IBOutlet NSTextField *contentField;
@property (weak) IBOutlet NSImageView *avatarView;
@property (weak) IBOutlet NSTextField *replyBox;

- (IBAction)send:(id)sender;
- (IBAction)cancel:(id)sender;

@end

@implementation WFReplyWindowController

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
    if (!self.baseNews)
    {
        [self cancel:self];
        return;
    }
    
    [self.contentField setStringValue:self.baseNews.title];
    [self.authorField setStringValue:[self.baseNews.author description]];
    [self.timeField setStringValue:[self.baseNews time]];
    
    NSURL *imageURL = self.baseNews.author.avatar;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSData *data = [NSData cachedDataAtURL:imageURL];
                       if (data)
                       {
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              NSImage *avatar = [[[NSImage alloc] initWithData:data] imageByScalingProportionallyToSize:[self.avatarView bounds].size];
                                              NSImage *roundedAvatar = [NSImage makeRoundCornerImage:avatar
                                                                                         cornerWidth:5
                                                                                        cornerHeight:5];
                                              [self.avatarView setImage:roundedAvatar];
                                          });
                       }
                   });
}

- (void)windowWillClose:(NSNotification *)notification
{
    [[WFApplicationServices applicationServices] releaseWindowController:self];
}

- (void)cancel:(id)sender
{
    [self.window orderOut:self];
}

- (void)send:(id)sender
{
    NSString *comment = [self.replyBox stringValue];
    if (![comment length])
        return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       FKConnection *connection = [[WFApplicationServices applicationServices] connection];
                       NSError *err = nil;
                       BOOL result = [connection replyTo:self.baseNews
                                             withMessage:comment
                                                   title:nil
                                                    data:nil
                                                   error:&err];
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          if (result)
                                          {
                                              [self cancel:self];
                                          }
                                          else
                                          {
                                              NSAlert *alert = [NSAlert alertWithError:err];
                                              [alert beginSheetModalForWindow:self.window
                                                                modalDelegate:nil
                                                               didEndSelector:NULL
                                                                  contextInfo:NULL];
                                          }
                                      });
                   });
}

@end
