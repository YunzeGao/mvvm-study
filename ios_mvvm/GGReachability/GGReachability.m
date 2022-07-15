//
//  GGReachability.m
//  ios_mvvm
//
//  Created by Gao on 2022/7/15.
//

#import "GGReachability.h"
#import "Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface GGReachability ()

@property (nonatomic, copy) NSString *defaultDomain;

@property (nonatomic, strong) Reachability *reach;
@property (nonatomic, assign) NetworkStatus status;
@property (nonatomic, strong) RACSubject *subject;

@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation GGReachability

- (instancetype)init
{
    self = [super init];
    if (self) {
        _status = NotReachable;
        _subject = [RACSubject subject];
        _queue = dispatch_queue_create("GGReachability Queue", NULL);
    }
    return self;
}

+ (GGReachability *)shared {
    static GGReachability *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[GGReachability alloc] init];
    });
    
    return instance;
}


+ (void)startWithDefaultDomain:(NSString *)domain {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        GGReachability *reach_ = [self shared];
        [reach_ setReach:[Reachability reachabilityWithHostName:domain]];
        [reach_ addObservers];
        [reach_ updateStatusAsync];
    });
}

+ (GGNetworkStatus)currentStatus {
    return GGNetworkStatusNotReachable;
}

+ (WWANStatus)currentWWANStatus {
    static NSArray *Access2GArray;
    static NSArray *Access3GArray;
    static NSArray *Access4GArray;
    static NSArray *Access5GArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Access2GArray = @[
            CTRadioAccessTechnologyGPRS,
            CTRadioAccessTechnologyEdge,
            CTRadioAccessTechnologyCDMA1x
        ];
        Access3GArray = @[
            CTRadioAccessTechnologyWCDMA,
            CTRadioAccessTechnologyHSDPA,
            CTRadioAccessTechnologyHSUPA,
            CTRadioAccessTechnologyCDMAEVDORev0,
            CTRadioAccessTechnologyCDMAEVDORevA,
            CTRadioAccessTechnologyCDMAEVDORevB,
            CTRadioAccessTechnologyeHRPD
        ];
        Access4GArray = @[
            CTRadioAccessTechnologyLTE
        ];
        Access5GArray = @[];
        /// iOS 14 以上才有 5G信号
        if (@available(iOS 14.1, *)) {
            Access5GArray = @[
                CTRadioAccessTechnologyNRNSA,
                CTRadioAccessTechnologyNR
            ];
        }
    });
    switch ([GGReachability shared].status) {
        case NotReachable:
            return WWANStatusNotReachable;
            break;
        case ReachableViaWWAN: {
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
            NSString *currentStatus = nil;
            if (@available(iOS 13.0, *)) {
                NSDictionary<NSString *, NSString *> *techDict = [info serviceCurrentRadioAccessTechnology];
                if (techDict.count) {
                    NSString *serviceId = info.dataServiceIdentifier;
                    if (serviceId.length) {
                        currentStatus = [techDict objectForKey:serviceId];
                    }
                }
            } else {
                currentStatus = info.currentRadioAccessTechnology;
            }
            if (currentStatus) {
                if ([Access5GArray containsObject:currentStatus]) {
                    return WWANStatus5G;
                } else if ([Access4GArray containsObject:currentStatus]) {
                    return WWANStatus4G;
                } else if ([Access3GArray containsObject:currentStatus]) {
                    return WWANStatus3G;
                } else if ([Access2GArray containsObject:currentStatus]) {
                    return WWANStatus2G;
                }
            }
            return WWANStatusUnknown;
        }
            break;
        default:
            return WWANStatusUnknown;
            break;
    }
}

# pragma mark - private methods
- (void)addObservers {
    /// 注册 Reachability的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachNotificationHandler:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    /// 注册 系统SIM卡网络状态状态
    if (@available(iOS 12.1, *)) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(radioNotificationHandler:)
                                                     name:CTServiceRadioAccessTechnologyDidChangeNotification
                                                   object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(radioNotificationHandler:)
                                                     name:CTRadioAccessTechnologyDidChangeNotification
                                                   object:nil];
    }
    
    /// 打开监听
    if ([NSThread isMainThread]) {
        [self.reach startNotifier];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.reach startNotifier];
        });
    }
}

- (void)reachNotificationHandler:(NSNotification *)notification {
    Reachability *reach = [notification object];
    if (reach != self.reach) return;
    [self updateStatusAsync];
}

- (void)radioNotificationHandler:(NSNotification *)notification {
    [self updateStatusAsync];
}

- (void)updateStatusAsync {
    dispatch_async(self.queue, ^{
        [self updateStatus];
    });
}

- (GGNetworkStatus)updateStatus {
    NetworkStatus status = [self.reach currentReachabilityStatus];
    if (status != self.status) {
        self.status = status;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.subject sendNext:@(status)];
        });
    }
    return (GGNetworkStatus)status;
}

# pragma mark - setters & getters

@end
