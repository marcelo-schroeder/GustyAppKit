//
//  ECSlidingViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import "IA_ECSlidingViewController.h"

NSString *const IA_ECSlidingViewUnderRightWillAppear = @"ECSlidingViewUnderRightWillAppear";
NSString *const IA_ECSlidingViewUnderLeftWillAppear = @"ECSlidingViewUnderLeftWillAppear";
NSString *const IA_ECSlidingViewTopDidAnchorLeft = @"ECSlidingViewTopDidAnchorLeft";
NSString *const IA_ECSlidingViewTopDidAnchorRight = @"ECSlidingViewTopDidAnchorRight";
NSString *const IA_ECSlidingViewTopDidReset = @"ECSlidingViewTopDidReset";

@interface IA_ECSlidingViewController ()

@property (nonatomic, strong) UIView *topViewSnapshot;
@property (nonatomic, unsafe_unretained) CGFloat initialTouchPositionX;
@property (nonatomic, unsafe_unretained) CGFloat initialHoizontalCenter;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UITapGestureRecognizer *resetTapGesture;
@property (nonatomic, unsafe_unretained) BOOL underLeftShowing;
@property (nonatomic, unsafe_unretained) BOOL underRightShowing;
@property (nonatomic, unsafe_unretained) BOOL topViewIsOffScreen;

- (NSUInteger)autoResizeToFillScreen;
- (UIView *)topView;
- (UIView *)underLeftView;
- (UIView *)underRightView;
- (void)adjustLayout;
- (void)updateTopViewHorizontalCenterWithRecognizer:(UIPanGestureRecognizer *)recognizer;
- (void)updateTopViewHorizontalCenter:(CGFloat)newHorizontalCenter;
- (void)topViewHorizontalCenterWillChange:(CGFloat)newHorizontalCenter;
- (void)topViewHorizontalCenterDidChange:(CGFloat)newHorizontalCenter;
- (void)addTopViewSnapshot;
- (void)removeTopViewSnapshot;
- (CGFloat)anchorRightTopViewCenter;
- (CGFloat)anchorLeftTopViewCenter;
- (CGFloat)resettedCenter;
- (CGFloat)screenWidth;
- (CGFloat)screenWidthForOrientation:(UIInterfaceOrientation)orientation;
- (void)underLeftWillAppear;
- (void)underRightWillAppear;
- (void)topDidReset;
- (BOOL)topViewHasFocus;
- (void)updateUnderLeftLayout;
- (void)updateUnderRightLayout;

@end

@implementation UIViewController(IA_ECSlidingViewExtension)

- (IA_ECSlidingViewController *)slidingViewController
{
  UIViewController *viewController = self.parentViewController;
  while (!(viewController == nil || [viewController isKindOfClass:[IA_ECSlidingViewController class]])) {
    viewController = viewController.parentViewController;
  }
  
  return (IA_ECSlidingViewController *)viewController;
}

@end

@implementation IA_ECSlidingViewController

// public properties

// category properties

- (void)setTopViewController:(UIViewController *)theTopViewController
{

    CGRect l_frame = self.view.bounds;
    if (_topViewController) {
        l_frame = _topViewController.view.frame;
    }
    
  [self removeTopViewSnapshot];
  [_topViewController.view removeFromSuperview];
  [_topViewController willMoveToParentViewController:nil];
  [_topViewController removeFromParentViewController];
  
  _topViewController = theTopViewController;
  
  [self addChildViewController:self.topViewController];
  [self.topViewController didMoveToParentViewController:self];
  
  [_topViewController.view setAutoresizingMask:self.autoResizeToFillScreen];
//    [_topViewController.view setFrame:self.view.bounds];
    [_topViewController.view setFrame:l_frame];
  _topViewController.view.layer.shadowOffset = CGSizeZero;
  _topViewController.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.layer.bounds].CGPath;
  
  [self.view addSubview:_topViewController.view];
}

- (void)setUnderLeftViewController:(UIViewController *)theUnderLeftViewController
{
  [_underLeftViewController.view removeFromSuperview];
  [_underLeftViewController willMoveToParentViewController:nil];
  [_underLeftViewController removeFromParentViewController];
  
  _underLeftViewController = theUnderLeftViewController;
  
  if (_underLeftViewController) {
    [self addChildViewController:self.underLeftViewController];
    [self.underLeftViewController didMoveToParentViewController:self];
    
    [self updateUnderLeftLayout];
    
    [self.view insertSubview:_underLeftViewController.view atIndex:0];
  }
}

