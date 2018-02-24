//
//  HRXServiceFactory.m
//  zztjProject
//
//  Created by 王超群(EX-WANGCHAOQUN001) on 2018/2/22.
//  Copyright © 2018年 PA. All rights reserved.
//

#import "HRXServiceFactory.h"

@interface HRXServiceFactory ()

@property (nonatomic, strong) NSDictionary *serviceSources;

@end

@implementation HRXServiceFactory

+ (instancetype)sharedFactory {
    
    static dispatch_once_t onceToken;
    static HRXServiceFactory *sharedFactory = nil;
    
    dispatch_once(&onceToken, ^{
        
        sharedFactory = [[[self class] alloc] init];
    });
    return sharedFactory;
}

- (id<HRXServiceProtocol>)service {
    
    NSString *serviceName = self.serviceSources[@(self.serviceEnvironment)];
    Class serviceClass = NSClassFromString(serviceName);
    id<HRXServiceProtocol> service = [[serviceClass alloc] init];
    return service;
}

- (NSDictionary *)serviceSources {
    
    return @{@(HRXServiceEnvironmentDevelop) : @"HRXDevelopService"
             
             };
}

@end
