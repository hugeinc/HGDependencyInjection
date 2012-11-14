//
//  HGDIInstanceImplementation.m
//  TMNGO
//
//  Created by Marc Ammann on 3/19/12.
//  Copyright (c) 2012 HUGE Inc. All rights reserved.
//

#import "HGDIInstanceImplementation.h"

@implementation HGDIInstanceImplementation

@synthesize storedInstance = storedInstance_;

- (id)initWithInstance:(id)instance {
	self = [super init];
	if (self) {
		self.storedInstance = instance;
	}

	return self;
}

- (BOOL)isNewInstanceSupported {
	return NO;
}

- (id)instance {
	return self.storedInstance;
}



@end
