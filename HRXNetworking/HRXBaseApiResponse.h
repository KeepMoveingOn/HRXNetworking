//
//  HRXApiResponse.h
//  zztjProject
//
//  Created by 王超群(EX-WANGCHAOQUN001) on 2018/2/12.
//  Copyright © 2018年 PA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRXBaseApiResponse : NSObject

/**
 提示信息
 */
@property (nonatomic, copy) NSString *message;
/**
 状态码
 */
@property (nonatomic, assign) NSInteger code;
/**
 返回数据
 */
@property (nonatomic, strong) id responseObject;
/**
 请求是否成功
 */
@property (nonatomic, assign) BOOL isSuccess;

/**
 返回数据解析
 
 @param responseObject 返回数据
 */
- (void)analyse:(id)responseObject task:(NSURLSessionDataTask *)task;
/**
 清除上次请求结果
 */
- (void)cleanData;

@end
