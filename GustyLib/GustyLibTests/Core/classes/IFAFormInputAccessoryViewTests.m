//
//  GustyLib - IFAFormInputAccessoryViewTests.m
//  Copyright 2014 InfoAccent Pty Ltd. All rights reserved.
//
//  Created by: Marcelo Schroeder
//

#import "IFACommonTests.h"
#import "GustyLibCore.h"

static const NSUInteger k_segmentIndexPrevious = 0;
static const NSUInteger k_segmentIndexNext = 1;

@interface IFAFormInputAccessoryView (Tests)
@property (strong, nonatomic) NSIndexPath *currentInputFieldIndexPath;
@property (strong, nonatomic) NSIndexPath *previousInputFieldIndexPath;
@property (strong, nonatomic) NSIndexPath *nextInputFieldIndexPath;
- (NSIndexPath *)IFA_indexPathForDirection:(IFAFormInputAccessoryViewDirection)a_direction;
@end

@interface IFAFormInputAccessoryViewTests : XCTestCase
@property(nonatomic, strong) IFAFormInputAccessoryView *p_view;
@property(nonatomic, strong) id p_mockTableView;
@property(nonatomic, strong) id p_mockTableViewDataSource;
@property(nonatomic, strong) id p_mockDataSource;
@property(nonatomic, strong) id p_mockSegmentedControl;
@end

@implementation IFAFormInputAccessoryViewTests{
}

/*

    Mock data model:

    Section   Row   Has Input Field?
    -------   ---   ----------------
    0         0     No
    1         0     Yes
    1         1     Yes
    2         0     No
    2         1     Yes
    2         2     Yes
    3         0     No

 */
- (void)setUp {
    [super setUp];
    [self m_createMockObjects];
    [self m_createSystemUnderTestAndSetMockObjects];
    [self m_configureMockObjects];
}

- (void)testThatInterfaceBuilderOutletConnectionsAreInPlace{
    IFAFormInputAccessoryView *l_view = [self m_createSystemUnderTest];
    assertThat(l_view.contentView, is(notNilValue()));
    assertThat(l_view.toolbar, is(notNilValue()));
    assertThat(l_view.segmentedControl, is(notNilValue()));
    assertThat(l_view.doneBarButtonItem, is(notNilValue()));
    assertThat(l_view, is(notNilValue()));
}

- (void)testThatInterfaceBuilderEventConnectionsAreInPlace{
    IFAFormInputAccessoryView *l_view = [self m_createSystemUnderTest];
    [self ifa_assertThatControl:l_view.segmentedControl hasValueChangedEventConfiguredWithTarget:l_view
                       action:@selector(onSegmentedControlValueChanged:)];
    [self ifa_assertThatBarButtonItem:l_view.doneBarButtonItem
    hasTapEventConfiguredWithTarget:l_view action:@selector(onDoneButtonTap:)];
}

- (void)testThatPreviousButtonIsEnabledWhenThereIsAnImmediatelyPrecedingCellContainingAnInputFieldToScrollTo{
    [self m_assertThatForSection:1 row:1 previousButtonIsEnabled:YES nextButtonIsEnabled:YES];
}

- (void)testThatPreviousButtonIsEnabledWhenThereIsAPrecedingCellOtherThanTheImmediatelyPrecedingCellContainingAnInputFieldToScrollTo{
    [self m_assertThatForSection:2 row:1 previousButtonIsEnabled:YES nextButtonIsEnabled:YES];
}

- (void)testThatPreviousButtonIsDisabledWhenThereIsNoPrecedingCellContainingAnInputFieldToScrollTo{
    [self m_assertThatForSection:1 row:0 previousButtonIsEnabled:NO nextButtonIsEnabled:YES];
}

- (void)testThatPreviousButtonIsDisabledWhenCurrentCellIsTheFirstOne{
    [self m_assertThatForSection:0 row:0 previousButtonIsEnabled:NO nextButtonIsEnabled:YES];
}

- (void)testThatNextButtonIsEnabledWhenThereIsAnImmediatelySubsequentCellContainingAnInputFieldToScrollTo{
    [self m_assertThatForSection:2 row:1 previousButtonIsEnabled:YES nextButtonIsEnabled:YES];
}

- (void)testThatNextButtonIsEnabledWhenThereIsASubsequentCellOtherThanTheImmediatelySubsequentCellContainingAnInputFieldToScrollTo{
    [self m_assertThatForSection:1 row:1 previousButtonIsEnabled:YES nextButtonIsEnabled:YES];
}

