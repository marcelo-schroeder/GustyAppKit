//
//  UIViewController+IACategory.m
//  Gusty
//
//  Created by Marcelo Schroeder on 16/11/11.
//  Copyright (c) 2011 InfoAccent Pty Limited. All rights reserved.
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
#import "UIStoryboard+IACategory.h"
#import "IAExternalUrlManager.h"
#import "IAUISubjectActivityItem.h"
#import "IAUIExternalWebBrowserActivity.h"
#import "IAUIPassthroughView.h"

//static UIPopoverArrowDirection  const k_arrowDirectionWithoutKeyboard   = UIPopoverArrowDirectionAny;
static UIPopoverArrowDirection  const k_arrowDirectionWithoutKeyboard   = UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown;
static UIPopoverArrowDirection  const k_arrowDirectionWithKeyboard      = UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionRight;
static BOOL                     const k_animated                        = YES;

static const int k_iPhoneLandscapeAdHeight = 32;
static char c_presenterKey;
static char c_activePopoverControllerKey;
static char c_activePopoverControllerBarButtonItemKey;
static char c_subTitleKey;
static char c_slidingMenuBarButtonItemKey;
static char c_titleViewDefaultKey;
static char c_helpTargetIdKey;
static char c_titleViewLandscapePhoneKey;
static char c_changesMadeByPresentedViewControllerKey;
static char c_helpBarButtonItemKey;
static char c_adContainerViewKey;
static char c_refreshControlKey;
static char c_fetchedResultsControllerKey;
static char c_keyboardPassthroughViewKey;
static char c_shouldUseKeyboardPassthroughViewKey;

@interface UIViewController (IACategory_Private)

@property (nonatomic, strong) UIPopoverController *p_activePopoverController;
@property (nonatomic, strong) UIBarButtonItem *p_activePopoverControllerBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *p_slidingMenuBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *p_helpBarButtonItem;
@property (nonatomic) BOOL p_changesMadeByPresentedViewController;
@property (nonatomic, strong) NSFetchedResultsController *p_fetchedResultsController;
@property (nonatomic, strong) IAUIPassthroughView *p_keyboardPassthroughView;

@end

@implementation UIViewController (IACategory)

#pragma mark - Private

-(void)ifa_presentModalSelectionViewController:(UIViewController *)a_viewController
                             fromBarButtonItem:(UIBarButtonItem *)a_fromBarButtonItem fromRect:(CGRect)a_fromRect inView:(UIView *)a_view{

//    NSLog(@"m_presentModalSelectionViewController: %@", [a_viewController description]);

    UIViewController *l_viewController = [a_viewController isKindOfClass:[UIActivityViewController class]] ? a_viewController : [[[[self IFA_appearanceTheme] navigationControllerClass] alloc] initWithRootViewController:a_viewController];
//    NSLog(@"  l_viewController: %@", [l_viewController description]);

    if ([a_viewController IFA_hasFixedSize]) {
        CGFloat l_width = a_viewController.view.frame.size.width;
        CGFloat l_height = a_viewController.view.frame.size.height + a_viewController.navigationController.navigationBar.frame.size.height + (a_viewController.p_needsToolbar ? a_viewController.navigationController.toolbar.frame.size.height : 0);
        l_viewController.view.frame = CGRectMake(0, 0, l_width, l_height);
//        NSLog(@"  l_viewController.view.frame: %@", NSStringFromCGRect(l_viewController.view.frame));
//        NSLog(@"  a_viewController.view.frame: %@", NSStringFromCGRect(a_viewController.view.frame));
    }
    
    if ([self conformsToProtocol:@protocol(IAUIPresenter)]) {
        a_viewController.p_presenter = (id<IAUIPresenter>)self;
    }

    if ([IAUIUtils isIPad]) { // If iPad present controller in a popover
        
        // Instantiate and configure popover controller
        UIPopoverController *l_popoverController = [self IFA_newPopoverControllerWithContentViewController:l_viewController];
        
        // Set the delegate
        if ([a_viewController conformsToProtocol:@protocol(UIPopoverControllerDelegate)]) {
            l_popoverController.delegate = (id<UIPopoverControllerDelegate>)a_viewController;
        }
        
        // Set the content size
        if ([a_viewController isKindOfClass:[IAUIAbstractFieldEditorViewController class]]) {
            // Popover controllers "merge" the navigation bar from the navigation controller with its border at the top.
            // Therefore we need to reduce the content height by that amount otherwise a small gap is shown at the bottom of the popover view.
            // The same goes for the toolbar when it exists.
            CGFloat l_newHeight = l_viewController.view.frame.size.height - (l_popoverController.p_borderThickness * (a_viewController.p_needsToolbar ? 2 : 1));
            l_popoverController.popoverContentSize = CGSizeMake(l_viewController.view.frame.size.width, l_newHeight);
        }
        
        // Present popover controller
        if (a_fromBarButtonItem) {
            [self IFA_presentPopoverController:l_popoverController fromBarButtonItem:a_fromBarButtonItem];
        }else{
            [self IFA_presentPopoverController:l_popoverController fromRect:a_fromRect inView:a_view];
        }
        
    }else { // If not iPad present as modal
        
        if ([a_viewController IFA_hasFixedSize]) {
            [self presentSemiModalViewController:l_viewController];
        }else {
            if ([a_viewController isKindOfClass:[UIActivityViewController class]]) {
                [self presentViewController:a_viewController animated:YES completion:NULL];
            }else{
                [self IFA_presentModalViewController:a_viewController presentationStyle:UIModalPresentationFullScreen
                                     transitionStyle:UIModalTransitionStyleCoverVertical];
            }
        }
        
    }
    
}

-(UIViewController *)p_presentedViewController{
    if ([self isKindOfClass:[IAUIAbstractPagingContainerViewController class]]) {
        IAUIAbstractPagingContainerViewController *l_pagingContainerViewController = (IAUIAbstractPagingContainerViewController*)self;
        return l_pagingContainerViewController.p_selectedViewController.presentedViewController ? l_pagingContainerViewController.p_selectedViewController.presentedViewController : self.presentedViewController;
    }else{
        return self.presentedViewController;
    }
}

