//
//  NetworkConfig.h
//  ios_mvvm
//
//  Created by Gao on 2022/7/14.
//

#import <Foundation/Foundation.h>

@interface NetworkConfig : NSObject

@property (nonatomic, copy) NSString *baseUrl;
@property (nonatomic, assign) NSTimeInterval timeout;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *defaultHeaders;

@end
