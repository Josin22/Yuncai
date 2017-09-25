//
//  YBLEditGoodPicViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/6/3.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEditGoodPicViewModel.h"
#import "YBLEditPicItemModel.h"
#import "YBLGoodModel.h"

@implementation YBLEditGoodPicViewModel

- (NSMutableArray *)picDataArray{
    
    if (!_picDataArray) {
        _picDataArray = [NSMutableArray array];
        NSArray *all_pic_array;
        NSString *infio;
        if (self.editPicType == EditPicTypeMain) {
            all_pic_array = self.editGoodModel.mains;
            infio = @"主图";
        } else {
            all_pic_array = self.editGoodModel.descs;
            infio = @"详情图";
        }
        for (NSInteger i = 0; i < all_pic_array.count; i++) {
            NSString *image_url = nil;
            if (i < all_pic_array.count) {
                image_url = all_pic_array[i];
            }
            YBLEditPicItemModel *itemModel = [YBLEditPicItemModel new];
            itemModel.good_Image_url = image_url;
            itemModel.good_info = [NSString stringWithFormat:@"%@",infio];
            itemModel.good_pure_url = image_url;
            [_picDataArray addObject:itemModel];
        }
    }
    return _picDataArray;
}



- (NSInteger)maxCount{
    if (_maxCount == 0) {
        NSInteger all_count = 0;
        if (self.editPicType == EditPicTypeMain) {
            all_count = 12;
        } else {
            all_count = 30;
        }
        _maxCount = all_count;
    }
    return _maxCount;
}

- (RACSignal *)siganlForUploadImage:(UIImage *)image index:(NSInteger)index{
    
    return [self siganlForUploadImage:image index:index isAppending:NO];
}

- (RACSignal *)siganlForUploadImage:(UIImage *)image index:(NSInteger)index isAppending:(BOOL)isAppending{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSData *thumbImageData = UIImageJPEGRepresentation(image, .8);
    YBLFileConfig *fileConfig = [YBLFileConfig
                                 fileConfigWithfileData:thumbImageData
                                 name:@"photo"
                                 fileName:@"photo"
                                 mimeType:@"image/png"];
    [SVProgressHUD showWithStatus:@"上传中..."];
    
    NSMutableDictionary *para = [self getBaseEditGoodParaWithIndex:index url_index:nil];
    
    [YBLRequstTools updateRequest:url_upload_photo(self.editGoodModel.id)
                           params:para
                  fileConfigArray:[@[fileConfig] mutableCopy]
                          success:^(id result,NSInteger statusCode) {
                              [SVProgressHUD showSuccessWithStatus:@"上传成功~"];
                              self.editGoodModel.descs = result[@"product"][@"descs"];
                              self.editGoodModel.mains = result[@"product"][@"mains"];
                              NSString *new_url = [self getUpdatePicURLWith:index];
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

- (NSString *)getUpdatePicURLWith:(NSInteger)index{
    NSString *new_url = nil;
    NSArray *all_pic_array;
    if (self.editPicType == EditPicTypeMain) {
        all_pic_array = self.editGoodModel.mains;
    } else {
        all_pic_array = self.editGoodModel.descs;
    }
    new_url = all_pic_array[index];
    return new_url;
}

- (YBLEditPicItemModel *)newPicItemModel{
    
    YBLEditPicItemModel *itemModel = [YBLEditPicItemModel new];
    NSString *infio;
    if (self.editPicType == EditPicTypeMain) {
        infio = @"主图";
    } else {
        infio = @"详情图";
    }
    itemModel.good_info = [NSString stringWithFormat:@"%@",infio];
    return itemModel;
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

- (BOOL)isMaxCount{
    NSInteger lessCount = self.maxCount-self.picDataArray.count;
    return lessCount==0?YES:NO;
}

- (RACSignal *)siganlForDeleteImageWithIndex:(NSInteger)index{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"删除中..."];
    
    NSMutableDictionary *para = [self getBaseEditGoodParaWithIndex:index url_index:nil];
    
    [YBLRequstTools HTTPDELETEWithUrl:url_delete_photo(self.editGoodModel.id)
                              Parames:para
                            commplete:^(id result, NSInteger statusCode) {
                                [SVProgressHUD showSuccessWithStatus:@"删除成功~"];
                                [self.picDataArray removeObjectAtIndex:index];
                                [subject sendCompleted];
                            }
                              failure:^(NSError *error, NSInteger errorCode) {
                                  [subject sendError:error];
                              }];
    
    return subject;
}

- (RACSignal *)siganlForSortImage{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"保存中..."];
    
    NSMutableDictionary *para = [self getBaseEditGoodParaWithIndex:0 url_index:@"url_index"];
    
    [YBLRequstTools HTTPPostWithUrl:url_sort_photo(self.editGoodModel.id)
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              [SVProgressHUD showSuccessWithStatus:@"保存成功~"];
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}

- (NSMutableDictionary *)getBaseEditGoodParaWithIndex:(NSInteger)index url_index:(NSString *)url_index{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    NSString *type;
    if (self.editPicType == EditPicTypeMain) {
        type = @"main";
    } else {
        type = @"desc";
    }
    para[@"type"] = type;
    if (url_index) {
        NSInteger index_para = 0;
        NSMutableArray *para_array = @[].mutableCopy;
        for (YBLEditPicItemModel *itemModel in self.picDataArray) {
            [para_array addObject:@{@"url":itemModel.good_pure_url,@"index":@(index_para)}];
            index_para++;
        }
        NSString *jsonString = [para_array yy_modelToJSONString];
        para[@"url_index"] = jsonString;
    } else {
        para[@"index"] = @(index);
    }
    return para;
}

@end
