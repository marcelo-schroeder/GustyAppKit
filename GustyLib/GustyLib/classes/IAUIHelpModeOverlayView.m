//
//  IAUIHelpModeOverlayView.m
//  Gusty
//
//  Created by Marcelo Schroeder on 29/03/12.
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

#import "IACommon.h"

@interface IAUIHelpModeOverlaySpotlightMaskView : UIView

@end

@interface IAUIHelpModeOverlayView()

@property (nonatomic) BOOL p_shouldSpotlight;
@property (nonatomic) BOOL p_showingSpotlight;
@property (nonatomic) BOOL p_finalDrawing;
@property (nonatomic) BOOL p_removeSpotlightWithAnimation;
@property (nonatomic) CGRect p_spotlightRect;

@property (nonatomic, strong) IAUIHelpModeOverlaySpotlightMaskView *p_spotlightMask;

@end

@implementation IAUIHelpModeOverlayView{
    
}

#pragma mark - Private

+(UIColor*)m_backgroundColour{
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.70];
}

#pragma mark - Overrides

- (id)init{
    
    CGSize l_size = [IAUIUtils screenBoundsSizeForCurrentOrientation];
    if (self = [super initWithFrame:CGRectMake(0, 0, l_size.width, l_size.height)]) {
        
        self.userInteractionEnabled = NO;
        self.tag = IA_UIVIEW_TAG_HELP_BACKGROUND;
        self.opaque = NO;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
    }
    
    return self;
    
}

- (void)drawRect:(CGRect)rect{
    
    //    NSLog(@"drawRect: %@", NSStringFromCGRect(rect));
    
    CGContextRef l_context = UIGraphicsGetCurrentContext();
    
    // Fill the rect with the background colour
    CGContextSetFillColorWithColor(l_context, [IAUIHelpModeOverlayView m_backgroundColour].CGColor);
    CGContextFillRect(l_context, rect);
    
    IAUIHelpModeOverlaySpotlightMaskView *l_previousSpotlightMask = nil;
    if (!self.p_finalDrawing) {
        
        if (self.p_showingSpotlight && self.p_removeSpotlightWithAnimation) {
            
            l_previousSpotlightMask = self.p_spotlightMask;
            
            // Draw spotlight
            CGContextSetFillColorWithColor(l_context, [UIColor clearColor].CGColor);
            CGContextSetBlendMode(l_context, kCGBlendModeClear);
            CGContextFillEllipseInRect(l_context, l_previousSpotlightMask.frame);
            
        }
        
        // Add spotlight mask
        if (self.p_shouldSpotlight) {
            self.p_spotlightMask = [[IAUIHelpModeOverlaySpotlightMaskView alloc] initWithFrame:self.p_spotlightRect];
            [self addSubview:self.p_spotlightMask];
        }
        
    }
    
    // Draw spotlight if required
    if (self.p_shouldSpotlight) {
        CGContextSetFillColorWithColor(l_context, [UIColor clearColor].CGColor);
        CGContextSetBlendMode(l_context, kCGBlendModeClear);
        CGContextFillEllipseInRect(l_context, self.p_spotlightRect);
        self.p_showingSpotlight = YES;
    }else {
        self.p_showingSpotlight = NO;
    }
    
    if (!self.p_finalDrawing) {
        
        self.p_finalDrawing = YES;
        
        // Schedule animations
        [IAUtils m_dispatchAsyncMainThreadBlock:^{
            
            BOOL l_removeSpotlightWithAnimation = self.p_removeSpotlightWithAnimation;
            
            [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                if (self.p_shouldSpotlight) {
                    [self.p_spotlightMask removeFromSuperview];
                }
                if (self.p_removeSpotlightWithAnimation) {
                    if (l_previousSpotlightMask) {
                        [self addSubview:l_previousSpotlightMask];
                    }
                }
            } completion:^(BOOL finished) {
                if (l_removeSpotlightWithAnimation) {
                    [l_previousSpotlightMask removeFromSuperview];
                    [self setNeedsDisplay];
                }
            }];
            
        }];
        
    }
    
}

#pragma mark - Public

-(void)m_spotlightAtRect:(CGRect)a_rect{
    
    // Correct the rect provided to compensate for shapes that are much wider than they are taller
    //  (i.e. the ellipse drawn here looks better when corrected this way)
//    NSLog(@"a_rect: %@", NSStringFromCGRect(a_rect));
    static CGFloat const k_xCorrectionFactor = 6;
    CGFloat l_widthHeightRatio = a_rect.size.width / a_rect.size.height;
//    NSLog(@"l_widthHeightRatio: %f", l_widthHeightRatio);
    CGFloat l_xCorrection = l_widthHeightRatio>=1.0 ? ((l_widthHeightRatio - 1) * k_xCorrectionFactor) : 0;
//    NSLog(@"l_xCorrection: %f", l_xCorrection);
    CGFloat l_x = a_rect.origin.x - l_xCorrection;
    CGFloat l_width = a_rect.size.width + (l_xCorrection * 2);
    CGRect l_correctedRect = CGRectMake(l_x, a_rect.origin.y, l_width, a_rect.size.height);

    // Set up correct state for the spotlight to be drawn
    self.p_spotlightRect = l_correctedRect;
    self.p_shouldSpotlight = YES;
    [self.p_spotlightMask setNeedsDisplay];
    
    // Draw spotlight
    self.p_finalDrawing = NO;
    self.p_removeSpotlightWithAnimation = NO;
    [self setNeedsDisplay];
    
}

-(void)m_removeSpotlightWithAnimation:(BOOL)a_animate{
    
    self.p_shouldSpotlight = NO;
    self.p_finalDrawing = NO;
    self.p_removeSpotlightWithAnimation = a_animate;
    [self setNeedsDisplay];
    
}

@end

@implementation IAUIHelpModeOverlaySpotlightMaskView

#pragma mark - Overrides

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.userInteractionEnabled = NO;
        self.opaque = NO;
        
    }
    
    return self;
    
}

- (void)drawRect:(CGRect)rect{
    
    //    NSLog(@"drawRect");
    
    CGContextRef l_context = UIGraphicsGetCurrentContext();
    
    // Fill the rect with the clear background
    CGContextSetFillColorWithColor(l_context, [UIColor clearColor].CGColor);
    CGContextFillRect(l_context, rect);
    
    // Draw spotlight mask
    CGContextSetFillColorWithColor(l_context, [IAUIHelpModeOverlayView m_backgroundColour].CGColor);
    CGContextFillEllipseInRect(l_context, rect);
    
}

@end