//
//  YSBaseCommand.m
//  YSNetwork
//
//  Created by yanghai on 2018/5/15.
//  Copyright © 2018年 fuzzball. All rights reserved.
//

#import "YSBaseCommand.h"

@implementation YSBaseCommand

- (NSDictionary *)body{
    if (_body) {
        return _body;
    }
    return [NSDictionary dictionary];
}

- (NSDictionary *)header{
    if (_header) {
        return _header;
    }
    return [NSDictionary dictionary];
}

@end

@implementation YSPostFileInfo

@end
