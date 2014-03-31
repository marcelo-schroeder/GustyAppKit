//
// Created by Marcelo Schroeder on 16/08/13.
// Copyright (c) 2013 IAG. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "IACommonTests.h"

@implementation XCTestCase (IACategory)

#pragma mark - Private

- (void)m_assertThatControl:(UIControl *)a_control hasEvent:(enum UIControlEvents)l_controlEvent
       configuredWithTarget:(id)a_target action:(SEL)a_action {
    NSArray *l_actions = [a_control actionsForTarget:a_target forControlEvent:l_controlEvent];
    assertThat(l_actions, hasItem(NSStringFromSelector(a_action)));
}

#pragma mark - Public

- (void)m_assertThatControl:(UIControl *)a_control hasTapEventConfiguredWithTarget:(id)a_target action:(SEL)a_action{
    [self m_assertThatControl:a_control hasEvent:UIControlEventTouchUpInside configuredWithTarget:a_target
                       action:a_action];
}

- (void)m_assertThatControl:(UIControl *)a_control hasValueChangedEventConfiguredWithTarget:(id)a_target action:(SEL)a_action{
    [self m_assertThatControl:a_control hasEvent:UIControlEventValueChanged configuredWithTarget:a_target
                       action:a_action];
}

- (void)m_assertThatBarButtonItem:(UIBarButtonItem *)a_barButtonItem hasTapEventConfiguredWithTarget:(id)a_target action:(SEL)a_action{
    assertThat(a_barButtonItem.target, is(equalTo(a_target)));
    assertThat(NSStringFromSelector(a_barButtonItem.action), is(equalTo(NSStringFromSelector(a_action))));
}

- (void)m_assertThatControl:(UIControl *)a_control hasEditingChangedEventConfiguredWithTarget:(id)a_target action:(SEL)a_action{
    [self m_assertThatControl:a_control hasEvent:UIControlEventEditingChanged configuredWithTarget:a_target
                       action:a_action];
}

- (void)m_waitForSemaphore:(dispatch_semaphore_t)semaphore {
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)m_signalSemaphore:(dispatch_semaphore_t)semaphore {
    dispatch_semaphore_signal(semaphore);
}

- (dispatch_semaphore_t)m_createSemaphore {
    return dispatch_semaphore_create(0);
}

@end