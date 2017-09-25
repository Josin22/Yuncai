//
//  YBLStoreViewModel.m
//  YBL365
//
//  Created by 乔同新 on 2017/3/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreViewModel.h"
#import "YBLSingletonMethodTools.h"

@implementation YBLStoreViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleArray = @[@"全部商品",@"热销商品",@"上新商品"];
    }
    return self;
}

- (NSMutableDictionary *)goodCategoryDataDict{
    if (!_goodCategoryDataDict) {
        _goodCategoryDataDict = [NSMutableDictionary dictionary];
        for (int i = 0; i < self.titleArray.count; i++) {
            NSMutableArray *array = [NSMutableArray array];
            [_goodCategoryDataDict setObject:array forKey:@(i)];
        }
    }
    return _goodCategoryDataDict;
}

- (NSMutableArray *)nummberValueArray{
    
    if (!_nummberValueArray) {
        _nummberValueArray = [NSMutableArray arrayWithCapacity:3];
    }
    return _nummberValueArray;
}

+ (RACSignal *)signalForShopDataWithID:(NSString *)shopID isReload:(BOOL)isReload{
    
    return [[self alloc] signalForShopDataWithID:shopID category_id:nil isReload:isReload];
}

- (RACSignal *)signalForShopDataWithIsReload:(BOOL)isReload{
    
    return [self signalForShopDataWithID:self.shopid isReload:isReload];
}