- (void)testThatNextButtonIsDisabledWhenThereIsNoSubsequentCellContainingAnInputFieldToScrollTo{
    [self m_assertThatForSection:2 row:2 previousButtonIsEnabled:YES nextButtonIsEnabled:NO];
}

- (void)testThatNextButtonIsDisabledWhenCurrentCellIsTheLastOne{
    [self m_assertThatForSection:3 row:0 previousButtonIsEnabled:YES nextButtonIsEnabled:NO];
}

- (void)testIndexPathFullForwardTraverse {

    id l_mockDataSource = [OCMockObject niceMockForProtocol:@protocol(IFAFormInputAccessoryViewDataSource)];
    [[[l_mockDataSource stub] ifa_andReturnBool:YES] formInputAccessoryView:self.p_view canReceiveKeyboardInputAtIndexPath:[OCMArg any]];
    self.p_view.dataSource = l_mockDataSource;

    IFAFormInputAccessoryViewDirection l_direction = IFAFormInputAccessoryViewDirectionNext;
    NSIndexPath *l_currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];

    l_currentIndexPath = [self assertNewIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]
                             withCurrentIndexPath:l_currentIndexPath
                                        direction:l_direction];

    l_currentIndexPath = [self assertNewIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]
                             withCurrentIndexPath:l_currentIndexPath
                                        direction:l_direction];

    l_currentIndexPath = [self assertNewIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]
                             withCurrentIndexPath:l_currentIndexPath
                                        direction:l_direction];

    l_currentIndexPath = [self assertNewIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]
                             withCurrentIndexPath:l_currentIndexPath
                                        direction:l_direction];

    l_currentIndexPath = [self assertNewIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]
                             withCurrentIndexPath:l_currentIndexPath
                                        direction:l_direction];

    [self assertNewIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]
        withCurrentIndexPath:l_currentIndexPath
                   direction:l_direction];

}

- (void)testIndexPathBackwardTraverse {

    id l_mockDataSource = [OCMockObject niceMockForProtocol:@protocol(IFAFormInputAccessoryViewDataSource)];
    [[[l_mockDataSource stub] ifa_andReturnBool:YES] formInputAccessoryView:self.p_view canReceiveKeyboardInputAtIndexPath:[OCMArg any]];
    self.p_view.dataSource = l_mockDataSource;

    IFAFormInputAccessoryViewDirection l_direction = IFAFormInputAccessoryViewDirectionPrevious;
    NSIndexPath *l_currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:3];

    l_currentIndexPath = [self assertNewIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]
                             withCurrentIndexPath:l_currentIndexPath
                                        direction:l_direction];

    l_currentIndexPath = [self assertNewIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]
                             withCurrentIndexPath:l_currentIndexPath
                                        direction:l_direction];

    l_currentIndexPath = [self assertNewIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]
                             withCurrentIndexPath:l_currentIndexPath
                                        direction:l_direction];

    l_currentIndexPath = [self assertNewIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]
                             withCurrentIndexPath:l_currentIndexPath
                                        direction:l_direction];

    l_currentIndexPath = [self assertNewIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]
                             withCurrentIndexPath:l_currentIndexPath
                                        direction:l_direction];

    [self assertNewIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
        withCurrentIndexPath:l_currentIndexPath
                   direction:l_direction];

}

