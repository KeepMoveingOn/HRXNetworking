//
//  HRXNetworking+RefreshToken.h
//  zztjProject
//
//  Created by 王超群(EX-WANGCHAOQUN001) on 2018/2/22.
//  Copyright © 2018年 PA. All rights reserved.
//

#import "HRXNetworking.h"
#import "HRXBaseApiRequest.h"

@interface HRXNetworking (RefreshToken)

- (BOOL)checkAccessToken:(HRXBaseApiRequest *)apiRequest success:(HRXRequestSuccessBlock)success failure:(HRXRequestFailureBlock)failure;

@end
