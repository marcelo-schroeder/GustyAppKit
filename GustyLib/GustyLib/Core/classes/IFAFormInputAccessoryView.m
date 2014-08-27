//
// Created by Marcelo Schroeder on 27/08/2014.
// Copyright (c) 2014 InfoAccent Pty Ltd. All rights reserved.
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

#import "IFAFormInputAccessoryView.h"
#import "UITableView+IFACategory.h"

@interface IFAFormInputAccessoryView ()

@property (weak, nonatomic) UITableView *IFA_tableView;
@property (strong, nonatomic) NSIndexPath *currentInputFieldIndexPath;
@property (strong, nonatomic) NSIndexPath *previousInputFieldIndexPath;
@property (strong, nonatomic) NSIndexPath *nextInputFieldIndexPath;
@property(nonatomic) BOOL IFA_scrollRequested;
@property (strong, nonatomic) NSIndexPath *IFA_scrollPendingIndexPath;

@end

@implementation IFAFormInputAccessoryView {

}

#pragma mark - Private

- (void)IFA_updateUiState {
    BOOL l_previousButtonEnabled = self.previousInputFieldIndexPath != nil;
    [self.segmentedControl setEnabled:l_previousButtonEnabled forSegmentAtIndex:0];
    BOOL l_nextButtonEnabled = self.nextInputFieldIndexPath != nil;
    [self.segmentedControl setEnabled:l_nextButtonEnabled forSegmentAtIndex:1];
}

- (NSIndexPath *)IFA_indexPathForDirection:(IFAFormInputAccessoryViewDirection)a_direction {
//    NSLog(@" ");
//    NSLog(@"self.currentInputFieldIndexPath: %@", [self.currentInputFieldIndexPath description]);

    NSIndexPath *l_inputFieldIndexPath = nil;

    NSInteger l_loopIncrement = (a_direction == IFAFormInputAccessoryViewDirectionNext) ? 1 : -1;

    NSInteger l_numberOfSections = [self.IFA_tableView.dataSource numberOfSectionsInTableView:self.IFA_tableView];
//    NSLog(@"l_numberOfSections: %u", l_numberOfSections);
    for (NSInteger l_section = self.currentInputFieldIndexPath.section; l_section >= 0 && l_section < l_numberOfSections; ) {
        @autoreleasepool {
            NSInteger l_numberOfRows = [self.IFA_tableView.dataSource tableView:self.IFA_tableView
                                                          numberOfRowsInSection:l_section];
//            NSLog(@"l_numberOfRows: %u", l_numberOfRows);
            NSInteger l_startRow = 0;
            if (l_section==self.currentInputFieldIndexPath.section) {
                l_startRow = self.currentInputFieldIndexPath.row;
            }else if(a_direction == IFAFormInputAccessoryViewDirectionPrevious){
                l_startRow = l_numberOfRows - 1;
            }
            for (NSInteger l_row = l_startRow; l_row >= 0 && l_row < l_numberOfRows; ) {
                @autoreleasepool {
//                    NSLog(@"  %u-%u", l_section, l_row);
                    NSIndexPath *l_indexPath = [NSIndexPath indexPathForRow:l_row inSection:l_section];
                    if (![l_indexPath isEqual:self.currentInputFieldIndexPath]) {
//                        NSLog(@"    not current field");
                        if ([self.dataSource formInputAccessoryView:self canReceiveKeyboardInputAtIndexPath:l_indexPath]) {
//                            NSLog(@"      is input field");
                            l_inputFieldIndexPath = l_indexPath;
                            goto label_inputFieldCellFound;
                        }
                    }
                    l_row += l_loopIncrement;
                }
            }
            l_section += l_loopIncrement;
        }
    }
    label_inputFieldCellFound:

    return l_inputFieldIndexPath;
}

#pragma mark - Public

- (id)initWithTableView:(UITableView *)a_tableView {

    if(self = [super init]){
        self.IFA_tableView = a_tableView;
        NSBundle *l_bundle = [NSBundle bundleForClass:[self class]];
        [l_bundle loadNibNamed:@"IFAFormInputAccessoryContentView" owner:self options:nil];
        [self addSubview:self.contentView];
        self.frame = self.contentView.frame;
    }

    return self;
}

- (void)notifyOfCurrentInputFieldIndexPath:(NSIndexPath *)a_indexPath {
    self.currentInputFieldIndexPath = a_indexPath;
    self.previousInputFieldIndexPath = [self IFA_indexPathForDirection:IFAFormInputAccessoryViewDirectionPrevious];
    self.nextInputFieldIndexPath = [self IFA_indexPathForDirection:IFAFormInputAccessoryViewDirectionNext];
//    NSLog(@" ");
//    NSLog(@"self.currentInputFieldIndexPath: %@", [self.currentInputFieldIndexPath description]);
//    NSLog(@"self.previousInputFieldIndexPath: %@", [self.previousInputFieldIndexPath description]);
//    NSLog(@"self.nextInputFieldIndexPath: %@", [self.nextInputFieldIndexPath description]);
    [self IFA_updateUiState];
}

- (void)notifyTableViewDidEndScrollingAnimation {
    if (self.IFA_scrollRequested && [self.IFA_scrollPendingIndexPath isEqual:self.currentInputFieldIndexPath]) {
        self.IFA_scrollRequested = NO;
        [[self.dataSource formInputAccessoryView:self
      responderForKeyboardInputFocusAtIndexPath:self.currentInputFieldIndexPath] becomeFirstResponder];
    }
}

- (IBAction)onSegmentedControlValueChanged:(UISegmentedControl *)a_segmentedControl {
    NSIndexPath * l_indexPath;
    if (a_segmentedControl.selectedSegmentIndex==0) {
        l_indexPath = self.previousInputFieldIndexPath;
    }else{
        l_indexPath = self.nextInputFieldIndexPath;
    }
    self.currentInputFieldIndexPath = l_indexPath;
    if (l_indexPath) {
        if ([self.IFA_tableView ifa_isCellFullyVisibleForRowAtIndexPath:l_indexPath]) {
            [[self.dataSource formInputAccessoryView:self responderForKeyboardInputFocusAtIndexPath:l_indexPath] becomeFirstResponder];
        }else{
            [self.IFA_tableView scrollToRowAtIndexPath:l_indexPath
                                      atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            self.IFA_scrollRequested = YES;
            self.IFA_scrollPendingIndexPath = l_indexPath;
        }
    }
}

- (IBAction)onDoneButtonTap:(UIBarButtonItem *)sender {
    [self.IFA_tableView endEditing:YES];
}

@end