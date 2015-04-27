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

#import "GustyAppKitCoreApp.h"


@implementation IFAUIUtils (IFACoreApp)

+ (void)setKeyWindowRootViewController:(UIViewController*)a_viewController{
//    [self dismissSplitViewControllerPopover];
    [UIApplication sharedApplication].keyWindow.rootViewController = a_viewController;
}

+ (void)setKeyWindowRootViewControllerToMainStoryboardInitialViewController {
    [self setKeyWindowRootViewController:[[[IFAUIConfiguration sharedInstance] storyboard] instantiateInitialViewController]];
}

+ (CGSize)statusBarSize{
    return [self statusBarFrame].size;
}

+ (CGSize)statusBarSizeForCurrentOrientation{
    CGSize l_statusBarSize = [self statusBarSize];
    return [self isDeviceInLandscapeOrientation] && ![IFAUtils isIOS8OrGreater] ? CGSizeMake(l_statusBarSize.height, l_statusBarSize.width) : l_statusBarSize;
}

+ (CGRect)statusBarFrame{
    return [[UIApplication sharedApplication] statusBarFrame];
}

+(void)appLogWithTitle:(NSString*)a_title
               message:(NSString*)a_message
              location:(CLLocation*)a_location
                 error:(NSError*)a_error
             showAlert:(BOOL)a_showAlert{
//    NSLog(@"%@ - %@", a_title, a_message);
    IFAApplicationLog *dbLogEntry = (IFAApplicationLog *) [[IFAPersistenceManager sharedInstance] instantiate:@"IFAApplicationLog"];
    dbLogEntry.date = [NSDate date];
    dbLogEntry.title = a_title;
    dbLogEntry.message = a_message;
    if (a_location) {
        dbLogEntry.isLocationAware = @(YES);
        dbLogEntry.latitude = @(a_location.coordinate.latitude);
        dbLogEntry.longitude = @(a_location.coordinate.longitude);
        dbLogEntry.horizontalAccuracy = @(a_location.horizontalAccuracy);
    }else{
        dbLogEntry.isLocationAware = @(NO);
    }
    if (a_error) {
        dbLogEntry.isError = @(YES);
        dbLogEntry.errorCode = @([a_error code]);
        dbLogEntry.errorDescription = [a_error localizedDescription];
    }else{
        dbLogEntry.isError = @(NO);
    }
    [[IFAPersistenceManager sharedInstance] save];
    if (a_showAlert) {
        if ([UIApplication sharedApplication].applicationState==UIApplicationStateActive) {
            [IFAUIUtils showAlertWithMessage:a_message title:a_title];
        }else if ([UIApplication sharedApplication].applicationState==UIApplicationStateBackground) {
            UILocalNotification *l_localNotification = [[UILocalNotification alloc] init];
            if (l_localNotification) {
                l_localNotification.alertBody = [NSString stringWithFormat:@"%@: %@", a_title, a_message];
                [[UIApplication sharedApplication] presentLocalNotificationNow:l_localNotification];
            }
        }
    }
}

+(void)appLogWithTitle:(NSString*)a_title message:(NSString*)a_message;{
    [self appLogWithTitle:a_title message:a_message location:nil error:nil showAlert:NO];
}

+(IFAMenuViewController *)mainMenuViewController {
    IFAMenuViewController *l_menuViewController = nil;
    UIViewController *l_rootViewController = [[UIApplication sharedApplication].delegate.window rootViewController];
    if ([l_rootViewController isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *l_splitViewController = (UISplitViewController *) l_rootViewController;
        UINavigationController *l_navigationController = (UINavigationController *) (l_splitViewController.viewControllers)[0];
        l_menuViewController = (IFAMenuViewController *) l_navigationController.topViewController;
    }
    return l_menuViewController;
}

+ (void) showAlertWithMessage:(NSString*)aMessage title:(NSString*)aTitle{
    [self showAlertWithMessage:aMessage
                         title:aTitle
                      delegate:nil
                   buttonLabel:nil];
}

+ (void) showAlertWithMessage:(NSString*)aMessage title:(NSString*)aTitle buttonLabel:(NSString*)aButtonLabel{
    [self showAlertWithMessage:aMessage
                         title:aTitle
                      delegate:nil
                   buttonLabel:aButtonLabel];
}

+ (void) showAlertWithMessage:(NSString*)aMessage title:(NSString*)aTitle delegate:(id)aDelegate{
    [self showAlertWithMessage:aMessage
                         title:aTitle
                      delegate:aDelegate
                   buttonLabel:nil];
}

+ (void) showAlertWithMessage:(NSString*)aMessage
                        title:(NSString*)aTitle
                     delegate:(id)aDelegate
                  buttonLabel:(NSString*)aButtonLabel{
    [self showAlertWithMessage:aMessage title:aTitle delegate:aDelegate buttonLabel:aButtonLabel tag:NSNotFound];
}

+ (void) showAlertWithMessage:(NSString*)aMessage title:(NSString*)aTitle delegate:(id)aDelegate buttonLabel:(NSString*)aButtonLabel tag:(NSInteger)aTag{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:aTitle message:aMessage
                                                   delegate:aDelegate
                                          cancelButtonTitle:(aButtonLabel==nil?NSLocalizedStringFromTable(@"Continue", @"GustyKitLocalizable", nil):aButtonLabel)
                                          otherButtonTitles:nil];
//	alert.accessibilityLabel = aTitle;
    if (aTag!=NSNotFound) {
        alert.tag = aTag;
    }
    [alert show];
}