- (void)setUnderRightViewController:(UIViewController *)theUnderRightViewController
{
  [_underRightViewController.view removeFromSuperview];
  [_underRightViewController willMoveToParentViewController:nil];
  [_underRightViewController removeFromParentViewController];
  
  _underRightViewController = theUnderRightViewController;
  
  if (_underRightViewController) {
    [self addChildViewController:self.underRightViewController];
    [self.underRightViewController didMoveToParentViewController:self];
    
    [self updateUnderRightLayout];
    
    [self.view insertSubview:_underRightViewController.view atIndex:0];
  }
}

- (void)setUnderLeftWidthLayout:(IA_ECViewWidthLayout)underLeftWidthLayout
{
  if (underLeftWidthLayout == IA_ECVariableRevealWidth && self.anchorRightPeekAmount <= 0) {
    [NSException raise:@"Invalid Width Layout" format:@"anchorRightPeekAmount must be set"];
  } else if (underLeftWidthLayout == IA_ECFixedRevealWidth && self.anchorRightRevealAmount <= 0) {
    [NSException raise:@"Invalid Width Layout" format:@"anchorRightRevealAmount must be set"];
  }
  
  _underLeftWidthLayout = underLeftWidthLayout;
}

- (void)setUnderRightWidthLayout:(IA_ECViewWidthLayout)underRightWidthLayout
{
  if (underRightWidthLayout == IA_ECVariableRevealWidth && self.anchorLeftPeekAmount <= 0) {
    [NSException raise:@"Invalid Width Layout" format:@"anchorLeftPeekAmount must be set"];
  } else if (underRightWidthLayout == IA_ECFixedRevealWidth && self.anchorLeftRevealAmount <= 0) {
    [NSException raise:@"Invalid Width Layout" format:@"anchorLeftRevealAmount must be set"];
  }
  
  _underRightWidthLayout = underRightWidthLayout;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.shouldAllowUserInteractionsWhenAnchored = NO;
  self.resetTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetTopView)];
  _panGesture          = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(updateTopViewHorizontalCenterWithRecognizer:)];
  self.resetTapGesture.enabled = NO;
  self.resetStrategy = IA_ECTapping | IA_ECPanning;
  
  self.topViewSnapshot = [[UIView alloc] initWithFrame:self.topView.bounds];
  [self.topViewSnapshot setAutoresizingMask:self.autoResizeToFillScreen];
  [self.topViewSnapshot addGestureRecognizer:self.resetTapGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.topView.layer.shadowOffset = CGSizeZero;
  self.topView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.layer.bounds].CGPath;
  [self adjustLayout];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  self.topView.layer.shadowPath = nil;
  self.topView.layer.shouldRasterize = YES;
  
  if(![self topViewHasFocus]){
    [self removeTopViewSnapshot];
  }
  
  [self adjustLayout];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
  self.topView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.layer.bounds].CGPath;
  self.topView.layer.shouldRasterize = NO;
  
  if(![self topViewHasFocus]){
    [self addTopViewSnapshot];
  }
}

- (void)setResetStrategy:(IA_ECResetStrategy)theResetStrategy
{
  _resetStrategy = theResetStrategy;
  if (_resetStrategy & IA_ECTapping) {
    self.resetTapGesture.enabled = YES;
  } else {
    self.resetTapGesture.enabled = NO;
  }
}

- (void)adjustLayout
{
  self.topViewSnapshot.frame = self.topView.bounds;
  
  if ([self underRightShowing] && ![self topViewIsOffScreen]) {
    [self updateUnderRightLayout];
    [self updateTopViewHorizontalCenter:self.anchorLeftTopViewCenter];
  } else if ([self underRightShowing] && [self topViewIsOffScreen]) {
    [self updateUnderRightLayout];
    [self updateTopViewHorizontalCenter:-self.resettedCenter];
  } else if ([self underLeftShowing] && ![self topViewIsOffScreen]) {
    [self updateUnderLeftLayout];
    [self updateTopViewHorizontalCenter:self.anchorRightTopViewCenter];
  } else if ([self underLeftShowing] && [self topViewIsOffScreen]) {
    [self updateUnderLeftLayout];
    [self updateTopViewHorizontalCenter:self.screenWidth + self.resettedCenter];
  }
}

- (void)updateTopViewHorizontalCenterWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
  CGPoint currentTouchPoint     = [recognizer locationInView:self.view];
  CGFloat currentTouchPositionX = currentTouchPoint.x;
  
  if (recognizer.state == UIGestureRecognizerStateBegan) {
    self.initialTouchPositionX = currentTouchPositionX;
    self.initialHoizontalCenter = self.topView.center.x;
  } else if (recognizer.state == UIGestureRecognizerStateChanged) {
    CGFloat panAmount = self.initialTouchPositionX - currentTouchPositionX;
    CGFloat newCenterPosition = self.initialHoizontalCenter - panAmount;
    
    if ((newCenterPosition < self.resettedCenter && self.anchorLeftTopViewCenter == NSNotFound) || (newCenterPosition > self.resettedCenter && self.anchorRightTopViewCenter == NSNotFound)) {
      newCenterPosition = self.resettedCenter;
    }
    
    [self topViewHorizontalCenterWillChange:newCenterPosition];
    [self updateTopViewHorizontalCenter:newCenterPosition];
    [self topViewHorizontalCenterDidChange:newCenterPosition];
  } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
    CGPoint currentVelocityPoint = [recognizer velocityInView:self.view];
    CGFloat currentVelocityX     = currentVelocityPoint.x;
    
    if ([self underLeftShowing] && currentVelocityX > 100) {
        [self anchorTopViewTo:IA_ECRight];
    } else if ([self underRightShowing] && currentVelocityX < 100) {
        [self anchorTopViewTo:IA_ECLeft];
    } else {
      [self resetTopView];
    }
  }
}

- (UIPanGestureRecognizer *)panGesture
{
  return _panGesture;
}

- (void)anchorTopViewTo:(IA_ECSide)side
{
  [self anchorTopViewTo:side animations:nil onComplete:nil];
}

- (void)anchorTopViewTo:(IA_ECSide)side animations:(void (^)())animations onComplete:(void (^)())complete
{
  CGFloat newCenter = self.topView.center.x;
  
  if (side == IA_ECLeft) {
    newCenter = self.anchorLeftTopViewCenter;
  } else if (side == IA_ECRight) {
    newCenter = self.anchorRightTopViewCenter;
  }
  
  [self topViewHorizontalCenterWillChange:newCenter];
  
  [UIView animateWithDuration:0.25f animations:^{
    if (animations) {
      animations();
    }
    [self updateTopViewHorizontalCenter:newCenter];
  } completion:^(BOOL finished){
    if (_resetStrategy & IA_ECPanning) {
      self.panGesture.enabled = YES;
    } else {
      self.panGesture.enabled = NO;
    }
    if (complete) {
      complete();
    }
    _topViewIsOffScreen = NO;
    [self addTopViewSnapshot];
    dispatch_async(dispatch_get_main_queue(), ^{
      NSString *key = (side == IA_ECLeft) ? IA_ECSlidingViewTopDidAnchorLeft : IA_ECSlidingViewTopDidAnchorRight;
      [[NSNotificationCenter defaultCenter] postNotificationName:key object:self userInfo:nil];
    });
  }];
}

- (void)anchorTopViewOffScreenTo:(IA_ECSide)side
{
  [self anchorTopViewOffScreenTo:side animations:nil onComplete:nil];
}

- (void)anchorTopViewOffScreenTo:(IA_ECSide)side animations:(void(^)())animations onComplete:(void(^)())complete
{
  CGFloat newCenter = self.topView.center.x;
  
  if (side == IA_ECLeft) {
    newCenter = -self.resettedCenter;
  } else if (side == IA_ECRight) {
    newCenter = self.screenWidth + self.resettedCenter;
  }
  
  [self topViewHorizontalCenterWillChange:newCenter];
  
  [UIView animateWithDuration:0.25f animations:^{
    if (animations) {
      animations();
    }
    [self updateTopViewHorizontalCenter:newCenter];
  } completion:^(BOOL finished){
    if (complete) {
      complete();
    }
    _topViewIsOffScreen = YES;
    [self addTopViewSnapshot];
    dispatch_async(dispatch_get_main_queue(), ^{
      NSString *key = (side == IA_ECLeft) ? IA_ECSlidingViewTopDidAnchorLeft : IA_ECSlidingViewTopDidAnchorRight;
      [[NSNotificationCenter defaultCenter] postNotificationName:key object:self userInfo:nil];
    });
  }];
}

