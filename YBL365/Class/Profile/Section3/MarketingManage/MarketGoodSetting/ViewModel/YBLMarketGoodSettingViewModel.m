//
//  YBLMarketGoodSettingViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/6/9.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMarketGoodSettingViewModel.h"
#import "YBLEditPicItemModel.h"

@implementation YBLMarketGoodSettingViewModel

- (NSMutableArray *)picDataArray{
    if (!_picDataArray) {
        _picDataArray = [NSMutableArray array];
    }
    return _picDataArray;
}

- (void)setMarketGoodModel:(YBLWMarketGoodModel *)marketGoodModel{
    
    if (!_marketGoodModel.copywritings) {
        _marketGoodModel.copywritings = [NSMutableArray array];
    }
    [self.picDataArray removeAllObjects];
    
    for (NSString *url in marketGoodModel.mains) {
        YBLEditPicItemModel *itemModel = [YBLEditPicItemModel new];
        itemModel.good_Image_url = url;
        itemModel.good_info = [NSString stringWithFormat:@"%@",@"图片"];
        itemModel.good_pure_url = url;
        [self.picDataArray addObject:itemModel];
    }
    _marketGoodModel = marketGoodModel;
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
    
    NSData *thumbImageData = UIImageJPEGRepresentation(image, .8);
    YBLFileConfig *fileConfig = [YBLFileConfig
                                 fileConfigWithfileData:thumbImageData
                                 name:@"pic"
                                 fileName:@"pic"
                                 mimeType:@"image/png"];
    
    [SVProgressHUD showWithStatus:@"上传中..."];
    WEAK
    [YBLRequstTools updateRequest:url_small_marketing_uppic(self.marketGoodModel.id)
                           params:nil
                  fileConfigArray:[@[fileConfig] mutableCopy]
                          success:^(id result,NSInteger statusCode) {
                              STRONG
                              [SVProgressHUD showSuccessWithStatus:@"上传成功~"];
                              NSString *new_url = result[@"pic"];
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
    itemModel.good_info = @"图片";
    return itemModel;
}

- (RACSignal *)siganlForSetWMarket{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    [SVProgressHUD showWithStatus:@"保存中..."];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    NSMutableArray *purl_url = @[].mutableCopy;
    for (YBLEditPicItemModel *itemModel in self.picDataArray) {
        [purl_url addObject:itemModel.good_pure_url];
    }
    para[@"small_marketing"] = [@{@"mains":purl_url,@"copywritings":self.marketGoodModel.copywritings} yy_modelToJSONString];
    [YBLRequstTools HTTPPostWithUrl:url_small_marketing_set(self.marketGoodModel.id)
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              [SVProgressHUD showSuccessWithStatus:@"保存成功~"];
                              YBLWMarketGoodModel *changeModel = [YBLWMarketGoodModel yy_modelWithJSON:result];
                              [subject sendNext:changeModel];
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}

- (RACSignal *)siganlForSyncMarketText:(NSString *)text{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"同步中..."];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"copywriting"] = text;
    
    [YBLRequstTools HTTPPostWithUrl:url_small_marketing_sync
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              [SVProgressHUD showSuccessWithStatus:@"同步成功~"];
                              [subject sendNext:result];
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}

@end
