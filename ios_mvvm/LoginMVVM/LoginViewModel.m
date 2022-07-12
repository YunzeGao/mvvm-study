//
//  LoginViewModel.m
//  ios_mvvm
//
//  Created by G&H on 2022/7/11.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialBind];
    }
    return self;
}

# pragma mark - private methods
- (void)initialBind {
    _enableLoginSignal = [RACSignal combineLatest:@[RACObserve(self.user, username),RACObserve(self.user, password)]
                                               reduce:^id(NSString *name, NSString *pwd) {
        NSLog(@"name = %@, pwd = %@", name, pwd);
        return @(name.length > 0 && pwd.length > 0);
    }];
    
    _LoginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"点击了登录");
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@"登录成功"];
                [subscriber sendCompleted];
            });
            return nil;
        }];
    }];
    
    // 监听登录产生的数据
    [_LoginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        if ([x isEqualToString:@"登录成功"]) {
            NSLog(@"登录成功");
        }
    }];
    
    // 监听登录状态
    [[_LoginCommand.executing skip:1] subscribeNext:^(id x) {
        if ([x isEqualToNumber:@(YES)]) {
            // 正在登录ing...
            // 用蒙版提示
//            [MBProgressHUD showMessage:@"正在登录..."];
        } else
        {
            // 登录成功
            // 隐藏蒙版
//            [MBProgressHUD hideHUD];
        }
    }];
}

# pragma mark - setters & getters
- (LoginModel *)user {
    if (!_user) {
        _user = [[LoginModel alloc] init];
    }
    return _user;
}

@end
