//
//  HGDIImplementation.h
//  TMNGO
//
//  Created by Marc Ammann on 3/19/12.
//  Copyright (c) 2012 HUGE Inc. All rights reserved.
//


@class HGDiContainer;

@interface HGDIImplementation : NSObject

@property (nonatomic, strong) NSMutableDictionary *parameters;
@property (nonatomic, readwrite, getter = isNewInstanceSupported) BOOL newInstanceSupported;
@property (nonatomic, weak) HGDiContainer *serviceContainer;

- (id)instance;
- (id)newInstance;
- (void)setParameter:(id)parameter forKey:(NSString *)key;

@end

