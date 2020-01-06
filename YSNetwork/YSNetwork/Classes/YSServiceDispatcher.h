//
//  YSServiceDispatcher.h
//  YSNetwork
//
//  Created by yanghai on 2018/5/15.
//  Copyright © 2018年 fuzzball. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YSBaseCommand;
@class YSBaseParser;
@class YSRequestHandler;
@class YSNetworkError;

@protocol YSRequestDelegate <NSObject>

@optional
///获取HTTP请求的公共部分
- (NSDictionary *)getCommonHeader;
- (NSDictionary *)getCommonBody;
///网络请求的签名
- (NSMutableDictionary *)requestSignInfosWithBody:(NSMutableDictionary *)reqBody;
- (NSMutableDictionary *)requestSignInfosWithHead:(NSMutableDictionary *)head;
///检查返回数据的业务是否正确，并将错误信息返回
- (YSNetworkError *)businessCheckWith:(id)responseObj;

@end

typedef void(^YSReqSuccessBlock)(_Nullable id result);
typedef void(^YSReqFailureBlock)(__kindof YSNetworkError *error);

@interface YSServiceDispatcher : NSObject

@property (nonatomic, assign) NSInteger timeoutValue;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)shareDispatcher;

- (NSURLSessionDataTask *)sendCommand:(YSBaseCommand *)command
                    withParser:(YSBaseParser *)parser
                       success:(nullable YSReqSuccessBlock)success
                       failure:(nullable YSReqFailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
