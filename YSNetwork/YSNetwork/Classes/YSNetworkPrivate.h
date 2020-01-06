//
//  YSNetworkPrivate.h
//  YSNetwork
//
//  Created by yanghai on 2018/5/15.
//  Copyright © 2018年 fuzzball. All rights reserved.
//

#import <Foundation/Foundation.h>

#define     DEBUG_LOG       1
#if         DEBUG_LOG
#define     RequestDebugLog(fmt, ...) NSLog((@"%s Line: %zd\n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define     RequestDebugLog(fmt, ...'')
#endif

NS_ASSUME_NONNULL_BEGIN

@interface YSNetworkPrivate : NSObject

@end

NS_ASSUME_NONNULL_END
