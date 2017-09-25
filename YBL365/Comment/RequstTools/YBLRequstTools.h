//
//  YBLRequstTools.h
//  YBL365
//
//  Created by 乔同新 on 2016/12/17.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLAPI.h"


@class YBLFileConfig;

@interface YBLRequstTools : NSObject

typedef void (^commpleteBlock)(id result,NSInteger statusCode);

typedef void (^failureBlock)(NSError *error,NSInteger errorCode);

/**
 *  GET 请求
 *
 *  @param url     url
 *  @param parames parames
 *  @param block   成功块
 *  @param fblock  失败块
 */
+ (void)HTTPGetDataWithUrl:(NSString *)url
                   Parames:(NSMutableDictionary *)parames
                 commplete:(commpleteBlock)block
                   failure:(failureBlock)fblock;

/**
 *  POST 请求
 *
 *  @param url     url
 *  @param parames parames
 *  @param block   成功块
 *  @param fblock  失败块
 */
+ (void)HTTPPostWithUrl:(NSString *)url
                Parames:(NSMutableDictionary *)parames
              commplete:(commpleteBlock)block
                failure:(failureBlock)fblock;

/**
 *  DELETE 请求
 *
 *  @param url     url
 *  @param parames parames description
 *  @param block   block description
 *  @param fblock  fblock description
 */
+ (void)HTTPDELETEWithUrl:(NSString *)url
                  Parames:(NSMutableDictionary *)parames
                commplete:(commpleteBlock)block
                  failure:(failureBlock)fblock;

/**
 *  PUT 请求
 *
 *  @param url     url
 *  @param parames parames description
 *  @param block   block description
 *  @param fblock  fblock description
 */
+ (void)HTTPPUTWithUrl:(NSString *)url
               Parames:(NSMutableDictionary *)parames
             commplete:(commpleteBlock)block
               failure:(failureBlock)fblock;

/**
 *  文件上传
 *
 *  @param url            url
 *  @param params         params
 *  @param fileConfigArray     上传的文件
 *  @param successHandler 成功块
 *  @param failureHandler 失败块
 */
+ (void)updateRequest:(NSString *)url
               params:(NSMutableDictionary *)params
      fileConfigArray:(NSMutableArray *)fileConfigArray
              success:(commpleteBlock)successHandler
              failure:(failureBlock)failureHandler;


+ (void)HTTPWithType:(RequestType)type
                 Url:(NSString *)url
                body:(NSData *)body
             Parames:(NSMutableDictionary *)parames
           commplete:(commpleteBlock)block
             failure:(failureBlock)fblock;

@end;

/**
 *  用来封装上文件数据的模型类
 */
@interface YBLFileConfig : NSObject
/**
 *  文件数据
 */
@property (nonatomic, strong) NSData *fileData;

/**
 *  服务器接收参数名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  文件名
 */
@property (nonatomic, copy) NSString *fileName;

/**
 *  文件类型
 */
@property (nonatomic, copy) NSString *mimeType;

+ (instancetype)fileConfigWithfileData:(NSData *)fileData
                                  name:(NSString *)name
                              fileName:(NSString *)fileName
                              mimeType:(NSString *)mimeType;

- (instancetype)initWithfileData:(NSData *)fileData
                            name:(NSString *)name
                        fileName:(NSString *)fileName
                        mimeType:(NSString *)mimeType;


@end
