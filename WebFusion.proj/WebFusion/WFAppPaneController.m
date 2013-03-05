//
//  WFAppPaneController.m
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-5.
//
//

#import "WFAppPaneController.h"
#import "WFMainWindowController.h"

@interface WFAppPaneController () <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (weak) IBOutlet WFMainWindowController *mainVC;
@property (weak) IBOutlet NSOutlineView *outlineView;

@property NSArray *titles;
@property NSDictionary *contents;

@end

@implementation WFAppPaneController

- (void)awakeFromNib
{
    self.titles = @[@"WebFusion", @"Apps"];
    self.contents = @{@"WebFusion": @[@"News",
                                      @"Posts",
                                      @"Me",
                                      @"Contacts"],
                      @"Apps": @[@"Places",
                                 @"Camera",
                                 @"Groove"]};
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
        NSTableCellView *dataCell = [outlineView makeViewWithIdentifier:@"DataCell"
                                                                  owner:self];
        [[dataCell imageView] setImage:[NSImage imageNamed:item]];
        [[dataCell textField] setStringValue:NSLocalizedString(item, @"")];
        return dataCell;
    }
}

@end
