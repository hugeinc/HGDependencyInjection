#HGDependencyInjection (HGDI)

HGDI is a lightweight dependency injection framework for Objective-C for MacOS X and iOS. With flexibility in mind, the HGDI framework gives us the flexibility to use many different Inversion of Control approaches. It was built around the principle of boot-strapping an application's dependencies at launch, containing them within a single point of the code, and share them across the application as a whole. 


Please refer to this great paper written by Martin Fowler, [Inversion of Control Containers and the Dependency Injection pattern](http://martinfowler.com/articles/injection.html) as it describes the three different types of IoC frameworks:

 * Type 1 IoC (Interface Injection)
 * Type 2 IoC (Setter Injection)
 * Type 3 IoC (Constructor Injection).
 
 
HGDI's flexibility gives us the ability to use hybrids of the three of approaches to create all of our dependency injection needs. Let's look at a few examples for each. In theory, the HGDI framework alleviates the use of abundant amounts of singletons, provides an easy way manually construct objects with their dependencies, and relieves memory overhead by organizing dependencies into one place within the code base


## Features

* Constructor Based / Service Locator Based Dependency Injection
* Service Container Support
	* Class Instances
	* Protocol Instance
	* Keyed Instance Support
	* Custom Parameter Support
	
# Using HGDI

The basic concept behind CSMapper is a three steps:

1. Create a shared instance of the `HGDIContainer`
2. Create `HGDIImplementation` instance of one of the following types:
	* `HGDIConstructorImplementation` 
	* `HGDIInstanceImplementation`
3. Register the `HGDIImplementation` with the service container 


The service container holds reference to constructor, instance, protocol specific, and keyed instances to be shared by the application. Generally we want to feed the service container itself, or a container object that holds reference of the service container, to all our instances via constructors. This allows class instances to use the service container at a later point to instantiate new objects with their respective dependencies accordingly. 

Lets look at some examples :)

##Basic Use

####Register Constructor Implementation

First we instantiate an `HGDIConstructorImplementation` instance for a specific class, in which we feed our dependencies. The shared instance of the service container in this example, accordingly to the view controller.

```
__weak __typeof__(self) blockSelf = self;
   
HGDIConstructorImplementation *viewControllerImplementation =
[[HGDIConstructorImplementation alloc] initWithImplementationClass:[DIParentViewController class] 
	bootstrap:^id(id container, __weak Class implementationClass, NSDictionary *parameters)
	{
		DIParentViewController *viewController = [[implementationClass alloc] init];
        viewController.serviceContainer = blockSelf.serviceContainer;
		return controller;
	}];
```

Then we register the constructor with the shared serviceContainer instance

```
[self.serviceContainer setImplementation:viewControllerImplementation forClass:[DIParentViewController class]];

```

#### Parent Class Instantiation via Constructor Implementation

Once the constructor has been registered, the object can be instantiated with all the injected dependencied using the service container.

``` 
DIParentViewController *p = [self.serviceContainer newInstanceForClass:[DIParentViewController class]];

```
#### Child Class Instantiation via Constructor Implementation

When a child object inherits from a parent, the parent's registered constructor can be used to inject the configured dependencies. You can instantiate the child object by using the parent's implementation constructor as follows.


``` 
DIChildViewController *c = [self.serviceContainer newInstanceForClass:[DIParentViewController class] 
 												  implementationClass:[DIChildViewController class]];
```

##Class Instance Implementation

In the case we need to create a single instance of a class to share across the application, we can create an `HGDIInstanceImplementation` instance to store the object within the service container.


####Register Class Instance Implementation

First we create an instance of the object we would like to store, in this case `DIService`

```
DIService *service = [[DIService alloc] init];
```

After we created the instance of the object we would like to store, we create `HGDIInstanceImplementation` instance that will hold reference to our object 

```
HGDIInstanceImplementation *instanceImplementation = [[HGDIInstanceImplementation alloc] initWithInstance:service];
```

Then we register the `HGDIInstanceImplementation` instance with the service container, binding it to the `DIService` class.

```
[self.serviceContainer setImplementation:instanceImplementation forClass:[DIConsumable class]];
```

####Access Class Instance Implementation

Assuming visible access to the service container. The object can be access as follows

```
DIService *service = [self.serviceContainer instanceForClass:[DIService class]];
```

##Protocol Instance Implementation

We can also tie an implementation instance for a specific protocol. This follows the exact same pattern as an instance implementation, except we register the `HGDIInstanceImplementation` object for a specific protocol.

####Register Protocol Implementation

First we create an instance that implements the protocol.

