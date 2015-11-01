//
//  GustyKit - IFAPersistenceManagerTests.m
//  Copyright 2015 InfoAccent Pty Ltd. All rights reserved.
//
//  Created by: Marcelo Schroeder
//

#import "IFACoreUITestCase.h"
#import "GustyKitCoreUI.h"
#import "TestCoreDataEntity1.h"

@interface IFAPersistenceManagerTests : IFACoreUITestCase
@property(nonatomic, strong) IFAPersistenceManager *persistenceManager;
@property(nonatomic, strong) id persistenceManagerPartialMock;
@property(nonatomic, strong) TestCoreDataEntity1 *managedObject1;
@end

@implementation IFAPersistenceManagerTests{
}

- (void)testCountEntity {
    // when
    NSUInteger count = [self.persistenceManager countEntity:[TestCoreDataEntity1 ifa_entityName]];
    // then
    assertThatUnsignedInteger(count, is(equalToUnsignedInteger(5)));
}

- (void)testCountEntityKeysAndValues {
    // when
    NSUInteger count = [self.persistenceManager countEntity:[TestCoreDataEntity1 ifa_entityName] keysAndValues:@{@"attribute1" : @"value2"}];
    // then
    assertThatUnsignedInteger(count, is(equalToUnsignedInteger(3)));
}

- (void)testCountEntityWithPredicate {
    // given
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"attribute1 = %@"
                                                argumentArray:@[@"value1"]];
    // when
    NSUInteger count = [self.persistenceManager countEntity:[TestCoreDataEntity1 ifa_entityName] withPredicate:predicate];
    // then
    assertThatUnsignedInteger(count, is(equalToUnsignedInteger(2)));
}

- (void)testThatUnsavedEditingChangesReturnsNoWhenThereAreNoUnsavedChanges {
    // when
    BOOL result = self.persistenceManager.unsavedEditingChanges;
    // then
    XCTAssertFalse(result);
}

- (void)testThatUnsavedEditingChangesReturnsYesWhenThereAreChangesInTheMainManagedObjectContext {
    // given
    [self.managedObject1 ifa_setValue:@"changed"
                          forProperty:@"attribute1"];
    // when
    BOOL result = self.persistenceManager.unsavedEditingChanges;
    // then
    XCTAssertTrue(result);
}

- (void)testThatUnsavedEditingChangesReturnsYesWhenThereAreChangesInAPushedChildManagedObjectContext1LevelDown {
    // given
    [self.persistenceManager pushChildManagedObjectContext];
    TestCoreDataEntity1 *managedObject = (TestCoreDataEntity1 *) [self.persistenceManager findById:self.managedObject1.objectID];
    [managedObject ifa_setValue:@"changed"
                    forProperty:@"attribute1"];
    // when
    BOOL result = self.persistenceManager.unsavedEditingChanges;
    // then
    XCTAssertTrue(result);
}

- (void)testThatUnsavedEditingChangesReturnsYesWhenThereAreChangesInAPushedChildManagedObjectContext2LevelsDown {
    // given
    [self.persistenceManager pushChildManagedObjectContext];
    [self.persistenceManager pushChildManagedObjectContext];
    TestCoreDataEntity1 *managedObject = (TestCoreDataEntity1 *) [self.persistenceManager findById:self.managedObject1.objectID];
    [managedObject ifa_setValue:@"changed"
                    forProperty:@"attribute1"];
    // when
    BOOL result = self.persistenceManager.unsavedEditingChanges;
    // then
    XCTAssertTrue(result);
}

#pragma mark - Overrides

- (void)setUp {
    [super setUp];
    self.persistenceManager = [IFAPersistenceManager new];
    self.persistenceManagerPartialMock = OCMPartialMock(self.persistenceManager);
    OCMStub([self.persistenceManagerPartialMock sharedInstance]).andReturn(self.persistenceManagerPartialMock);
    [self createInMemoryTestDatabaseWithPersistenceManager:self.persistenceManager];
    [self createTestObjects];
}

#pragma mark - Private

- (void)createTestObjects {
    self.managedObject1 = (TestCoreDataEntity1 *) [self.persistenceManager instantiate:[TestCoreDataEntity1 ifa_entityName]];
    self.managedObject1.attribute1 = @"value1";
    TestCoreDataEntity1 *managedObject2 = (TestCoreDataEntity1 *) [self.persistenceManager instantiate:[TestCoreDataEntity1 ifa_entityName]];
    managedObject2.attribute1 = @"value1";
    TestCoreDataEntity1 *managedObject3 = (TestCoreDataEntity1 *) [self.persistenceManager instantiate:[TestCoreDataEntity1 ifa_entityName]];
    managedObject3.attribute1 = @"value2";
    TestCoreDataEntity1 *managedObject4 = (TestCoreDataEntity1 *) [self.persistenceManager instantiate:[TestCoreDataEntity1 ifa_entityName]];
    managedObject4.attribute1 = @"value2";
    TestCoreDataEntity1 *managedObject5 = (TestCoreDataEntity1 *) [self.persistenceManager instantiate:[TestCoreDataEntity1 ifa_entityName]];
    managedObject5.attribute1 = @"value2";
    [self.persistenceManager save];
}

@end
