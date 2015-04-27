//
// Created by Marcelo Schroeder on 24/04/15.
// Copyright (c) 2015 InfoAccent Pty Ltd. All rights reserved.
//
//  Created by Marcelo Schroeder on 30/08/11.
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

#import "GustyAppKitCoreApp.h"


@implementation IFAAppDefaultAppearanceTheme {

}

#pragma mark - Overrides

- (void)setTextAppearanceForSelectedContentSizeCategoryInObject:(id)a_object {
    [super setTextAppearanceForSelectedContentSizeCategoryInObject:a_object];
    if ([a_object isKindOfClass:[IFAAboutFormViewController class]]) {
        IFAAboutFormViewController *obj = (IFAAboutFormViewController *) a_object;
        obj.appNameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        obj.copyrightNoticeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    }
}

- (UIViewController *)newInternalWebBrowserViewControllerWithUrl:(NSURL *)a_url{
    return [self newInternalWebBrowserViewControllerWithUrl:a_url completionBlock:nil];
}

- (UIViewController *)newInternalWebBrowserViewControllerWithUrl:(NSURL *)a_url completionBlock:(void(^)(void))a_completionBlock{
    IFAInternalWebBrowserViewController *l_viewController = [[IFAInternalWebBrowserViewController alloc] initWithURL:a_url completionBlock:a_completionBlock];
    return l_viewController;
}

- (void)setAppearanceOnViewDidLoadForViewController:(UIViewController *)a_viewController {
    [super setAppearanceOnViewDidLoadForViewController:a_viewController];
    if ([a_viewController isKindOfClass:[IFAMasterDetailViewController class]]) {
        IFAMasterDetailViewController *l_viewController = (IFAMasterDetailViewController *) a_viewController;
        l_viewController.separatorView.backgroundColor = [self.class splitViewControllerDividerColour];
    }
}

- (UIColor *)defaultTintColor {
    return [UIApplication sharedApplication].delegate.window.tintColor;
}

@end