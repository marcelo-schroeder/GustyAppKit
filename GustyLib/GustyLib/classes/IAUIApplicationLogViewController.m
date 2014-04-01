//
//  IAUIApplicationLogViewController.m
//  Gusty
//
//  Created by Marcelo Schroeder on 6/05/11.
//  Copyright 2011 InfoAccent Pty Limited. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "IACommon.h"


@implementation IAUIApplicationLogViewController

#pragma mark -
#pragma mark Private

- (void)onAction:(id)a_sender{
    if (a_sender==v_deleteAllButton) {
        [[IAPersistenceManager instance] deleteAllForEntityAndSave:self.entityName];
    }
    [self m_refreshAndReloadDataAsync];
}

#pragma mark -
#pragma mark Overrides

-(id)init{
    return [super initWithEntityName:@"IAApplicationLog"];
}

- (UITableViewCellStyle) m_tableViewCellStyle{
	return UITableViewCellStyleSubtitle;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *l_cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    [[self m_appearanceTheme] m_setAppearanceForView:l_cell.detailTextLabel];
    IAApplicationLog *l_logEntry = [self.p_entities objectAtIndex:indexPath.row];
    l_cell.detailTextLabel.text = l_logEntry.message;
    return l_cell;
}

- (NSArray*)m_nonEditModeToolbarItems{
    
    if (!v_deleteAllButton) {
        v_deleteAllButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(onAction:)];
    }
    
    if (!v_refreshButton) {
        v_refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onAction:)];
    }
	
	// Separator
	UIBarButtonItem *spaceBarButtonItem = [IAUIUtils barButtonItemForType:IA_UIBAR_BUTTON_ITEM_FLEXIBLE_SPACE target:nil action:nil];
	
	return @[v_deleteAllButton, 
			spaceBarButtonItem, 
			v_refreshButton];
	
}


@end