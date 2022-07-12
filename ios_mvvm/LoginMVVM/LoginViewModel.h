//
//  LoginViewModel.h
//  ios_mvvm
//
//  Created by G&H on 2022/7/11.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "LoginModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewModel : NSObject

@property (nonatomic, strong) LoginModel *user;
// 是否允许登录的信号
@property (nonatomic, strong, readonly) RACSignal *enableLoginSignal;
@property (nonatomic, strong, readonly) RACCommand *LoginCommand;

@end

NS_ASSUME_NONNULL_END
