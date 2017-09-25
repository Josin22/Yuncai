//
//  YBLRequstTools.m
//  YBL365
//
//  Created by 乔同新 on 2016/12/17.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLRequstTools.h"
#import "YBLJSONResponseSerializerWithData.h"
#import "YBLAPI.h"

static const NSTimeInterval timeout = 30.0f;

@implementation YBLRequstTools

+ (void)HTTPPUTWithUrl:(NSString *)url
               Parames:(NSMutableDictionary *)parames
             commplete:(commpleteBlock)block
               failure:(failureBlock)fblock {
    [self requestWithType:RequestTypePUT
                      Url:url
                  Parames:parames
                commplete:^(id result,NSInteger statusCode) {
                    block(result,statusCode);
                } failure:^(NSError *error,NSInteger errorCode) {
                    fblock(error,errorCode);
                }];
}

+ (void)HTTPDELETEWithUrl:(NSString *)url
                  Parames:(NSMutableDictionary *)parames
                commplete:(commpleteBlock)block
                  failure:(failureBlock)fblock{
    
    [self requestWithType:RequestTypeDELETE
                      Url:url
                  Parames:parames
                commplete:^(id result,NSInteger statusCode) {
                    block(result,statusCode);
                } failure:^(NSError *error,NSInteger errorCode) {
                    fblock(error,errorCode);
                }];
}

+ (void)HTTPPostWithUrl:(NSString *)url
                Parames:(NSMutableDictionary *)parames
              commplete:(commpleteBlock)block
                failure:(failureBlock)fblock{
    
    [self requestWithType:RequestTypePOST
                      Url:url
                  Parames:parames
                commplete:^(id result,NSInteger statusCode) {
                    block(result,statusCode);
                } failure:^(NSError *error,NSInteger errorCode) {
                    fblock(error,errorCode);
                }];
}

+ (void)HTTPGetDataWithUrl:(NSString *)url
                   Parames:(NSMutableDictionary *)parames
                 commplete:(commpleteBlock)block
                   failure:(failureBlock)fblock{
    
    [self requestWithType:RequestTypeGET
                      Url:url
                  Parames:parames
                commplete:^(id result,NSInteger statusCode) {
                    block(result,statusCode);
                } failure:^(NSError *error,NSInteger errorCode) {
                    fblock(error,errorCode);
                }];
    
}

+ (void)HTTPWithType:(RequestType)type
                 Url:(NSString *)url
                body:(NSData *)body
             Parames:(NSMutableDictionary *)parames
           commplete:(commpleteBlock)block
             failure:(failureBlock)fblock{
    
    BOOL vaild = [self checkRequestVaildWith:url];
    if (!vaild) {
        return;
    }
    NSString *requestString = nil;
    switch (type) {
        case RequestTypeGET:
        {
            requestString = @"GET";
        }
            break;
        case RequestTypePOST:
        {
            requestString = @"POST";
        }
            break;
        case RequestTypePUT:
        {
            requestString = @"PUT";
        }
            break;
            
        default:
            break;
    }
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:requestString URLString:url parameters:nil error:nil];
    NSString *koen = [YBLUserManageCenter shareInstance].userModel.authentication_token;
    [request setValue:koen forHTTPHeaderField:@"Authentication-Token"];
    [request setValue:XKey forHTTPHeaderField:@"X-Warehouse-Rest-Api-Key"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.timeoutInterval = timeout;
    // 设置body
    [request setHTTPBody:body];
    YBLJSONResponseSerializerWithData *response = [YBLJSONResponseSerializerWithData serializer];
    response.removesKeysWithNullValues = YES;
    manager.responseSerializer = response;
    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)response;
            [self resetSuccess:responseObject code:responses.statusCode successHandler:block];
        } else {
            [self resetError:error failureBlock:fblock];
        }
    }] resume];
    /*
    NSMutableURLRequest*request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *requestString = nil;
    switch (type) {
        case RequestTypeGET:
        {
            requestString = @"GET";
        }
            break;
        case RequestTypePOST:
        {
            requestString = @"POST";
        }
            break;
        case RequestTypePUT:
        {
            requestString = @"PUT";
        }
            break;
            
        default:
            break;
    }
    NSLog(@"url:%@------\n parames:%@--------\n",url,parames);
    [request setHTTPMethod:requestString];
    [request setHTTPBody:body];
    NSString *koen = [YBLUserManageCenter shareInstance].userModel.authentication_token;
    [request setValue:koen forHTTPHeaderField:@"Authentication-Token"];
    request.timeoutInterval = timeout;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLSession*session = [NSURLSession sharedSession];
    NSURLSessionDataTask*task = [session dataTaskWithRequest:request completionHandler:^(NSData*_Nullable data,NSURLResponse*_Nullable response,NSError*_Nullable error) {
        
//        if (data == nil) {
//
//            [SVProgressHUD showErrorWithStatus:RequsestNullErrorTitle];
//            
//        } else {
//
//        }
        NSDictionary*responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)response;
        if (responses.statusCode == 200||responses.statusCode==201||responses.statusCode==204) {
            [self resetSuccess:responseObject code:responses.statusCode successHandler:block];
        }else {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            if (errorData) {
                NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
                NSString *errorInfo = serializedData[@"error"];
                [SVProgressHUD showErrorWithStatus:errorInfo];
            } else {
                [SVProgressHUD showErrorWithStatus:RequsestErrorTitle];
            }
        }

    }];
    [task resume];
    */
}

