//
//  UIImage+IFACategory.h
//  Gusty
//
//  Created by Marcelo Schroeder on 13/07/12.
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

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, IFASeparatorImageType){
    IFASeparatorImageTypeHorizontalTop,
    IFASeparatorImageTypeVerticalLeft,
    IFASeparatorImageTypeHorizontalBottom,
    IFASeparatorImageTypeVerticalRight,
};

typedef NS_ENUM(NSUInteger, IFABlurEffect){
    IFABlurEffectLight,
    IFABlurEffectExtraLight,
    IFABlurEffectDark,
};

@interface UIImage (IFACoreUI)

-(UIImage*)ifa_imageWithOverlayColor:(UIColor*)a_color;
-(UIImage*)ifa_imageWithHue:(CGFloat)a_hue;
-(UIImage*)ifa_imageWithHueInDegrees:(CGFloat)a_hueInDegrees;

- (UIImage *)ifa_imageWithTintBlurEffectForColor:(UIColor *)tintColor;
- (UIImage *)ifa_imageWithBlurEffectForRadius:(CGFloat)a_radius tintColor:(UIColor *)a_tintColor
                        saturationDeltaFactor:(CGFloat)a_saturationDeltaFactor maskImage:(UIImage *)a_maskImage;
- (UIImage *)ifa_imageWithBlurEffect:(IFABlurEffect)a_blurEffect;
- (UIImage *)ifa_imageWithBlurEffect:(IFABlurEffect)a_blurEffect radius:(CGFloat)a_radius;

- (UIImage *)ifa_imageWithOrientationUp;

/**
* @returns Image's aspect ratio (width divided by height)
*/
- (CGFloat)ifa_aspectRatio;

+ (UIImage*)ifa_imageWithColor:(UIColor *)a_color rect:(CGRect)a_rect;
+ (UIImage*)ifa_imageWithColor:(UIColor*)a_color;

/**
* @param a_separatorImageType Type of separator to provide an image for.
* @return 1 pixel separator image of type specified. The color will be the default color used by iOS for table view cell separators.
*/
+ (UIImage *)ifa_separatorImageForType:(IFASeparatorImageType)a_separatorImageType;

@end
