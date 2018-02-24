//
//  HRXNetworking.h
//  zztjProject
//
//  Created by 王超群(EX-WANGCHAOQUN001) on 2018/2/12.
//  Copyright © 2018年 PA. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HRXBaseApiRequest.h"
#import "HRXBaseApiResponse.h"

typedef void(^HRXRequestSuccessBlock)(HRXBaseApiResponse *response);
typedef void(^HRXRequestFailureBlock)(NSError *error);
typedef void(^HRXDownloadProgressBlock)(int64_t bytesRead, int64_t totalBytes);
typedef void(^HRXDownloadSuccessBlock)(NSString *filePath);

@interface HRXNetworking : NSObject

@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, assign) BOOL refreshedToken;
@property (nonatomic, assign) NSInteger refreshApiCount;

+ (instancetype)sharedNetworking;

/**
 通用请求方法

 @param apiRequest 具体请求API类
 */
- (void)excuteApiRequest:(HRXBaseApiRequest *)apiRequest;
/**
 通用请求方法

 @param apiRequest 具体请求API类
 @param success 请求成功回调
 @param failure 请求失败回调
 */
- (void)excuteApiRequest:(HRXBaseApiRequest *)apiRequest success:(HRXRequestSuccessBlock)success failure:(HRXRequestFailureBlock)failure;

/**
 文件下载
 
 @param url 文件下载地址
 @param destinationPath 可指定下载目录,不设置则默认为Document文件夹
 @param processBlock bytesRead:已下载数据量 totalBytes:总数据大小
 @param successBlock filePath:文件保存路径
 @param failureBlock error:错误信息
 */
- (void)downloadWithUrl:(NSString *)urlString destinationPath:(NSString *)destinationPath processBlock:(HRXDownloadProgressBlock)processBlock successBlock:(HRXDownloadSuccessBlock)successBlock failureBlock:(HRXRequestFailureBlock)failureBlock;

@end
