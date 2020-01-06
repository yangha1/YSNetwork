//
//  YSBaseParser.m
//  YSNetwork
//
//  Created by yanghai on 2018/5/15.
//  Copyright © 2018年 fuzzball. All rights reserved.
//

#import "YSBaseParser.h"
#import "YSNetworkError.h"

@implementation YSBaseParser

- (BOOL)parseResponse:(id)responseObject{
    @try {
        self.result = [self parseResult:responseObject];
    } @catch (NSException *exception) {
        self.error = [YSNetworkError errorWithErrorCode:kError_Parser_Error errorMsg:kError_Parser_Error_Msg sourceError:nil];
    } @finally {
        
    }
    return !self.error;
}

- (id)parseResult:(id)result{
    return result;
}

@end
