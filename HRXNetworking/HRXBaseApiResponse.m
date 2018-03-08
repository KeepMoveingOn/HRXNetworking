//
//  HRXApiResponse.m
//  zztjProject
//
//  Created by 王超群(EX-WANGCHAOQUN001) on 2018/2/12.
//  Copyright © 2018年 PA. All rights reserved.
//

#import "HRXBaseApiResponse.h"
#import "PADataObject.h"

static NSInteger const requestSuccessCode = 10001;

@implementation HRXBaseApiResponse

- (void)analyse:(id)responseObject task:(NSURLSessionDataTask *)task {

    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        
        NSMutableDictionary *responseDictionary = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        [responseDictionary setValue:response.allHeaderFields forKey:@"responseHeaders"];
        
        _code = [responseDictionary[@"responseCode"] integerValue];
        _message = responseDictionary[@"responseMsg"];
        _isSuccess = _code == requestSuccessCode;
        _responseObject = responseDictionary;
    }
}

- (void)cleanData {
    
    _code = nil;
    _message = nil;
    _responseObject = nil;
    _isSuccess = NO;
}

@end
