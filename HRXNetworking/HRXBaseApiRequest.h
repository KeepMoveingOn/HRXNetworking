//
//  HRXBaseApiRequest.h
//  zztjProject
//
//  Created by 王超群(EX-WANGCHAOQUN001) on 2018/2/12.
//  Copyright © 2018年 PA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HRXBaseApiRequest;
@class HRXBaseApiResponse;

typedef NS_ENUM(NSUInteger, HRXApiRequestType) {
    HRXApiRequestTypePost,
    HRXApiRequestTypeGet,
};

typedef NS_ENUM(NSUInteger, HRXApiRequestDataType) {
    HRXApiRequestDataTypeBinary,
    HRXApiRequestDataTypeJson,
};

typedef NS_ENUM(NSUInteger, HRXApiResponseDataType) {
    HRXApiResponseDataTypeBinary,
    HRXApiResponseDataTypeJson,
    HRXApiResponseDataTypeXml,
    HRXApiResponseDataTypeImage,
};

@protocol HRXApiParamsDelegate <NSObject>

- (NSDictionary *)paramsOfapiRequest:(HRXBaseApiRequest *)apiRequest;

@end

@protocol HRXApiRequestDelegate <NSObject>

@optional

/**
 请求数据成功

 */
- (void)apiRequest:(HRXBaseApiRequest *)apiRequest didResponseSuccess:(HRXBaseApiResponse *)response;
/**
 请求数据异常

 */
- (void)apiRequest:(HRXBaseApiRequest *)apiRequest didResponseFailure:(HRXBaseApiResponse *)response;
/**
 请求数据失败 无网、请求超时等
 */
- (void)apiRequest:(HRXBaseApiRequest *)apiRequest didRequestError:(NSError *)error;
@end

@interface HRXBaseApiRequest : NSObject

/**
 请求回调代理
 */
@property (nonatomic, assign) id<HRXApiRequestDelegate> delegate;
/**
 请求接口名
 */
@property (nonatomic, strong) NSString *apiName;
/**
 请求接口路径
 */
@property (nonatomic, strong) NSString *requestUrl;
/**
 请求类型: POST、GET 默认POST方式
 */
@property (nonatomic, assign) HRXApiRequestType apiRequestType;
/**
 请求参数代理
 */
@property (nonatomic, weak) id<HRXApiParamsDelegate> paramsSources;
/**
 请求参数(请勿直接设置参数值,统一设置代理paramsSources进行外部获取)
 */
@property (nonatomic, strong) NSDictionary *params;
/**
 请求超时设置 默认15s
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
/**
 请求数据类型 默认JSON格式
 */
@property (nonatomic, assign) HRXApiRequestDataType apiRequestDataType;
/**
 返回数据类型 默认JSON格式
 */
@property (nonatomic, assign) HRXApiResponseDataType apiResponseDataType;
/**
 公共请求头参数
 */
@property (nonatomic, strong) NSMutableDictionary *httpHeads;
/**
 响应数据类型
 */
@property (nonatomic, strong) NSMutableArray *acceptableContentTypes;
/**
 返回数据解析类,如有特殊解析需求可继承该类并重写[apiResponse analyse:]方法
 */
@property (nonatomic, strong) HRXBaseApiResponse *apiResponse;

/**
 返回数据解析

 @param responseObject 返回数据
 */
- (void)analyse:(id)responseObject task:(NSURLSessionDataTask *)task;
/**
 数据请求失败
 */
- (void)failure:(NSError *)error;

@end