```
DIService<DIProtocol> *protocolInstance = [[DIService alloc] init];

HGDIInstanceImplementation *protocolImplementation = 
				[[HGDIInstanceImplementation alloc] initWithInstance:protocolInstance];
```

Then we register the object, binding it to the protocol itself.

```
[self.serviceContainer setImplementation:protocolInstanceImplementation forProtocol:@protocol(DIProtocol)];
```

####Access Protocol Instance Implementation

Assuming visible access to the service container. The object can be access as follows

```
DIService<DIProtocol> protocolInstance = [self.serviceContainer instanceForProtocol:@protocol(DIProtocol)];  
```

## Keyed Instance Implementation

An instance of an can be registered for specific developer defined instance key, and accessed from the service container using the key. The Keyed implementation follows the exact same pattern as the __Instance / Protocol Instance Implementation__ examples, with a few minor differences. 


####Register Keyed Instance Implementation

First we create an instance of the object we would like to store, in this case `DIService`, then create an `HGDIInstanceImplementation` that will hold reference to our object 

```
DIService *service = [[DIService alloc] init];

HGDIInstanceImplementation *instanceImplementation = [[HGDIInstanceImplementation alloc] initWithInstance:service];
```

Then we register the `HGDIInstanceImplementation` instance with the service container, binding it to developer defined key

```
[self.serviceContainer setImplementation:instanceImplementation forKey:kServiceKey];
```

####Access Keyed Instance Implementation

Assuming visible access to the service container. The object can be access as follows

```
DIService *service = [self.serviceContainer instanceForKey:kServiceKey]; 
```


##Custom Parameter Support

From time to time we need to include some specific parameters into our constructor implementation for configuration purpose during instantiation. Let's look at example and how we can apply it.

####Register Parameters For Constructor Implementation

For this example let's pretend we have an `DIHTTPCLient` class.

```
@interface DIHTTPClient : NSObject
@property (nonatomic, strong) NSURL *baseURL;
@end

```
During instantiation we need to set the baseURL property on the instance, and feed in a __baseURL__. In the example below we can set specific parameters which will be applied via constructor implementation.

```
NSString *const kBaseURLParameterKey= @"kBaseURLParameterKey";

- (void)loadHTTPClientConstructor {
	__weak __typeof__(self) blockSelf = self;
   
	HGDIConstructorImplementation *httpClientImplementation =
	[[HGDIConstructorImplementation alloc] initWithImplementationClass:[DIHTTPClient class] 
		bootstrap:^id(id container, __weak Class implementationClass, NSDictionary *parameters)
		{
			DIHTTPClient *httpClient = [[implementationClass alloc] init];
        	httpClient setBaseURL:[parameters objectForKey:kBaseURLParameterKey]
			return httpClient;
		}];
	
	NSURL *baseURLParameter = [NSURL URLWithString:@"http://www.apiendpoint.com"];
	[httpClientImplementation setParameter:baseURLParameter forKey:kBaseURLParameterKey];
	
	[self.serviceContainer setImplementation:httpClientImplementation forClass:[DIHTTPClient class]];
}
```
Assuming visible access to the service container. The object can be created as follows with the default parameters applied to the constructor implementation

```
DIHTTPClient *httpClient = [self.serviceContainer instanceForClass:[DIHTTPClient class]];
```

####Override Constructor Implementation Parameters

Let's pretend the `DIHTTPClient` had multiple dependencies within it's constructor and we do not want to change those. The only difference is that we need to create a new instance, but with custom __baseURL__  that all of a sudden, we need to create a separate instance of the DIHTTPClient, with a different url. 

```
HGDIConstructorImplementation *implementation = [self.serviceContainer implementationForClass:[DIHTTPClient class]];

NSURL *baseURLParameter = [NSURL URLWithString:@"http://www.differentapiendpoint.com"];
[httpClientImplementation setParameter:baseURLParameter forKey:kBaseURLParameterKey];

DIHTTPClient *newHttpClient = [implementation newInstanceWithClass:[DIHTTPClient class]];

```

##Advanced Techniques





## Testing

The project includes XCTestCases

## Installation

### Cocoapods

Edit your Pofile

    edit Podfile
    pod 'HGDI', '1.0'

Now you can install Objection
    
    pod install

#### Include framework
    #import <HGDI.h>

Learn more at [CocoaPods](http://cocoapods.org).

## Requirements

* MacOS X 10.7 +
* iOS 5.0 +

## Authors

* Marc Ammann (marc@codesofa.com)
* Anton Doudarev (adoudarev@hugeinc.com)


## Applications that use HGDI

TBD


