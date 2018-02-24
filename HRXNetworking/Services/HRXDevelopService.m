//
//  HRXStageService.m
//  zztjProject
//
//  Created by 王超群(EX-WANGCHAOQUN001) on 2018/2/22.
//  Copyright © 2018年 PA. All rights reserved.
//

#import "HRXDevelopService.h"
#import "PALastLoginManager.h"

@implementation HRXDevelopService

- (NSString *)host {

    return @"";
}

- (NSDictionary *)commonParams {
    
    return nil;
}

- (NSDictionary *)commonHttpHeads {
    
    NSMutableDictionary *commonHttpHeads = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type", @"application/json", @"Accept", @"application/json", nil];
    
    NSString *papa5Wesession = [PALastLoginManager readLastUserBean].papa5Wesession;
    
    return commonHttpHeads;
}

- (NSArray *)commonAcceptableContentTypes {
    
    return @[@"application/x-gzip",
             @"text/html",
             @"text/plain"];
}

@end
