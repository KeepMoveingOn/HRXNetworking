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
        
        [self refreshToken:apiRequest success:success failure:failure];
        return NO;
    }else {
        
        return YES;
    }
}

- (void)refreshToken:(HRXBaseApiRequest *)apiRequest success:(HRXRequestSuccessBlock)success failure:(HRXRequestFailureBlock)failure {

    dispatch_async(self.concurrentQueue, ^{
        
        ++self.refreshApiCount;
        dispatch_semaphore_wait(self.refreshTokenSemaphore, DISPATCH_TIME_FOREVER);
            if (!self.refreshedToken) {
                
                HRXRefreshTokenApi *refreshTokenRequest = [HRXRefreshTokenApi new];
                refreshTokenRequest.paramsSources = self;
                [self excuteApiRequest:refreshTokenRequest success:^(HRXBaseApiResponse *response) {
                    
                    if (response.isSuccess) {
                        
                        PALoginModel *loginModel = [HRXAppManager shareMager].loginModel;
                        loginModel.accessToken = response.responseObject[@"data"][@"accessToken"];
                        loginModel.refreshToken = response.responseObject[@"data"][@"refreshToken"];
                        
                        [self excuteApiRequest:apiRequest success:success failure:failure];
                        self.refreshedToken = --self.refreshApiCount ? NO : YES;
                        dispatch_semaphore_signal(self.refreshTokenSemaphore);
                    }else {
                        
                        if (failure) {
                            
                            NSError *error = [NSError errorWithDomain:@"invalidateToken" code:9999 userInfo:nil];
                            failure(error);
                        }
                        
                        --self.refreshApiCount;
                        dispatch_semaphore_signal(self.refreshTokenSemaphore);
                    }
                } failure:^(NSError *error) {
                    
                    if (failure) {
                        
                        failure(error);
                    }
                    
                    --self.refreshApiCount;
                    dispatch_semaphore_signal(self.refreshTokenSemaphore);
                }];
            }else {
                
                [self excuteApiRequest:apiRequest success:success failure:failure];
                self.refreshedToken = --self.refreshApiCount ? NO : YES;
                dispatch_semaphore_signal(self.refreshTokenSemaphore);
            }
    });
}

#pragma mark - HRXApiParamsDelegate
- (NSDictionary *)paramsOfapiRequest:(HRXBaseApiRequest *)apiRequest {
    
    PALoginModel *loginModel = [HRXAppManager shareMager].loginModel;
    return @{@"refreshToken" : loginModel.refreshToken};
}

@end
