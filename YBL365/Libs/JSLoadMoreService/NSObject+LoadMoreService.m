//
//  NSObject+LoadMoreService.m
//  JSLoadMoreServiceDemo
//
//  Created by 乔同新 on 2017/8/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//  Github: https://github.com/Josin22/JSLoadMoreService

#import <objc/runtime.h>
#import "NSObject+LoadMoreService.h"
#import "JSLoadMoreHeader.h"

@implementation JSTitleItemModel


@end

static char const *key_isNoMoreData = "key_isNoMoreData";

static char const *key_isRequesting = "key_isRequesting";

static char const *key_currentPage = "key_currentPage";

static char const *key_dataArray = "key_dataArray";

static char const *key_appendingIndexpaths = "key_appendingIndexpaths";

static char const *key_orginResponseObject = "key_orginResponseObject";

static char const *key_multiDataDict = "key_multiDataDict";

static char const *key_multiCurrentPageDict = "key_multiCurrentPageDict";

static char const *key_multiTitleDataArray = "key_multiTitleDataArray";

static char const *key_currentIndex = "key_currentIndex";

static char const *key_multiNoMoreDataDict = "key_multiNoMoreDataDict";


@implementation NSObject (LoadMoreService)

#pragma mark - associated single list view

- (BOOL)isNoMoreData{
    return [objc_getAssociatedObject(self, &key_isNoMoreData) boolValue];
}

