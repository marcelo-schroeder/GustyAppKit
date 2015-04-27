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

@end