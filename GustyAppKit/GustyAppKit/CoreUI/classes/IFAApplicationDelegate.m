//
//  IFAApplicationDelegate.m
//  Gusty
//
//  Created by Marcelo Schroeder on 21/05/12.
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

#import "GustyAppKitCoreUI.h"

@interface IFAApplicationDelegate ()
@end

@implementation IFAApplicationDelegate


#pragma mark - Private

- (IFAUIConfiguration *)IFA_uiConfiguration {
    return [IFAUIConfiguration sharedInstance];
}

-(void)IFA_configureWindowRootViewController {
    self.window.rootViewController = [self.IFA_uiConfiguration initialViewController];
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{

    // Observe keyboard visibility changes
    [[IFAKeyboardVisibilityManager sharedInstance] startObservingKeyboard];

    // Configure the app's window
    if (!self.skipWindowSetup) {
        self.window = [[UIWindow alloc] initWithFrame:[IFAUIUtils screenBounds]];
        [self.window makeKeyAndVisible];
    }

    // Make sure to initialise the appearance theme
    [self.IFA_uiConfiguration appearanceTheme];

    // Apply appearance using the appearance manager
    [[IFAAppearanceThemeManager sharedInstance] applyAppearanceTheme];

    // Configure the window's root view controller
    if (!self.skipWindowSetup && !self.skipWindowRootViewControllerSetup) {

        // Configure the window's root view controller
        [self IFA_configureWindowRootViewController];

    }

    return YES;
	
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
	//TODO: review this behaviour - are we making the most of NSCache here? (i.e. by removing everything from the cache)
	//	I did a lot of testing with IFAPurgeableObject and always all entries would get evicted, even with setEvictsObjectsWithDiscardedContent true
	//  And removing the removeAllObjects lines below does not do anything if a memory warning is received (probably because it's hard to test
	//	under normal memory circumstances)
    //	NSLog(@"*** applicationDidReceiveMemoryWarning ***");
	[[IFADynamicCache sharedInstance] removeAllObjects];
}

- (void)                application:(UIApplication *)application
didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [[IFAUserNotificationSettingsManager sharedInstance] notifyRegistrationOfUserNotificationSettings:notificationSettings];
}

@end