- (RACSignal *)signalForShopDataWithID:(NSString *)shopID  isReload:(BOOL)isReload{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [[self signalForShopDataWithID:shopID category_id:nil isReload:isReload] subscribeNext:^(NSArray *x) {
        
        YBLShopModel *shopModel = x[0];
        NSMutableArray *indexps = x[1];
        self.shopinfo = shopModel.shopinfo;
        
        NSMutableArray *allGoodArray = self.goodCategoryDataDict[@(0)];
        NSMutableArray *rexiaoGoodArray = self.goodCategoryDataDict[@(1)];
        NSMutableArray *shangxinGoodArray = self.goodCategoryDataDict[@(2)];
        if (!self.isNoMoreData) {
            //热销商品
            NSArray *rexiaoArray = [allGoodArray sortedArrayUsingComparator:sale_count_Sort];
            rexiaoGoodArray = rexiaoArray.mutableCopy;
            [self.goodCategoryDataDict setObject:rexiaoGoodArray forKey:@(1)];
            //上新商品
            NSArray *sortArray = [allGoodArray sortedArrayUsingComparator:time_Sort];
            shangxinGoodArray = sortArray.mutableCopy;
            [self.goodCategoryDataDict setObject:shangxinGoodArray forKey:@(2)];
//            for (YBLGoodModel *model in sortArray) {
//                NSString *timeLimte = [YBLMethodTools dateTimeDifferenceWithEndTime:model.created_at];
//                if (timeLimte.intValue<=90) {
//                    [shangxinGoodArray addObject:model];
//                }
//            }
            if (self.nummberValueArray.count>0) {
                [self.nummberValueArray removeAllObjects];
            }
            self.nummberValueArray = @[self.shopinfo.pdcount,self.shopinfo.pdcount,self.shopinfo.pdcount].mutableCopy;
        }
        [subject sendNext:indexps];
        [subject sendCompleted];
     
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    
    return subject;
}

- (RACSignal *)signalForShopDataWithID:(NSString *)shopID
                           category_id:(NSString *)category_id
                              isReload:(BOOL)isReload{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (category_id) {
        para[@"category_id"] = category_id;
    }
    NSString *new_url = [YBLMethodTools updateURL:url_shops(shopID) versionWithSiganlNumber:2];
    [[self siganlForSingleListViewRequestLoadMoreWithPara:para
                                                     url:new_url
                                                isReload:isReload] subscribeNext:^(id  _Nullable result) {
        YBLShopModel *shopModel = [YBLShopModel yy_modelWithJSON:result];
        if (isReload) {
            for (int i = 0; i < self.goodCategoryDataDict.count; i++) {
                NSMutableArray *countArray = self.goodCategoryDataDict[@(i)];
                [countArray removeAllObjects];
            }
        }
        NSArray *dataArray = shopModel.products.copy;
        NSMutableArray *allGoodArray = self.goodCategoryDataDict[@(0)];
        NSInteger currentCount = allGoodArray.count;
        NSInteger appendCount = dataArray.count;
        NSMutableArray *indexps = [YBLMethodTools getRowAppendingIndexPathsWithIndex:currentCount appendingCount:appendCount inSection:0];
        if (dataArray.count==0) {
            self.isNoMoreData = YES;
        } else {
            self.isNoMoreData = NO;
            //全部商品
            [allGoodArray addObjectsFromArray:dataArray];
            
            //            for (YBLGoodModel *model in sortArray) {
            //                NSString *timeLimte = [YBLMethodTools dateTimeDifferenceWithEndTime:model.created_at];
            //                if (timeLimte.intValue<=90) {
            //                    [shangxinGoodArray addObject:model];
            //                }
            //            }
        }
        [subject sendNext:@[shopModel,indexps]];
        [subject sendCompleted];
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    
    /*
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    page_index++;
    para[@"page"] = @(page_index);
    para[@"per_page"] = @(page_size);
    
    [YBLRequstTools HTTPGetDataWithUrl:url_shops(shopID)
                               Parames:para
                             commplete:^(id result,NSInteger statusCode) {
                                 YBLShopModel *shopModel = [YBLShopModel yy_modelWithJSON:result];
                                 [subject sendNext:shopModel];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error,NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    */
    
    return subject;
}

NSComparator sale_count_Sort = ^(YBLGoodModel *model1,YBLGoodModel *model2){
    ///销量最大
    if (model1.sale_order_count.integerValue > model2.sale_order_count.integerValue) {
        return (NSComparisonResult)NSOrderedAscending;
    }else if (model1.sale_order_count.integerValue < model2.sale_order_count.integerValue){
        return (NSComparisonResult)NSOrderedDescending;
    }
    else
        return (NSComparisonResult)NSOrderedSame;
};

NSComparator time_Sort = ^(YBLGoodModel *model1,YBLGoodModel *model2){
    ///最新时间
    NSDateFormatter *dateFormatter = [YBLSingletonMethodTools shareMethodTools].cachedDateFormatter;
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date1 = [dateFormatter dateFromString:model1.created_at];
    NSDate *date2 = [dateFormatter dateFromString:model2.created_at];
    
    if (date1 > date2) {
        return (NSComparisonResult)NSOrderedAscending;
    }else if (date1 < date2){
        return (NSComparisonResult)NSOrderedDescending;
    }
    else
        return (NSComparisonResult)NSOrderedSame;
};

- (RACSignal *)signalForGetShopFixtrue{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"userinfo_id"] = [YBLUserManageCenter shareInstance].userModel.userinfo_id;
    
    [YBLRequstTools HTTPGetDataWithUrl:url_shopfixtrue
                               Parames:para
                             commplete:^(id result, NSInteger statusCode) {
                                 
                                 NSArray *dataArray = [NSArray yy_modelArrayWithClass:[YBLShopFixtrueModel class] json:result];
                                 [subject sendNext:dataArray];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return  subject;
}


- (RACSignal *)signalForUploadShopBannerWithImage:(UIImage *)image{
    
    return [self siganlForUploadShopImage:image type:@"banner"];
}

- (RACSignal *)signalForUploadShopLogoWithImage:(UIImage *)image{
    
    return [self siganlForUploadShopImage:image type:@"logo"];
}

- (RACSignal *)siganlForUploadShopImage:(UIImage *)image type:(NSString *)type{

    RACReplaySubject *subject = [RACReplaySubject subject];

    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"model"] = type;
    
    NSData *thumbImageData = UIImageJPEGRepresentation(image, .8);
    YBLFileConfig *fileConfig = [YBLFileConfig
                                 fileConfigWithfileData:thumbImageData
                                 name:@"picture"
                                 fileName:@"picture"
                                 mimeType:@"image/png"];
    [SVProgressHUD showWithStatus:@"上传中..."];
    [YBLRequstTools updateRequest:url_shopfixtrue
                           params:para
                  fileConfigArray:[@[fileConfig] mutableCopy]
                          success:^(id result,NSInteger statusCode) {
                              [SVProgressHUD showSuccessWithStatus:@"上传成功~"];

                              [subject sendCompleted];
                          }
                          failure:^(NSError *error,NSInteger errorCode) {
                              [subject sendError:error];
                          }];
    
    return  subject;
}

+ (RACSignal *)signalForStore:(NSString *)storeID isFollow:(BOOL)isFollow{
    
    return [[self alloc] signalForStore:storeID isFollow:isFollow];
}

- (RACSignal *)signalForStoreFollow:(BOOL)isFollow{
    return [self signalForStore:self.shopid isFollow:isFollow];
}
- (RACSignal *)signalForStore:(NSString *)storeID isFollow:(BOOL)isFollow{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSString *new_url= nil;
    NSString *fousString = nil;
    if (!isFollow) {
        //取消关注
        fousString = @"取消";
        new_url = url_store_unfollow(storeID);
    } else {
        //关注
        fousString = @"关注";
        new_url = url_store_follow(storeID);
    }
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"%@中...",fousString]];
    [YBLRequstTools HTTPPostWithUrl:new_url
                            Parames:nil
                          commplete:^(id result, NSInteger statusCode) {
                              NSString *res = result[@"result"];
//                              BOOL state = [result[@"state"] boolValue];
//                              NSInteger money = [result[@"money"] integerValue];
                              if ([res isEqualToString:@"SUCCESS"]) {
                                  [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@成功~",fousString]];
                              } else {
                                  
                              }
                              [subject sendNext:result];
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
    
}

- (BOOL)isHasBriberyMoney{
    float lessMoney = self.shopinfo.wallet_follow_quota.doubleValue-self.shopinfo.follow_shop_money.doubleValue;
    return (lessMoney>=0)&&!self.shopinfo.followed.boolValue&&self.shopinfo;
}

@end
