//
//  YSNetworkError.h
//  YSNetwork
//
//  Created by yanghai on 2018/5/15.
//  Copyright © 2018年 fuzzball. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kError_Parser_Error         11111
#define kError_Parser_Error_Msg     @"解析返回数据crash"
#define kError_Servers_Error        22222
#define kError_Servers_Error_Msg    @"网络或服务器错误"
#define kError_Business_Error       33333
#define KError_Business_Error_Msg   @"业务范围内的错误"

NS_ASSUME_NONNULL_BEGIN

@interface YSNetworkError : NSObject

@property (nonatomic, copy) NSString *errorMsg;
@property (nonatomic, assign) NSInteger errorCode;
@property (nonatomic, strong) NSError *sourceError;

+ (instancetype)errorWithErrorCode:(NSInteger)errorCode
                          errorMsg:(NSString *)errorMsg
                       sourceError:(nullable NSError *)sourceError;

- (instancetype)initWithErrorCode:(NSInteger)errorCode
                          errorMsg:(NSString *)errorMsg
                       sourceError:(nullable NSError *)sourceError;

@end

NS_ASSUME_NONNULL_END
