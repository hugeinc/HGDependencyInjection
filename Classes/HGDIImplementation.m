//
//  HGDIImplementation.m
//  TMNGO
//
//  Created by Marc Ammann on 3/19/12.
//  Copyright (c) 2012 HUGE Inc. All rights reserved.
//

#import "HGDIImplementation.h"

@interface HGDIImplementation ()

@end


@implementation HGDIImplementation

@synthesize parameters = parameters_;
@synthesize serviceContainer = serviceContainer_;
@synthesize newInstanceSupported;


- (NSMutableDictionary *)parameters {
	if (!parameters_) {
		parameters_ = [[NSMutableDictionary alloc] init];
	}
	return parameters_;
}


- (id)instance {
	return nil;
}


- (id)newInstance {
	return nil;
}


- (void)setParameter:(id)parameter forKey:(NSString *)key {
	[self.parameters setObject:parameter forKey:key];
}


- (BOOL)isNewInstanceSupported {
	return NO;
}

@end
