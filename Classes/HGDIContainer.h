//
//  HGDIContainer.h
//  TMNGO
//
//  Created by Marc Ammann on 3/8/12.
//  Copyright (c) 2012 HUGE Inc. All rights reserved.
//

@class HGDIImplementation;

@interface HGDIContainer : NSObject

/**
 *	<#Description#>
 *
 *	@param impl <#impl description#>
 *	@param protocol <#protocol description#>
 */
- (void)setImplementation:(HGDIImplementation *)impl forProtocol:(Protocol *)protocol;

/**
 *	<#Description#>
 *
 *	@param impl <#impl description#>
 *	@param classKey <#classKey description#>
 */
- (void)setImplementation:(HGDIImplementation *)impl forClass:(Class)classKey;

/**
 *	<#Description#>
 *
 *	@param impl <#impl description#>
 *	@param key <#key description#>
 */
- (void)setImplementation:(HGDIImplementation *)impl forKey:(NSString *)key;


/**
 *	<#Description#>
 *
 *	@param protocol <#protocol description#>
 *	@returns <#return value description#>
 */
- (HGDIImplementation *)implementationForProtocol:(Protocol *)protocol;

/**
 *	<#Description#>
 *
 *	@param classKey <#classKey description#>
 *	@returns <#return value description#>
 */
- (HGDIImplementation *)implementationForClass:(Class)classKey;

/**
 *	<#Description#>
 *
 *	@param key <#key description#>
 *	@returns <#return value description#>
 */
- (HGDIImplementation *)implementationForKey:(NSString *)key;



/**
 *	<#Description#>
 *
 *	@param protocol <#protocol description#>
 *	@returns <#return value description#>
 */
- (id)newInstanceForProtocol:(Protocol *)protocol;

/**
 *	<#Description#>
 *
 *	@param classKey <#classKey description#>
 *	@returns <#return value description#>
 */
- (id)newInstanceForClass:(Class)classKey;

/**
 *	<#Description#>
 *
 *	@param key <#key description#>
 *	@returns <#return value description#>
 */
- (id)newInstanceForKey:(NSString *)key;


- (id)newInstanceForClass:(Class)classKey implementationClass:(Class)implementationClass;

/**
 *	<#Description#>
 *
 *	@param protocol <#protocol description#>
 *	@returns <#return value description#>
 */
- (id)instanceForProtocol:(Protocol *)protocol;

/**
 *	<#Description#>
 *
 *	@param classKey <#classKey description#>
 *	@returns <#return value description#>
 */
- (id)instanceForClass:(Class)classKey;

/**
 *	<#Description#>
 *
 *	@param key <#key description#>
 *	@returns <#return value description#>
 */
- (id)instanceForKey:(NSString *)key;


/**
 *	<#Description#>
 *
 *	@param param <#param description#>
 *	@param key <#key description#>
 */
- (void)setParameter:(id)param forKey:(NSString *)key;


/**
 *	<#Description#>
 *
 *	@param key <#key description#>
 *	@returns <#return value description#>
 */
- (id)parameterForKey:(NSString *)key;



@end