- (void)testThatTableViewIsScrolledToRowAtTheNextIndexPathWithAnInputFieldWhenUserTapsTheNextButtonAndTheDestinationCellIsNotFullyVisible {
    // given
    [self.p_view notifyOfCurrentInputFieldIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    id l_mockSegmentedControl = [OCMockObject mockForClass:[UISegmentedControl class]];
    [[[l_mockSegmentedControl stub] ifa_andReturnInteger:k_segmentIndexNext] selectedSegmentIndex];
    [[self.p_mockTableView expect] scrollToRowAtIndexPath:self.p_view.nextInputFieldIndexPath
                                         atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    // when
    [self.p_view onSegmentedControlValueChanged:l_mockSegmentedControl];

    // then
    [self.p_mockTableView verify];
}

- (void)testThatTableViewIsNotScrolledToRowAtTheNextIndexPathWithAnInputFieldAndThatResponderIsRequestedWhenUserTapsTheNextButtonAndTheDestinationCellIsAlreadyFullyVisible {
    // given
    [self.p_view notifyOfCurrentInputFieldIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    id l_mockSegmentedControl = [OCMockObject mockForClass:[UISegmentedControl class]];
    [[[l_mockSegmentedControl stub] ifa_andReturnInteger:k_segmentIndexNext] selectedSegmentIndex];
    NSIndexPath *l_nextInputFieldIndexPath = self.p_view.nextInputFieldIndexPath;
    [[[self.p_mockTableView expect] ifa_andReturnBool:YES] ifa_isCellFullyVisibleForRowAtIndexPath:l_nextInputFieldIndexPath];
    [[self.p_mockDataSource expect] formInputAccessoryView:self.p_view
                 responderForKeyboardInputFocusAtIndexPath:l_nextInputFieldIndexPath];
    [[self.p_mockTableView reject] scrollToRowAtIndexPath:l_nextInputFieldIndexPath
                                         atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    // when
    [self.p_view onSegmentedControlValueChanged:l_mockSegmentedControl];

    // then
    [self.p_mockTableView verify];
}

- (void)testThatTableViewIsScrolledToRowAtThePreviousIndexPathWithAnInputFieldWhenUserTapsThePreviousButtonAndTheDestinationCellIsNotFullyVisible {
    // given
    [self.p_view notifyOfCurrentInputFieldIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    id l_mockSegmentedControl = [OCMockObject mockForClass:[UISegmentedControl class]];
    [[[l_mockSegmentedControl stub] ifa_andReturnInteger:k_segmentIndexPrevious] selectedSegmentIndex];
    [[self.p_mockTableView expect] scrollToRowAtIndexPath:self.p_view.previousInputFieldIndexPath
                                         atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    // when
    [self.p_view onSegmentedControlValueChanged:l_mockSegmentedControl];

    // then
    [self.p_mockTableView verify];
}

- (void)testThatTableViewIsNotScrolledToRowAtThePreviousIndexPathWithAnInputFieldAndThatResponderIsRequestedWhenUserTapsThePreviousButtonAndTheDestinationCellIsAlreadyFullyVisible {
    // given
    [self.p_view notifyOfCurrentInputFieldIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    id l_mockSegmentedControl = [OCMockObject mockForClass:[UISegmentedControl class]];
    [[[l_mockSegmentedControl stub] ifa_andReturnInteger:k_segmentIndexPrevious] selectedSegmentIndex];
    NSIndexPath *l_previousInputFieldIndexPath = self.p_view.previousInputFieldIndexPath;
    [[[self.p_mockTableView expect] ifa_andReturnBool:YES] ifa_isCellFullyVisibleForRowAtIndexPath:l_previousInputFieldIndexPath];
    [[self.p_mockDataSource expect] formInputAccessoryView:self.p_view
                 responderForKeyboardInputFocusAtIndexPath:l_previousInputFieldIndexPath];
    [[self.p_mockTableView reject] scrollToRowAtIndexPath:l_previousInputFieldIndexPath
                                         atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    // when
    [self.p_view onSegmentedControlValueChanged:l_mockSegmentedControl];

    // then
    [self.p_mockTableView verify];
}

- (void)testThatDataSourceIsRequestedTheResponderAfterTableViewScrollingAnimationEnded{

    NSIndexPath *l_currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *l_nextIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];

    // Notify of current input field index path
    [self.p_view notifyOfCurrentInputFieldIndexPath:l_currentIndexPath];

    // "Tap" the Next button
    id l_mockSegmentedControl = [OCMockObject mockForClass:[UISegmentedControl class]];
    [[[l_mockSegmentedControl stub] ifa_andReturnInteger:k_segmentIndexNext] selectedSegmentIndex];
    [self.p_view onSegmentedControlValueChanged:l_mockSegmentedControl];

    // Simulate scrolling animation ended
    [[self.p_mockDataSource expect] formInputAccessoryView:self.p_view
                 responderForKeyboardInputFocusAtIndexPath:l_nextIndexPath];
    [self.p_view notifyTableViewDidEndScrollingAnimation];
    [self.p_mockDataSource verify];

}

#pragma mark - Private

- (void)m_configureMockObjects {
    [self m_configureMockTableView];
    [self m_configureMockDataSource];
    [self m_configureMockTableViewDataSource];
}

- (void)m_configureMockTableView {
    [[[self.p_mockTableView stub] andReturn:self.p_mockTableViewDataSource] dataSource];
}

- (void)m_configureMockDataSource {
    [[[self.p_mockDataSource stub] ifa_andReturnBool:NO] formInputAccessoryView:self.p_view canReceiveKeyboardInputAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                                                inSection:0]];
    [[[self.p_mockDataSource stub] ifa_andReturnBool:YES] formInputAccessoryView:self.p_view canReceiveKeyboardInputAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                                                 inSection:1]];
    [[[self.p_mockDataSource stub] ifa_andReturnBool:YES] formInputAccessoryView:self.p_view canReceiveKeyboardInputAtIndexPath:[NSIndexPath indexPathForRow:1
                                                                                                 inSection:1]];
    [[[self.p_mockDataSource stub] ifa_andReturnBool:NO] formInputAccessoryView:self.p_view canReceiveKeyboardInputAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                                                inSection:2]];
    [[[self.p_mockDataSource stub] ifa_andReturnBool:YES] formInputAccessoryView:self.p_view canReceiveKeyboardInputAtIndexPath:[NSIndexPath indexPathForRow:1
                                                                                                 inSection:2]];
    [[[self.p_mockDataSource stub] ifa_andReturnBool:YES] formInputAccessoryView:self.p_view canReceiveKeyboardInputAtIndexPath:[NSIndexPath indexPathForRow:2
                                                                                                 inSection:2]];
    [[[self.p_mockDataSource stub] ifa_andReturnBool:NO] formInputAccessoryView:self.p_view canReceiveKeyboardInputAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                                                inSection:3]];
}

- (void)m_configureMockTableViewDataSource {
    [[[self.p_mockTableViewDataSource stub] ifa_andReturnInteger:4] numberOfSectionsInTableView:self.p_mockTableView];
    [[[self.p_mockTableViewDataSource stub] ifa_andReturnInteger:1] tableView:self.p_mockTableView
                                                    numberOfRowsInSection:0];
    [[[self.p_mockTableViewDataSource stub] ifa_andReturnInteger:2] tableView:self.p_mockTableView
                                                    numberOfRowsInSection:1];
    [[[self.p_mockTableViewDataSource stub] ifa_andReturnInteger:3] tableView:self.p_mockTableView
                                                    numberOfRowsInSection:2];
    [[[self.p_mockTableViewDataSource stub] ifa_andReturnInteger:1] tableView:self.p_mockTableView
                                                    numberOfRowsInSection:3];
}

- (void)m_createMockObjects {
    self.p_mockTableViewDataSource = [OCMockObject niceMockForProtocol:@protocol(UITableViewDataSource)];
    self.p_mockTableView = [OCMockObject niceMockForClass:[UITableView class]];
    self.p_mockDataSource = [OCMockObject mockForProtocol:@protocol(IFAFormInputAccessoryViewDataSource)];
    self.p_mockSegmentedControl = [OCMockObject niceMockForClass:[UISegmentedControl class]];
}

- (void)m_createSystemUnderTestAndSetMockObjects {
    self.p_view = [self m_createSystemUnderTest];
    self.p_view.dataSource = self.p_mockDataSource;
    self.p_view.segmentedControl = self.p_mockSegmentedControl;
}

- (IFAFormInputAccessoryView *)m_createSystemUnderTest {
    return [[IFAFormInputAccessoryView alloc] initWithTableView:self.p_mockTableView];
}

- (void)m_assertThatForSection:(NSInteger)a_section row:(NSInteger)a_row
       previousButtonIsEnabled:(BOOL)a_previousButtonEnabled nextButtonIsEnabled:(BOOL)a_nextButtonEnabled {
    [[self.p_mockSegmentedControl expect] setEnabled:a_previousButtonEnabled forSegmentAtIndex:k_segmentIndexPrevious];
    [[self.p_mockSegmentedControl expect] setEnabled:a_nextButtonEnabled forSegmentAtIndex:k_segmentIndexNext];
    [self.p_view notifyOfCurrentInputFieldIndexPath:[NSIndexPath indexPathForRow:a_row inSection:a_section]];
    [self.p_mockSegmentedControl verify];
}

- (NSIndexPath *)assertNewIndexPath:(NSIndexPath *)a_newIndexPath withCurrentIndexPath:(NSIndexPath *)a_currentIndexPath
                          direction:(IFAFormInputAccessoryViewDirection)a_direction {
    [self.p_view notifyOfCurrentInputFieldIndexPath:a_currentIndexPath];
    NSIndexPath *l_actualNewIndexPath = [self.p_view IFA_indexPathForDirection:a_direction];
    assertThat(l_actualNewIndexPath, is(equalTo(a_newIndexPath)));
    return l_actualNewIndexPath;
}

@end
