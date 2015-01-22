//
// Created by Marcelo Schroeder on 15/01/15.
// Copyright (c) 2015 InfoAccent Pty Ltd. All rights reserved.
//

#import "IFAHudManager.h"
#import "GustyLibCoreUI.h"


//wip: memory profile this window thing
@interface IFAHudManager ()
@property(nonatomic, strong) UIWindow *IFA_window;
@property(nonatomic, strong) IFAHudViewController *hudViewController;
@property(nonatomic) IFAHudChromeViewLayoutFittingMode chromeViewLayoutFittingMode;
@end

@implementation IFAHudManager {

}

#pragma mark - Public

- (instancetype)initWithStyle:(IFAHudViewStyle)a_style
  chromeViewLayoutFittingMode:(IFAHudChromeViewLayoutFittingMode)a_chromeViewLayoutFittingMode {
    self = [super init];
    if (self) {
        self.hudViewController = [[IFAHudViewController alloc] initWithStyle:a_style];
        self.chromeViewLayoutFittingMode = a_chromeViewLayoutFittingMode;
        self.visualIndicatorMode = IFAHudVisualIndicatorModeNone;
    }
    return self;
}

- (void)presentWithCompletion:(void (^)())a_completion {
    [self presentWithAutoDismissalDelay:0 completion:a_completion];
}

- (void)presentWithAutoDismissalDelay:(NSTimeInterval)a_autoDismissalDelay completion:(void (^)())a_completion {
    [self presentWithPresentingViewController:nil animated:YES autoDismissalDelay:a_autoDismissalDelay
                                   completion:a_completion];
}

- (void)presentWithPresentingViewController:(UIViewController *)a_presentingViewController animated:(BOOL)a_animated
                         autoDismissalDelay:(NSTimeInterval)a_autoDismissalDelay completion:(void (^)())a_completion {
    void (^completion)() = ^{
        __weak UIViewController *presentingViewController = a_presentingViewController?:self.IFA_window.rootViewController;
        if (a_autoDismissalDelay) {
            [IFAUtils dispatchAsyncMainThreadBlock:^{
                [self dismissWithPresentingViewController:presentingViewController
                                                 animated:a_animated completion:nil];
            } afterDelay:a_autoDismissalDelay];
        }
        if (a_completion) {
            a_completion();
        }
    };
    if (a_presentingViewController) {
        [a_presentingViewController presentViewController:self.hudViewController
                                                 animated:a_animated
                                               completion:completion];
    } else {
        if (self.IFA_window.hidden) {
            [self.IFA_window makeKeyAndVisible];
            [self.IFA_window.rootViewController presentViewController:self.hudViewController
                                                             animated:a_animated
                                                           completion:completion];
        }
    }
}

- (void)dismissWithCompletion:(void (^)())a_completion {
    [self dismissWithPresentingViewController:nil animated:YES completion:a_completion];
}

- (void)dismissWithPresentingViewController:(UIViewController *)a_presentingViewController animated:(BOOL)a_animated
                                 completion:(void (^)())a_completion {
    if (a_presentingViewController) {
        [a_presentingViewController dismissViewControllerAnimated:a_animated
                                                       completion:a_completion];
    } else {
        if (!self.IFA_window.hidden) {
            __weak __typeof(self) l_weakSelf = self;
            void(^completion)() = ^{
                if (a_completion) {
                    a_completion();
                }
                [l_weakSelf.IFA_window resignKeyWindow];
                l_weakSelf.IFA_window.hidden = YES;
            };
            [l_weakSelf.IFA_window.rootViewController dismissViewControllerAnimated:a_animated
                                                                         completion:completion];
        }
    }
}

- (void)setText:(NSString *)text {
    self.hudViewController.hudView.textLabel.text = text;
}

- (NSString *)text {
    return self.hudViewController.hudView.textLabel.text;
}


- (void)setDetailText:(NSString *)detailText {
    self.hudViewController.hudView.detailTextLabel.text = detailText;
}

- (NSString *)detailText {
    return self.hudViewController.hudView.detailTextLabel.text;
}

- (void)setTapActionBlock:(void (^)())tapActionBlock {
    _tapActionBlock = tapActionBlock;
    [self IFA_updateHudViewControllerTapActionBlock];
}

- (void)setShouldDismissOnTap:(BOOL)shouldDismissOnTap {
    _shouldDismissOnTap = shouldDismissOnTap;
    [self IFA_updateHudViewControllerTapActionBlock];
}

- (void)setProgress:(CGFloat)progress {
    self.hudViewController.hudView.progressView.progress = progress;
}

- (CGFloat)progress {
    return self.hudViewController.hudView.progressView.progress;
}

