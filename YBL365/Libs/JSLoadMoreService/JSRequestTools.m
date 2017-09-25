//
//  JSRequestTools.m
//  JSLoadMoreServiceDemo
//
//  Created by 乔同新 on 2017/8/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//  Github: https://github.com/Josin22/JSLoadMoreService

#import "JSRequestTools.h"
#import "JSLoadMoreHeader.h"
#import "YBLJSONResponseSerializerWithData.h"

@implementation JSRequestTools

+ (RACSignal *)js_postURL:(NSString *)url para:(NSMutableDictionary *)para{
    
    return [self js_baseRequestWithType:RequestTypePOST URL:url para:para];
}

+ (RACSignal *)js_getURL:(NSString *)url para:(NSMutableDictionary *)para{
    
    return [self js_baseRequestWithType:RequestTypeGET URL:url para:para];
}

+ (RACSignal *)js_deleteURL:(NSString *)url para:(NSMutableDictionary *)para{
    
    return [self js_baseRequestWithType:RequestTypeDELETE URL:url para:para];
}

+ (RACSignal *)js_putURL:(NSString *)url para:(NSMutableDictionary *)para{
    
    return [self js_baseRequestWithType:RequestTypePUT URL:url para:para];
}

+ (RACSignal *)js_uploadURL:(NSString *)url para:(NSMutableDictionary *)para files:(NSMutableArray <JSFileConfig *>*)files{
    return [self js_baseRequestWithType:RequestTypePOSTUPLOAD URL:url para:para files:files];
}

+ (RACSignal *)js_baseRequestWithType:(RequestType)type URL:(NSString *)url para:(NSMutableDictionary *)para{
    return [self js_baseRequestWithType:type URL:url para:para files:nil];
}

+ (RACSignal *)js_baseRequestWithType:(RequestType)type URL:(NSString *)url para:(NSMutableDictionary *)para files:(NSMutableArray <JSFileConfig *>*)files{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    NSLog(@"para:%@",para);
    BOOL vaild = [self checkRequestVaildWith:url];
    if (!vaild) {
        return subject;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30.f;
    YBLJSONResponseSerializerWithData *response = [YBLJSONResponseSerializerWithData serializer];
    response.removesKeysWithNullValues = YES;
    manager.responseSerializer = response;
    
    NSString *koen = [YBLUserManageCenter shareInstance].userModel.authentication_token;
    [manager.requestSerializer setValue:koen forHTTPHeaderField:@"Authentication-Token"];
    [manager.requestSerializer setValue:XKey forHTTPHeaderField:@"X-Warehouse-Rest-Api-Key"];
    switch (type) {
        case RequestTypeGET:
        {
            [manager GET:url
             parameters:para
               progress:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"responseObject:%@",responseObject);
                    [subject sendNext:responseObject];
                    [subject sendCompleted];
                }
                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self handleError:error];
                    [subject sendError:error];
                }];
            
        }
            break;
        case RequestTypePOST:
        {
            [manager POST:url
              parameters:para
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
                     //                     NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
                     NSLog(@"responseObject:%@",responseObject);
                     [subject sendNext:responseObject];
                     [subject sendCompleted];
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
                     [self handleError:error];
                     [subject sendError:error];
                 }];
            
        }
            break;
            
        case RequestTypePUT:
        {
            [manager PUT:url
              parameters:para
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
                     //                     NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
                     NSLog(@"responseObject:%@",responseObject);
                     [subject sendNext:responseObject];
                     [subject sendCompleted];
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
                     [self handleError:error];
                     [subject sendError:error];
                 }];
            
        }
            break;
            
        case RequestTypeDELETE:
        {
            [manager DELETE:url
              parameters:para
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
                     //                     NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
                     NSLog(@"responseObject:%@",responseObject);
                     [subject sendNext:responseObject];
                     [subject sendCompleted];
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
                     [self handleError:error];
                     [subject sendError:error];
                 }];
            
        }
            break;
        case RequestTypePOSTUPLOAD:
        {
                [manager POST:url
                  parameters:para
   constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    
       for (JSFileConfig *file in files) {
           [formData appendPartWithFileData:file.fileData name:file.name fileName:file.fileName mimeType:file.mimeType];
       }
   }
                    progress:^(NSProgress * _Nonnull uploadProgress) {
                        [subject sendNext:uploadProgress];
                    }
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSLog(@"responseObject:%@",responseObject);
                         [subject sendCompleted];
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         [self handleError:error];
                         [subject sendError:error];
                     }];
            
        }
            break;
            
    }
    return subject;
}

+ (void)handleError:(NSError *)error{
    
    NSLog(@"errorInfo:%@",error);
    [YBLLogLoadingView dismissInWindow];
    
    NSString *error_info = [error userInfo][Key_JsonBody];
    
    NSInteger error_code = [[error userInfo][Key_JsonStatusCode] integerValue];
    if (error_code==200||error_code==201) {
        return;
    }
    if (error_info) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error_info]];
    } else {
        [SVProgressHUD showErrorWithStatus:RequsestErrorTitle];
    }
}


+ (BOOL)checkRequestVaildWith:(NSString *)url{
    if (!url) {
        [SVProgressHUD showErrorWithStatus:@"URL不存在!"];
        [YBLLogLoadingView dismissInWindow];
        [SVProgressHUD dismiss];
        return NO;
    }
    NSString *kongString = @" ";
    if ([url rangeOfString:kongString].location!=NSNotFound) {
        [url stringByReplacingOccurrencesOfString:kongString withString:@""];
    }
    if ([YBLUserManageCenter shareInstance].isNoActiveNetStatus) {
        [YBLLogLoadingView dismissInWindow];
        [SVProgressHUD dismiss];
        return NO;
    }
    return YES;
}


@end


/**
 *  用来封装上传参数
 */
@implementation JSFileConfig

+ (instancetype)fileConfigWithfileData:(NSData *)fileData
                                  name:(NSString *)name
                              fileName:(NSString *)fileName
                              mimeType:(NSString *)mimeType {
    
    return [[self alloc] initWithfileData:fileData
                                     name:name
                                 fileName:fileName
                                 mimeType:mimeType];
}

- (instancetype)initWithfileData:(NSData *)fileData
                            name:(NSString *)name
                        fileName:(NSString *)fileName
                        mimeType:(NSString *)mimeType {
    
    if (self = [super init]) {
        
        _fileData = fileData;
        _name = name;
        _fileName = fileName;
        _mimeType = mimeType;
    }
    return self;
}

@end
