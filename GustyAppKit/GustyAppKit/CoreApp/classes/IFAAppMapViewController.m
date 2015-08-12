//
// Created by Marcelo Schroeder on 27/04/15.
// Copyright (c) 2015 InfoAccent Pty Ltd. All rights reserved.
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

#import "GustyAppKitCoreApp.h"


@implementation IFAAppMapViewController {

}

#pragma mark - Overrides

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Add observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(IFA_onLocationAuthorizationStatusChange:)
                                                 name:IFANotificationLocationAuthorizationStatusChange
                                               object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];

    // Remover observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IFANotificationLocationAuthorizationStatusChange object:nil];

}

#pragma mark - Private

-(void)IFA_onLocationAuthorizationStatusChange:(NSNotification*)a_notification {
    // Respond to authorisation changes requested by this view controller
    if ([UIApplication sharedApplication].applicationState==UIApplicationStateActive) {
        [self locateUserDueToUserRequest:NO
                         completionBlock:nil];
    }
}

@end