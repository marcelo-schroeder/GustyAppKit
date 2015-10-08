//
// Created by Marcelo Schroeder on 24/04/15.
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

#import <Foundation/Foundation.h>
#import <GustyKit/IFAUIUtils.h>

@interface IFAUIUtils (IFACoreApp)
+ (void)setKeyWindowRootViewController:(UIViewController *)a_viewController;

+ (void)setKeyWindowRootViewControllerToMainStoryboardInitialViewController;

+ (CGSize)statusBarSize;

+ (CGSize)statusBarSizeForCurrentOrientation;

+ (CGRect)statusBarFrame;

+ (void)appLogWithTitle:(NSString *)a_title
                message:(NSString *)a_message
               location:(CLLocation *)a_location
                  error:(NSError *)a_error
              showAlert:(BOOL)a_showAlert;

+ (void)appLogWithTitle:(NSString *)a_title
                message:(NSString *)a_message;

+ (IFAMenuViewController *)mainMenuViewController;

/**
* Deprecated as of iOS 8. Use IFAUIUtils' presentAlertController* methods or UIViewController+IFACoreUI's ifa_presentAlertController* methods in GustyKit instead.
* @param aMessage Alert's message.
* @param aTitle Alert's title.
*/
+ (void)showAlertWithMessage:(NSString *)aMessage
                       title:(NSString *)aTitle;

/**
* Deprecated as of iOS 8. Use IFAUIUtils' presentAlertController* methods or UIViewController+IFACoreUI's ifa_presentAlertController* methods in GustyKit instead.
* @param aMessage Alert's message.
* @param aTitle Alert's title.
* @param aButtonLabel Button's label.
*/
+ (void)showAlertWithMessage:(NSString *)aMessage
                       title:(NSString *)aTitle
                 buttonLabel:(NSString *)aButtonLabel;

/**
* Deprecated as of iOS 8. Use IFAUIUtils' presentAlertController* methods or UIViewController+IFACoreUI's ifa_presentAlertController* methods in GustyKit instead.
* @param aMessage Alert's message.
* @param aTitle Alert's title.
* @param aDelegate Alert's delegate implementing UIAlertViewDelegate.
*/
+ (void)showAlertWithMessage:(NSString *)aMessage
                       title:(NSString *)aTitle
                    delegate:(id)aDelegate;

/**
* Deprecated as of iOS 8. Use IFAUIUtils' presentAlertController* methods or UIViewController+IFACoreUI's ifa_presentAlertController* methods in GustyKit instead.
* @param aMessage Alert's message.
* @param aTitle Alert's title.
* @param aDelegate Alert's delegate implementing UIAlertViewDelegate.
* @param aButtonLabel Button's label.
*/
+ (void)showAlertWithMessage:(NSString *)aMessage
                       title:(NSString *)aTitle
                    delegate:(id)aDelegate
                 buttonLabel:(NSString *)aButtonLabel;

/**
* Deprecated as of iOS 8. Use IFAUIUtils' presentAlertController* methods or UIViewController+IFACoreUI's ifa_presentAlertController* methods in GustyKit instead.
* @param aMessage Alert's message.
* @param aTitle Alert's title.
* @param aDelegate Alert's delegate implementing UIAlertViewDelegate.
* @param aButtonLabel Button's label.
* @param aTag Tag for the alert view.
*/
+ (void)showAlertWithMessage:(NSString *)aMessage
                       title:(NSString *)aTitle
                    delegate:(id)aDelegate
                 buttonLabel:(NSString *)aButtonLabel
                         tag:(NSInteger)aTag;

+ (void)showActionSheetWithMessage:(NSString *)aMessage
      destructiveButtonLabelSuffix:(NSString *)aDestructiveButtonLabelSuffix
                    viewController:(UIViewController *)aViewController
                     barButtonItem:(UIBarButtonItem *)aBarButtonItem
                          delegate:(id <UIActionSheetDelegate>)aDelegate;

+ (void)showActionSheetWithMessage:(NSString *)aMessage
      destructiveButtonLabelSuffix:(NSString *)aDestructiveButtonLabelSuffix
                    viewController:(UIViewController *)aViewController
                     barButtonItem:(UIBarButtonItem *)aBarButtonItem
                          delegate:(id <UIActionSheetDelegate>)aDelegate
                               tag:(NSInteger)aTag;

+ (void)showActionSheetWithMessage:(NSString *)aMessage
           cancelButtonLabelSuffix:(NSString *)aCancelButtonLabelSuffix
      destructiveButtonLabelSuffix:(NSString *)aDestructiveButtonLabelSuffix
                              view:(UIView *)aView
                     barButtonItem:(UIBarButtonItem *)aBarButtonItem
                          delegate:(id <UIActionSheetDelegate>)aDelegate
                               tag:(NSInteger)aTag;

+ (UIView *)actionSheetShowInViewForViewController:(UIViewController *)a_viewController;

+ (void)showServerErrorAlertViewForNetworkReachable:(BOOL)a_networkReachable
                                  alertViewDelegate:(id <UIAlertViewDelegate>)a_alertViewDelegate;

@end