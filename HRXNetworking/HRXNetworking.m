//
//  HRXNetworking.m
//  zztjProject
//
//  Created by 王超群(EX-WANGCHAOQUN001) on 2018/2/12.
//  Copyright © 2018年 PA. All rights reserved.
//

#import "HRXNetworking.h"
#import "HRNetworkingLog.h"
#import "HRXServiceProtocol.h"
#import "HRXServiceFactory.h"
#import "HRXNetworking+RefreshToken.h"

#import <AFNetworking.h>

@implementation HRXNetworking

#pragma mark - Public
+ (instancetype)sharedNetworking {
    
    static dispatch_once_t onceToken;
    static HRXNetworking *sharedNetworking = nil;
    
    dispatch_once(&onceToken, ^{
        
        sharedNetworking = [[self alloc] init];
    });
    
    return sharedNetworking;
}

- (void)excuteApiRequest:(HRXBaseApiRequest *)apiRequest {
    
    [self excuteApiRequest:apiRequest success:nil failure:nil];
}

- (void)excuteApiRequest:(HRXBaseApiRequest *)apiRequest success:(HRXRequestSuccessBlock)success failure:(HRXRequestFailureBlock)failure {
    
    if (apiRequest.apiRequestType == HRXApiRequestTypePost) {
        
        [self POST:apiRequest success:success failure:failure];
    }else if (apiRequest.apiRequestType == HRXApiRequestTypeGet) {
        
        [self GET:apiRequest success:success failure:failure];
    }
}

- (void)downloadWithUrl:(NSString *)urlString destinationPath:(NSString *)destinationPath processBlock:(HRXDownloadProgressBlock)processBlock successBlock:(HRXDownloadSuccessBlock)successBlock failureBlock:(HRXRequestFailureBlock)failureBlock {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (processBlock) processBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return [NSURL fileURLWithPath:destinationPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {
            
            if (failureBlock) failureBlock(error);
        }else {
            
            if (successBlock) successBlock(destinationPath);
        }
    }];
    
    [downloadTask resume];
}

#pragma mark - Private
- (void)POST:(HRXBaseApiRequest *)apiRequest success:(HRXRequestSuccessBlock)success failure:(HRXRequestFailureBlock)failure {
 
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager *manager = [self manager:apiRequest];
    
    [manager POST:apiRequest.requestUrl parameters:apiRequest.params progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [apiRequest analyse:responseObject task:task];
        if ([self checkAccessToken:apiRequest success:success failure:failure]) {
            
            if (success) {
                
                success(apiRequest.apiResponse);
            }
        }
        [HRNetworkingLog logRequestInfoWithRequest:apiRequest error:nil];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [apiRequest failure:error];
        if (failure) {
            
            failure(error);
        }
        
        [HRNetworkingLog logRequestInfoWithRequest:apiRequest error:error];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

- (void)GET:(HRXBaseApiRequest *)apiRequest success:(HRXRequestSuccessBlock)success failure:(HRXRequestFailureBlock)failure {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager *manager = [self manager:apiRequest];
    
    [manager GET:apiRequest.requestUrl parameters:apiRequest.params progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [apiRequest analyse:responseObject task:task];
        
        if ([self checkAccessToken:apiRequest success:success failure:failure]) {
            
            if (success) {
                
                success(apiRequest.apiResponse);
            }
        }
        
        [HRNetworkingLog logRequestInfoWithRequest:apiRequest error:nil];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [apiRequest failure:error];
        if (failure) {
            
            failure(error);
        }
        
        [HRNetworkingLog logRequestInfoWithRequest:apiRequest error:error];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

- (AFHTTPSessionManager *)manager:(HRXBaseApiRequest *)apiRequest {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [self requestSerializer:apiRequest.apiRequestDataType];
    manager.responseSerializer = [self responseSerializer:apiRequest.apiResponseDataType];
    manager.requestSerializer.timeoutInterval = apiRequest.timeoutInterval;
    
    id<HRXServiceProtocol> service = [[HRXServiceFactory sharedFactory] service];
    [apiRequest.httpHeads addEntriesFromDictionary:[service commonHttpHeads]];
    [apiRequest.httpHeads enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        [manager.requestSerializer setValue:key forHTTPHeaderField:obj];
    }];
    
    [apiRequest.acceptableContentTypes addObjectsFromArray:[service commonAcceptableContentTypes]];
    [apiRequest.acceptableContentTypes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:obj];
    }];
    
    return manager;
}

- (AFHTTPRequestSerializer <AFURLRequestSerialization> *)requestSerializer:(HRXApiRequestDataType)requestDataType {
    
    switch (requestDataType) {
        case HRXApiRequestDataTypeBinary:
            return [AFHTTPRequestSerializer serializer];
            break;
        
        case HRXApiRequestDataTypeJson:
            return [AFJSONRequestSerializer serializer];
            break;
            
        default:
            break;
    }
}

- (AFHTTPResponseSerializer <AFURLResponseSerialization> *)responseSerializer:(HRXApiResponseDataType)responseDataType {
    
    switch (responseDataType) {
        case HRXApiResponseDataTypeBinary:
            return [AFHTTPResponseSerializer serializer];
            break;
            
        case HRXApiResponseDataTypeJson:
            return [AFJSONResponseSerializer serializer];
            break;
            
        case HRXApiResponseDataTypeXml:
            return [AFXMLParserResponseSerializer serializer];
            break;
            
        case HRXApiResponseDataTypeImage:
            return [AFImageResponseSerializer serializer];
            break;
            
        default:
            break;
    }
}

#pragma mark - Getter
- (dispatch_queue_t)serialQueue {
    
    if (!_serialQueue) {
        
        _serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _serialQueue;
}

@end
