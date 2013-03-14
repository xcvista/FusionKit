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
#import "WFNewsListView.h"
#import "FKNews+NwsDisplay.h"
#import <WebKit/WebKit.h>

@interface WFNewsViewController () <NSTableViewDelegate, NSTableViewDataSource, NSSplitViewDelegate>

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSScrollView *scrollView;
@property (weak) IBOutlet WebView *webView;

@property BOOL running;
@property NSArray *contents;

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

- (NSUInteger)sortOrder
{
    return 0;
}

- (BOOL)canUnload
{
    return NO;
}

- (void)reload:(id)sender
{
    if (self.running)
        return;
    
    self.running = YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger loadCount = [userDefaults integerForKey:@"loadBatchSize"];
    if (![self.sidebarItem isLoading])
        [self.sidebarItem beginLoading];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
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
                                              self.contents = news;
                                              [self.tableView reloadData];
                                              [self.tableView becomeFirstResponder];
                                              if ([self.tableView selectedRow] < 0)
                                                  [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0]
                                                              byExtendingSelection:NO];
                                              [self.scrollView.contentView scrollToPoint:NSPointFromCGPoint(CGPointZero)];
                                              [self.scrollView.verticalScroller setDoubleValue:0];
                                              if ([self.scrollView respondsToSelector:@selector(flashScrollers)])
                                                  [self.scrollView flashScrollers];
                                          }
                                          if ([self isActive])
                                              [self.sidebarItem setBadgeAsRefreshButton];
                                          else
                                              [self.sidebarItem setBadge:nil];
                                      });
                       
                   });
}

- (void)awakeFromNib
{
    [self view];
    if (!self.oldTarget)
    {
        self.oldTarget = self.scrollView.verticalScroller.target;
        self.oldAction = self.scrollView.verticalScroller.action;
    }
    
    self.scrollView.verticalScroller.target = self;
    self.scrollView.verticalScroller.action = @selector(scrollerChanged:);
}

- (void)userDidLogin
{
    [self view];
}

- (void)setSidebarItem:(SidebarTableCellView *)sidebarItem
{
    [super setSidebarItem:sidebarItem];
    if (self.running)
        [self.sidebarItem beginLoading];
    else if (![[self.sidebarItem badge] length])
        [self.sidebarItem setBadgeAsRefreshButton];
    else
        ; // eh
    
    if (self.isActive)
    {
        [self.sidebarItem.button setTarget:self];
        [self.sidebarItem.button setAction:@selector(reload:)];
    }
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
    
    if (![self.contents count])
        [self reload:self];
    
    [self.sidebarItem.button setTarget:self];
    [self.sidebarItem.button setAction:@selector(reload:)];
}

- (void)loadMore
{
    if (self.running)
        return;
    
    self.running = YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger loadCount = [userDefaults integerForKey:@"historyBatchSize"];
    WFApplicationServices *appServices = [WFApplicationServices applicationServices];
    NSMutableArray *currentObjects = [self.contents mutableCopy];
    NSString *currentBadge = [self.sidebarItem badge];
    NSNumber *badgeIsRefresh = @([self.sidebarItem isRefreshBadge]);
    if (![self.sidebarItem isLoading])
        [self.sidebarItem beginLoading];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
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
                                          else
                                          {
                                              self.contents = currentObjects;
                                              [self.tableView reloadData];
                                              
                                              if ([self.scrollView respondsToSelector:@selector(flashScrollers)])
                                                  [self.scrollView flashScrollers];
                                          }
                                          
                                          if ([badgeIsRefresh boolValue])
                                          {
                                              if ([self isActive])
                                                  [self.sidebarItem setBadgeAsRefreshButton];
                                              else
                                                  [self.sidebarItem setBadge:nil];
                                          }
                                          else
                                              [self.sidebarItem setBadge:currentBadge];
                                          
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
        [self loadMore];
    }
}

- (NSDictionary *)registerPoll
{
    if (![self.contents count])
        return nil;
    NSNumber *timestamp = @(FKTimestampFromNSTimeInterval([[(FKNews *)self.contents[0] publishDate] timeIntervalSince1970]));
    NSMutableDictionary *request = [@{@"dvt": @([[self.sidebarItem badge] integerValue]), @"exceptions": @"", @"lt": timestamp, @"type": @""} mutableCopy];;
    return @{@"newsc": request};
}

- (void)pollDidFinish:(NSNotification *)aNotification
{
    NSDictionary *data = [aNotification userInfo];
    NSDictionary *source = data[@"request"][@"newsc"];
    if (source)
    {
        NSTimeInterval reqTime = NSTimeIntervalFromFKTimestamp([source[@"lt"] longValue]);
        NSTimeInterval curTime = [[(FKNews *)self.contents[0] publishDate] timeIntervalSince1970];
        if (curTime - reqTime >= 1000)
            return;
    }
    else
    {
        return;
    }
    NSNumber *number = data[@"newsc"];
    if (number)
        [self.sidebarItem setBadge:[number stringValue]];
}

- (void)viewWillDisappear
{
    if (![[self.sidebarItem badge] length])
        [self.sidebarItem setBadge:nil];
    
    [self.sidebarItem.button setTarget:nil];
    [self.sidebarItem.button setAction:nil];
    
    [super viewWillDisappear];
}

#pragma mark Split View

- (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)view
{
    return [[splitView subviews] indexOfObject:view] != 0;
}

#pragma mark Table View

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.contents count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    FKNews *news = self.contents[row];
    WFNewsListView *listView = [tableView makeViewWithIdentifier:@"News"
                                                           owner:self];
    
    [listView.textField setStringValue:news.title];
    [listView.authorField setStringValue:news.author.description];
    [listView.timeField setStringValue:news.time];
    listView.imageURL = news.author.avatar;
    [listView asyncLoad];
    return listView;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    // Cancel previous load
    if ([self.webView isLoading])
        [self.webView stopLoading:self];
    
    if ([self.tableView selectedRow] >= 0)
    {
        FKNews *news = self.contents[[self.tableView selectedRow]];
        [self.webView.mainFrame loadAlternateHTMLString:news.htmlString
                                                baseURL:[[[NSBundle bundleForClass:[self class]] bundleURL] URLByAppendingPathComponent:@"Contents/Resources"]
                                      forUnreachableURL:nil];
    }
    if ([self.tableView selectedRow] >= [self.contents count] - 1)
        [self loadMore];
    
}

@end
