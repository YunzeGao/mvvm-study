//
//  GGReachability.h
//  ios_mvvm
//
//  Created by Gao on 2022/7/15.
//

#import <Foundation/Foundation.h>

@class RACSignal;

typedef NS_ENUM(NSUInteger, GGNetworkStatus) {
    GGNetworkStatusNotReachable = 0,      /// 无法抵达
    GGNetworkStatusReachableWIFI = 1,     /// WIFI
    GGNetworkStatusReachableWWAN = 2,     /// 流量
};

typedef NS_ENUM(NSUInteger, WWANStatus) {
    WWANStatusNotReachable = 0,    /// 没有定义
    WWANStatus2G,
    WWANStatus3G,
    WWANStatus4G,
    WWANStatus5G,
    WWANStatusUnknown = 99,     /// 已定义
};

@interface GGReachability : NSObject

/// 设置defaultDomain来启动该模块
+ (void)startWithDefaultDomain:(NSString *)domain;

/// 获取当前连接状态
+ (GGNetworkStatus)currentStatus;
/// 获取当前流量状态
+ (WWANStatus)currentWWANStatus;
/// 网络是否联通
+ (BOOL)isReachable;
/// WiFi是否联通
+ (BOOL)isReachableWIFI;
/// 流量是否联通
+ (BOOL)isReachableWWAN;

/// 网络信息更改信号
+ (RACSignal *)statusSignal;
/// 异步刷新一次当前的网络状态
+ (void)refreshStatusWithAsync:(void(^)(void))completion;
/// 同步刷新一次当前的网络状态
+ (void)refreshStatusWithSync:(void(^)(void))completion;

@end
