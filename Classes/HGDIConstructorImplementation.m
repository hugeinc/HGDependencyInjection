	//
//  HGDIConstructorImplementation.m
//  TMNGO
//
//  Created by Marc Ammann on 3/19/12.
//  Copyright (c) 2012 HUGE Inc. All rights reserved.
//

#import "HGDIConstructorImplementation.h"

@interface HGDIConstructorImplementation ()
@property (nonatomic, copy) HGDIImplementationConstructorBlock constructorBlock;
@property (nonatomic, copy) Class implementationClass;
@end


@implementation HGDIConstructorImplementation

@synthesize constructorBlock = constructorBlock_;
@synthesize implementationClass = implementationClass_;

- (id)initWithImplementationClass:(Class)implementationClass bootstrap:(id (^)(id container, Class implementationClass, NSDictionary *parameters))block {
	self = [super init];
	if (self) {
		self.implementationClass = implementationClass;
		self.constructorBlock = block;
	}

	return self;
}


- (BOOL)isNewInstanceSupported {
	return YES;
}


- (id)newInstance {
	id newInstance = self.constructorBlock(self.serviceContainer, self.implementationClass, self.parameters);
	
	return newInstance;
}


- (id)newInstanceWithClass:(Class)implementationClass {
	id newInstance = self.constructorBlock(self.serviceContainer, implementationClass, self.parameters);
	
	return newInstance;
}


@end
