//
//  HRXStageService.m
//  zztjProject
//
//  Created by 王超群(EX-WANGCHAOQUN001) on 2018/2/22.
//  Copyright © 2018年 PA. All rights reserved.
//

#import "HRXDevelopService.h"
#import "PALoginModel.h"

@implementation HRXDevelopService

- (NSString *)host {

    return @"";
}

- (NSDictionary *)commonParams {
    
    NSMutableDictionary *commonParams = [NSMutableDictionary new];
    PALoginModel *loginModel = [HRXAppManager shareMager].loginModel;
    
    if (loginModel.accessToken) {
        
        [commonParams setValue:loginModel.accessToken forKey:@"accessToken"];
        return commonParams;
    }
    
    return nil;
}

- (NSDictionary *)commonHttpHeads {
    
    NSMutableDictionary *commonHttpHeads = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type", @"application/json", @"Accept", @"application/json", nil];
    NSString *accessToken = [HRXAppManager shareMager].loginModel.accessToken;


    if (accessToken) {
        
        [commonHttpHeads setValue:accessToken forKey:@"X-HRX-SESSION"];
    }
    
    return commonHttpHeads;
}

- (NSArray *)commonAcceptableContentTypes {
    
    return @[@"application/x-gzip",
             @"text/html",
             @"text/plain"];
}

@end
