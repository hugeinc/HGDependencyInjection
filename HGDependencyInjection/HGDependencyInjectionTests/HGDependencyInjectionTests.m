//
//  HGDependencyInjectionTests.m
//  HGDependencyInjectionTests
//
//  Created by HUGE | Anton Doudarev on 11/5/13.
//  Copyright (c) 2013 HUGE Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HGDI.h"

@protocol DIProtocol <NSObject>
@required
@property (nonatomic, strong) NSString *testValue;
- (NSString *)returnTestValue;
@end


@interface DIProtocolImplementation : NSObject  <DIProtocol>
@property (nonatomic, strong) NSString *testValue;
@end


@implementation DIProtocolImplementation
- (NSString *)returnTestValue {
    return self.testValue;
}
@end



@interface DIService : NSObject
@property (nonatomic, strong) NSString *testValue;
@end


@implementation DIService
@end


@interface DIParentViewController : UIViewController
@property (nonatomic, strong) HGDIContainer *serviceContainer;
@property (nonatomic, strong) DIService *sharedService;
@property (nonatomic, strong) DIService *containerConsumable;
@end


@implementation DIParentViewController
@end


@interface DIChildViewController : DIParentViewController
@end


@implementation DIChildViewController
@end


@interface HGDependencyInjectionTests : XCTestCase
@property (nonatomic, strong) HGDIContainer *serviceContainer;
@property (nonatomic, strong) DIService *sharedService;
@property (nonatomic, strong) DIService *containerConsumable;
@end


NSString *const kContainerConsumableKey = @"kContainerConsumableKey";
NSString *const kParameterValue = @"kParameterValue";
NSString *const kParameterKey = @"kParameterKey";

NSString *const kProtocolInstanceTestValue = @"kProtocolInstanceTestValue";
NSString *const kClassInstanceTestValue = @"kClassInstanceTestValue";
NSString *const kKeyedInstanceTestValue = @"kKeyedInstanceTestValue";

@implementation HGDependencyInjectionTests

- (void)setUp {
    [super setUp];
    
    _serviceContainer = [HGDIContainer new];
    
    [self loadService];
    [self loadContainerConsumable];
    [self loadDIProtocolInstanceImplementation];
    [self loadDIClassInstanceImplementation];
    [self loadDIConstructors];
}


- (void)tearDown {
    [super tearDown];
    
    _serviceContainer = nil;
    _sharedService = nil;
    _containerConsumable = nil;
    
    if (_serviceContainer || _sharedService || _containerConsumable) {
        XCTFail(@"Tear down of shared objects failed");
    }
}


- (void)loadService {
    _sharedService = [[DIService alloc] init];
}


- (void)loadContainerConsumable {
    _containerConsumable = [[DIService alloc] init];
    [self.serviceContainer setImplementation:[[HGDIInstanceImplementation alloc] initWithInstance:_containerConsumable] forKey:kContainerConsumableKey];
}


- (void)loadDIConstructors
{
     __weak __block __typeof__(self) blockSelf = self;
    
    HGDIConstructorImplementation *viewControllerImplementation =
	[[HGDIConstructorImplementation alloc] initWithImplementationClass:[DIParentViewController class] bootstrap:^id(id container, __weak Class implementationClass, NSDictionary *parameters)
	 {
         DIParentViewController *viewController = [[implementationClass alloc] init];
         viewController.sharedService = blockSelf.sharedService;
         
         [viewController.sharedService setTestValue:[parameters valueForKey:kParameterKey]];
         
         viewController.containerConsumable = [blockSelf.serviceContainer instanceForKey:kContainerConsumableKey];
         viewController.serviceContainer = blockSelf.serviceContainer;
		 return viewController;
	 }];
	
    [viewControllerImplementation setParameter:kParameterValue forKey:kParameterKey];
	[self.serviceContainer setImplementation:viewControllerImplementation forClass:[DIParentViewController class]];
}



- (void)loadDIProtocolInstanceImplementation
{
    DIProtocolImplementation *protocolImplementation = [[DIProtocolImplementation alloc] init];
    [protocolImplementation setTestValue:kProtocolInstanceTestValue];
    [self.serviceContainer setImplementation:[[HGDIInstanceImplementation alloc] initWithInstance:protocolImplementation] forProtocol:@protocol(DIProtocol)];
}


