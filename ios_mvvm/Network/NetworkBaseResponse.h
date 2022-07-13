//
//  NetworkBaseResponse.h
//  ios_mvvm
//
//  Created by Gao on 2022/7/13.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

@interface NetworkBaseResponse : NSObject

@property (nonatomic, copy) NSString *requestID;

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, assign) BOOL success;

@property (nonatomic, copy) NSString *msg;

@end
