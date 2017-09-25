//
//  YBLJSONResponseSerializerWithData.m
//  YC168
//
//  Created by 乔同新 on 2017/5/1.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLJSONResponseSerializerWithData.h"

@implementation YBLJSONResponseSerializerWithData

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    id JSONObject = [super responseObjectForResponse:response data:data error:error]; // may mutate `error`
    
    if (*error != nil) {
        NSMutableDictionary *userInfo = [(*error).userInfo mutableCopy];
#ifdef DEBUG
        NSString *error_value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        int error_code = [[response valueForKey:Key_JsonStatusCode] intValue];
        NSString *all_value = [NSString stringWithFormat:@"error_code:%d \n%@",error_code,error_value];
        [userInfo setValue:all_value forKey:Key_JsonBody];
#else
        NSString *receiveStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSData * k_data = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:k_data options:NSJSONReadingMutableLeaves error:nil];
        NSString *string_error = jsonDict[@"error"];
        [userInfo setValue:string_error forKey:Key_JsonBody];
#endif

        [userInfo setValue:[response valueForKey:Key_JsonStatusCode] forKey:Key_JsonStatusCode];
        NSError *newError = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:userInfo];
        (*error) = newError;
    }
    
    return JSONObject;
}


@end
