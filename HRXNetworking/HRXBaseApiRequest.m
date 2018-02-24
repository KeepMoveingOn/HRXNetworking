//
//  HRXBaseApiRequest.m
//  zztjProject
//
//  Created by 王超群(EX-WANGCHAOQUN001) on 2018/2/12.
//  Copyright © 2018年 PA. All rights reserved.
//

#import "HRXBaseApiRequest.h"
#import "HRXBaseApiResponse.h"
#import "HRXServiceFactory.h"

@implementation HRXBaseApiRequest

- (instancetype)init {
    
    if (self = [super init]) {
        
        _apiRequestType = HRXApiRequestTypePost;
        _timeoutInterval = 15.0;
        _apiRequestDataType = HRXApiRequestDataTypeJson;
        _apiResponseDataType = HRXApiResponseDataTypeJson;
    }
    return self;
}

#pragma mark - Public
- (void)analyse:(id)responseObject task:(NSURLSessionDataTask *)task {
    
    [self.apiResponse analyse:responseObject task:task];
    
    if (self.apiResponse.isSuccess) {
        
        if ([_delegate respondsToSelector:@selector(apiRequest:didResponseSuccess:)]) {
            
            [_delegate apiRequest:self didResponseSuccess:_apiResponse];
        }
    }else {
        
        if ([_delegate respondsToSelector:@selector(apiRequest:didResponseFailure:)]) {
            
            [_delegate apiRequest:self didResponseFailure:_apiResponse];
        }
    }
}

- (void)failure:(NSError *)error {
    
    if ([_delegate respondsToSelector:@selector(apiRequest:didRequestError:)]) {
        
        [_delegate apiRequest:self didRequestError:error];
    }
}

#pragma mark - Getter
- (NSString *)requestUrl {
    
    NSString *requestUrl = [[HRXServiceFactory sharedFactory] service].host;
    requestUrl = [requestUrl stringByAppendingPathComponent:self.apiName];
    
    return [requestUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSMutableDictionary *)httpHeads {
    
    if (!_httpHeads) {
        
        _httpHeads = [NSMutableDictionary new];
    }
    return _httpHeads;
}

- (NSMutableArray *)acceptableContentTypes {
    
    if (!_acceptableContentTypes) {
        
        _acceptableContentTypes = [NSMutableArray new];
    }
    return _acceptableContentTypes;
}

- (NSDictionary *)params {
    
    if ([_paramsSources respondsToSelector:@selector(paramsOfapiRequest:)]) {
        
        return [_paramsSources paramsOfapiRequest:self];
    }
    
    return nil;
}

- (HRXBaseApiResponse *)apiResponse {
    
    if (!_apiResponse) {
        
        _apiResponse = [HRXBaseApiResponse new];
    }
    return _apiResponse;
}

#pragma mark - Test Code
//- (NSString *)apiName {
//
////    return @"cram/user/getCaptcha.do";
//    return @"cram/user/sendSms.do";
//}

@end
