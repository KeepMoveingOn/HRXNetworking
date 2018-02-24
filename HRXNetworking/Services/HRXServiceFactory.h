//
//  HRXServiceFactory.h
//  zztjProject
//
//  Created by 王超群(EX-WANGCHAOQUN001) on 2018/2/22.
//  Copyright © 2018年 PA. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HRXServiceProtocol.h"

typedef NS_ENUM(NSUInteger, HRXServiceEnvironment) {
    HRXServiceEnvironmentDevelop = 0,     //开发
    HRXServiceEnvironmentStageOne = 1,    //stage1
    HRXServiceEnvironmentStageTwo = 2,    //stage2
    HRXServiceEnvironmentGray = 9,        //灰度测试
    HRXServiceEnvironmentProduct = 10     //生产
};

@interface HRXServiceFactory : NSObject

@property (nonatomic, assign) HRXServiceEnvironment serviceEnvironment;

+ (instancetype)sharedFactory;
- (id<HRXServiceProtocol>)service;

@end
