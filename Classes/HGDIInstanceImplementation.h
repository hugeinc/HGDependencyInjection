//
//  HGDIInstanceImplementation.h
//  TMNGO
//
//  Created by Marc Ammann on 3/19/12.
//  Copyright (c) 2012 HUGE Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HGDIImplementation.h"

@interface HGDIInstanceImplementation : HGDIImplementation

@property (nonatomic, strong) id storedInstance;

- (id)initWithInstance:(id)instance;

@end