-(void)setP_activePopoverController:(UIPopoverController*)a_activePopoverController{
    objc_setAssociatedObject(self, &c_activePopoverControllerKey, a_activePopoverController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setP_activePopoverControllerBarButtonItem:(UIBarButtonItem*)a_activePopoverControllerBarButtonItem{
    objc_setAssociatedObject(self, &c_activePopoverControllerBarButtonItemKey, a_activePopoverControllerBarButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)ifa_setActivePopoverController:(UIPopoverController *)a_popoverController
                            presenter:(UIViewController *)a_presenter barButtonItem:(UIBarButtonItem*)a_barButtonItem{
//    NSLog(@"a_popoverController.popoverContentSize: %@", NSStringFromCGSize(a_popoverController.popoverContentSize));
//    NSLog(@"a_popoverController.contentViewController.view.frame.size: %@", NSStringFromCGSize(a_popoverController.contentViewController.view.frame.size));
    self.p_activePopoverController = a_popoverController;
    [IAUIApplicationDelegate sharedInstance].p_popoverControllerPresenter = a_presenter;
    self.p_activePopoverControllerBarButtonItem = a_barButtonItem;
}

-(void)ifa_resizePopoverContent {
    UIPopoverController *l_popoverController = self.p_activePopoverController;
    UIViewController *l_contentViewController = l_popoverController.contentViewController;
    BOOL l_hasFixedSize =  [l_contentViewController isKindOfClass:[UINavigationController class]] ? [((UINavigationController *) l_contentViewController).topViewController IFA_hasFixedSize] : [l_contentViewController IFA_hasFixedSize];
    CGSize l_contentViewControllerSize = l_contentViewController.view.frame.size;
    if (l_hasFixedSize) {
        l_popoverController.popoverContentSize = l_contentViewControllerSize;
        NSLog(@"l_popoverController.popoverContentSize: %@", NSStringFromCGSize(l_popoverController.popoverContentSize));
    }
}

-(void)ifa_onMenuBarButtonItemInvalidated:(NSNotification*)a_notification{
//    NSLog(@"menu button invalidated - removing it...");
    [self IFA_removeLeftBarButtonItem:a_notification.object];
}

-(void)ifa_onSlidingMenuButtonAction:(UIBarButtonItem*)a_button{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

-(void)ifa_releaseViewForController:(UIViewController*)a_viewController{
//    NSLog(@"ifa_releaseViewForController: %@", [a_viewController description]);
    a_viewController.view = nil;
    a_viewController.p_previousVisibleViewController = nil;
    for (UIViewController *l_childViewController in a_viewController.childViewControllers) {
//        NSLog(@"   going to release view for child view controller: %@", [l_childViewController description]);
        [self ifa_releaseViewForController:l_childViewController];
    }
}

-(CGSize)IFA_gadAdFrameSize {
    CGFloat l_width, l_height;
    if ([IAUIUtils isIPad]) {
        l_width = self.view.frame.size.width;
        l_height = kGADAdSizeLeaderboard.size.height;
    }else{
        l_width = self.view.frame.size.width;
        l_height = [IAUIUtils isDeviceInLandscapeOrientation] ? k_iPhoneLandscapeAdHeight : kGADAdSizeBanner.size.height;
    }
    CGSize l_size = CGSizeMake(l_width, l_height);
//    NSLog(@"ifa_gadAdSize: %@", NSStringFromCGSize(l_size));
    return l_size;
}

-(GADAdSize)ifa_gadAdSize {
    return GADAdSizeFromCGSize([self IFA_gadAdFrameSize]);
}

-(GADBannerView *)IFA_gadBannerView {
    return [[IAUIApplicationDelegate sharedInstance] gadBannerView];
}

-(void)ifa_popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)ifa_spaceBarButtonItems:(NSMutableArray *)a_items firstItemSpacingType:(IAUISpacingBarButtonItemType)a_firstItemSpacingType{
    
    if (![[self IFA_appearanceTheme] shouldAutomateBarButtonItemSpacingForViewController:self]) {
        return;
    }
    
    NSArray *l_items = [NSArray arrayWithArray:a_items];
    [a_items removeAllObjects];
    for (int i=0; i<l_items.count; i++) {
        UIBarButtonItem *l_spacingBarButtonItem;
        if (i==0) {
            l_spacingBarButtonItem = [[self IFA_appearanceTheme] spacingBarButtonItemForType:a_firstItemSpacingType
                                                                            viewController:self];
        }else{
            l_spacingBarButtonItem = [[self IFA_appearanceTheme] spacingBarButtonItemForType:IAUISpacingBarButtonItemTypeMiddle
                                                                            viewController:self];
        }
        if (l_spacingBarButtonItem) {
            [a_items addObject:l_spacingBarButtonItem];
        }
        [a_items addObject:l_items[i]];
    }
    
}

-(void)ifa_removeAutomatedSpacingFromBarButtonItemArray:(NSMutableArray*)a_items{
    
    if (![[self IFA_appearanceTheme] shouldAutomateBarButtonItemSpacingForViewController:self]) {
        return;
    }
    
    NSMutableArray *l_objectsToRemove = [NSMutableArray new];
    for (UIBarButtonItem *l_barButtonItem in a_items) {
        if (l_barButtonItem.tag==IA_UIBAR_ITEM_TAG_FIXED_SPACE_BUTTON) {
            [l_objectsToRemove addObject:l_barButtonItem];
        }
    }
    [a_items removeObjectsInArray:l_objectsToRemove];
    
}

- (void)ifa_showLeftSlidingPaneButtonIfRequired {
    if ([self IFA_shouldShowLeftSlidingPaneButton]) {
        if (self.slidingViewController) {
            self.navigationController.view.layer.shadowOpacity = 0.75f;
            self.navigationController.view.layer.shadowRadius = 10.0f;
            self.navigationController.view.layer.shadowColor = [UIColor blackColor].CGColor;
            [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];

            BOOL l_shouldShowMenuButton = self.navigationController.topViewController==[self.navigationController.viewControllers objectAtIndex:0];
            if (l_shouldShowMenuButton) {
                if (!self.p_slidingMenuBarButtonItem) {
                    self.p_slidingMenuBarButtonItem = [[self IFA_appearanceTheme] slidingMenuBarButtonItemForViewController:self];
                    self.p_slidingMenuBarButtonItem.target = self;
                    self.p_slidingMenuBarButtonItem.action = @selector(ifa_onSlidingMenuButtonAction:);
                    self.p_slidingMenuBarButtonItem.tag = IA_UIBAR_ITEM_TAG_LEFT_SLIDING_PANE_BUTTON;
                }
                [self IFA_addToNavigationBarForSlidingMenuBarButtonItem:self.p_slidingMenuBarButtonItem];
            }
        }else if (self.splitViewController) {
            [self IFA_addLeftBarButtonItem:((IAUISplitViewController *) self.splitViewController).p_popoverControllerBarButtonItem];
        }
    }
}

- (void)ifa_updateAdContainerViewFrameWithAdBannerViewHeight:(CGFloat)a_adBannerViewHeight {
    UIView *l_adContainerView = self.p_adContainerView;
    CGRect l_newAdContainerViewFrame = l_adContainerView.frame;
    l_newAdContainerViewFrame.origin.y = self.view.frame.size.height - a_adBannerViewHeight;
    l_newAdContainerViewFrame.size.height = a_adBannerViewHeight;
    l_adContainerView.frame = l_newAdContainerViewFrame;
//    NSLog(@"adContainerView.frame 2: %@", NSStringFromCGRect(l_adContainerView.frame));
}

- (void)ifa_updateAdBannerSize {
//    NSLog(@"ifa_updateAdBannerSize");
    GADBannerView *l_bannerView = [self IFA_gadBannerView];
    CGRect l_newAdBannerViewFrame = CGRectZero;
    l_newAdBannerViewFrame.size = [self IFA_gadAdFrameSize];
    l_bannerView.frame = l_newAdBannerViewFrame;
//    NSLog(@"          l_bannerView.frame: %@", NSStringFromCGRect(l_bannerView.frame));
//    NSLog(@"self.p_adContainerView.frame: %@", NSStringFromCGRect(self.p_adContainerView.frame));
    l_bannerView.adSize = [self ifa_gadAdSize];
//    NSLog(@"    l_bannerView.adSize.size: %@", NSStringFromCGSize(l_bannerView.adSize.size));
//    NSLog(@"   l_bannerView.adSize.flags: %u", l_bannerView.adSize.flags);
}

// Determines the best presenting view controller for the situation.
//  For instance, a view controller set as the master view controller in a split view controller is not
//      the most appropriate view controller when presenting another view controller in portrait orientation.
//  If the device is rotated to landscape, the master view controller presented as a popover will be dismissed and so will
//      the presented view controller. In those case, it is better to present the view controller from the detail
//      view controller in the split view controller (which does not get dismissed if the device is rotated)
-(UIViewController*)ifa_appropriatePresentingViewController {
    BOOL l_shouldPresentingViewControllerBeSplitViewControllerDetail = NO;
    if (self.splitViewController) {
        UIViewController *l_masterViewController = self.splitViewController.viewControllers[0];
        if (l_masterViewController==self) {
            l_shouldPresentingViewControllerBeSplitViewControllerDetail = YES;
        }else if([l_masterViewController isKindOfClass:[UINavigationController class]]){
            UINavigationController *l_navigationController = (UINavigationController*)l_masterViewController;
            if (l_navigationController.topViewController==self) {
                l_shouldPresentingViewControllerBeSplitViewControllerDetail = YES;
            }
        }
    }
    return l_shouldPresentingViewControllerBeSplitViewControllerDetail ? self.splitViewController.viewControllers[1] : self;
}

- (void)ifa_removeKeyboardPassthroughView {
    [self.p_keyboardPassthroughView removeFromSuperview];
}

#pragma mark - Public

-(void)setP_presenter:(id<IAUIPresenter>)a_presenter{
    objc_setAssociatedObject(self, &c_presenterKey, a_presenter, OBJC_ASSOCIATION_ASSIGN);
}

-(id<IAUIPresenter>)p_presenter{
    return objc_getAssociatedObject(self, &c_presenterKey);
}

-(UIPopoverController*)p_activePopoverController{
    return objc_getAssociatedObject(self, &c_activePopoverControllerKey);
}

-(UIBarButtonItem*)p_activePopoverControllerBarButtonItem{
    return objc_getAssociatedObject(self, &c_activePopoverControllerBarButtonItemKey);
}

-(NSString*)p_subTitle{
    return objc_getAssociatedObject(self, &c_subTitleKey);
}

-(void)setP_subTitle:(NSString*)a_subTitle{
    objc_setAssociatedObject(self, &c_subTitleKey, a_subTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(IAUINavigationItemTitleView*)p_titleViewDefault{
    return objc_getAssociatedObject(self, &c_titleViewDefaultKey);
}

-(void)setP_titleViewDefault:(IAUINavigationItemTitleView*)a_titleViewDefault{
    objc_setAssociatedObject(self, &c_titleViewDefaultKey, a_titleViewDefault, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString*)p_helpTargetId{
    return objc_getAssociatedObject(self, &c_helpTargetIdKey);
}

-(void)setP_helpTargetId:(NSString*)a_helpTargetId{
    objc_setAssociatedObject(self, &c_helpTargetIdKey, a_helpTargetId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(ODRefreshControl*)p_refreshControl{
    return objc_getAssociatedObject(self, &c_refreshControlKey);
}

-(void)setP_refreshControl:(ODRefreshControl*)a_refreshControl{
    objc_setAssociatedObject(self, &c_refreshControlKey, a_refreshControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)p_shouldUseKeyboardPassthroughView{
    return ((NSNumber*)objc_getAssociatedObject(self, &c_shouldUseKeyboardPassthroughViewKey)).boolValue;
}

-(void)setP_shouldUseKeyboardPassthroughView:(BOOL)a_shouldUseKeyboardPassthroughView{
    objc_setAssociatedObject(self, &c_shouldUseKeyboardPassthroughViewKey, @(a_shouldUseKeyboardPassthroughView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(IAUIPassthroughView*)p_keyboardPassthroughView{
    IAUIPassthroughView *l_obj = objc_getAssociatedObject(self, &c_keyboardPassthroughViewKey);
    if (!l_obj) {
        l_obj = [IAUIPassthroughView new];
        l_obj.p_shouldDismissKeyboardOnNonTextInputInteractions = YES;
        self.p_keyboardPassthroughView = l_obj;
    }
    return l_obj;
}

-(void)setP_keyboardPassthroughView:(IAUIPassthroughView*)a_keyboardPassthroughView{
    objc_setAssociatedObject(self, &c_keyboardPassthroughViewKey, a_keyboardPassthroughView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIBarButtonItem*)p_helpBarButtonItem{
    return objc_getAssociatedObject(self, &c_helpBarButtonItemKey);
}

-(void)setP_helpBarButtonItem:(UIBarButtonItem*)a_helpBarButtonItem{
    objc_setAssociatedObject(self, &c_helpBarButtonItemKey, a_helpBarButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSFetchedResultsController*)p_fetchedResultsController{
    return objc_getAssociatedObject(self, &c_fetchedResultsControllerKey);
}

-(void)setP_fetchedResultsController:(NSFetchedResultsController*)a_fetchedResultsController{
    objc_setAssociatedObject(self, &c_fetchedResultsControllerKey, a_fetchedResultsController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIView*)p_adContainerView{

    UIView *l_adContainerView = objc_getAssociatedObject(self, &c_adContainerViewKey);

    if (!l_adContainerView && [self IFA_shouldEnableAds]) {
        
        // Create ad container
        CGSize l_gadAdFrameSize = [self IFA_gadAdFrameSize];
        CGFloat l_adContainerViewX = 0;
        CGFloat l_adContainerViewY = self.view.frame.size.height-l_gadAdFrameSize.height;
        CGFloat l_adContainerViewWidth = self.view.frame.size.width;
        CGFloat l_adContainerViewHeight = l_gadAdFrameSize.height;
        CGRect l_adContainerViewFrame = CGRectMake(l_adContainerViewX, l_adContainerViewY, l_adContainerViewWidth, l_adContainerViewHeight);
        l_adContainerView = [[UIView alloc] initWithFrame:l_adContainerViewFrame];
//        NSLog(@"adContainerView.frame 1: %@", NSStringFromCGRect(l_adContainerView.frame));
        l_adContainerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        
        // Add shadow
        l_adContainerView.layer.masksToBounds = NO;
        l_adContainerView.layer.shadowOffset = CGSizeMake(0, 2);
        l_adContainerView.layer.shadowOpacity = 1;

        self.p_adContainerView = l_adContainerView;
    
    }

    return l_adContainerView;

}

-(void)setP_adContainerView:(UIView*)a_adContainerView{
    objc_setAssociatedObject(self, &c_adContainerViewKey, a_adContainerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)p_changesMadeByPresentedViewController{
    return ((NSNumber*)objc_getAssociatedObject(self, &c_changesMadeByPresentedViewControllerKey)).boolValue;
}

-(void)setP_changesMadeByPresentedViewController:(BOOL)a_changesMadeByPresentedViewController{
    objc_setAssociatedObject(self, &c_changesMadeByPresentedViewControllerKey, @(a_changesMadeByPresentedViewController), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(IAUINavigationItemTitleView*)p_titleViewLandscapePhone{
    return objc_getAssociatedObject(self, &c_titleViewLandscapePhoneKey);
}

-(void)setP_titleViewLandscapePhone:(IAUINavigationItemTitleView*)a_titleViewLandscapePhone{
    objc_setAssociatedObject(self, &c_titleViewLandscapePhoneKey, a_titleViewLandscapePhone, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString*)p_slidingMenuBarButtonItem{
    return objc_getAssociatedObject(self, &c_slidingMenuBarButtonItemKey);
}

-(void)setP_slidingMenuBarButtonItem:(NSString*)a_slidingMenuBarButtonItem{
    objc_setAssociatedObject(self, &c_slidingMenuBarButtonItemKey, a_slidingMenuBarButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)IFA_addLeftBarButtonItem:(UIBarButtonItem*)a_barButtonItem{
    [self IFA_insertLeftBarButtonItem:a_barButtonItem atIndex:NSNotFound];
}

-(void)IFA_insertLeftBarButtonItem:(UIBarButtonItem *)a_barButtonItem atIndex:(NSUInteger)a_index{

    if (!a_barButtonItem) {
        return;
    }
    UINavigationItem *l_navigationItem = [self IFA_navigationItem];
    NSMutableArray *l_leftBarButtonItems = [l_navigationItem.leftBarButtonItems mutableCopy];

    BOOL l_fixedPositionItem = a_barButtonItem.tag==IA_UIBAR_ITEM_TAG_BACK_BUTTON || a_barButtonItem.tag== IA_UIBAR_ITEM_TAG_LEFT_SLIDING_PANE_BUTTON;
    if (![l_navigationItem.leftBarButtonItems containsObject:a_barButtonItem] || l_fixedPositionItem) {
        
        if (l_leftBarButtonItems) {
            [self ifa_removeAutomatedSpacingFromBarButtonItemArray:l_leftBarButtonItems];
        }else{
            l_leftBarButtonItems = [NSMutableArray new];
        }

        if (a_barButtonItem.tag) {
            // Remove any existing instance with a matching tag
            for (UIBarButtonItem *l_barButtonItem in l_navigationItem.leftBarButtonItems) {
                if (l_barButtonItem.tag==a_barButtonItem.tag) {
                    [l_leftBarButtonItems removeObject:l_barButtonItem];
                }
            }
        }
        if (a_index==NSNotFound) {
            [l_leftBarButtonItems addObject:a_barButtonItem];
            // Prioritise certain bar button items
            UIBarButtonItem *l_backBarButtonItem, *l_leftSlidingPane;
            for (UIBarButtonItem *l_barButtonItem in l_leftBarButtonItems) {
                switch (l_barButtonItem.tag) {
                    case IA_UIBAR_ITEM_TAG_BACK_BUTTON:
                        l_backBarButtonItem = l_barButtonItem;
                        break;
                    case IA_UIBAR_ITEM_TAG_LEFT_SLIDING_PANE_BUTTON:
                        l_leftSlidingPane = l_barButtonItem;
                        break;
                    default:
                        // does nothing
                        break;
                }
            }
            [l_leftBarButtonItems removeObject:l_backBarButtonItem];
            [l_leftBarButtonItems removeObject:l_leftSlidingPane];
            if (l_leftSlidingPane) {
                [l_leftBarButtonItems insertObject:l_leftSlidingPane atIndex:0];
            }
            if (l_backBarButtonItem) {
                [l_leftBarButtonItems insertObject:l_backBarButtonItem atIndex:0];
            }
        }else{
            [l_leftBarButtonItems insertObject:a_barButtonItem atIndex:a_index];
        }

        // Bar button item spacing automation
        [self ifa_spaceBarButtonItems:l_leftBarButtonItems firstItemSpacingType:IAUISpacingBarButtonItemTypeLeft];

        [l_navigationItem setLeftBarButtonItems:l_leftBarButtonItems animated:NO];
//        NSLog(@"m_insertLeftBarButtonItem - button inserted for %@, tag: %u, navigationItem.title: %@: %@", [self description], a_barButtonItem.tag, l_navigationItem.title, [l_navigationItem.leftBarButtonItems description]);

    }

}

-(void)IFA_removeLeftBarButtonItem:(UIBarButtonItem*)a_barButtonItem{

    if (!a_barButtonItem) {
        return;
    }

    UINavigationItem *l_navigationItem = [self IFA_navigationItem];
    NSMutableArray *l_leftBarButtonItems = [l_navigationItem.leftBarButtonItems mutableCopy];
    if (l_leftBarButtonItems) {
        [self ifa_removeAutomatedSpacingFromBarButtonItemArray:l_leftBarButtonItems];
        [l_leftBarButtonItems removeObject:a_barButtonItem];
        [self ifa_spaceBarButtonItems:l_leftBarButtonItems firstItemSpacingType:IAUISpacingBarButtonItemTypeLeft];
        [l_navigationItem setLeftBarButtonItems:l_leftBarButtonItems animated:NO];
//        NSLog(@"m_removeLeftBarButtonItem - button removed for %@: %@", l_navigationItem.title, [l_navigationItem.leftBarButtonItems description]);
    }

}

-(void)IFA_addRightBarButtonItem:(UIBarButtonItem*)a_barButtonItem{
    [self IFA_insertRightBarButtonItem:a_barButtonItem atIndex:NSNotFound];
}

-(void)IFA_insertRightBarButtonItem:(UIBarButtonItem *)a_barButtonItem atIndex:(NSUInteger)a_index{

    if (!a_barButtonItem) {
        return;
    }

    UINavigationItem *l_navigationItem = [self IFA_navigationItem];
    NSMutableArray *l_rightBarButtonItems = [l_navigationItem.rightBarButtonItems mutableCopy];
    if (![l_navigationItem.rightBarButtonItems containsObject:a_barButtonItem]) {

        if (l_rightBarButtonItems) {
            [self ifa_removeAutomatedSpacingFromBarButtonItemArray:l_rightBarButtonItems];
        }else{
            l_rightBarButtonItems = [NSMutableArray new];
        }

        if (a_barButtonItem.tag) {
            // Remove any existing instance with a matching tag
            for (UIBarButtonItem *l_barButtonItem in l_navigationItem.rightBarButtonItems) {
                if (l_barButtonItem.tag==a_barButtonItem.tag) {
                    [l_rightBarButtonItems removeObject:l_barButtonItem];
                }
            }
        }
        if (a_index==NSNotFound) {
            [l_rightBarButtonItems addObject:a_barButtonItem];
        }else{
            [l_rightBarButtonItems insertObject:a_barButtonItem atIndex:a_index];
        }
        
        // Bar button item spacing automation
        [self ifa_spaceBarButtonItems:l_rightBarButtonItems firstItemSpacingType:IAUISpacingBarButtonItemTypeRight];

        [l_navigationItem setRightBarButtonItems:l_rightBarButtonItems animated:NO];
        //        NSLog(@"m_insertRightBarButtonItem - button inserted for %@, navigationItem.title: %@: %@", [self description], l_navigationItem.title, [l_navigationItem.rightBarButtonItems description]);

    }

}

-(void)IFA_removeRightBarButtonItem:(UIBarButtonItem*)a_barButtonItem{

    if (!a_barButtonItem) {
        return;
    }

    UINavigationItem *l_navigationItem = [self IFA_navigationItem];
    NSMutableArray *l_rightBarButtonItems = [l_navigationItem.rightBarButtonItems mutableCopy];
    if (l_rightBarButtonItems) {
        [self ifa_removeAutomatedSpacingFromBarButtonItemArray:l_rightBarButtonItems];
        [l_rightBarButtonItems removeObject:a_barButtonItem];
        [self ifa_spaceBarButtonItems:l_rightBarButtonItems firstItemSpacingType:IAUISpacingBarButtonItemTypeRight];
        [l_navigationItem setRightBarButtonItems:l_rightBarButtonItems animated:NO];
        //        NSLog(@"m_removeRightBarButtonItem - button removed for %@: %@", l_navigationItem.title, [l_navigationItem.rightBarButtonItems description]);
    }

}

-(BOOL)p_isMasterViewController{
    return [self.splitViewController.viewControllers objectAtIndex:0]==self.navigationController && self.navigationController.viewControllers[0]==self;
}

-(BOOL)p_isDetailViewController{
    return [self.splitViewController.viewControllers objectAtIndex:1]==self.navigationController && self.navigationController.viewControllers[0]==self;
}

-(NSString*)IFA_helpTargetIdForName:(NSString*)a_name{
    return [NSString stringWithFormat:@"controllers.%@.%@", [[self class] description], a_name];
}

-(BOOL)p_presentedAsModal{
    //    NSLog(@"presentingViewController: %@, presentedViewController: %@, self: %@, topViewController: %@, visibleViewController: %@, viewController[0]: %@, navigationController.parentViewController: %@, parentViewController: %@, presentedAsSemiModal: %u", [self.presentingViewController description], [self.presentedViewController description], [self description], self.navigationController.topViewController, self.navigationController.visibleViewController, [self.navigationController.viewControllers objectAtIndex:0], self.navigationController.parentViewController, self.parentViewController, self.p_presentedAsSemiModal);
    return [IAUIApplicationDelegate sharedInstance].p_popoverControllerPresenter.p_activePopoverController.contentViewController==self.navigationController || ( self.navigationController.presentingViewController!=nil && [self.navigationController.viewControllers objectAtIndex:0]==self) || self.parentViewController.p_presentedAsSemiModal || [[IAUIApplicationDelegate sharedInstance].p_popoverControllerPresenter.p_activePopoverController.contentViewController isKindOfClass:[UIActivityViewController class]];
}

- (void)IFA_updateToolbarForMode:(BOOL)anEditModeFlag animated:(BOOL)anAnimatedFlag{
//    NSLog(@" ");
//    NSLog(@"toolbar items before: %@", [self.toolbarItems description]);
    if(self.p_manageToolbar || anEditModeFlag){
        NSArray *toolbarItems = anEditModeFlag ? [self IFA_editModeToolbarItems] : [self IFA_nonEditModeToolbarItems];
//        NSLog(@"self.navigationController.toolbar: %@", [self.navigationController.toolbar description]);
//        NSLog(@" self.navigationController.toolbarHidden: %u, animated: %u", self.navigationController.toolbarHidden, anAnimatedFlag);
        [self.navigationController setToolbarHidden:(![toolbarItems count]) animated:anAnimatedFlag];
//        NSLog(@" self.navigationController.toolbarHidden: %u", self.navigationController.toolbarHidden);
        if ([toolbarItems count]) {
            if (self.p_manageToolbar) {
                if (![self.toolbarItems isEqualToArray:toolbarItems]) {
                    [self setToolbarItems:toolbarItems animated:anAnimatedFlag];
                }
            }else{
                if (![self.parentViewController.toolbarItems isEqualToArray:toolbarItems]) {
                    [self.parentViewController setToolbarItems:toolbarItems animated:anAnimatedFlag];
                }
            }
        }
    }else{
        [self.navigationController setToolbarHidden:(![self.toolbarItems count]) animated:anAnimatedFlag];
    }
//    NSLog(@"toolbar items after: %@", [self.toolbarItems description]);
}

-(BOOL)IFA_hasFixedSize {
    return NO;
}

-(void)IFA_presentPopoverController:(UIPopoverController *)a_popoverController fromBarButtonItem:(UIBarButtonItem *)a_fromBarButtonItem{
    [self ifa_setActivePopoverController:a_popoverController presenter:self barButtonItem:a_fromBarButtonItem];
    [self ifa_resizePopoverContent];
    [a_popoverController presentPopoverFromBarButtonItem:a_fromBarButtonItem
                                permittedArrowDirections:[self IFA_permittedPopoverArrowDirectionForViewController:nil ]
                                                animated:k_animated];
    __weak UIViewController *l_weakSelf = self;
    [IAUtils dispatchAsyncMainThreadBlock:^{
        [l_weakSelf IFA_didPresentPopoverController:a_popoverController];
    }];
}

-(void)IFA_presentPopoverController:(UIPopoverController *)a_popoverController fromRect:(CGRect)a_fromRect inView:(UIView *)a_view{
    [self ifa_setActivePopoverController:a_popoverController presenter:self barButtonItem:nil];
    [self ifa_resizePopoverContent];
    [a_popoverController presentPopoverFromRect:a_fromRect inView:a_view
                       permittedArrowDirections:[self IFA_permittedPopoverArrowDirectionForViewController:nil ] animated:k_animated];
    __weak UIViewController *l_weakSelf = self;
    [IAUtils dispatchAsyncMainThreadBlock:^{
        [l_weakSelf IFA_didPresentPopoverController:a_popoverController];
    }];
}

-(void)IFA_didPresentPopoverController:(UIPopoverController*)a_popoverController{
    // Remove the navigation bar or toolbar that owns the button from the passthrough view list
    a_popoverController.passthroughViews = nil;
}

-(void)IFA_presentModalFormViewController:(UIViewController*)a_viewController{
    [self IFA_presentModalViewController:a_viewController presentationStyle:UIModalPresentationPageSheet
                         transitionStyle:UIModalTransitionStyleCoverVertical];
}

-(void)IFA_presentModalSelectionViewController:(UIViewController *)a_viewController fromBarButtonItem:(UIBarButtonItem *)a_fromBarButtonItem{
    [self ifa_presentModalSelectionViewController:a_viewController fromBarButtonItem:a_fromBarButtonItem
                                         fromRect:CGRectZero inView:nil];
}

-(void)IFA_presentModalSelectionViewController:(UIViewController *)a_viewController fromRect:(CGRect)a_fromRect inView:(UIView *)a_view{
    [self ifa_presentModalSelectionViewController:a_viewController fromBarButtonItem:nil fromRect:a_fromRect
                                           inView:a_view];
}

-(void)IFA_presentModalViewController:(UIViewController *)a_viewController
                    presentationStyle:(UIModalPresentationStyle)a_presentationStyle transitionStyle:(UIModalTransitionStyle)a_transitionStyle{
    [self IFA_presentModalViewController:a_viewController presentationStyle:a_presentationStyle
                         transitionStyle:a_transitionStyle shouldAddDoneButton:NO];
}

- (void)IFA_presentModalViewController:(UIViewController *)a_viewController
                     presentationStyle:(UIModalPresentationStyle)a_presentationStyle
                       transitionStyle:(UIModalTransitionStyle)a_transitionStyle
                   shouldAddDoneButton:(BOOL)a_shouldAddDoneButton {
    [self IFA_presentModalViewController:a_viewController
                       presentationStyle:a_presentationStyle
                         transitionStyle:a_transitionStyle
                     shouldAddDoneButton:a_shouldAddDoneButton
                              customSize:CGSizeZero];
}

- (void)IFA_presentModalViewController:(UIViewController *)a_viewController
                     presentationStyle:(UIModalPresentationStyle)a_presentationStyle
                       transitionStyle:(UIModalTransitionStyle)a_transitionStyle
                   shouldAddDoneButton:(BOOL)a_shouldAddDoneButton
                            customSize:(CGSize)a_customSize{
    UIViewController *l_presentingViewController = [self ifa_appropriatePresentingViewController];
    if ([l_presentingViewController conformsToProtocol:@protocol(IAUIPresenter)]) {
        a_viewController.p_presenter = (id <IAUIPresenter>) l_presentingViewController;
        if (a_shouldAddDoneButton) {
            UIBarButtonItem *l_barButtonItem = [[l_presentingViewController IFA_appearanceTheme] doneBarButtonItemWithTarget:a_viewController
                                                                                                                    action:@selector(IFA_onDoneButtonTap:)
                                                                                                            viewController:a_viewController];
            [a_viewController IFA_addLeftBarButtonItem:l_barButtonItem];
        }
    }
    id <IAUIAppearanceTheme> l_appearanceTheme = [self IFA_appearanceTheme];
    Class l_navigationControllerClass = [l_appearanceTheme navigationControllerClass];
    IAUINavigationController *l_navigationController = [[l_navigationControllerClass alloc] initWithRootViewController:a_viewController];
    l_navigationController.modalPresentationStyle = a_presentationStyle;
    l_navigationController.modalTransitionStyle = a_transitionStyle;
    [l_presentingViewController presentViewController:l_navigationController animated:YES completion:^{
        [a_viewController.p_presenter didPresentViewController:l_navigationController];
    }];
    if (a_customSize.width && a_customSize.height) {
        l_navigationController.view.superview.backgroundColor = [UIColor clearColor];
        l_navigationController.view.bounds = CGRectMake(0, 0, a_customSize.width, a_customSize.height + l_navigationController.navigationBar.frame.size.height);
    }
}

- (void)IFA_notifySessionCompletionWithChangesMade:(BOOL)a_changesMade data:(id)a_data {
    [self.p_presenter sessionDidCompleteForViewController:self changesMade:a_changesMade data:a_data];
}

-(void)IFA_notifySessionCompletion {
    [self IFA_notifySessionCompletionWithChangesMade:NO data:nil ];
}

- (void)IFA_dismissModalViewControllerWithChangesMade:(BOOL)a_changesMade data:(id)a_data {
    if (self.presentedViewController) {
        __weak UIViewController *l_weakSelf = self;
        UIViewController *l_presentedViewController = self.presentedViewController; // Add retain cycle
        [self dismissViewControllerAnimated:YES completion:^{
            if ([l_weakSelf conformsToProtocol:@protocol(IAUIPresenter)]) {
                [l_weakSelf didDismissViewController:l_presentedViewController changesMade:a_changesMade data:a_data];
            }
        }];
    }else if(self.p_activePopoverController){
        [self.p_activePopoverController dismissPopoverAnimated:YES];
        [self IFA_resetActivePopoverController];
    }else if(self.p_presentingSemiModal){
        [self dismissSemiModalViewWithChangesMade:a_changesMade data:a_data];
    }else{
        NSAssert(NO, @"No modal view controller to dismiss");
    }
}

-(IAAsynchronousWorkManager*)p_aom{
    return [IAAsynchronousWorkManager instance];
}

-(void)IFA_dismissMenuPopoverController {
    [self IFA_dismissMenuPopoverControllerWithAnimation:YES];
}

-(void)IFA_dismissMenuPopoverControllerWithAnimation:(BOOL)a_animated{
    // Dismiss the popover controller if a split view controller is used and this controller is not presented as modal
    if (!self.p_presentedAsModal) {
        [((IAUISplitViewController*)self.splitViewController).p_popoverController dismissPopoverAnimated:a_animated];
    }
}

-(void)IFA_resetActivePopoverController {
    [self ifa_setActivePopoverController:nil presenter:nil barButtonItem:nil];
}

-(void)IFA_prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [self IFA_dismissMenuPopoverController];
}

-(id<IAUIAppearanceTheme>)IFA_appearanceTheme {
    return [[IAUIAppearanceThemeManager sharedInstance] activeAppearanceTheme];
}

// To be overriden by subclasses
-(BOOL)p_manageToolbar{
    return YES;
}

// To be overriden by subclasses
-(UIViewController*)p_previousVisibleViewController{
    return nil;
}

// To be overriden by subclasses
-(BOOL)p_doneButtonSaves{
    return NO;
}

// To be overriden by subclasses
-(void)setP_previousVisibleViewController:(UIViewController *)p_previousVisibleViewController{
}

// To be overriden by subclasses
- (NSArray*)IFA_editModeToolbarItems {
	return nil;
}

// To be overriden by subclasses
- (NSArray*)IFA_nonEditModeToolbarItems {
	return nil;
}

// To be overriden by subclasses
-(void)IFA_updateScreenDecorationState {
}

// To be overriden by subclasses
-(void)IFA_updateNavigationItemState {
}

// To be overriden by subclasses
-(void)IFA_updateToolbarNavigationButtonState {
}

// To be overriden by subclasses
- (void)IFA_onApplicationWillEnterForegroundNotification:(NSNotification*)aNotification{
}

// To be overriden by subclasses
- (void)IFA_onApplicationDidBecomeActiveNotification:(NSNotification*)aNotification{
}

// To be overriden by subclasses
- (void)IFA_onApplicationWillResignActiveNotification:(NSNotification*)aNotification{
}

// To be overriden by subclasses
- (void)IFA_onApplicationDidEnterBackgroundNotification:(NSNotification*)aNotification{
}

- (void)ifa_onAdsSuspendRequest:(NSNotification*)aNotification{
    [self IFA_stopAdRequests];
}

- (void)ifa_onAdsResumeRequest:(NSNotification*)aNotification{
    if ([self IFA_shouldEnableAds]) {
        [self IFA_startAdRequests];
    }
}

-(void)IFA_dealloc {
    
    // Remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IA_NOTIFICATION_MENU_BAR_BUTTON_ITEM_INVALIDATED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];

}

// To be overriden by subclasses
-(UIView*)IFA_nonAdContainerView {
    return nil;
}

// To be overriden by subclasses
-(BOOL)IFA_shouldEnableAds {
    return NO;
}

-(UIBarButtonItem*)ifa_editBarButtonItem {
    if ([self isKindOfClass:[IAUIDynamicPagingContainerViewController class]]) {
        IAUIDynamicPagingContainerViewController *l_containerViewController = (IAUIDynamicPagingContainerViewController*)self;
        return [l_containerViewController visibleChildViewController].editButtonItem;
    }else{
        return self.editButtonItem;
    }
}

//-(void)m_updateEditButtonItemAccessibilityLabel{
//    [self ifa_editBarButtonItem].accessibilityLabel = self.editing ? @"Done Button" : @"Edit Button";
//}

- (void)IFA_viewDidLoad {
    
//    NSLog(@"IFA_viewDidLoad: %@, topViewController: %@, visibleViewController: %@, presentingViewController: %@, presentedViewController: %@", [self description], [self.navigationController.topViewController description], [self.navigationController.visibleViewController description], [self.presentingViewController description], [self.presentedViewController description]);
    
//    [self m_updateEditButtonItemAccessibilityLabel];

    UINavigationItem *l_navigationItem = [self IFA_navigationItem];
    l_navigationItem.leftItemsSupplementBackButton = YES;
    UIBarButtonItem *l_backBarButtonItem = [[self IFA_appearanceTheme] backBarButtonItemForViewController:self];
    l_navigationItem.backBarButtonItem = l_backBarButtonItem;
    if (l_backBarButtonItem.customView && self.navigationController.topViewController==self && self.navigationController.viewControllers.count>1) {
        l_navigationItem.hidesBackButton = YES;
        l_backBarButtonItem.tag = IA_UIBAR_ITEM_TAG_BACK_BUTTON;
        l_backBarButtonItem.target = self;
        l_backBarButtonItem.action = @selector(ifa_popViewController);
        [self IFA_addLeftBarButtonItem:l_backBarButtonItem];
    }

    // Configure help button
    if ([[IAHelpManager sharedInstance] isHelpEnabledForViewController:self]) {
        self.p_helpBarButtonItem = [[IAHelpManager sharedInstance] newHelpBarButtonItem];
    }else{
        self.p_helpBarButtonItem = nil;
    }
    
    // Set appearance
    [[[IAUIAppearanceThemeManager sharedInstance] activeAppearanceTheme] setAppearanceOnViewDidLoadForViewController:self];
    
    // Add observers
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(ifa_onMenuBarButtonItemInvalidated:)
                                                 name:IA_NOTIFICATION_MENU_BAR_BUTTON_ITEM_INVALIDATED 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(IFA_onApplicationWillEnterForegroundNotification:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(IFA_onApplicationDidBecomeActiveNotification:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(IFA_onApplicationWillResignActiveNotification:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(IFA_onApplicationDidEnterBackgroundNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];

    // Configure fetched results controller and perform fetch
    [self IFA_configureFetchedResultsControllerAndPerformFetch];

    // Configure keyboard passthrough view
    if (self.p_shouldUseKeyboardPassthroughView) {
        self.p_keyboardPassthroughView.p_shouldDismissKeyboardOnNonTextInputInteractions = YES;
    }

}

-(void)IFA_viewDidUnload {

    //    NSLog(@"IFA_viewDidUnload: %@, topViewController: %@, visibleViewController: %@, presentingViewController: %@, presentedViewController: %@", [self description], [self.navigationController.topViewController description], [self.navigationController.visibleViewController description], [self.presentingViewController description], [self.presentedViewController description]);
    
    // Remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IA_NOTIFICATION_MENU_BAR_BUTTON_ITEM_INVALIDATED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];

    self.p_fetchedResultsController = nil;

}

- (void)IFA_viewWillAppear {
    
//    NSLog(@"IFA_viewWillAppear: %@, topViewController: %@, visibleViewController: %@, presentingViewController: %@, presentedViewController: %@", [self description], [self.navigationController.topViewController description], [self.navigationController.visibleViewController description], [self.presentingViewController description], [self.presentedViewController description]);
    
    // Add the help button if help is enabled for this view controller
    if (self.p_helpBarButtonItem) {
        if ([self isKindOfClass:[IAUIAbstractFieldEditorViewController class]] || [self isKindOfClass:[IAUIMultiSelectionListViewController class]]) {
            if ([self isKindOfClass:[IAUIAbstractFieldEditorViewController class]] ) {
                CGRect l_customViewFrame = self.p_helpBarButtonItem.customView.frame;
                self.p_helpBarButtonItem.customView.frame = CGRectMake(l_customViewFrame.origin.x, l_customViewFrame.origin.y, 34, self.navigationController.navigationBar.frame.size.height);
            }
            [self IFA_addLeftBarButtonItem:self.p_helpBarButtonItem];
        }else{
            [self IFA_insertRightBarButtonItem:self.p_helpBarButtonItem atIndex:0];
        }
    }
    
    // Add observers
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ifa_onAdsSuspendRequest:)
                                                 name:IA_NOTIFICATION_ADS_SUSPEND_REQUEST
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ifa_onAdsResumeRequest:)
                                                 name:IA_NOTIFICATION_ADS_RESUME_REQUEST
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(IFA_onKeyboardNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(IFA_onKeyboardNotification:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(IFA_onKeyboardNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(IFA_onKeyboardNotification:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];

    if (self.p_manageToolbar && [self.navigationController.viewControllers count]==1 && ![self IFA_isReturningVisibleViewController]) {
        //            NSLog(@"About to call m_updateToolbarForMode in IFA_viewWillAppear...");
        [self IFA_updateToolbarForMode:self.editing animated:NO];
    }

    // Manage left sliding menu button visibility
    [self ifa_showLeftSlidingPaneButtonIfRequired];

    // Set appearance
    [[[IAUIAppearanceThemeManager sharedInstance] activeAppearanceTheme] setAppearanceOnViewWillAppearForViewController:self];

    // Configure help target
    [self IFA_registerForHelp];

}

- (BOOL)IFA_shouldShowLeftSlidingPaneButton {
    BOOL l_shouldShowIt = NO;
    if (self.slidingViewController) {
        l_shouldShowIt = self.slidingViewController.topViewController==self.navigationController && self.navigationController.viewControllers[0]==self;
    }else if (self.splitViewController) {
        l_shouldShowIt = [self p_isDetailViewController];
    }
//    NSLog(@"  [self IFA_shouldShowLeftSlidingPaneButton] for %@: %u", [self description], l_shouldShowIt);
    return l_shouldShowIt;
}

- (void)IFA_addToNavigationBarForSlidingMenuBarButtonItem:(UIBarButtonItem *)a_slidingMenuBarButtonItem {
    [self IFA_insertLeftBarButtonItem:a_slidingMenuBarButtonItem atIndex:0];
}

- (void)IFA_viewDidAppear {
    
//    NSLog(@"IFA_viewDidAppear: %@, topViewController: %@, visibleViewController: %@, presentingViewController: %@, presentedViewController: %@", [self description], [self.navigationController.topViewController description], [self.navigationController.visibleViewController description], [self.presentingViewController description], [self.presentedViewController description]);
    
    if ([self IFA_shouldEnableAds]) {
        [self IFA_startAdRequests];
    }
    
    if (self.p_manageToolbar && !([self.navigationController.viewControllers count]==1 && ![self IFA_isReturningVisibleViewController]) ) {
        //            NSLog(@"About to call m_updateToolbarForMode in IFA_viewDidAppear...");
        [self IFA_updateToolbarForMode:self.editing animated:YES];
    }
    
}

- (void)IFA_viewWillDisappear {
    
//    NSLog(@"IFA_viewWillDisappear: %@, topViewController: %@, visibleViewController: %@, presentingViewController: %@, presentedViewController: %@", [self description], [self.navigationController.topViewController description], [self.navigationController.visibleViewController description], [self.presentingViewController description], [self.presentedViewController description]);
        
    self.p_previousVisibleViewController = self.navigationController.visibleViewController;
    
}

- (void)IFA_viewDidDisappear {
    
//    NSLog(@"IFA_viewDidDisappear: %@, topViewController: %@, visibleViewController: %@, presentingViewController: %@, presentedViewController: %@", [self description], [self.navigationController.topViewController description], [self.navigationController.visibleViewController description], [self.presentingViewController description], [self.presentedViewController description]);
        
    // Remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IA_NOTIFICATION_ADS_SUSPEND_REQUEST object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IA_NOTIFICATION_ADS_RESUME_REQUEST object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];

    if (self.p_manageToolbar && [self.toolbarItems count]>0) {
        self.toolbarItems = @[];
    }
    
    // Remove ad container
    if ([self IFA_shouldEnableAds]) {
        [self IFA_stopAdRequests];
    }

    // Remove keyboard passthrough view if required
    if (self.p_shouldUseKeyboardPassthroughView) {
        [self ifa_removeKeyboardPassthroughView]; // Keyboard dismissal is doing this already - this is just a safety net in case of any unforeseen scenarios out there.
    }

//    [self m_simulateMemoryWarning];
    
}

-(BOOL)IFA_isReturningVisibleViewController {
//    NSLog(@"m_isReturningTopViewController: %@, p_previousVisibleViewController: %@", self, self.p_previousVisibleViewController);
    if ([self.parentViewController isKindOfClass:[IAUIAbstractPagingContainerViewController class]]) {
        return [((IAUIAbstractPagingContainerViewController *) self.parentViewController) IFA_isReturningVisibleViewController];
    }else {
        return self.p_previousVisibleViewController && self!=self.p_previousVisibleViewController && ![self.p_previousVisibleViewController isKindOfClass:[IAUIMenuViewController class]];
    }
}

//-(BOOL)m_isLeavingVisibleViewController{
////    NSLog(@"m_isLeavingTopViewController: %@, p_previousVisibleViewController: %@", self, self.p_previousVisibleViewController);
//    return self.p_previousVisibleViewController && self!=self.p_previousVisibleViewController;
//}

-(UIView*)IFA_viewForActionSheet {
    return [IAUIUtils actionSheetShowInViewForViewController:self];
}

-(UIViewController*)IFA_mainViewController {
    if (((UIViewController*)[self.navigationController.viewControllers objectAtIndex:0]).p_presentedAsModal) {
        return self.navigationController;
    }else{
        return [UIApplication sharedApplication].delegate.window.rootViewController;
    }
}

// iOS 5 (the next method is for iOS 6 or greater)
-(BOOL)IFA_shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    BOOL l_shouldAutorotate = NO;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        l_shouldAutorotate = YES;
    }else{
        l_shouldAutorotate = toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
    if (l_shouldAutorotate) {
        if ([IAUIApplicationDelegate sharedInstance].p_semiModalViewController) {
            l_shouldAutorotate = UIInterfaceOrientationIsLandscape(toInterfaceOrientation) == UIInterfaceOrientationIsLandscape([IAUIApplicationDelegate sharedInstance].p_semiModalInterfaceOrientation);
        }
    }
    return l_shouldAutorotate;
}

// iOS 6 or greater (the previous method is for iOS 5)
-(NSUInteger)IFA_supportedInterfaceOrientations {
    if ([IAUIApplicationDelegate sharedInstance].p_semiModalViewController) {
        if (UIInterfaceOrientationIsLandscape([IAUIApplicationDelegate sharedInstance].p_semiModalInterfaceOrientation)) {
            return UIInterfaceOrientationMaskLandscape;
        }else{
            return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown : UIInterfaceOrientationMaskPortrait;
        }
    }else{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            return UIInterfaceOrientationMaskAll;
        }else{
            return UIInterfaceOrientationMaskAllButUpsideDown;
        }
    }
}

-(void)IFA_willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    // Tell help manager about the interface orientation change
    if (self.p_helpMode && [IAHelpManager sharedInstance].p_observedHelpTargetContainer==self) {
        [[IAHelpManager sharedInstance] observedViewControllerWillRotateToInterfaceOrientation:toInterfaceOrientation
                                                                                  duration:duration];
    }

    [[[IAUIAppearanceThemeManager sharedInstance] activeAppearanceTheme] setAppearanceOnWillRotateForViewController:self
                                                                                           toInterfaceOrientation:toInterfaceOrientation];

}

- (void)IFA_willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration{

    [[[IAUIAppearanceThemeManager sharedInstance] activeAppearanceTheme] setAppearanceOnWillAnimateRotationForViewController:self
                                                                                                      interfaceOrientation:interfaceOrientation];

    if ([self IFA_shouldEnableAds]) {
        [self IFA_stopAdRequests];
    }

}

-(void)IFA_didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    // Tell help manager about the interface orientation change
    if (self.p_helpMode && [IAHelpManager sharedInstance].p_observedHelpTargetContainer==self) {
        [[IAHelpManager sharedInstance] observedViewControllerDidRotateFromInterfaceOrientation:fromInterfaceOrientation];
    }
    
    if (self.p_activePopoverController && self.p_activePopoverControllerBarButtonItem) {
        
        // Present popover controller in the new interface orientation
        // Also need to reset content size as iOS will attempt to resize it automatically due to the fact the popover was triggered by a bar button item
        [self IFA_presentPopoverController:self.p_activePopoverController
                         fromBarButtonItem:self.p_activePopoverControllerBarButtonItem];
        
    }
    
    // Hide ad container (but it should be offscreen at this point)
    self.p_adContainerView.hidden = YES;

    if ([self IFA_shouldEnableAds]) {
        [self IFA_startAdRequests];
    }

}

-(BOOL)p_needsToolbar{
    return [(self.editing ? [self IFA_editModeToolbarItems] : [self IFA_nonEditModeToolbarItems]) count] > 0;
}

-(BOOL)p_helpMode{
    return [IAHelpManager sharedInstance].p_helpMode;
}

-(UIStoryboard*)IFA_commonStoryboard {
    static NSString * const k_storyboardName = @"CommonStoryboard";
    return [UIStoryboard storyboardWithName:k_storyboardName bundle:[[self IFA_appearanceTheme] bundle]];
}

-(void)IFA_reset {
    self.p_previousVisibleViewController = nil;
}

-(UINavigationItem*)IFA_navigationItem {
    if ([self.parentViewController isKindOfClass:[IAUIAbstractPagingContainerViewController class]] || [self.parentViewController isKindOfClass:[UITabBarController class]]) {
        return self.parentViewController.navigationItem;
    }else{
        return self.navigationItem;
    }
}

-(void)IFA_registerForHelp {
    if (![self.parentViewController isKindOfClass:[IAUIAbstractPagingContainerViewController class]]) {
        UIViewController *l_helpTargetViewController = [[IAHelpManager sharedInstance] isHelpEnabledForViewController:self] ? self : nil;
        [[IAHelpManager sharedInstance] observeHelpTargetContainer:l_helpTargetViewController];
    }
}

-(NSString*)IFA_editBarButtonItemHelpTargetId {
    NSString *l_helpTargetId = nil;
    if (self.editing) {
        BOOL l_doneButtonSaves = self.p_doneButtonSaves;
        if ([self isKindOfClass:[IAUIDynamicPagingContainerViewController class]]) {
            IAUIDynamicPagingContainerViewController *l_pagingContainerViewController = (IAUIDynamicPagingContainerViewController*)self;
            l_doneButtonSaves = [l_pagingContainerViewController visibleChildViewController].p_doneButtonSaves;
        }
        if (l_doneButtonSaves) {
            l_helpTargetId = [IAUIUtils helpTargetIdForName:@"saveButton"];
        }else{
            l_helpTargetId = [IAUIUtils helpTargetIdForName:@"doneButton"];
        }
    }else{
        l_helpTargetId = [IAUIUtils helpTargetIdForName:@"editButton"];
    }
    return l_helpTargetId;
}

-(void)IFA_openUrl:(NSURL*)a_url{
    [[IAExternalUrlManager sharedInstance] openUrl:a_url];
}

-(void)IFA_releaseView {
    [self ifa_releaseViewForController:self];
}

-(NSString*)IFA_accessibilityLabelForKeyPath:(NSString*)a_keyPath{
    return [[IAHelpManager sharedInstance] accessibilityLabelForKeyPath:a_keyPath];
}

-(NSString*)IFA_accessibilityLabelForName:(NSString*)a_name{
    return [self IFA_accessibilityLabelForKeyPath:[self IFA_helpTargetIdForName:a_name]];
}

-(void)IFA_showRefreshControl:(UIControl *)a_control inScrollView:(UIScrollView*)a_scrollView{
//    NSLog(@"m_showRefreshControl - a_control: %@", [a_control description]);
    CGFloat l_controlHeight = [a_control isKindOfClass:[ODRefreshControl class]] ? 44 : a_control.frame.size.height;
    [a_scrollView setContentOffset:CGPointMake(0, -(l_controlHeight)) animated:YES];
}

-(void)IFA_beginRefreshingWithScrollView:(UIScrollView*)a_scrollView{
    [self IFA_beginRefreshingWithScrollView:a_scrollView showControl:YES];
}

-(void)IFA_beginRefreshingWithScrollView:(UIScrollView *)a_scrollView showControl:(BOOL)a_shouldShowControl{
    if (!self.p_refreshControl.refreshing) {
        [self.p_refreshControl beginRefreshing];
        if (a_shouldShowControl) {
            [self IFA_showRefreshControl:self.p_refreshControl inScrollView:a_scrollView];
        }
    }
}

-(UIPopoverController*)IFA_newPopoverControllerWithContentViewController:(UIViewController*)a_contentViewController{
    UIPopoverController *l_popoverController = [[UIPopoverController alloc] initWithContentViewController:a_contentViewController];
    [[self IFA_appearanceTheme] setAppearanceForPopoverController:l_popoverController];
    return l_popoverController;
}

-(void)IFA_onDoneButtonTap:(UIBarButtonItem*)a_barButtonItem{
    [self IFA_notifySessionCompletion];
}

-(void)IFA_startAdRequests {
    
    if (![self IFA_shouldEnableAds] || [self IFA_gadBannerView].superview) {
        return;
    }
    
    // Add ad container subview
    UIView *l_adContainerView = self.p_adContainerView;
    if (l_adContainerView) {
        l_adContainerView.hidden = YES;
        l_adContainerView.frame = CGRectMake(0, self.view.frame.size.height, l_adContainerView.frame.size.width, l_adContainerView.frame.size.height);
//        NSLog(@"adContainerView.frame 3: %@", NSStringFromCGRect(l_adContainerView.frame));
        [self.view addSubview:l_adContainerView];
    }

    [self ifa_updateAdBannerSize];

    // Add the ad view to the container view
    [self.p_adContainerView addSubview:[self IFA_gadBannerView]];
    
    // Make a note of the owner view controller
    [IAUIApplicationDelegate sharedInstance].p_adsOwnerViewController = self;

    // Configure request Google ad request
    GADRequest *l_gadRequest = [GADRequest request];
    GADAdMobExtras *l_gadExtras = [[IAUIApplicationDelegate sharedInstance] gadExtras];
    if (l_gadExtras) {
        [l_gadRequest registerAdNetworkExtras:l_gadExtras];
    }
    
//    // Register simulator as a test device
//#if TARGET_IPHONE_SIMULATOR
//    l_gadRequest.testDevices = @[[[UIDevice currentDevice] performSelector:@selector(uniqueIdentifier)]];
//    //    NSLog(@"Configured test devices for Google Ads: %@", [l_gadRequest.testDevices description]);
//#endif
    
    // Initiate a generic Google ad request
    [self IFA_gadBannerView].delegate = self;
    [self IFA_gadBannerView].rootViewController = self;
    [[self IFA_gadBannerView] loadRequest:l_gadRequest];
    
}

-(void)IFA_stopAdRequests {
    
    if (![self IFA_shouldEnableAds] || ![self IFA_gadBannerView].superview) {
        return;
    }
    
    UIView *l_adContainerView = self.p_adContainerView;
    if (l_adContainerView) {
        [l_adContainerView removeFromSuperview];
        [self IFA_updateNonAdContainerViewFrameWithAdBannerViewHeight:0];
    }
    
    [[self IFA_gadBannerView] removeFromSuperview]; // This seems to stop ad loading
    [self IFA_gadBannerView].delegate = nil;
    [self IFA_gadBannerView].rootViewController = nil;

    [IAUIApplicationDelegate sharedInstance].p_adsOwnerViewController = self;
    
}

// To be overriden by subclasses
-(NSFetchedResultsController*)IFA_fetchedResultsController {
    return nil;
}

// Can be overriden by subclasses
-(id<NSFetchedResultsControllerDelegate>)IFA_fetchedResultsControllerDelegate {
    return self;
}

// Can be overriden by subclasses
-(void)IFA_configureFetchedResultsControllerAndPerformFetch {
    
    self.p_fetchedResultsController = [self IFA_fetchedResultsController];
    
    if (self.p_fetchedResultsController) {
        
        // Configure delegate
        self.p_fetchedResultsController.delegate = [self IFA_fetchedResultsControllerDelegate];
        
        // Perform fetch
        NSError *l_error;
        if (![self.p_fetchedResultsController performFetch:&l_error]) {
            [IAUtils handleUnrecoverableError:l_error];
        };
        
    }
    
}

- (BOOL)IFA_isVisibleTopViewController {
    return self.navigationController.topViewController==self && self.navigationController.viewControllers[0]==self;
}

- (void)IFA_updateNonAdContainerViewFrameWithAdBannerViewHeight:(CGFloat)a_adBannerViewHeight {
//    NSLog(@"m_updateNonAdContainerViewFrameWithAdBannerViewHeight BEFORE: self m_nonAdContainerView.frame: %@", NSStringFromCGRect([self IFA_nonAdContainerView].frame));
    CGRect l_newNonAdContainerViewFrame = [self IFA_nonAdContainerView].frame;
    l_newNonAdContainerViewFrame.size.height = self.view.frame.size.height - a_adBannerViewHeight;
    [self IFA_nonAdContainerView].frame = l_newNonAdContainerViewFrame;
//    NSLog(@"m_updateNonAdContainerViewFrameWithAdBannerViewHeight AFTER: self m_nonAdContainerView.frame: %@", NSStringFromCGRect([self IFA_nonAdContainerView].frame));
}

- (UIPopoverArrowDirection)IFA_permittedPopoverArrowDirectionForViewController:(UIViewController *)a_viewController {
    return [IAUIApplicationDelegate sharedInstance].p_isKeyboardVisible ? k_arrowDirectionWithKeyboard : k_arrowDirectionWithoutKeyboard;
}

- (void)IFA_presentActivityViewControllerFromBarButtonItem:(UIBarButtonItem *)a_barButtonItem
                                                   webView:(UIWebView *)a_webView {
    NSString *l_subjectString = [a_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSURL *l_url = a_webView.request.URL;
    [self IFA_presentActivityViewControllerFromBarButtonItem:a_barButtonItem subject:l_subjectString url:l_url];
}

- (void)IFA_presentActivityViewControllerFromBarButtonItem:(UIBarButtonItem *)a_barButtonItem
                                                   subject:(NSString *)a_subject url:(NSURL *)a_url {
    IAUISubjectActivityItem *l_subject = [[IAUISubjectActivityItem alloc] initWithSubject:a_subject];
    NSArray *l_activityItems = @[l_subject, a_url];
    id l_externalWebBrowserActivity = [IAUIExternalWebBrowserActivity new];
    NSArray *l_applicationActivities = @[l_externalWebBrowserActivity];
    UIActivityViewController *l_activityVC = [[UIActivityViewController alloc] initWithActivityItems:l_activityItems applicationActivities:l_applicationActivities];
    l_activityVC.p_presenter = self;
    [self IFA_presentModalSelectionViewController:l_activityVC fromBarButtonItem:a_barButtonItem];
}

- (void)IFA_addChildViewController:(UIViewController *)a_childViewController parentView:(UIView *)a_parentView {
    [self IFA_addChildViewController:a_childViewController parentView:a_parentView
                 shouldFillSuperview:YES];
}

- (void)IFA_addChildViewController:(UIViewController *)a_childViewController parentView:(UIView *)a_parentView
               shouldFillSuperview:(BOOL)a_shouldFillParentView {
    [self addChildViewController:a_childViewController];
    [a_parentView addSubview:a_childViewController.view];
    if (a_shouldFillParentView) {
        [a_childViewController.view IFA_addLayoutConstraintsToFillSuperview];
    }
    [a_childViewController didMoveToParentViewController:self];
}

- (void)IFA_removeFromParentViewController {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

-(void)IFA_onKeyboardNotification:(NSNotification*)a_notification {
    if (self.p_shouldUseKeyboardPassthroughView) {
        if ([a_notification.name isEqualToString:UIKeyboardDidShowNotification]) {
            [self.navigationController.view addSubview:self.p_keyboardPassthroughView];
            [self.p_keyboardPassthroughView IFA_addLayoutConstraintsToFillSuperview];
        } else if ([a_notification.name isEqualToString:UIKeyboardDidHideNotification]) {
            [self ifa_removeKeyboardPassthroughView];
        }
    }
}

+ (instancetype)IFA_instantiateFromStoryboard {
    NSString *l_storyboardName = [self IFA_storyboardName];
    id l_viewController = [UIStoryboard IFA_instantiateInitialViewControllerFromStoryboardNamed:l_storyboardName];
    NSAssert(l_viewController, @"It was not possible to instantiate view controller from storyboard named %@", l_storyboardName);
    return l_viewController;
}

+ (id)IFA_instantiateFromStoryboardWithViewControllerIdentifier:(NSString *)a_viewControllerIdentifier {
    NSString *l_storyboardName = [self IFA_storyboardName];
    id l_viewController = [UIStoryboard IFA_instantiateViewControllerWithIdentifier:a_viewControllerIdentifier
                                                                fromStoryboardNamed:l_storyboardName];
    NSAssert(l_viewController, @"It was not possible to instantiate view controller with identifier %@ from storyboard named %@", a_viewControllerIdentifier, l_storyboardName);
    return l_viewController;
}

+ (NSString *)IFA_storyboardName {
    NSMutableString *l_storyboardName = [NSMutableString stringWithString:[self description]];
    if ([self IFA_isStoryboardDeviceSpecific]) {
        if ([IAUIUtils isIPad]) {
            [l_storyboardName appendString:[self IFA_storyboardNameIPadSuffix]];
        }else{
            [l_storyboardName appendString:[self IFA_storyboardNameIPhoneSuffix]];
        }
    }
    return l_storyboardName;
}

+ (NSString *)IFA_storyboardNameIPhoneSuffix {
    return @"_iPhone";
}

+ (NSString *)IFA_storyboardNameIPadSuffix {
    return @"_iPad";
}

+ (BOOL)IFA_isStoryboardDeviceSpecific {
    return NO;
}

//-(void)m_simulateMemoryWarning{
//
//#ifdef DEBUG
//    NSLog(@"About to simulate memory warning situation...");
//    [IAUtils dispatchAsyncMainThreadBlock:^{
//        [[UIApplication sharedApplication] performSelector:@selector(_performMemoryWarning)];
//    }];
//#endif
//    
//}

#pragma mark - IAHelpTargetContainer

-(NSArray*)helpTargets {

    NSMutableArray *l_helpTargets = [NSMutableArray new];

    // Navigation bar
    id<IAHelpTarget> l_helpTarget = nil;
    if ((l_helpTarget=self.navigationController.navigationBar)) {
//        NSLog(@"navigationBar: %@", [l_helpTarget description]);
        [l_helpTargets addObject:l_helpTarget];
    }
//    NSLog(@"Processing left bar button items in %@...", [self description]);
    for (UIBarButtonItem *l_barButtonItem in self.navigationItem.leftBarButtonItems) {
//        NSLog(@"l_barButtonItem: %@, helpTargetId: %@, title: %@", [l_barButtonItem description], l_barButtonItem.p_helpTargetId, l_barButtonItem.title);
        [l_helpTargets addObject:l_barButtonItem];
    }
//    NSLog(@"Processing right bar button items in %@...", [self description]);
    for (UIBarButtonItem *l_barButtonItem in self.navigationItem.rightBarButtonItems) {
//        NSLog(@" l_barButtonItem: %@", [l_barButtonItem description]);
        if (l_barButtonItem.tag==IA_UIBAR_ITEM_TAG_HELP_BUTTON) {
//            NSLog(@" help button ignored");
            continue;
        }
//        NSLog(@" ifa_editBarButtonItem: %@", [[self m_editBarButtonItem] description]);
        if (l_barButtonItem== [self ifa_editBarButtonItem]) {
            l_barButtonItem.p_helpTargetId = [self IFA_editBarButtonItemHelpTargetId];
        }
        [l_helpTargets addObject:l_barButtonItem];
    }

    // Tool bar
    for (UIBarButtonItem *l_barButtonItem in self.navigationController.toolbar.items) {
        [l_helpTargets addObject:l_barButtonItem];
    }

    // Tab bar
    if (self.tabBarController.tabBar) {
        [l_helpTargets addObject:self.tabBarController.tabBar];
    }

    return l_helpTargets;

}

-(UIView*)helpModeToggleView {
    return self.navigationController.navigationBar;
}

-(UIView*)targetView {
    return [self IFA_mainViewController].view;
}

-(void)willEnterHelpMode {
    // does nothing
}

-(void)didEnterHelpMode {
    // does nothing
}

-(void)willExitHelpMode {
    // does nothing
}

-(void)didExitHelpMode {
    // does nothing
}

-(void)IFA_logAnalyticsScreenEntry {
    if (![self IFA_isReturningVisibleViewController]) {
        [IAAnalyticsUtils logEntryForScreenName:self.navigationItem.title];
    }
}

#pragma mark - IAUIPresenter protocol

-(void)changesMadeByViewController:(UIViewController *)a_viewController{
    // Subclasses to override
}

- (void)sessionDidCompleteForViewController:(UIViewController *)a_viewController changesMade:(BOOL)a_changesMade
                                       data:(id)a_data {
    self.p_changesMadeByPresentedViewController = a_changesMade;
    [self IFA_registerForHelp];
    if (a_viewController.p_presentedAsModal) {
        [self IFA_dismissModalViewControllerWithChangesMade:a_changesMade data:a_data];
    }else{
        [a_viewController.navigationController popViewControllerAnimated:YES];
    }
}

-(void)didPresentViewController:(UIViewController *)a_viewController{
    // Subclasses to override
}

- (void)didDismissViewController:(UIViewController *)a_viewController changesMade:(BOOL)a_changesMade
                            data:(id)a_data {
    // Subclasses to override
}

#pragma mark - GADBannerViewDelegate

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    
//    NSLog(@"adViewDidReceiveAd in %@ - bannerView.frame: %@", [self description], NSStringFromCGRect(bannerView.frame));
    
    if ([self IFA_shouldEnableAds]) {
        
        if (![IAUIApplicationDelegate sharedInstance].p_adsSuspended) {
            UIView *l_adContainerView = self.p_adContainerView;
            if (l_adContainerView.hidden) {
                [UIView animateWithDuration:0.2 animations:^{
                    l_adContainerView.hidden = NO;
                    CGFloat l_bannerViewHeight = bannerView.frame.size.height;
                    [self IFA_updateNonAdContainerViewFrameWithAdBannerViewHeight:l_bannerViewHeight];
                    [self ifa_updateAdContainerViewFrameWithAdBannerViewHeight:l_bannerViewHeight];
                }];
            }
        }

    }else{

        // This can occur if ads were previously enabled but have now been disabled and the UI has not been reloaded yet
        [self IFA_stopAdRequests];

    }
    
}

-(void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error{

    NSLog(@"didFailToReceiveAdWithError: %@", [error description]);

    if ([self IFA_shouldEnableAds]) {
        // This can occur if ads were previously enabled but have now been disabled and the UI has not been reloaded yet
        [self IFA_stopAdRequests];
    }

}

- (void)adViewWillPresentScreen:(GADBannerView *)bannerView{

    //    NSLog(@"adViewWillPresentScreen");

    // Hides the status overlay in case it is being used
    [[MTStatusBarOverlay sharedInstance] hide];

}

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [self.p_presenter sessionDidCompleteForViewController:self changesMade:NO data:nil ];
}

@end
