//
//  YSBaseCommand.h
//  YSNetwork
//
//  Created by yanghai on 2018/5/15.
//  Copyright © 2018年 fuzzball. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YSHTTPMethod) {
    YSHTTPMethodPost = 0,
    YSHTTPMethodGet = 1,
};

@class YSPostFileInfo;

@interface YSBaseCommand : NSObject

@property (nonatomic, assign) YSHTTPMethod method;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSArray<YSPostFileInfo *> *files;
@property (nonatomic, copy) NSDictionary *header;
@property (nonatomic, copy) NSDictionary *body;


///override
///返回请求头
- (NSDictionary *)header;

///override
///返回请求体
- (NSDictionary *)body;

@end

@interface YSPostFileInfo : NSObject

/*
 第一个:文件转换后data数据
 第二个:web上对应接口的图片name
 第三个:图片保存在web的名字
 第四个:文件的MIME类型
 */
@property (nonatomic, strong) NSData *fileData;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *mimeType;

@end

NS_ASSUME_NONNULL_END
