//
//  HGDIConstructorImplementation.h
//  TMNGO
//
//  Created by Marc Ammann on 3/19/12.
//  Copyright (c) 2012 HUGE Inc. All rights reserved.
//

#import "HGDIImplementation.h"

typedef id (^HGDIImplementationConstructorBlock)(id,Class,NSDictionary*);

@interface HGDIConstructorImplementation : HGDIImplementation

- (id)initWithImplementationClass:(Class)implementationClass bootstrap:(id (^)(id container, Class implementationClass, NSDictionary *parameters))block;
- (id)newInstanceWithClass:(Class)implementationClass;

@end
