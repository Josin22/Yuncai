//
//  YBLOrderMakeCommentsViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/6/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderMakeCommentsViewModel.h"
#import "YBLEditPicItemModel.h"

@implementation YBLOrderMakeCommentsViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ratingCount = 10.f;
        self.isNiMing = YES;
    }
    return self;
}

- (NSMutableArray *)picDataArray{
    if (!_picDataArray) {
        _picDataArray = [NSMutableArray array];
    }
    return _picDataArray;
}

- (RACSignal *)siganlForCreateCommentsWithContentText:(NSString *)contentText{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"提交中..."];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    NSDictionary *comment = @{@"line_item_id":self.commentsModel.line_item_id,
                              @"score":@((NSInteger)self.ratingCount),
                              @"content":contentText,
                              @"anonymity":@(self.isNiMing)};
    para[@"comment"] = [comment yy_modelToJSONString];
    NSMutableArray *urls = @[].mutableCopy;
    for (YBLEditPicItemModel *itemModel in self.picDataArray) {
        [urls addObject:itemModel.good_pure_url];
    }
    para[@"picture_urls"] = [urls yy_modelToJSONString];
    
    [YBLRequstTools HTTPPostWithUrl:url_orders_comments
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              [SVProgressHUD showSuccessWithStatus:@"提交成功~"];
                              [subject sendNext:result];
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    /*
    NSMutableArray *pics = @[].mutableCopy;
    for (YBLEditPicItemModel *itemModel in self.picDataArray) {
        UIImage *image = itemModel.good_Image_url;
        NSData *thumbImageData = UIImageJPEGRepresentation(image, .4);
        YBLFileConfig *fileConfig = [YBLFileConfig
                                     fileConfigWithfileData:thumbImageData
                                     name:@"pictures[]"
                                     fileName:@"pictures[]"
                                     mimeType:@"image/png"];
        [pics addObject:fileConfig];
    }
    
    [SVProgressHUD showWithStatus:@"提交中..."];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    NSDictionary *comment = @{@"line_item_id":self.commentsModel.line_item_id,
                              @"score":@((NSInteger)self.ratingCount),
                              @"content":contentText,
                              @"anonymity":@(self.isNiMing)};
    para[@"comment"] = [comment yy_modelToJSONString];
    
    [YBLRequstTools updateRequest:url_orders_comments
                           params:para
                  fileConfigArray:pics
                          success:^(id result,NSInteger statusCode) {
                              [SVProgressHUD showSuccessWithStatus:@"提交成功~"];
                              [subject sendNext:result];
                          }
                          failure:^(NSError *error,NSInteger errorCode) {
                              [subject sendError:error];
                          }];
    */
    return subject;
}

- (RACSignal *)siganlForUploadImage:(UIImage *)image index:(NSInteger)index{
    
    return [self siganlForUploadImage:image index:index isAppending:NO];
}


- (RACSignal *)siganlForMutilUploadImage:(NSArray *)imageArray{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    dispatch_queue_t queue = dispatch_queue_create("js.upload.com", DISPATCH_QUEUE_SERIAL);
    //设置信号总量为1，保证只有一个进程执行
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    __block NSInteger index = self.picDataArray.count;
    for (UIImage *selectImage in imageArray) {
        dispatch_async(queue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            [[self siganlForUploadImage:selectImage index:index isAppending:YES] subscribeNext:^(id  _Nullable x) {
                dispatch_semaphore_signal(semaphore);  //发送一个信号
                [subject sendNext:x];
            } error:^(NSError * _Nullable error) {
                dispatch_semaphore_signal(semaphore);  //发送一个信号
            }];
            index++;
        });
    }
    
    return subject;
}

- (RACSignal *)siganlForUploadImage:(UIImage *)image index:(NSInteger)index isAppending:(BOOL)isAppending{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSData *thumbImageData = UIImageJPEGRepresentation(image, .5);
    YBLFileConfig *fileConfig = [YBLFileConfig
                                 fileConfigWithfileData:thumbImageData
                                 name:@"picture"
                                 fileName:@"picture"
                                 mimeType:@"image/png"];
    
    [SVProgressHUD showWithStatus:@"上传中..."];
    
    [YBLRequstTools updateRequest:url_orders_comments_up_pic
                           params:nil
                  fileConfigArray:[@[fileConfig] mutableCopy]
                          success:^(id result,NSInteger statusCode) {
                              [SVProgressHUD showSuccessWithStatus:@"上传成功~"];
                              NSString *new_url = result[@"url"];
                              if (isAppending) {
                                  YBLEditPicItemModel *new_appdending = [self newPicItemModel];
                                  [self.picDataArray addObject:new_appdending];
                              }
                              YBLEditPicItemModel *selectModel = self.picDataArray[index];
                              selectModel.good_pure_url = new_url;
                              selectModel.good_Image_url = image;
                              [subject sendNext:result];
                              [subject sendCompleted];
                          }
                          failure:^(NSError *error,NSInteger errorCode) {
                              [subject sendError:error];
                          }];
    
    return subject;
}

- (YBLEditPicItemModel *)newPicItemModel{
    YBLEditPicItemModel *itemModel = [YBLEditPicItemModel new];
    return itemModel;
}


@end
