//
//  YSServiceDispatcher.m
//  YSNetwork
//
//  Created by yanghai on 2018/5/15.
//  Copyright © 2018年 fuzzball. All rights reserved.
//

#import "YSServiceDispatcher.h"
#import "AFNetworking.h"
#import "YSBaseCommand.h"
#import "YSNetworkConfig.h"
#import "YSBaseParser.h"
#import "YSNetworkPrivate.h"
#import "YSNetworkError.h"

#define kRemoteRequestTimeoutValue              10
#define kUploadFileTimeoutValue_MIN             30
#define kUploadFileTimeoutValut_MAX             60
#define kHTTPS_Prefix                           @"https://"

@interface YSServiceDispatcher ()

@property (nonatomic, weak) id <YSRequestDelegate>requestDelegate;
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation YSServiceDispatcher

+ (instancetype)shareDispatcher{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timeoutValue = kRemoteRequestTimeoutValue;
        self.manager = [AFHTTPSessionManager manager];
        self.manager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
        self.manager.requestSerializer.timeoutInterval = self.timeoutValue;
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
        /*
         如果是自签名的证书，这里需要检查环境加载证书文件
         */
    }
    return self;
}

- (void)setTimeoutValue:(NSInteger)timeoutValue{
    _timeoutValue = timeoutValue;
    self.manager.requestSerializer.timeoutInterval = timeoutValue;
}

- (NSURLSessionTask *)sendCommand:(YSBaseCommand *)command
                    withParser:(YSBaseParser *)parser
                       success:(nullable YSReqSuccessBlock)success
                       failure:(nullable YSReqFailureBlock)failure{
    //URL
    NSString *reqURL = command.url;
    if ([reqURL hasPrefix:kHTTPS_Prefix]) {
        self.manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    }
    
    //header 添加公共请求头，并签名
    NSMutableDictionary *reqHeader = [NSMutableDictionary dictionary];
    if ([self.requestDelegate respondsToSelector:@selector(getCommonHeader)]) {
        [reqHeader addEntriesFromDictionary:[self.requestDelegate getCommonHeader]];
    }
    [reqHeader addEntriesFromDictionary:command.header];
    if ([self.requestDelegate respondsToSelector:@selector(requestSignInfosWithHead:)]) {
        reqHeader = [self.requestDelegate requestSignInfosWithHead:reqHeader];
    }
    for (NSString *key in [reqHeader allKeys]) {
        [self.manager.requestSerializer setValue:[reqHeader valueForKey:key] forHTTPHeaderField:key];
    }
    
    //bodys 添加公共请求体，并签名
    NSMutableDictionary *reqBody = [NSMutableDictionary dictionary];
    if ([self.requestDelegate respondsToSelector:@selector(getCommonBody)]) {
        [reqBody addEntriesFromDictionary:[self.requestDelegate getCommonBody]];
    }
    [reqBody addEntriesFromDictionary:command.body];
    if ([self.requestDelegate respondsToSelector:@selector(requestSignInfosWithBody:)]) {
        reqBody = [self.requestDelegate requestSignInfosWithBody:reqBody];
    }
    
    //success
    id reqSuccess = ^(NSURLSessionDataTask *task, id responseObject){
        
        //代理校验业务数据
        if ([self.requestDelegate respondsToSelector:@selector(businessCheckWith:)]) {
            YSNetworkError *businessError = [self.requestDelegate businessCheckWith:responseObject];
            if (businessError) {
                if (failure) {
                    failure(businessError);
                }
                return ;
            }
        }
        
        if (!parser) {
            if (success) {
                success(responseObject);
            }
            return;
        }
        
        //parser 解析数据
        if ([parser parseResponse:responseObject]) {
            if (success) {
                success(parser.result);
            }
        }else{
            if (failure) {
                failure(parser.error);
            }
        }
    };
    
    id reqFailure = ^(NSURLSessionDataTask *tast, NSError *error){
        if (failure) {
            YSNetworkError *aError = [YSNetworkError errorWithErrorCode:kError_Servers_Error errorMsg:kError_Servers_Error_Msg sourceError:error];
            failure(aError);
        }
    };

    NSURLSessionDataTask *task = nil;
    switch (command.method) {
        case YSHTTPMethodGet:{

            task = [self.manager GET:reqURL parameters:reqBody progress:nil success:reqSuccess failure:reqFailure];
        
        }
            break;
        case YSHTTPMethodPost:{
            if (command.files.count > 0) {
                self.timeoutValue = MIN(kUploadFileTimeoutValut_MAX, MAX(kUploadFileTimeoutValue_MIN, kRemoteRequestTimeoutValue * command.files.count));
                
                task = [self.manager POST:reqURL parameters:reqBody constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    for (YSPostFileInfo *fileInfo in command.files) {
                        [formData appendPartWithFileData:fileInfo.fileData name:fileInfo.name fileName:fileInfo.fileName mimeType:fileInfo.mimeType];
                    }
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:reqSuccess failure:reqFailure];
                
            }else{
                
                task = [self.manager POST:reqURL parameters:reqBody progress:nil success:reqSuccess failure:reqFailure];
            }

        }
            break;
            
        default:
            break;
    }
    
    return task;
}

@end
