//
//  IAUITabBarController.m
//  Gusty
//
//  Created by Marcelo Schroeder on 18/05/11.
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

#import "IACommon.h"


@implementation IAUITabBarController

#pragma mark - Private

-(void)m_selectViewController:(UIViewController*)a_viewController{
//    NSLog(@"going to select tab view controller...");
    self.selectedViewController = a_viewController;
    [self tabBarController:self didSelectViewController:self.selectedViewController];
//    NSLog(@"tab view controller selected");
}

- (void)oncontextSwitchRequestGrantedNotification:(NSNotification*)aNotification{
//    NSLog(@"IA_NOTIFICATION_CONTEXT_SWITCH_REQUEST_GRANTED received by %@", [self description]);
    [self m_selectViewController:aNotification.object];
}

-(void)m_releaseMemory{
//    NSLog(@"m_releaseMemory in %@", [self description]);
    for (UIViewController *l_viewController in self.viewControllers) {
//        NSLog(@"   inspecting view controller: %@", [l_viewController description]);
        if (l_viewController!=self.selectedViewController) {
//            NSLog(@"      not selected - releasing view...");
            [l_viewController m_releaseView];
        }
    }
}

-(void)m_onApplicationDidEnterBackgroundNotification:(NSNotification *)aNotification{
    [self m_releaseMemory];
}

#pragma mark - UITabBarControllerDelegate

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{

    //    NSLog(@"shouldSelectViewController: %@", [viewController description]);
    
    // Check if we are in help mode first
    if ([IAHelpManager m_instance].p_helpMode) {
        NSUInteger l_selectedViewControllerIndex = [self.viewControllers indexOfObject:viewController];
        UITabBarItem *l_tabBarItem = ((UITabBarItem*)[tabBarController.tabBar.items objectAtIndex:l_selectedViewControllerIndex]);
        NSString *l_title = l_tabBarItem.title;
        if (!l_title && [viewController isKindOfClass:[UINavigationController class]]) {
            // If a title is not available (e.g. the tab bar item is a system item), then it will attempt to derive the title from the navigation controller's root view controller
            UINavigationController *l_navigationController = (UINavigationController*)viewController;
            UIViewController *l_rootViewController = [l_navigationController.viewControllers objectAtIndex:0];
            l_title = l_rootViewController.title;
        }
        l_title = [NSString stringWithFormat:@"%@ Tab", l_title];
        [[IAHelpManager m_instance] m_helpRequestedForTabBarItemIndex:l_selectedViewControllerIndex helpTargetId:l_tabBarItem.p_helpTargetId title:l_title];
        return NO;
    }
    
    BOOL l_shouldSelectViewController = YES;
    if ([self.selectedViewController isKindOfClass:[IAUINavigationController class]]) {
        IAUINavigationController *l_selectedNavigationController = (IAUINavigationController*)self.selectedViewController;
//        NSLog(@"l_navigationController.p_contextSwitchRequestRequired: %u", l_selectedNavigationController.p_contextSwitchRequestRequired);
        if (l_selectedNavigationController.p_contextSwitchRequestRequired) {
            NSNotification *l_notification = [NSNotification notificationWithName:IA_NOTIFICATION_CONTEXT_SWITCH_REQUEST object:viewController userInfo:nil];
            [[NSNotificationQueue defaultQueue] enqueueNotification:l_notification 
                                                       postingStyle:NSPostASAP
                                                       coalesceMask:NSNotificationNoCoalescing 
                                                           forModes:nil];
//            NSLog(@" ");
//            NSLog(@"IA_NOTIFICATION_CONTEXT_SWITCH_REQUEST sent by %@", [self description]);
            return NO;
        }
    }
    return l_shouldSelectViewController;

}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//    NSLog(@"didSelectViewController: %@", [viewController description]);
//    if (v_previousViewController && [v_previousViewController isKindOfClass:[UINavigationController class]]) {
//        UINavigationController *l_navigationController = (UINavigationController*)viewController;
//        NSLog(@"[l_navigationController.viewControllers count]: %u", [l_navigationController.viewControllers count]);
//        NSLog(@"[l_navigationController.topViewController description]: %@", [l_navigationController.topViewController description]);
//    }
    if (v_previousViewController && [v_previousViewController isKindOfClass:[UINavigationController class]]) {
        // If the previously selected view controller is a navigation controller then make sure to pop to its root view controller
        //  in order to minimise memory requirements and avoid complications with entities being changed somewhere else (for now)
        UINavigationController *l_navigationController = (UINavigationController*)v_previousViewController;
//        NSLog(@"before...");
//        NSLog(@"  [l_navigationController.viewControllers count]: %u", [l_navigationController.viewControllers count]);
//        NSLog(@"  [l_navigationController.topViewController description]: %@", [l_navigationController.topViewController description]);
        [l_navigationController popToRootViewControllerAnimated:NO];
//        NSLog(@"...after");
//        NSLog(@"[l_navigationController.viewControllers count]: %u", [l_navigationController.viewControllers count]);
//        NSLog(@"[l_navigationController.topViewController description]: %@", [l_navigationController.topViewController description]);
    }
    v_previousViewController = viewController;
    [IAUIUtils m_postNavigationEventNotification];
}

#pragma mark - Overrides

-(id)initWithCoder:(NSCoder *)aDecoder{

    self = [super initWithCoder:aDecoder];

    self.customizableViewControllers = nil;
    self.delegate = self;
    v_previousViewController = [self.viewControllers objectAtIndex:0];
    
    // Add observers
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(oncontextSwitchRequestGrantedNotification:)
                                                 name:IA_NOTIFICATION_CONTEXT_SWITCH_REQUEST_GRANTED
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(m_onApplicationDidEnterBackgroundNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    return self;
}

-(void)dealloc{
    
    // Remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IA_NOTIFICATION_CONTEXT_SWITCH_REQUEST_GRANTED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self m_viewDidLoad];
    self.navigationItem.leftItemsSupplementBackButton = YES;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return [self m_shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

-(NSUInteger)supportedInterfaceOrientations{
    return [self m_supportedInterfaceOrientations];
}

-(void)didReceiveMemoryWarning{
//    NSLog(@"didReceiveMemoryWarning in %@", [self description]);
    [super didReceiveMemoryWarning];
    [self m_releaseMemory];
}

@end