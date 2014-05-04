//
//  IFAAboutFormViewController.m
//  Gusty
//
//  Created by Marcelo Schroeder on 20/09/12.
//  Copyright (c) 2012 InfoAccent Pty Limited. All rights reserved.
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

#import "IFACommon.h"

@interface IFAAboutFormViewController ()

@property (nonatomic, strong) UIBarButtonItem *ifa_reportBugBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *ifa__provideFeedbackBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *ifa_forceCrashBarButtonItem;
@property (nonatomic, strong) IFAEmailManager *ifa_emailManager;

@end

@implementation IFAAboutFormViewController {
    
}

#pragma mark - Private

-(NSString*)ifa_supportEmailAddress {
    return [[IFAUtils infoPList] objectForKey:@"IASupportEmailAddress"];
}

- (void)ifa_ReportBugButtonTap:(id)sender{
    NSString *l_body = [NSString stringWithFormat:@"Hi there,\n\nPlease fix the following bug I have found in %@:", [IFAUtils appFullName]];
    [self.ifa_emailManager composeEmailWithSubject:[NSString stringWithFormat:@"%@ In-App Bug Report",
                                                                              [IFAUtils appNameAndEdition]]
                                         recipient:[self ifa_supportEmailAddress] body:l_body];
}

- (void)ifa_provideFeedbackButtonTap:(id)sender{
    NSString *l_body = [NSString stringWithFormat:@"Hi there,\n\nI have the following feedback to provide for %@:", [IFAUtils appFullName]];
    [self.ifa_emailManager composeEmailWithSubject:[NSString stringWithFormat:@"%@ In-App Feedback",
                                                                              [IFAUtils appNameAndEdition]]
                                         recipient:[self ifa_supportEmailAddress] body:l_body];
}

- (void)ifa_forceCrashButtonTap:(id)sender{
    [IFAUtils forceCrash];
}

#pragma mark - Overrides

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self=[super initWithCoder:aDecoder]) {
        
        // Populate model object
        IFAAboutInfoModel *l_model = [IFAAboutInfoModel new];
        l_model.edition = [IFAUtils appEdition];
        l_model.version = [IFAUtils appVersionAndBuildNumber];
        NSArray *l_appCreators = [[IFAUtils infoPList] objectForKey:@"IAAppCreators"];
        l_model.creatorName = l_appCreators[0][@"name"];
        l_model.creatorUrl = l_appCreators[0][@"url"];
        NSArray *l_appVisualDesigners = [[IFAUtils infoPList] objectForKey:@"IAAppVisualDesigners"];
        l_model.visualDesignerName = l_appVisualDesigners[0][@"name"];
        l_model.visualDesignerUrl = l_appVisualDesigners[0][@"url"];
        
        // Configure form view controller
        self.object = l_model;
        self.readOnlyMode = YES;
        self.createMode = NO;
        
        // Configure toolbar buttons
        self.ifa_reportBugBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Report Bug"
                                                                         style:UIBarButtonItemStyleBordered target:self
                                                                        action:@selector(ifa_ReportBugButtonTap:)];
        self.ifa__provideFeedbackBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Provide Feedback"
                                                                               style:UIBarButtonItemStyleBordered
                                                                              target:self
                                                                              action:@selector(ifa_provideFeedbackButtonTap:)];
        self.ifa_forceCrashBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Force Crash"
                                                                          style:UIBarButtonItemStyleBordered target:self
                                                                         action:@selector(ifa_forceCrashButtonTap:)];
        
        // Configure email manager
        self.ifa_emailManager = [[IFAEmailManager alloc] initWithParentViewController:self];
        
        // Configure custom view
        [[NSBundle mainBundle] loadNibNamed:@"IFAAboutCustomView" owner:self options:nil];
        self.appNameLabel.text = [IFAUtils appName];
        self.copyrightNoticeLabel.text = [[IFAUtils infoPList] objectForKey:@"IACopyrightNotice"];
        
    }
    
    return self;
    
}

-(NSArray *)IFA_nonEditModeToolbarItems {
    UIBarButtonItem *l_flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSMutableArray *l_items = [NSMutableArray arrayWithArray:@[l_flexibleSpace, self.ifa_reportBugBarButtonItem, l_flexibleSpace, self.ifa__provideFeedbackBarButtonItem, l_flexibleSpace]];
    if ([[[IFAUtils infoPList] objectForKey:@"IAShowForceCrashButton"] boolValue]) {
        [l_items addObjectsFromArray:@[self.ifa_forceCrashBarButtonItem, l_flexibleSpace]];
    }
    return l_items;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self IFA_logAnalyticsScreenEntry];
}

#pragma mark - UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[self nameForIndexPath:indexPath] isEqualToString:@"appName"]) {
        return self.customView.frame.size.height;
    }else{
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *l_cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([[self nameForIndexPath:indexPath] isEqualToString:@"appName"]) {
        [l_cell.contentView addSubview:self.customView];
        [[self IFA_appearanceTheme] setLabelTextStyleForChildrenOfView:self.customView];
    }
    return l_cell;
}

@end
