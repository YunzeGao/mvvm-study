//
//  NetworkRequest.h
//  ios_mvvm
//
//  Created by Gao on 2022/7/13.
//

#import <Foundation/Foundation.h>
#import "NetworkBaseResponse.h"

typedef NS_ENUM(NSUInteger, NetworkRequestErrorCode) {
    NetworkRequestErrorCodeUndefined = 0,
};

@class NetworkRequest;
typedef NetworkRequest *(^methodBlock)(NSString *url, NSDictionary *params);
typedef void(^successBlock)(__kindof NetworkBaseResponse *);
typedef void(^failBlock)(NSError *error, NSString *msg);

@interface NetworkRequest : NSObject

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *method;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, copy) NSString *fileType;
@property (nonatomic, strong) NSData *formData;
@property (nonatomic, strong) Class modelClass;
@property (nonatomic, copy) successBlock completion;
@property (nonatomic, copy) failBlock error;

- (void)commit;
- (void)commit:(BOOL)synchronization;

# pragma mark - 链式调用

- (methodBlock)GET;
- (methodBlock)POST;
- (methodBlock)PUT;
- (methodBlock)DELETE;

- (NetworkRequest *(^)(NSString *))set_fileType;
- (NetworkRequest *(^)(NSData *))set_formData;
- (NetworkRequest *(^)(Class ))set_modelClass;

- (NetworkRequest *(^)(successBlock))success;
- (NetworkRequest *(^)(failBlock))fail;

- (void(^)(void))commitAsync;
- (void(^)(void))commitSync;

@end