- (void)resetTopView
{
  [self resetTopViewWithAnimations:nil onComplete:nil];
}

- (void)resetTopViewWithAnimations:(void(^)())animations onComplete:(void(^)())complete
{
  [self topViewHorizontalCenterWillChange:self.resettedCenter];
  
  [UIView animateWithDuration:0.25f animations:^{
    if (animations) {
      animations();
    }
    [self updateTopViewHorizontalCenter:self.resettedCenter];
  } completion:^(BOOL finished) {
    if (complete) {
      complete();
    }
    [self topViewHorizontalCenterDidChange:self.resettedCenter];
  }];
}

- (NSUInteger)autoResizeToFillScreen
{
  return (UIViewAutoresizingFlexibleWidth |
          UIViewAutoresizingFlexibleHeight |
          UIViewAutoresizingFlexibleTopMargin |
          UIViewAutoresizingFlexibleBottomMargin |
          UIViewAutoresizingFlexibleLeftMargin |
          UIViewAutoresizingFlexibleRightMargin);
}

- (UIView *)topView
{
  return self.topViewController.view;
}

- (UIView *)underLeftView
{
  return self.underLeftViewController.view;
}

- (UIView *)underRightView
{
  return self.underRightViewController.view;
}

- (void)updateTopViewHorizontalCenter:(CGFloat)newHorizontalCenter
{
  CGPoint center = self.topView.center;
  center.x = newHorizontalCenter;
  self.topView.layer.position = center;
}

- (void)topViewHorizontalCenterWillChange:(CGFloat)newHorizontalCenter
{
  CGPoint center = self.topView.center;
  
  if (center.x <= self.resettedCenter && newHorizontalCenter > self.resettedCenter) {
    [self underLeftWillAppear];
  } else if (center.x >= self.resettedCenter && newHorizontalCenter < self.resettedCenter) {
    [self underRightWillAppear];
  }  
}

- (void)topViewHorizontalCenterDidChange:(CGFloat)newHorizontalCenter
{
  if (newHorizontalCenter == self.resettedCenter) {
    [self topDidReset];
  }
}

- (void)addTopViewSnapshot
{
  if (!self.topViewSnapshot.superview && !self.shouldAllowUserInteractionsWhenAnchored) {
    self.topViewSnapshot.frame = self.topView.bounds;   // Makes sure the frame is up to date - had issues at the first time when the frame was zero in some cases
    self.topViewSnapshot.layer.contents = (id)[UIImage imageWithUIView:self.topView].CGImage;
    [self.topView addSubview:self.topViewSnapshot];
  }
}

- (void)removeTopViewSnapshot
{
  if (self.topViewSnapshot.superview) {
    [self.topViewSnapshot removeFromSuperview];
  }
}

- (CGFloat)anchorRightTopViewCenter
{
  if (self.anchorRightPeekAmount) {
    return self.screenWidth + self.resettedCenter - self.anchorRightPeekAmount;
  } else if (self.anchorRightRevealAmount) {
    return self.resettedCenter + self.anchorRightRevealAmount;
  } else {
    return NSNotFound;
  }
}

- (CGFloat)anchorLeftTopViewCenter
{
  if (self.anchorLeftPeekAmount) {
    return -self.resettedCenter + self.anchorLeftPeekAmount;
  } else if (self.anchorLeftRevealAmount) {
    return -self.resettedCenter + (self.screenWidth - self.anchorLeftRevealAmount);
  } else {
    return NSNotFound;
  }
}

- (CGFloat)resettedCenter
{
  return ceil(self.screenWidth / 2);
}

