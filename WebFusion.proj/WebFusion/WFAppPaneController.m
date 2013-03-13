//
//  WFAppPaneController.m
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-5.
//
//

#import "WFAppPaneController.h"
#import "WFMainWindowController.h"
#import <FusionApps/FusionApps.h>
#import "WFAppLoader.h"

@interface WFAppPaneController () <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (weak) IBOutlet WFMainWindowController *mainVC;
@property (weak) IBOutlet NSOutlineView *outlineView;

@property NSMutableArray *titles;
@property NSMutableDictionary *contents;

@end

@implementation WFAppPaneController

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reload:)
                                                 name:WFAppLoaderLoadedBundleNotification
                                               object:nil];
    [self reload:nil];
}

- (void)reload:(id)notification
{
    NSArray *objects = [[WFAppLoader appLoader] loadedApps];
    self.titles = [NSMutableArray array];
    self.contents = [NSMutableDictionary dictionary];
    
    for (WFViewController *app in objects)
    {
        if (![app showInSidebar])
            continue;
        if (![self.titles containsObject:app.appCategory])
            [self.titles addObject:app.appCategory];
        if (!self.contents[app.appCategory])
            self.contents[app.appCategory] = [NSMutableArray array];
        [self.contents[app.appCategory] addObject:app];
    }
    
    [self.titles sortUsingComparator:
     ^NSComparisonResult(NSString *key1, NSString *key2) {
         if ([key1 isEqualToString:@"WebFusion"])
             return NSOrderedAscending;
         else if ([key2 isEqualToString:@"WebFusion"])
             return NSOrderedDescending;
         else
             return [key1 compare:key2];
     }];
    for (id key in self.contents)
    {
        [self.contents[key] sortUsingSelector:@selector(compare:)];
    }
    [self.outlineView reloadData];
}

- (void)configureView
{
    [self.outlineView sizeLastColumnToFit];
    [self.outlineView reloadData];
    [self.outlineView setFloatsGroupRows:NO];
    
    [self.outlineView setRowSizeStyle:NSTableViewRowSizeStyleDefault];
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0];
    [self.outlineView expandItem:nil expandChildren:YES];
    [NSAnimationContext endGrouping];
}

- (NSArray *)childrenOfItem:(id)item
{
    if (!item)
        return self.titles;
    else
        return self.contents[item];
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    if ([self.outlineView selectedRow] >= 0)
    {
        id item = [self.outlineView itemAtRow:[self.outlineView selectedRow]];
        SidebarTableCellView *view = [self.outlineView viewAtColumn:0
                                                                row:[self.outlineView selectedRow]
                                                    makeIfNecessary:NO];
        [view setNeedsDisplay:YES];
        if ([self.outlineView parentForItem:item] != nil)
        {
            [self.mainVC loadAppWithName:item];
        }
    }
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    return [self childrenOfItem:item][index];
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    return [[self childrenOfItem:item] count];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    return [self.titles containsObject:item];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldShowOutlineCellForItem:(id)item
{
    return [self.titles indexOfObject:item] != 0;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    return [self.titles containsObject:item];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    return ![self.titles containsObject:item];
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    if ([self.titles containsObject:item])
    {
        NSTextField *headerCell = [outlineView makeViewWithIdentifier:@"HeaderText"
                                                                owner:self];
        [headerCell setStringValue:[NSLocalizedString(item, @"") uppercaseString]];
        return headerCell;
    }
    else
    {
        SidebarTableCellView *dataCell = [outlineView makeViewWithIdentifier:@"MainCell"
                                                                       owner:self];
        WFViewController *vc = item;
        [[dataCell imageView] setImage:vc.appIcon];
        [[dataCell textField] setStringValue:vc.appName];
        vc.sidebarItem = dataCell;
        return dataCell;
    }
}

@end
