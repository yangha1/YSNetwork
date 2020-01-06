//
//  YSBaseParser.h
//  YSNetwork
//
//  Created by yanghai on 2018/5/15.
//  Copyright © 2018年 fuzzball. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YSNetworkError;

@interface YSBaseParser : NSObject

@property (nonatomic, strong) id result;
@property (nonatomic, strong) YSNetworkError *error;

- (BOOL)parseResponse:(id)responseObject;

//override
//所有类实现，解析数据返回数据模型
- (id)parseResult:(id)result;

@end

NS_ASSUME_NONNULL_END