- (void)setIsNoMoreData:(BOOL)isNoMoreData{
    objc_setAssociatedObject(self, &key_isNoMoreData, @(isNoMoreData), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isRequesting{
    return [objc_getAssociatedObject(self, &key_isRequesting) boolValue];
}

- (void)setIsRequesting:(BOOL)isRequesting{
    objc_setAssociatedObject(self, &key_isRequesting, @(isRequesting), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)currentPage{
    return [objc_getAssociatedObject(self, &key_currentPage) integerValue];
}

- (void)setCurrentPage:(NSInteger)currentPage{
    objc_setAssociatedObject(self, &key_currentPage, @(currentPage), OBJC_ASSOCIATION_ASSIGN);
}

- (NSMutableArray *)dataArray{
    return objc_getAssociatedObject(self, &key_dataArray);
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    objc_setAssociatedObject(self, &key_dataArray, dataArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)appendingIndexpaths{
    return objc_getAssociatedObject(self, &key_appendingIndexpaths);
}

- (void)setAppendingIndexpaths:(NSMutableArray *)appendingIndexpaths{
    objc_setAssociatedObject(self, &key_appendingIndexpaths, appendingIndexpaths, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)orginResponseObject{
    return objc_getAssociatedObject(self, &key_orginResponseObject);
}

- (void)setOrginResponseObject:(id)orginResponseObject{
    objc_setAssociatedObject(self, &key_orginResponseObject, orginResponseObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - associated multi list view

- (void)setMultiDataDict:(NSMutableDictionary *)multiDataDict{
    objc_setAssociatedObject(self, &key_multiDataDict, multiDataDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)multiDataDict{
    return objc_getAssociatedObject(self, &key_multiDataDict);
}

- (void)setMultiNoMoreDataDict:(NSMutableDictionary *)multiNoMoreDataDict{
    objc_setAssociatedObject(self, &key_multiNoMoreDataDict, multiNoMoreDataDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)multiNoMoreDataDict{
    return objc_getAssociatedObject(self, &key_multiNoMoreDataDict);
}

- (void)setMultiCurrentPageDict:(NSMutableDictionary *)multiCurrentPageDict{
    objc_setAssociatedObject(self, &key_multiCurrentPageDict, multiCurrentPageDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)multiCurrentPageDict{
    return objc_getAssociatedObject(self, &key_multiCurrentPageDict);
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    objc_setAssociatedObject(self, &key_currentIndex, @(currentIndex), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)currentIndex{
    return [objc_getAssociatedObject(self, &key_currentIndex) integerValue];
}

- (void)setMultiTitleDataArray:(NSMutableArray<JSTitleItemModel *> *)multiTitleDataArray{
    objc_setAssociatedObject(self, &key_multiTitleDataArray, multiTitleDataArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)multiTitleDataArray{
    return objc_getAssociatedObject(self, &key_multiTitleDataArray);
}

#pragma mark - method

- (RACSignal *)js_singalForSingleRequestWithURL:(NSString *)baseURL
                                           para:(NSMutableDictionary *)para
                                     keyOfArray:(NSString *)keyOfArray
                          classNameOfModelArray:(NSString *)classNameOfModelArray
                                       isReload:(BOOL)isReload{

    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [[self js_baseSingleRequestWithURL:baseURL
                                 para:para
                             isReload:isReload] subscribeNext:^(id  _Nullable x) {
        
        NSAssert(classNameOfModelArray, @"请建个对应的model,为了能创建数组模型!");
        
        self.orginResponseObject = x;
        
        if (!self.dataArray) {
            self.dataArray = @[].mutableCopy;
        }
        
        if (isReload) {
            [self.dataArray removeAllObjects];
        }
        
        NSArray *separateKeyArray = [keyOfArray componentsSeparatedByString:@"/"];
        for (NSString *sepret_key in separateKeyArray) {
            x = x[sepret_key];
        }
        
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:NSClassFromString(classNameOfModelArray) json:x];
        NSInteger from_index = self.dataArray.count;
        NSInteger data_count = dataArray.count;
        self.appendingIndexpaths = [self getAppendingIndexpathsFromIndex:from_index
                                                          appendingCount:data_count
                                                               inSection:0
                                                                isForRow:YES];
        [subject sendNext:dataArray];
        
        if (dataArray.count==0) {
            self.isNoMoreData = YES;
        } else {
            self.isNoMoreData = NO;
            [self.dataArray addObjectsFromArray:dataArray];
        }
        [subject sendCompleted];
        
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    
    return subject;
}

- (RACSignal *)js_baseSingleRequestWithURL:(NSString *)baseURL
                               para:(NSMutableDictionary *)para
                           isReload:(BOOL)isReload{
    
    RACReplaySubject *subject = [RACReplaySubject subject];

    if (![self isSatisfyLoadMoreRequest]&&!isReload) {
        return subject;
    }
    if (!para) {
        para = [NSMutableDictionary dictionary];
    }
    if (isReload) {
        self.currentPage = 0;
#warning 此处可以添加统一的HUD
        //...
        [YBLLogLoadingView showInWindow];
    }
    self.currentPage++;
#warning 分页的key按需修改
    para[@"page"] = @(self.currentPage);
    para[@"per_page"] = @(PerPageMaxCount);
    
    self.isRequesting = YES;
    
    [[JSRequestTools js_getURL:baseURL para:para] subscribeNext:^(id  _Nullable x) {
        self.isRequesting = NO;
        if (isReload) {
#warning 消失HUD
            //...
            [YBLLogLoadingView dismissInWindow];
        }
        [subject sendNext:x];
        [subject sendCompleted];
    } error:^(NSError * _Nullable error) {
        self.isRequesting = NO;
        if (self.currentPage>0) {
            self.currentPage--;
        }
        [subject sendError:error];
    }];
    
    return subject;
}

- (BOOL)isSatisfyLoadMoreRequest{
    return (!self.isNoMoreData&&!self.isRequesting);
}

- (NSMutableArray *)getAppendingIndexpathsFromIndex:(NSInteger)from_index
                                     appendingCount:(NSInteger)appendingCount
                                          inSection:(NSInteger)inSection
                                           isForRow:(BOOL)isForRow{
    NSMutableArray *indexps = [NSMutableArray array];
    for (NSInteger i = 0; i < appendingCount; i++) {
        if (isForRow) {
            NSIndexPath *indexp = [NSIndexPath indexPathForRow:from_index+i inSection:inSection];
            [indexps addObject:indexp];
        } else {
            NSIndexPath *indexp = [NSIndexPath indexPathForRow:0 inSection:from_index+i];
            [indexps addObject:indexp];
        }
    }
    return indexps;
}

- (RACSignal *)js_singalForMultiRequestWithURL:(NSString *)baseURL
                                          para:(NSMutableDictionary *)para
                                    keyOfArray:(NSString *)keyOfArray
                         classNameOfModelArray:(NSString *)classNameOfModelArray
                                      isReload:(BOOL)isReload{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    JSTitleItemModel *currentTitleModel = self.multiTitleDataArray[self.currentIndex];
    NSString *index = currentTitleModel.id;
    
    [[self js_singalForMultiBaseRequestPara:para
                                       url:baseURL
                                      index:index
                                  isReload:isReload] subscribeNext:^(id  _Nullable x) {
        NSAssert(classNameOfModelArray, @"请建个对应的model,为了能创建数组模型!");
        
        NSArray *separateKeyArray = [keyOfArray componentsSeparatedByString:@"/"];
        for (NSString *sepret_key in separateKeyArray) {
            x = x[sepret_key];
        }
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:NSClassFromString(classNameOfModelArray) json:x];
        
        [subject sendNext:dataArray];
        
        NSMutableArray *currentDataArray = self.multiDataDict[index];
        if (!currentDataArray) {
            NSMutableArray *newArray = @[].mutableCopy;
            [self.multiDataDict setObject:newArray forKey:index];
            currentDataArray = self.multiDataDict[index];
        }
        if (dataArray.count==0) {
            [self.multiNoMoreDataDict setObject:@(YES) forKey:index];
        } else {
            [self.multiNoMoreDataDict setObject:@(NO) forKey:index];
            [currentDataArray addObjectsFromArray:dataArray];
        }
        [subject sendCompleted];
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    
    return subject;
}

- (RACSignal *)js_singalForMultiBaseRequestPara:(NSMutableDictionary *)para
                                            url:(NSString *)url
                                          index:(NSString *)index
                                       isReload:(BOOL)isReload{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    if (![self isSatisfyRequestWithIndex:self.currentIndex]&&!isReload) {
        return subject;
    }
    if (isReload) {
#warning 此处可以添加统一的HUD
        //...
        [YBLLogLoadingView showInWindow];
    }
    self.isRequesting = YES;
    if (!para) {
        para = [NSMutableDictionary dictionary];
    }
    if (!self.multiCurrentPageDict) {
        self.multiCurrentPageDict = @{}.mutableCopy;
    }
    if (!self.multiNoMoreDataDict) {
        self.multiNoMoreDataDict = @{}.mutableCopy;
    }
    if (!self.multiDataDict) {
        self.multiDataDict = @{}.mutableCopy;
    }
    
    if (!self.multiCurrentPageDict[index]||isReload) {
        [self.multiCurrentPageDict setObject:@(0) forKey:index];
    }
    __block NSInteger page = [self.multiCurrentPageDict[index] integerValue];
    page++;
#warning 分页的key按需修改
    para[@"page"] = @(page);
    para[@"per_page"] = @(PerPageMaxCount);
    
    [[JSRequestTools js_getURL:url
                         para:para] subscribeNext:^(id  _Nullable x) {
        self.isRequesting = NO;
        if (isReload ) {
#warning 消失HUD
            //...
            [YBLLogLoadingView dismissInWindow];
            //刷新删除旧数据
            [self.multiDataDict removeObjectForKey:index];
        }
        [self.multiDataDict setObject:@(page) forKey:index];
        [subject sendNext:x];
        [subject sendCompleted];
    } error:^(NSError * _Nullable error) {
        if (page > 0) {
            page--;
        }
        [self.multiCurrentPageDict setObject:@(page) forKey:index];
        self.isRequesting = NO;
        [subject sendError:error];
    }];
    
    return subject;
    
}

- (BOOL)isSatisfyRequestWithIndex:(NSInteger)index{
    BOOL isNomoreData = [self.multiCurrentPageDict[[NSString stringWithFormat:@"%@",@(index)]] boolValue];
    return (!self.isRequesting&&!isNomoreData);
}

- (NSMutableArray *)getCurrentDataArray{
    return [self getDataArrayWithIndex:self.currentIndex];
}

- (NSMutableArray *)getDataArrayWithIndex:(NSInteger)index{
    JSTitleItemModel *titleItemModel = self.multiTitleDataArray[index];
    NSMutableArray *dataArray = self.multiDataDict[titleItemModel.id];
    return dataArray;
}

@end
