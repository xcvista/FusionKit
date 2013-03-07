//
//  WFNewsViewController.m
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-5.
//
//

#import "WFNewsViewController.h"
#import "WFAppDelegate.h"
//#import <FusionBinding/FusionBinding.h>
#import <objc/message.h>

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
                       WFAppDelegate *appDelegate = [NSApp delegate];
                       
                       NSArray *news = [appDelegate.connection newsBeforeEpoch:[NSDate distantFuture]
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
                                              return;
                                          }
                                          
                                          [self.collectionView setContent:news];
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
        WFAppDelegate *appDelegate = [NSApp delegate];
        NSMutableArray *currentObjects = [[self.collectionView content] mutableCopy];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           if (self.running)
                               return;
                           
                           self.running = YES;
                           NSError *err;
                           NSArray *news = [appDelegate.connection newsBeforeEpoch:[[currentObjects lastObject] publishDate]
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
                                                  return;
                                              }
                                              
                                              [currentObjects addObjectsFromArray:news];
                                              
                                              [self.collectionView setContent:currentObjects];
                                              
                                              if ([self.scrollView respondsToSelector:@selector(flashScrollers)])
                                                  [self.scrollView flashScrollers];
                                              
                                              
                                          });
                       });
        
        
    }
}

- (void)viewWillAppear
{
    if (self.running)
        [self.sidebarItem beginLoading];
    else if (![[self.sidebarItem badge] length])
        [self.sidebarItem setBadgeAsRefreshButton];
    else
        [self reload:self];
}

- (void)viewWillDisappear
{
    if (![[self.sidebarItem badge] length])
        [self.sidebarItem setBadge:nil];
}

@end
