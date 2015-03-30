//
//  IFASelectionManager.m
//  Gusty
//
//  Created by Marcelo Schroeder on 14/07/11.
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

#import "GustyLibCoreUI.h"

@interface IFASelectionManager ()
@property(nonatomic, weak) id <IFASelectionManagerDataSource> dataSource;
@end

@implementation IFASelectionManager

#pragma mark - Public

- (id)initWithSelectionManagerDataSource:(id<IFASelectionManagerDataSource>)a_dataSource{
    NSMutableArray *selectedObjects = [[NSMutableArray alloc] init];
	return [self initWithSelectionManagerDataSource:a_dataSource
                                    selectedObjects:selectedObjects];
}

- (id)initWithSelectionManagerDataSource:(id<IFASelectionManagerDataSource>)a_dataSource selectedObjects:(NSArray *)a_selectedObjects{
	if ((self=[super init])) {
		self.dataSource = a_dataSource;
        self.allowMultipleSelection = NO;
		self.selectedObjects = [NSMutableArray arrayWithArray:a_selectedObjects];
	}
	return self;
}

- (void)handleSelectionForIndexPath:(NSIndexPath*)a_indexPath{
    [self handleSelectionForIndexPath:a_indexPath userInfo:nil];
}

- (void)handleSelectionForIndexPath:(NSIndexPath*)a_indexPath userInfo:(NSDictionary*)a_userInfo{
    
//    NSLog(@"handleSelectionForIndexPath: %@", [a_indexPath description]);
//    NSLog(@"self.selectedIndexPaths: %@", [self.selectedIndexPaths description]);
    
    NSIndexPath *l_previousSelectedIndexPath = nil;
	id l_previousSelectedObject = nil;
	id l_selectedObject = nil;
    if (self.allowMultipleSelection) {
        id l_targetObject = [self.dataSource selectionManager:self
                                            objectAtIndexPath:a_indexPath];
        if ([self.selectedObjects containsObject:l_targetObject]) {
            l_previousSelectedIndexPath = a_indexPath;
            l_previousSelectedObject = l_targetObject;
        }else{
            l_selectedObject = l_targetObject;
        }
    }else{
        if ([self.selectedIndexPaths count]>0) {
            l_previousSelectedIndexPath = self.selectedIndexPaths[0];
            l_previousSelectedObject = self.selectedObjects[0];
        }
        if ([self.selectedIndexPaths count]==0 || ![l_previousSelectedIndexPath isEqual:a_indexPath]) {
            l_selectedObject = [self.dataSource selectionManager:self
                                               objectAtIndexPath:a_indexPath];
        }
        if (self.disallowDeselection && l_previousSelectedIndexPath && [l_previousSelectedIndexPath compare:a_indexPath] == NSOrderedSame) {
            if ([self.delegate respondsToSelector:@selector(selectionManager:didSelectObject:deselectedObject:indexPath:userInfo:)]) {
                // Run delegate's handler
                [self.delegate selectionManager:self
                                didSelectObject:nil
                               deselectedObject:nil
                                      indexPath:a_indexPath
                                       userInfo:a_userInfo];
            }
            if ([self.dataSource respondsToSelector:@selector(tableViewForSelectionManager:)]) {
                // Deselect row (UITableView's default visual indication only)
                [[self.dataSource tableViewForSelectionManager:self] deselectRowAtIndexPath:a_indexPath
                                                                                  animated:YES];
            }
            return;
        }
    }
//    NSLog(@"l_previousSelectedObject: %@", [l_previousSelectedObject description]);
//    NSLog(@"l_selectedObject: %@", [l_selectedObject description]);

    // Old cell
	if (l_previousSelectedObject) {
//        NSLog(@"l_previousSelectedIndex: %u", l_previousSelectedIndex);
        if ([self.dataSource respondsToSelector:@selector(tableViewForSelectionManager:)] && [self.delegate respondsToSelector:@selector(selectionManager:didRequestDecorationForCell:selected:object:)]) {
            NSIndexPath *oldIndexPath = l_previousSelectedIndexPath;
            //        NSLog(@"oldIndexPath: %u", oldIndexPath.row);
            UITableViewCell *oldCell = [[self.dataSource tableViewForSelectionManager:self] cellForRowAtIndexPath:oldIndexPath];
            [self.delegate selectionManager:self
                didRequestDecorationForCell:oldCell
                                   selected:NO
                                     object:l_previousSelectedObject];
        }
	}

	// New cell
	if (l_selectedObject) {
        if ([self.dataSource respondsToSelector:@selector(tableViewForSelectionManager:)] && [self.delegate respondsToSelector:@selector(selectionManager:didRequestDecorationForCell:selected:object:)]) {
            UITableViewCell *newCell = [[self.dataSource tableViewForSelectionManager:self] cellForRowAtIndexPath:a_indexPath];
            [self.delegate selectionManager:self
                didRequestDecorationForCell:newCell
                                   selected:YES
                                     object:l_selectedObject];
        }
        [self.selectedObjects addObject:[self.dataSource selectionManager:self
                                                        objectAtIndexPath:a_indexPath]];
	}

    // Remove previous selection
    [self.selectedObjects removeObject:l_previousSelectedObject];

    if ([self.delegate respondsToSelector:@selector(selectionManager:didSelectObject:deselectedObject:indexPath:userInfo:)]) {
        // Run delegate's handler
        [self.delegate selectionManager:self
                        didSelectObject:l_selectedObject
                       deselectedObject:l_previousSelectedObject
                              indexPath:a_indexPath
                               userInfo:a_userInfo];
    }

    if ([self.dataSource respondsToSelector:@selector(tableViewForSelectionManager:)]) {
        // Deselect row (UITableView's default visual indication only)
        [[self.dataSource tableViewForSelectionManager:self] deselectRowAtIndexPath:a_indexPath
                                                                          animated:YES];
    }

}

-(void)deselectAll{
    [self deselectAllWithUserInfo:nil];
}

- (void)deselectAllWithUserInfo:(NSDictionary *)a_userInfo{
    for (NSIndexPath *l_selectedIndexPath in self.selectedIndexPaths) {
		[self handleSelectionForIndexPath:l_selectedIndexPath userInfo:a_userInfo];
    }
}

- (NSArray*)selectedIndexPaths {
    NSMutableArray *l_selectedIndexPaths = [[NSMutableArray alloc] init];
    for (id l_selectedObject in self.selectedObjects) {
        NSIndexPath *l_selectedIndexPath = [self.dataSource selectionManager:self
                                                          indexPathForObject:l_selectedObject];
        if (l_selectedIndexPath) {
            [l_selectedIndexPaths addObject:l_selectedIndexPath];
        }
    }
	return l_selectedIndexPaths;
}

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
- (void)notifyDeletionForObject:(id)a_deletedObject{
//    NSLog(@"notifyDeletionForIndexPath - size before: %u", [self.selectedObjects count]);
    [self.selectedObjects removeObject:a_deletedObject];
//    NSLog(@"notifyDeletionForIndexPath - size after: %u", [self.selectedObjects count]);
}
#pragma clang diagnostic pop

#pragma mark - Overrides


@end
