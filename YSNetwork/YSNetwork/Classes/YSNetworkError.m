//
//  YSNetworkError.m
//  YSNetwork
//
//  Created by yanghai on 2018/5/15.
//  Copyright © 2018年 fuzzball. All rights reserved.
//

#import "YSNetworkError.h"

@implementation YSNetworkError

+ (instancetype)errorWithErrorCode:(NSInteger)errorCode
                          errorMsg:(NSString *)errorMsg
                       sourceError:(NSError *)sourceError{
    return [[self alloc] initWithErrorCode:errorCode errorMsg:errorMsg sourceError:sourceError];
}

- (instancetype)initWithErrorCode:(NSInteger)errorCode
                          errorMsg:(NSString *)errorMsg
                       sourceError:(NSError *)sourceError{
    if (self = [super init]) {
        self.errorCode = errorCode;
        self.errorMsg = errorMsg;
        self.sourceError = sourceError;
    }
    return self;
}

@end
