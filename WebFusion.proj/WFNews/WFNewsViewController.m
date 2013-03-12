//
//  WFNewsViewController.m
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-5.
//
//

#import "WFNewsViewController.h"
//#import <FusionBinding/FusionBinding.h>
#import <objc/message.h>
#import <FusionApps/FusionApps.h>

@interface WFNewsViewController ()

@property (weak) IBOutlet NSCollectionView *collectionView;
@property (weak) IBOutlet NSScroller *vertivalScroller;
@property (weak) IBOutlet NSScrollView *scrollView;

@property BOOL running;

@property (weak) id oldTarget;
@property SEL oldAction;

- (IBAction)scrollerChanged:(id)sender;

@end

@implementation WFNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (NSString *)appName
{
    return NSLocalizedStringFromTableInBundle(@"News", @"ui", [NSBundle bundleForClass:[self class]], @"");
}

- (NSString *)appCategory
{
    return @"WebFusion";
}

- (NSImage *)appIcon
{
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"News" withExtension:@"pdf"]];
    [image setTemplate:YES];
    return image;
}

- (NSUInteger)sortOrder
{
    return 0;
}

- (void)reload:(id)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger loadCount = [userDefaults integerForKey:@"loadBatchSize"];
    [self.sidebarItem beginLoading];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       if (self.running)
                           return;
                       self.running = YES;
                       
                       NSError *err;
                       WFApplicationServices *appServices = [WFApplicationServices applicationServices];
                       
                       NSArray *news = [appServices.connection newsBeforeEpoch:[NSDate distantFuture]
                                                                         count:loadCount
                                                                          type:nil
                                                                         error:&err];
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          self.running = NO;
                                          if (!news)
                                          {
                                              NSAlert *alert = [NSAlert alertWithError:err];
                                              [alert beginSheetModalForWindow:self.window
                                                                modalDelegate:nil
                                                               didEndSelector:nil
                                                                  contextInfo:nil];
                                          }
                                          else
                                          {
                                              [self.collectionView setContent:news];
                                          }
                                          [self.sidebarItem setBadgeAsRefreshButton];
                                      });
                       
                   });
}

- (void)awakeFromNib
{
    self.oldTarget = self.vertivalScroller.target;
    self.oldAction = self.vertivalScroller.action;
    
    self.vertivalScroller.target = self;
    self.vertivalScroller.action = @selector(scrollerChanged:);
    
    [self.sidebarItem.button setTarget:self];
    [self.sidebarItem.button setAction:@selector(reload:)];
}

- (void)viewWillAppear
{
    if (self.running)
        [self.sidebarItem beginLoading];
    else if (![[self.sidebarItem badge] length])
        [self.sidebarItem setBadgeAsRefreshButton];
    else
        [self reload:self];
    
    [self reload:self];
}

- (void)scrollerChanged:(id)sender
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.oldTarget performSelector:self.oldAction withObject:sender]; //Redispatch it.
#pragma clang diagnostic pop
    
    if ([self.vertivalScroller doubleValue] > 0.99)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSInteger loadCount = [userDefaults integerForKey:@"historyBatchSize"];
        WFApplicationServices *appServices = [WFApplicationServices applicationServices];
        NSMutableArray *currentObjects = [[self.collectionView content] mutableCopy];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           if (self.running)
                               return;
                           
                           self.running = YES;
                           NSError *err;
                           NSArray *news = [appServices.connection newsBeforeEpoch:[[currentObjects lastObject] publishDate]
                                                                             count:loadCount
                                                                              type:nil
                                                                             error:&err];
                           
                           if (news)
                           {
                               [currentObjects addObjectsFromArray:news];
                           }
                           
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              self.running = NO;
                                              if (!news)
                                              {
                                                  NSAlert *alert = [NSAlert alertWithError:err];
                                                  [alert beginSheetModalForWindow:self.window
                                                                    modalDelegate:nil
                                                                   didEndSelector:nil
                                                                      contextInfo:nil];
                                                  return;
                                              }
                                              
                                              [self.collectionView setContent:currentObjects];
                                              
                                              if ([self.scrollView respondsToSelector:@selector(flashScrollers)])
                                                  [self.scrollView flashScrollers];
                                              
                                              
                                          });
                       });
        
        
    }
}

- (void)viewWillDisappear
{
    if (![[self.sidebarItem badge] length])
        [self.sidebarItem setBadge:nil];
}

@end