- (void)loadDIClassInstanceImplementation
{
    DIService *classInstance = [[DIService alloc] init];
    [classInstance setTestValue:kClassInstanceTestValue];
    [self.serviceContainer setImplementation:[[HGDIInstanceImplementation alloc] initWithInstance:classInstance] forClass:[DIService class]];
}



- (void)testParentConstructorImplementation
{
    id parentViewController = [self.serviceContainer newInstanceForClass:[DIParentViewController class]];
    XCTAssertEqual([parentViewController class], [DIParentViewController class], @"Invalid class has been loaded from the service container");
}


- (void)testChildConstructorImplementation
{
    id childViewController = [self.serviceContainer newInstanceForClass:[DIParentViewController class] implementationClass:[DIChildViewController class]];
    XCTAssertEqual([childViewController class], [DIChildViewController class], @"Invalid class has been loaded form the service container");
}


- (void)testClassInstanceImplementation
{
     DIService *classInstance = [self.serviceContainer instanceForClass:[DIService class]];
     XCTAssert([[classInstance testValue] isEqualToString:kClassInstanceTestValue], @"Service container returned the wrong protocol implementation object");
}


- (void)testProtocolInstanceImplementation
{
    id<DIProtocol> protocolInstance = [self.serviceContainer instanceForProtocol:@protocol(DIProtocol)];
    XCTAssert([[protocolInstance returnTestValue] isEqualToString:kProtocolInstanceTestValue], @"Service container returned the wrong protocol implementation object");
}


- (void)testKeyedInstanceImplementation
{
    DIService *keyedInstance = [self.serviceContainer instanceForKey:kContainerConsumableKey];
    XCTAssert(keyedInstance == self.containerConsumable, @"Memory Addresses on shared container consumables should not match");
}


- (void)testChildViewControllerWithPassedParameters
{
    DIChildViewController *childViewController = [self.serviceContainer newInstanceForClass:[DIParentViewController class] implementationClass:[DIChildViewController class]];
    XCTAssert([childViewController.sharedService.testValue isEqualToString:kParameterValue], @"Incorrect Parameter Passed to child's shared consumable");
}


- (void)testChildViewControllerWithParameterOverride {
    DIChildViewController *childViewController = [self.serviceContainer newInstanceForClass:[DIParentViewController class] implementationClass:[DIChildViewController class]];
    XCTAssert([childViewController.sharedService.testValue isEqualToString:kParameterValue], @"Incorrect Parameter Passed to child's shared consumable");
}


- (void)testParentServiceContainer
{
    DIParentViewController *parentViewController = [self.serviceContainer newInstanceForClass:[DIParentViewController class]];
    DIService *containerParentContainerConsumable = [parentViewController.serviceContainer instanceForKey:kContainerConsumableKey];
    
    XCTAssert(containerParentContainerConsumable == self.containerConsumable, @"Parent's Service container returned the wrong object");
}


- (void)testChildServiceContainer
{
    DIChildViewController *childViewController = [self.serviceContainer newInstanceForClass:[DIParentViewController class] implementationClass:[DIChildViewController class]];
    DIService *containerParentContainerConsumable = [childViewController.serviceContainer instanceForKey:kContainerConsumableKey];
    
    XCTAssert(containerParentContainerConsumable == self.containerConsumable, @"Parent's Service container returned the wrong object");
}


- (void)testParentVsChildImplementationInstances
{
    DIParentViewController *parentViewController = [self.serviceContainer newInstanceForClass:[DIParentViewController class]];
    DIChildViewController  *childViewController = [[DIChildViewController alloc] init];
    
    XCTAssert(parentViewController.sharedService != childViewController.sharedService, @"Memory Addresses on shared consumable should not match");
    XCTAssert(parentViewController.containerConsumable != childViewController.containerConsumable, @"Memory Addresses on shared container consumables should not match");
    
    childViewController = [self.serviceContainer newInstanceForClass:[DIParentViewController class] implementationClass:[DIChildViewController class]];
    
    XCTAssert(parentViewController.sharedService == childViewController.sharedService, @"Memory Addresses on the consumables should match");
    XCTAssert(parentViewController.containerConsumable == childViewController.containerConsumable, @"Memory Addresses on shared container consumables should not match");
}


@end
