//
//  HRXNetworking+RefreshToken.m
//  zztjProject
//
//  Created by 王超群(EX-WANGCHAOQUN001) on 2018/2/22.
//  Copyright © 2018年 PA. All rights reserved.
//

#import "HRXNetworking+RefreshToken.h"
#import "HRXRefreshTokenApi.h"
#import "PALoginModel.h"

@interface HRXNetworking () <HRXApiParamsDelegate>


@end

@implementation HRXNetworking (RefreshToken)

- (BOOL)checkAccessToken:(HRXBaseApiRequest *)apiRequest success:(HRXRequestSuccessBlock)success failure:(HRXRequestFailureBlock)failure {
    
    NSInteger invalidateTokenCode = 20002;
    
    if (apiRequest.apiResponse.code == invalidateTokenCode) {
        
        ++self.refreshApiCount;
        [self refreshToken:apiRequest success:success failure:failure];
        return NO;
    }else {
        
        return YES;
    }
}

- (void)refreshToken:(HRXBaseApiRequest *)apiRequest success:(HRXRequestSuccessBlock)success failure:(HRXRequestFailureBlock)failure {

    dispatch_async(self.serialQueue, ^{
        
        @synchronized(self) {
            
            if (!self.refreshedToken) {
                
                HRXRefreshTokenApi *refreshTokenRequest = [HRXRefreshTokenApi new];
                refreshTokenRequest.paramsSources = self;
                [self excuteApiRequest:refreshTokenRequest success:^(HRXBaseApiResponse *response) {
                    
                    if (response.isSuccess) {
                        
                        PALoginModel *loginModel = [PALoginModel sharedUserInfo];
                        loginModel.accessToken = response.responseObject[@"data"][@"accessToken"];
                        loginModel.refreshToken = response.responseObject[@"data"][@"refreshToken"];
                        
                        [self excuteApiRequest:apiRequest success:success failure:failure];
                        self.refreshedToken = --self.refreshApiCount ? YES : NO;
                    }else {
                        
                        --self.refreshApiCount;
                        if (failure) {
                            
                            NSError *error = [NSError errorWithDomain:@"invalidateToken" code:9999 userInfo:nil];
                            failure(error);
                        }
                    }
                } failure:^(NSError *error) {
                    
                    if (failure) {
                        
                        failure(error);
                    }
                }];
            }else {
                
                [self excuteApiRequest:apiRequest success:success failure:failure];
                self.refreshedToken = --self.refreshApiCount ? YES : NO;
            }
        }
    });
}

#pragma mark - HRXApiParamsDelegate
- (NSDictionary *)paramsOfapiRequest:(HRXBaseApiRequest *)apiRequest {
    
    PALoginModel *loginModel = [PALoginModel sharedUserInfo];
    return @{@"refreshToken" : loginModel.refreshToken};
}

@end