+ (void) showActionSheetWithMessage:(NSString*)aMessage
       destructiveButtonLabelSuffix:(NSString*)aDestructiveButtonLabelSuffix
                     viewController:(UIViewController*)aViewController
                      barButtonItem:(UIBarButtonItem*)aBarButtonItem
                           delegate:(id<UIActionSheetDelegate>)aDelegate{
    [self showActionSheetWithMessage:aMessage
        destructiveButtonLabelSuffix:aDestructiveButtonLabelSuffix
                      viewController:aViewController
                       barButtonItem:aBarButtonItem
                            delegate:aDelegate
                                 tag:0];
}

+ (void) showActionSheetWithMessage:(NSString*)aMessage
       destructiveButtonLabelSuffix:(NSString*)aDestructiveButtonLabelSuffix
                     viewController:(UIViewController*)aViewController
                      barButtonItem:(UIBarButtonItem*)aBarButtonItem
                           delegate:(id<UIActionSheetDelegate>)aDelegate
                                tag:(NSInteger)aTag{
    [self showActionSheetWithMessage:aMessage
             cancelButtonLabelSuffix:nil
        destructiveButtonLabelSuffix:aDestructiveButtonLabelSuffix
                                view:[self actionSheetShowInViewForViewController:aViewController]
                       barButtonItem:aBarButtonItem
                            delegate:aDelegate
                                 tag:aTag];
}

+ (void) showActionSheetWithMessage:(NSString*)aMessage
            cancelButtonLabelSuffix:(NSString*)aCancelButtonLabelSuffix
       destructiveButtonLabelSuffix:(NSString*)aDestructiveButtonLabelSuffix
                               view:(UIView*)aView
                      barButtonItem:(UIBarButtonItem*)aBarButtonItem
                           delegate:(id<UIActionSheetDelegate>)aDelegate
                                tag:(NSInteger)aTag{
    UIActionSheet *actionSheet =
            [[UIActionSheet alloc] initWithTitle:aMessage
                                        delegate:aDelegate
                               cancelButtonTitle:[NSLocalizedStringFromTable(@"No", @"GustyKitLocalizable", nil) stringByAppendingString:(aCancelButtonLabelSuffix?[NSString stringWithFormat:@", %@", aCancelButtonLabelSuffix]:@"")]
                          destructiveButtonTitle:[NSLocalizedStringFromTable(@"Yes, ", @"GustyKitLocalizable", nil) stringByAppendingString:aDestructiveButtonLabelSuffix]
                               otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
//    NSLog(@"aView: %@", [aView description]);
    if ([IFAUIUtils isIPad] && aBarButtonItem) {
        [actionSheet showFromBarButtonItem:aBarButtonItem animated:YES];
    }else {
        [actionSheet showInView:aView];
    }
    if(aTag!=0){
        actionSheet.tag = aTag;
    }
}

+(UIView*)actionSheetShowInViewForViewController:(UIViewController*)a_viewController{
    UIView *l_view = nil;
    if (!(l_view = a_viewController.tabBarController.view)) {
        if (!(l_view = a_viewController.splitViewController.view)) {
            l_view = a_viewController.navigationController.toolbar;
            if (l_view.hidden || !l_view) { // Added check for hidden is it was crashing the app in some cases when the toolbar was not visible and it had been used by a view controller that had been pushed
                l_view = a_viewController.view;
            }
        }
    }
    return l_view;
}

+ (void)showServerErrorAlertViewForNetworkReachable:(BOOL)a_networkReachable
                                  alertViewDelegate:(id <UIAlertViewDelegate>)a_alertViewDelegate {
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *l_title;
    NSString *l_messageArgument;
    if (a_networkReachable) {
        l_title= NSLocalizedStringFromTable(@"Server error", @"GustyKitLocalizable", nil);
        l_messageArgument = NSLocalizedStringFromTable(@" Please try again later.", @"GustyKitLocalizable", nil);
    }else{
        l_title= NSLocalizedStringFromTable(@"No Internet access", @"GustyKitLocalizable", nil);
        l_messageArgument = NSLocalizedStringFromTable(@" Please try again when you are back online.", @"GustyKitLocalizable", nil);
    }
    NSString *l_message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"It was not possible to complete the operation.%@", @"GustyKitLocalizable", nil), l_messageArgument];
    [IFAUIUtils showAlertWithMessage:l_message title:l_title delegate:a_alertViewDelegate];
}

@end