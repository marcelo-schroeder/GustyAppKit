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

#import "GustyKitCoreUI.h"

@interface IFABlurredFadingOverlayPresentationController ()
@property(nonatomic) IFABlurEffect IFA_blurEffect;
@property(nonatomic) CGFloat IFA_radius;
@end

@implementation IFABlurredFadingOverlayPresentationController {

}

#pragma mark - Public

-(instancetype)initWithBlurEffect:(IFABlurEffect)a_blurEffect
                           radius:(CGFloat)a_radius
          presentedViewController:(UIViewController *)a_presentedViewController
         presentingViewController:(UIViewController *)a_presentingViewController {
    self = [super initWithPresentedViewController:a_presentedViewController
                         presentingViewController:a_presentingViewController];
    if (self) {
        self.IFA_blurEffect = a_blurEffect;
        self.IFA_radius = a_radius;
        self.fadingOverlayPresentationControllerDataSource = self;
    }
    return self;
}

#pragma mark - IFAFadingOverlayPresentationControllerDataSource

- (UIView *)overlayViewForFadingOverlayPresentationController:(IFAFadingOverlayPresentationController *)a_overlayPresentationController {
    UIImageView *overlayImageView = [UIImageView new];
    overlayImageView.image = [[self.presentingViewController.view ifa_snapshotImage] ifa_imageWithBlurEffect:self.IFA_blurEffect
                                                                                                      radius:self.IFA_radius];
    return overlayImageView;
}

@end