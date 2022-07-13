//
//  Network.h
//  ios_mvvm
//
//  Created by G&H on 2022/7/13.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "NetworkConfig.h"


@interface Network : NSObject

+ (AFHTTPSessionManager *)sharedManager;

/// 注入默认配置以启动
/// 只能注入一次
+ (void)openServiceWithDefaultConfig:(NetworkConfig *)config;

+ (BOOL)hasNetwork;

@end
