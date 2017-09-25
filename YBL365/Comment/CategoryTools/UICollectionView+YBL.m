//
//  UICollectionView+YBL.m
//  YC168
//
//  Created by 乔同新 on 2017/6/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "UICollectionView+YBL.h"

@implementation UICollectionView (YBL)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        Method reload_fromMethod = class_getInstanceMethod(class, @selector(reloadData));
        Method reload_toMethod = class_getInstanceMethod(class, @selector(js_reloadData));
        method_exchangeImplementations(reload_fromMethod, reload_toMethod);
        
        Method scrollToItem_fromMethod = class_getInstanceMethod(class, @selector(scrollToItemAtIndexPath:atScrollPosition:animated:));
        Method scrollToItem_toMethod = class_getInstanceMethod(class, @selector(js_scrollToItemAtIndexPath:atScrollPosition:animated:));
        method_exchangeImplementations(scrollToItem_fromMethod, scrollToItem_toMethod);
        
        Method insertSections_fromMethod = class_getInstanceMethod(class, @selector(insertSections:));
        Method insertSections_toMethod = class_getInstanceMethod(class, @selector(js_insertSections:));
        method_exchangeImplementations(insertSections_fromMethod, insertSections_toMethod);
        
        Method deleteSections_fromMethod = class_getInstanceMethod(class, @selector(deleteSections:));
        Method deleteSections_toMethod = class_getInstanceMethod(class, @selector(js_deleteSections:));
        method_exchangeImplementations(deleteSections_fromMethod, deleteSections_toMethod);
        
        Method reloadSections_fromMethod = class_getInstanceMethod(class, @selector(reloadSections:));
        Method reloadSections_toMethod = class_getInstanceMethod(class, @selector(js_reloadSections:));
        method_exchangeImplementations(reloadSections_fromMethod, reloadSections_toMethod);
        
        Method insertItemsAtIndexPaths_fromMethod = class_getInstanceMethod(class, @selector(insertItemsAtIndexPaths:));
        Method insertItemsAtIndexPaths_toMethod = class_getInstanceMethod(class, @selector(js_insertItemsAtIndexPaths:));
        method_exchangeImplementations(insertItemsAtIndexPaths_fromMethod, insertItemsAtIndexPaths_toMethod);
        
        Method deleteItemsAtIndexPaths_fromMethod = class_getInstanceMethod(class, @selector(deleteItemsAtIndexPaths:));
        Method deleteItemsAtIndexPaths_toMethod = class_getInstanceMethod(class, @selector(js_deleteItemsAtIndexPaths:));
        method_exchangeImplementations(deleteItemsAtIndexPaths_fromMethod, deleteItemsAtIndexPaths_toMethod);
        
        Method reloadItemsAtIndexPaths_fromMethod = class_getInstanceMethod(class, @selector(reloadItemsAtIndexPaths:));
        Method reloadItemsAtIndexPaths_toMethod = class_getInstanceMethod(class, @selector(js_reloadItemsAtIndexPaths:));
        method_exchangeImplementations(reloadItemsAtIndexPaths_fromMethod, reloadItemsAtIndexPaths_toMethod);
    });
}

/**
 *  new
 */
- (void)js_reloadData{
    if ([self checkEverythingIsAllRight]) {
        [self js_reloadData];
    }
}

- (void)js_scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated{
    if ([self checkEverythingIsAllRight]) {
        [self js_scrollToItemAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
    }
}

- (void)js_insertSections:(NSIndexSet *)sections{
    if ([self checkEverythingIsAllRight]) {
//        [self js_insertSections:sections];
        [self js_reloadData];
    }
}
- (void)js_deleteSections:(NSIndexSet *)sections{
    if ([self checkEverythingIsAllRight]) {
        [self js_deleteSections:sections];
    }
}
- (void)js_reloadSections:(NSIndexSet *)sections{
    if ([self checkEverythingIsAllRight]) {
        [self js_reloadSections:sections];
    }
}

- (void)js_insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    if ([self checkEverythingIsAllRight]) {
//        [self js_insertItemsAtIndexPaths:indexPaths];
        [self js_reloadData];
    }
}
- (void)js_deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    if ([self checkEverythingIsAllRight]) {
        [self js_deleteItemsAtIndexPaths:indexPaths];
    }
}
- (void)js_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    if ([self checkEverythingIsAllRight]) {
        [self js_reloadItemsAtIndexPaths:indexPaths];
    }
}

- (BOOL)checkEverythingIsAllRight{
    BOOL isAllRight = NO;
    //父view不被销毁/==>>return YES
    if (self.superview) {
        isAllRight = YES;
    }
    return isAllRight;
}

/**
 *  old
 */
- (void)jsReloadData{

    [self reloadData];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//    });
}

- (void)jsInsertRowIndexps:(NSMutableArray *)indexps{

//    [self insertItemsAtIndexPaths:indexps];
    [self reloadData];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//    });
}

@end