- (void)setVisualIndicatorMode:(IFAHudVisualIndicatorMode)visualIndicatorMode {
    _visualIndicatorMode = visualIndicatorMode;
    if (visualIndicatorMode == IFAHudVisualIndicatorModeProgressIndeterminate) {
        [self.hudViewController.hudView.activityIndicatorView startAnimating];
    } else {
        [self.hudViewController.hudView.activityIndicatorView stopAnimating];
    }
    self.hudViewController.hudView.progressView.hidden = visualIndicatorMode !=IFAHudVisualIndicatorModeProgressDeterminate;
    if (visualIndicatorMode == IFAHudVisualIndicatorModeSuccess || visualIndicatorMode == IFAHudVisualIndicatorModeError) {
        NSString *imageName = visualIndicatorMode == IFAHudVisualIndicatorModeSuccess ? @"IFA_Icon_HudSuccess" : @"IFA_Icon_HudError";
        UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        self.hudViewController.hudView.customView = imageView;
    }
}

- (void)setChromeViewLayoutFittingMode:(IFAHudChromeViewLayoutFittingMode)chromeViewLayoutFittingMode {
    _chromeViewLayoutFittingMode = chromeViewLayoutFittingMode;
    self.hudViewController.hudView.chromeViewLayoutFittingSize = chromeViewLayoutFittingMode == IFAHudChromeViewLayoutFittingModeExpanded ? UILayoutFittingExpandedSize : UILayoutFittingCompressedSize;
}

- (NSTimeInterval)presentationTransitionDuration {
    return self.hudViewController.viewControllerTransitioningDelegate.viewControllerAnimatedTransitioning.presentationTransitionDuration;
}

- (void)setPresentationTransitionDuration:(NSTimeInterval)presentationTransitionDuration {
    self.hudViewController.viewControllerTransitioningDelegate.viewControllerAnimatedTransitioning.presentationTransitionDuration = presentationTransitionDuration;
}

- (NSTimeInterval)dismissalTransitionDuration {
    return self.hudViewController.viewControllerTransitioningDelegate.viewControllerAnimatedTransitioning.dismissalTransitionDuration;
}

- (void)setDismissalTransitionDuration:(NSTimeInterval)dismissalTransitionDuration {
    self.hudViewController.viewControllerTransitioningDelegate.viewControllerAnimatedTransitioning.dismissalTransitionDuration = dismissalTransitionDuration;
}

- (UIView *)customVisualIndicatorView {
    return self.hudViewController.hudView.customView;
}

- (void)setCustomVisualIndicatorView:(UIView *)customVisualIndicatorView {
    self.visualIndicatorMode = customVisualIndicatorView ? IFAHudVisualIndicatorModeCustom : IFAHudVisualIndicatorModeNone;
    self.hudViewController.hudView.customView = customVisualIndicatorView;
}

- (UIColor *)chromeForegroundColour {
    return self.hudViewController.hudView.chromeForegroundColour;
}

- (void)setChromeForegroundColour:(UIColor *)chromeForegroundColour {
    self.hudViewController.hudView.chromeForegroundColour = chromeForegroundColour;
}

- (UIColor *)chromeBackgroundColour {
    return self.hudViewController.hudView.chromeBackgroundColour;
}

- (void)setChromeBackgroundColour:(UIColor *)chromeBackgroundColour {
    self.hudViewController.hudView.chromeBackgroundColour = chromeBackgroundColour;
}

- (BOOL)shouldAnimateLayoutChanges {
    return self.hudViewController.hudView.shouldAnimateLayoutChanges;
}

- (void)setShouldAnimateLayoutChanges:(BOOL)shouldAnimateLayoutChanges {
    self.hudViewController.hudView.shouldAnimateLayoutChanges = shouldAnimateLayoutChanges;
}

- (IFAHudViewStyle)style {
    return self.hudViewController.hudView.style;
}

#pragma mark - Overrides

- (instancetype)init {
    return [self initWithStyle:(IFAHudViewStylePlain)
   chromeViewLayoutFittingMode:IFAHudChromeViewLayoutFittingModeCompressed];
}

#pragma mark - Private

- (UIWindow *)IFA_window {
    if (!_IFA_window) {
        _IFA_window = [[UIWindow alloc] initWithFrame:[UIApplication sharedApplication].delegate.window.bounds];
        _IFA_window.backgroundColor = [UIColor clearColor];
        UIViewController *rootViewController = [UIViewController new];
        _IFA_window.rootViewController = rootViewController;
    }
    return _IFA_window;
}

- (void)IFA_updateHudViewControllerTapActionBlock {
    __weak __typeof(self) l_weakSelf = self;
    self.hudViewController.tapActionBlock = ^{
        if (l_weakSelf.tapActionBlock) {
            l_weakSelf.tapActionBlock();
        }
        if (l_weakSelf.shouldDismissOnTap) {
            [l_weakSelf dismissWithPresentingViewController:nil animated:YES completion:nil];
        }
    };
}

@end