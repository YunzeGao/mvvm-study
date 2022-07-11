//
//  LoginModel.m
//  ios_mvvm
//
//  Created by Gao on 2022/7/11.
//

#import "LoginModel.h"

@implementation LoginModel


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithName:(NSString *)username password:(NSString *)password
{
    self = [super init];
    if (self) {
        _username = [username copy];
        _password = [password copy];
    }
    return self;
}



@end
