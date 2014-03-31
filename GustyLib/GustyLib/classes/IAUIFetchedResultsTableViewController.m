//
//  IAUIFetchedResultsViewController.m
//  Gusty
//
//  Created by Marcelo Schroeder on 8/03/13.
//  Copyright (c) 2013 InfoAccent Pty Limited. All rights reserved.
//

#import "IACommon.h"

@interface IAUIFetchedResultsTableViewController ()

@end

@implementation IAUIFetchedResultsTableViewController{
    
}

#pragma mark - UITableViewDataSource protocol

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.p_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> l_sectionInfo = [[self.p_fetchedResultsController sections] objectAtIndex:section];
    return [l_sectionInfo numberOfObjects];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    id <NSFetchedResultsSectionInfo> l_sectionInfo = [[self.p_fetchedResultsController sections] objectAtIndex:section];
    return [l_sectionInfo name];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {

    switch(type) {

        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            NSAssert(NO, @"Unexpected section change type: %u", type);
            break;

    }

}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
//    NSLog(@"NSFetchedResultsController cell changed detected for controller: %@", [controller description]);
//    NSLog(@"  didChangeObject: %@", [anObject description]);
//    NSLog(@"      atIndexPath: %@", [indexPath description]);
//    NSLog(@"     newIndexPath: %@", [newIndexPath description]);
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
//            NSLog(@"    forChangeType: insert");
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
//            NSLog(@"    forChangeType: delete");
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
//            NSLog(@"    forChangeType: update");
            [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
//            NSLog(@"    forChangeType: move");
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;

        default:
            NSAssert(NO, @"Unexpected object change type: %u", type);
            break;

    }
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
