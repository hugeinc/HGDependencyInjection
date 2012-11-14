//
//  HGDIContainer.m
//  TMNGO
//
//  Created by Marc Ammann on 3/8/12.
//  Copyright (c) 2012 HUGE Inc. All rights reserved.
//

#import "HGDIContainer.h"
#import <objc/runtime.h>

#import "HGDIImplementation.h"
#import "HGDIConstructorImplementation.h"

@interface HGDIContainer ()
@property (nonatomic, strong) NSMutableDictionary *containerParameters;
@property (nonatomic, strong) NSMutableDictionary *protocolImplementations;
@property (nonatomic, strong) NSMutableDictionary *classImplementations;
@property (nonatomic, strong) NSMutableDictionary *keyImplementations;

+ (NSString *)protocolName:(Protocol *)protocol;
+ (NSString *)className:(Class)class;

@end


@implementation HGDIContainer

@synthesize protocolImplementations = protocolImplementations_;
@synthesize classImplementations = classImplementations_;
@synthesize keyImplementations = keyImplementations_;
@synthesize containerParameters = containerParameters_;


- (NSMutableDictionary *)protocolImplementations {
	if (!protocolImplementations_) {
		protocolImplementations_ = [[NSMutableDictionary alloc] init];
	}
	return protocolImplementations_;
}


- (NSMutableDictionary *)classImplementations {
	if (!classImplementations_) {
		classImplementations_ = [[NSMutableDictionary alloc] init];
	}
	return classImplementations_;
}


- (NSMutableDictionary *)keyImplementations {
	if (!keyImplementations_) {
		keyImplementations_ = [[NSMutableDictionary alloc] init];
	}
	return keyImplementations_;
}


- (NSMutableDictionary *)containerParameters {
	if (!containerParameters_) {
		containerParameters_ = [[NSMutableDictionary alloc] init];
	}
	return containerParameters_;
}


- (void)setImplementation:(HGDIImplementation *)impl forProtocol:(Protocol *)protocol {
	__weak id weakSelf = self;
	[impl setServiceContainer:weakSelf];
	[self.protocolImplementations setObject:impl forKey:[HGDIContainer protocolName:protocol]];
	// TODO: Check if the implementation actually implements the protocol.
}


- (void)setImplementation:(HGDIImplementation *)impl forClass:(Class)classKey {
	__weak id weakSelf = self;
	[impl setServiceContainer:weakSelf];
	[self.classImplementations setObject:impl forKey:[HGDIContainer className:classKey]];
	// TODO: Maybe posing?
}


- (void)setImplementation:(HGDIImplementation *)impl forKey:(NSString *)key {
	__weak id weakSelf = self;
	[impl setServiceContainer:weakSelf];
	[self.keyImplementations setObject:impl forKey:key];
}


- (HGDIImplementation *)implementationForProtocol:(Protocol *)protocol {
	return [self.protocolImplementations objectForKey:[HGDIContainer protocolName:protocol]];
}


- (HGDIImplementation *)implementationForClass:(Class)classKey {
	return [self.classImplementations objectForKey:[HGDIContainer className:classKey]];
}


- (HGDIImplementation *)implementationForKey:(NSString *)key {
	return [self.keyImplementations objectForKey:key];
}


- (id)newInstanceForProtocol:(Protocol *)protocol {
	HGDIImplementation *impl = [self implementationForProtocol:protocol];
	if (![impl isNewInstanceSupported]) {
		return nil;
	}

	return [impl newInstance];
}


- (id)newInstanceForClass:(Class)classKey {
	HGDIImplementation *impl = [self implementationForClass:classKey];
	if (![impl isNewInstanceSupported]) {
		return nil;
	}

	return [impl newInstance];
}


/**
 Returns a new instance for a base class and an actual implementation class
 */
- (id)newInstanceForClass:(Class)classKey implementationClass:(Class)implementationClass {
	HGDIImplementation *impl = [self implementationForClass:classKey];
	if (![impl isNewInstanceSupported]) {
		return nil;
	}
	
	return [(HGDIConstructorImplementation *)impl newInstanceWithClass:implementationClass];
}


- (id)newInstanceForKey:(NSString *)key {
	HGDIImplementation *impl = [self implementationForKey:key];
	if (![impl isNewInstanceSupported]) {
		return nil;
	}

	return [impl newInstance];
}


- (id)instanceForProtocol:(Protocol *)protocol {
	HGDIImplementation *impl = [self implementationForProtocol:protocol];
	return [impl instance];
}


- (id)instanceForClass:(Class)classKey {
	HGDIImplementation *impl = [self implementationForClass:classKey];
	return [impl instance];
}


- (id)instanceForKey:(NSString *)key {
	HGDIImplementation *impl = [self implementationForKey:key];
	return [impl instance];
}


- (void)setParameter:(id)param forKey:(NSString *)key {
	[self.containerParameters setObject:param forKey:key];
}


- (id)parameterForKey:(NSString *)key {
	return [self.containerParameters objectForKey:key];
}


+ (NSString *)protocolName:(Protocol *)protocol {
	return [NSString stringWithUTF8String:protocol_getName(protocol)];
}


+ (NSString *)className:(Class)class {
	return [NSString stringWithUTF8String:class_getName(class)];
}


@end
