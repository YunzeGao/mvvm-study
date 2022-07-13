//
//  NetworkRequest.m
//  ios_mvvm
//
//  Created by Gao on 2022/7/13.
//

#import "NetworkRequest.h"
#import "Network.h"
#import "NSDate+Add.h"

@implementation NetworkRequest

# pragma mark - 链式调用
- (methodBlock)GET {
    return [self configWithMethod:@"GET"];
}

- (methodBlock)POST {
    return [self configWithMethod:@"POST"];
}

- (methodBlock)PUT {
    return [self configWithMethod:@"PUT"];
}

- (methodBlock)DELETE {
    return [self configWithMethod:@"DELETE"];
}

- (NetworkRequest *(^)(NSString *))set_fileType {
    return ^ NetworkRequest * (NSString *fileType) {
        self.fileType = fileType;
        return self;
    };
}

- (NetworkRequest *(^)(NSData *))set_formData {
    return ^ NetworkRequest * (NSData *formData) {
        self.formData = formData;
        return self;
    };
}

- (NetworkRequest *(^)(__unsafe_unretained Class))set_modelClass {
    return ^ NetworkRequest * (Class modelClass) {
        self.modelClass = modelClass;
        return self;
    };
}


- (NetworkRequest *(^)(successBlock))success {
    return ^ NetworkRequest * (successBlock block) {
        self.completion = block;
        return self;
    };
}

- (NetworkRequest *(^)(failBlock))fail {
    return ^ NetworkRequest * (failBlock block) {
        self.error = block;
        return self;
    };
}

- (void(^)(void))commitAsync {
    return ^ void () {
        [self commit:NO];
    };
}

- (void(^)(void))commitSync {
    return ^ void () {
        return [self commit:YES];
    };
}

# pragma mark - 网路请求
- (void)commit {
    [self commit:NO];
}

- (void)commit:(BOOL)synchronization {
    if (![Network hasNetwork]) {
        [NSError errorWithDomain:@"NO_NETWORK" code:1 userInfo:@{}];
        return;
    }
    AFHTTPSessionManager *manager = nil;
    if (synchronization) {
        manager = [[Network sharedManager] copy];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        manager.completionQueue = queue;
    } else {
        manager = [Network sharedManager];
    }
    
    NSString *method = [NSString stringWithString:[self.method uppercaseString]];
    
    NSDictionary *dict = self.params ?: (self.data ?: @{});
    if ([method isEqualToString:@"GET"]) {
        [manager GET:self.url parameters:dict headers:@{} progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self detailData:responseObject];
        }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self detailError:error];
        }];
    } else if ([method isEqualToString:@"POST"]) {
        [manager POST:self.url parameters:dict headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            if (self.formData) {
                NSString *fileName = [NSString stringWithFormat:@"%@.%@", [NSDate currentDate:NSDateStringStyleSecond], self.fileType ?: @"jpg"];
                [formData appendPartWithFileData:self.formData name:@"file" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
            }
        }
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self detailData:responseObject];
        }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self detailError:error];
        }];
    } else if ([method isEqualToString:@"PUT"]) {
        [manager PUT:self.url parameters:dict headers:@{}
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self detailData:responseObject];
        }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self detailError:error];
        }];
    } else if ([method isEqualToString:@"DELETE"]) {
        [manager DELETE:self.url parameters:dict headers:@{}
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self detailData:responseObject];
        }
                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self detailError:error];
        }];
    } else {
        NSError *error = [NSError errorWithDomain:@"NO_METHOD" code:2 userInfo:@{}];
        [self detailError:error];
    }
}

# pragma mark - private methods
- (void)detailData:(id) responseObject{
    NetworkBaseResponse *baseModel = [self.modelClass yy_modelWithDictionary:responseObject];
    if (baseModel.success) {
        self.completion([self.modelClass yy_modelWithDictionary:responseObject]);
    } else {
        NSError *error = [NSError errorWithDomain:@"BIZ_ERROR" code:3 userInfo:@{}];
        [self detailError:error msg:baseModel.msg ?: @""];
    }
}

- (void)detailError:(NSError *)error {
    [self detailError:error msg:@""];
}

- (void)detailError:(NSError *)error  msg:(NSString *)msg {
    self.error(error, msg);
}

# pragma mark - setters & getters
- (methodBlock)configWithMethod:(NSString *)method {
    self.method = method;
    return ^ NetworkRequest * (NSString *url, NSDictionary *data) {
        self.url = url;
        self.data = data;
        return self;
    };
}
@end
