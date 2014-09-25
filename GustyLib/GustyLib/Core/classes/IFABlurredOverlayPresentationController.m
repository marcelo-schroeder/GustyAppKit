//
// Created by Marcelo Schroeder on 25/09/2014.
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

#import "GustyLibCore.h"

@interface IFABlurredOverlayPresentationController ()
@end

@implementation IFABlurredOverlayPresentationController {

}

#pragma mark - Overrides

-(instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController{
    self = [super initWithPresentedViewController:presentedViewController
                         presentingViewController:presentingViewController];
    if (self) {
        self.overlayPresentationControllerDataSource = self;
    }
    return self;
}

#pragma mark - IFAOverlayPresentationControllerDataSource

- (UIView *)overlayViewForOverlayPresentationController:(IFAOverlayPresentationController *)a_overlayPresentationController {
    UIImageView *overlayImageView = [UIImageView new];
    overlayImageView.image = [[self.presentingViewController.view ifa_snapshotImage] ifa_imageWithBlurEffect:IFABlurEffectDark radius:10];  //wip: should this be parametrised further?
    return overlayImageView;
}

@end