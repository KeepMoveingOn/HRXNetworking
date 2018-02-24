//
//  HRNetworkingLog.m
//  zztjProject
//
//  Created by 王超群(EX-WANGCHAOQUN001) on 2018/2/22.
//  Copyright © 2018年 PA. All rights reserved.
//

#import "HRNetworkingLog.h"

@implementation HRNetworkingLog

+ (void)logRequestInfoWithRequest:(HRXBaseApiRequest *)apiRequest error:(NSError *)error {

#ifdef DEBUG
    
    NSMutableString *infoString = [NSMutableString new];
    [infoString appendString:@"\n\n===========================================================================\n=                      HRXNetworking Response start                       =\n===========================================================================\n\n"];
    
    [infoString appendFormat:@"API Url:\t\t%@\n", apiRequest.requestUrl];
    [infoString appendFormat:@"HTTP Header:\n%@\n", apiRequest.httpHeads];
    [infoString appendFormat:@"Params:\n%@\n", apiRequest.params];
    [infoString appendFormat:@"Content:\n%@\n", apiRequest.apiResponse.responseObject ?: error];
    
    [infoString appendString:@"\n\n=========================================================================\n=                      HRXNetworking Response end                       =\n=========================================================================\n\n"];
    
    NSLog(@"%@", infoString);
    
#endif
    
}

@end
