//
//  HRXServiceProtocol.h
//  zztjProject
//
//  Created by 王超群(EX-WANGCHAOQUN001) on 2018/2/22.
//  Copyright © 2018年 PA. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HRXServiceProtocol <NSObject>

- (NSString *)host;
- (NSDictionary *)commonParams;
- (NSDictionary *)commonHttpHeads;
- (NSArray *)commonAcceptableContentTypes;

@end
