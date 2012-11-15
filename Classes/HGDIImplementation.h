//
//  HGDIImplementation.h
//  TMNGO
//
//  Created by Marc Ammann on 3/19/12.
//  Copyright (c) 2012 HUGE Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HGDIContainer;

@interface HGDIImplementation : NSObject

@property (nonatomic, strong) NSMutableDictionary *parameters;
@property (nonatomic, readwrite, getter = isNewInstanceSupported) BOOL newInstanceSupported;
@property (nonatomic, weak) HGDIContainer *serviceContainer;

- (id)instance;
- (id)newInstance;
- (void)setParameter:(id)parameter forKey:(NSString *)key;

@end

