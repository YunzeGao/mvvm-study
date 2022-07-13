//
//  Network.m
//  ios_mvvm
//
//  Created by G&H on 2022/7/13.
//

#import "Network.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

static AFNetworkReachabilityStatus networkReachabilityStatus;

@interface Network ()

@property (nonatomic, strong) NetworkConfig *defaultConfig;
@property (nonatomic, weak) AFHTTPSessionManager *manager;

@end

@implementation Network

+ (void)load {
    // 开始监听网络
    // 检测网络连接的单例,网络变化时的回调方法
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"网络状态 : %@", @(status));
        networkReachabilityStatus = status;
    }];
}

+ (instancetype)shardInstance {
    static Network *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (void)openServiceWithDefaultConfig:(NetworkConfig *)config {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        [[self shardInstance] setDefaultConfig:config];
    });
}

+ (AFHTTPSessionManager *)sharedManager {
    return [[self shardInstance] manager];
}

# pragma mark - setters & getters
- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:self.defaultConfig.baseUrl]];
        // 请求数据慢的时候，手机的左上角会出现菊花的效果
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        //默认解析模式
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        manager.requestSerializer.timeoutInterval = self.defaultConfig.timeout;
        //配置响应序列化
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", @"application/octet-stream", @"application/zip"]];
        [self.defaultConfig.defaultHeaders enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull value, BOOL * _Nonnull stop) {
            [manager.requestSerializer setValue:value forHTTPHeaderField:key];
        }];
        _manager = manager;
    }
    return _manager;
}

+ (BOOL)hasNetwork {
    if (AFNetworkReachabilityStatusNotReachable == networkReachabilityStatus ||
        AFNetworkReachabilityStatusUnknown == networkReachabilityStatus) {
        return YES;
    }
    return YES;
}

@end