- (CGFloat)screenWidth
{
  return [self screenWidthForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (CGFloat)screenWidthForOrientation:(UIInterfaceOrientation)orientation
{
  CGSize size = [UIScreen mainScreen].bounds.size;
  UIApplication *application = [UIApplication sharedApplication];
  if (UIInterfaceOrientationIsLandscape(orientation))
  {
    size = CGSizeMake(size.height, size.width);
  }
  if (application.statusBarHidden == NO)
  {
    size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
  }
  return size.width;
}

- (void)underLeftWillAppear
{
  dispatch_async(dispatch_get_main_queue(), ^{
      [[NSNotificationCenter defaultCenter] postNotificationName:IA_ECSlidingViewUnderLeftWillAppear object:self
                                                        userInfo:nil];
  });
  self.underRightView.hidden = YES;
  [self.underLeftViewController viewWillAppear:NO];
  self.underLeftView.hidden = NO;
  [self updateUnderLeftLayout];
  _underLeftShowing  = YES;
  _underRightShowing = NO;
}

- (void)underRightWillAppear
{
  dispatch_async(dispatch_get_main_queue(), ^{
      [[NSNotificationCenter defaultCenter] postNotificationName:IA_ECSlidingViewUnderRightWillAppear object:self
                                                        userInfo:nil];
  });
  self.underLeftView.hidden = YES;
  [self.underRightViewController viewWillAppear:NO];
  self.underRightView.hidden = NO;
  [self updateUnderRightLayout];
  _underLeftShowing  = NO;
  _underRightShowing = YES;
}

- (void)topDidReset
{
  dispatch_async(dispatch_get_main_queue(), ^{
      [[NSNotificationCenter defaultCenter] postNotificationName:IA_ECSlidingViewTopDidReset object:self userInfo:nil];
  });
  [self.topView removeGestureRecognizer:self.resetTapGesture];
  [self removeTopViewSnapshot];
  self.panGesture.enabled = YES;
  _underLeftShowing   = NO;
  _underRightShowing  = NO;
  _topViewIsOffScreen = NO;
}

- (BOOL)topViewHasFocus
{
  return !_underLeftShowing && !_underRightShowing && !_topViewIsOffScreen;
}

- (void)updateUnderLeftLayout
{
  if (self.underLeftWidthLayout == IA_ECFullWidth) {
    [self.underLeftView setAutoresizingMask:self.autoResizeToFillScreen];
    [self.underLeftView setFrame:self.view.bounds];
  } else if (self.underLeftWidthLayout == IA_ECVariableRevealWidth && !self.topViewIsOffScreen) {
    CGRect frame = self.view.bounds;
    CGFloat newWidth;
    
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
      newWidth = [UIScreen mainScreen].bounds.size.height - self.anchorRightPeekAmount;
    } else {
      newWidth = [UIScreen mainScreen].bounds.size.width - self.anchorRightPeekAmount;
    }
    
    frame.size.width = newWidth;
    
    self.underLeftView.frame = frame;
  } else if (self.underLeftWidthLayout == IA_ECFixedRevealWidth) {
    CGRect frame = self.view.bounds;
    
    frame.size.width = self.anchorRightRevealAmount;
    self.underLeftView.frame = frame;
  } else {
    [NSException raise:@"Invalid Width Layout" format:@"underLeftWidthLayout must be a valid ECViewWidthLayout"];
  }
}

- (void)updateUnderRightLayout
{
  if (self.underRightWidthLayout == IA_ECFullWidth) {
    [self.underRightViewController.view setAutoresizingMask:self.autoResizeToFillScreen];
    self.underRightView.frame = self.view.bounds;
  } else if (self.underRightWidthLayout == IA_ECVariableRevealWidth) {
    CGRect frame = self.view.bounds;
    
    CGFloat newLeftEdge;
    CGFloat newWidth;
    
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
      newWidth = [UIScreen mainScreen].bounds.size.height;
    } else {
      newWidth = [UIScreen mainScreen].bounds.size.width;
    }
    
    if (self.topViewIsOffScreen) {
      newLeftEdge = 0;
    } else {
      newLeftEdge = self.anchorLeftPeekAmount;
      newWidth   -= self.anchorLeftPeekAmount;
    }
    
    frame.origin.x   = newLeftEdge;
    frame.size.width = newWidth;
    
    self.underRightView.frame = frame;
  } else if (self.underRightWidthLayout == IA_ECFixedRevealWidth) {
    CGRect frame = self.view.bounds;
    
    CGFloat newLeftEdge = self.screenWidth - self.anchorLeftRevealAmount;
    CGFloat newWidth = self.anchorLeftRevealAmount;
    
    frame.origin.x   = newLeftEdge;
    frame.size.width = newWidth;
    
    self.underRightView.frame = frame;
  } else {
    [NSException raise:@"Invalid Width Layout" format:@"underRightWidthLayout must be a valid ECViewWidthLayout"];
  }
}

@end
