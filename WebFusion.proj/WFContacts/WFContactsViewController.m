//
//  WFContactsViewController.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-13.
//
//

#import "WFContactsViewController.h"
#import <FusionApps/FusionApps.h>

@interface WFContactsViewController () <NSTextFieldDelegate>

@property (weak) IBOutlet NSSearchField *searchField;
@property (weak) IBOutlet NSCollectionView *collectionView;
@property (weak) IBOutlet NSScrollView *scrollView;

@property NSUInteger currentLastPage;
@property BOOL running;

@property (weak) id oldTarget;
@property SEL oldAction;

- (IBAction)scrollerChanged:(id)sender;
- (IBAction)reload:(id)sender;

@end

@implementation WFContactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (NSInteger)sortOrder
{
    return 2;
}

- (BOOL)canUnload
{
    return NO;
}

- (void)awakeFromNib
{
    self.oldTarget = self.scrollView.verticalScroller.target;
    self.oldAction = self.scrollView.verticalScroller.action;
    
    self.scrollView.verticalScroller.target = self;
    self.scrollView.verticalScroller.action = @selector(scrollerChanged:);
}

- (void)viewWillAppear
{
    [super viewWillAppear];
    if (self.running)
        [self.sidebarItem beginLoading];
    else if (![[self.sidebarItem badge] length])
        [self.sidebarItem setBadgeAsRefreshButton];
    else
        ; // eh
    
    [self reload:self];
    
    [self.sidebarItem.button setTarget:self];
    [self.sidebarItem.button setAction:@selector(reload:)];
}

- (void)viewWillDisappear
{
    if (![[self.sidebarItem badge] length])
        [self.sidebarItem setBadge:nil];
    
    [self.sidebarItem.button setTarget:nil];
    [self.sidebarItem.button setAction:nil];
    
    [super viewWillDisappear];
}

- (void)reload:(id)sender
{
    if (self.running)
        return;
    self.running = YES;
    [self.sidebarItem beginLoading];
    self.currentLastPage = 0;
    if (![self.sidebarItem isLoading])
        [self.sidebarItem beginLoading];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       WFApplicationServices *appServices = [WFApplicationServices applicationServices];
                       FKConnection *connection = [appServices connection];
                       
                       NSError *err = nil;
                       NSArray *contacts = [connection searchContact:[self.searchField stringValue]
                                                             inGroup:@""
                                                                page:self.currentLastPage
                                                               error:&err];
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          if (contacts)
                                          {
                                              [self.collectionView setContent:contacts];
                                          }
                                          else
                                          {
                                              NSAlert *alert = [NSAlert alertWithError:err];
                                              [alert beginSheetModalForWindow:self.window
                                                                modalDelegate:nil
                                                               didEndSelector:NULL
                                                                  contextInfo:NULL];
                                          }
                                          self.running = NO;
                                          if ([self isActive])
                                              [self.sidebarItem setBadgeAsRefreshButton];
                                          else
                                              [self.sidebarItem setBadge:nil];
                                      });
                   });
}

- (void)scrollerChanged:(id)sender
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.oldTarget performSelector:self.oldAction withObject:sender]; //Redispatch it.
#pragma clang diagnostic pop
    
    if ([self.scrollView.verticalScroller doubleValue] > 0.99)
    {
        if (self.running)
            return;
        
        self.running = YES;
        
        self.currentLastPage++;
        if (![self.sidebarItem isLoading])
            [self.sidebarItem beginLoading];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           WFApplicationServices *appServices = [WFApplicationServices applicationServices];
                           FKConnection *connection = [appServices connection];
                           
                           NSError *err = nil;
                           NSArray *contacts = [connection searchContact:[self.searchField stringValue]
                                                                 inGroup:@""
                                                                    page:self.currentLastPage
                                                                   error:&err];
                           NSArray *everything = [[self.collectionView content] arrayByAddingObjectsFromArray:contacts];
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              if (contacts)
                                              {
                                                  [self.collectionView setContent:everything];
                                              }
                                              else
                                              {
                                                  self.currentLastPage--;
                                              }
                                              self.running = NO;
                                              if ([self isActive])
                                                  [self.sidebarItem setBadgeAsRefreshButton];
                                              else
                                                  [self.sidebarItem setBadge:nil];
                                          });
                       });

    }
}

@end