+ (void)requestWithType:(RequestType)type
                    Url:(NSString *)url
                Parames:(NSMutableDictionary *)parames
              commplete:(commpleteBlock)block
                failure:(failureBlock)fblock{
    BOOL vaild = [self checkRequestVaildWith:url];
    if (!vaild) {
        return;
    }
    NSLog(@"url:%@------\n parames:%@--------\n ",url,parames);
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    manage.requestSerializer.timeoutInterval = timeout;
    YBLJSONResponseSerializerWithData *response = [YBLJSONResponseSerializerWithData serializer];
    response.removesKeysWithNullValues = YES;
    manage.responseSerializer = response;
    NSString *koen = [YBLUserManageCenter shareInstance].userModel.authentication_token;
    [manage.requestSerializer setValue:koen forHTTPHeaderField:@"Authentication-Token"];
    [manage.requestSerializer setValue:XKey forHTTPHeaderField:@"X-Warehouse-Rest-Api-Key"];
    switch (type) {
        case RequestTypeGET:
        {
            [manage GET:url
          parameters:parames
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
                 [self resetSuccess:responseObject code:responses.statusCode successHandler:block];
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                 [self resetError:error failureBlock:fblock];
             }];
            
        }
            break;
        case RequestTypePOST:
        {
            [manage POST:url
           parameters:parames
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
                  NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
                  
                  [self resetSuccess:responseObject code:responses.statusCode successHandler:block];
                  
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
             
                  [self resetError:error failureBlock:fblock];
              }];
            
        }
            break;
        case RequestTypeDELETE:
        {
            [manage DELETE:url
             parameters:parames
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
                    
                    [self resetSuccess:responseObject code:responses.statusCode successHandler:block];
                    
                }
                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   
                    [self resetError:error failureBlock:fblock];
                    
                }];
        }
            break;
        case RequestTypePUT:
        {
            [manage PUT:url
          parameters:parames
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
                 
                 [self resetSuccess:responseObject code:responses.statusCode successHandler:block];
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self resetError:error failureBlock:fblock];
                 
             }];
        }
            break;
            
        default:
            break;
    }
    
}


+ (void)updateRequest:(NSString *)url
               params:(NSDictionary *)params
      fileConfigArray:(NSMutableArray *)fileConfigArray
              success:(commpleteBlock)successHandler
              failure:(failureBlock)failureHandler{
    BOOL vaild = [self checkRequestVaildWith:url];
    if (!vaild) {
        return;
    }
    NSLog(@"url:%@------\n parames:%@--------\n ",url,params);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = timeout;
    YBLJSONResponseSerializerWithData *response = [YBLJSONResponseSerializerWithData serializer];
    response.removesKeysWithNullValues = YES;
    manager.responseSerializer = response;
    
    NSString *koen = [YBLUserManageCenter shareInstance].userModel.authentication_token;
    [manager.requestSerializer setValue:koen forHTTPHeaderField:@"Authentication-Token"];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (fileConfigArray.count != 0) {
            for (YBLFileConfig *file in fileConfigArray) {
                [formData appendPartWithFileData:file.fileData name:file.name fileName:file.fileName mimeType:file.mimeType];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        [self resetSuccess:responseObject code:responses.statusCode successHandler:successHandler];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [self resetError:error failureBlock:failureHandler];
        
    }];
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


+ (void)resetSuccess:(id)resp code:(NSInteger)code successHandler:(commpleteBlock)successHandler{
    
    NSLog(@"responseObject:%@",resp);
    if (code == 200||code==201||code==204) {
        successHandler(resp,code);
    } else {
        [SVProgressHUD showErrorWithStatus:RequsestErrorCodeTitle];
    }
}

+ (void)resetError:(NSError *)error failureBlock:(failureBlock)failureBlock{
    
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
    failureBlock(error,error_code);
}


@end


/**
 *  用来封装上传参数
 */
@implementation YBLFileConfig

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
