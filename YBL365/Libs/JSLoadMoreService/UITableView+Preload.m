//
//  UITableView+Prereload.m
//  JSLoadMoreServiceDemo
//
//  Created by 乔同新 on 2017/8/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//  Github: https://github.com/Josin22/JSLoadMoreService

#import "UITableView+Preload.h"
#import <objc/runtime.h>
#import <MJRefresh/MJRefresh.h>

static const char * key_js_dataArray = "key_js_dataArray";

static const char * key_js_preloadBlock = "key_js_preloadBlock";

@implementation UITableView (Prereload)

- (PreloadBlock)js_preloadBlock{
    return objc_getAssociatedObject(self, &key_js_preloadBlock);
}

- (void)setJs_preloadBlock:(PreloadBlock)js_preloadBlock{
    objc_setAssociatedObject(self, &key_js_preloadBlock, js_preloadBlock, OBJC_ASSOCIATION_COPY);
}

- (NSMutableArray *)dataArray{
    return objc_getAssociatedObject(self, &key_js_dataArray);
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    objc_setAssociatedObject(self, &key_js_dataArray, dataArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)headerReloadBlock:(ReloadBlock)js_reloadBlock{
    
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:js_reloadBlock];
//    self.mj_header = header;
    [YBLMethodTools headerRefreshWithTableView:self completion:js_reloadBlock];
}

- (void)endReload{
    
    [self.mj_header endRefreshing];
}

- (void)preloadDataWithCurrentIndex:(NSInteger)currentIndex{
    NSInteger totalCount = self.dataArray.count;
    if ([self isSatisfyPreloadDataWithTotalCount:totalCount currentIndex:currentIndex]&&self.js_preloadBlock) {
        self.js_preloadBlock();
    }
}

- (BOOL)isSatisfyPreloadDataWithTotalCount:(NSInteger)totalCount currentIndex:(NSInteger)currentIndex{
    return  ((currentIndex == totalCount - PreloadMinCount) && (currentIndex >= PreloadMinCount));
}

@end
