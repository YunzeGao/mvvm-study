//
//  LoginModel.h
//  ios_mvvm
//
//  Created by Gao on 2022/7/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginModel : NSObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

- (instancetype)initWithName:(NSString *)username password:(NSString *)password;

@end

NS_ASSUME_NONNULL_END
