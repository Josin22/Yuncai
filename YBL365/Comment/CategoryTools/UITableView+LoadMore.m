//
//  UITableView+YBLLoadMore.m
//  YC168
//
//  Created by 乔同新 on 2017/6/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "UITableView+LoadMore.h"
#import "YBLFooterSignView.h"

static const char * data_key = "UITableView+LoadMore_data";

static const char * isShowFooter_key = "UITableView+LoadMore_footer";

static const char * prestrain_block_key = "UITableView+LoadMore_block";

static const char * ybl_delegate_key = "UITableView+LoadMore_delegate";

@implementation UITableView (LoadMore)

+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
         Class class = [self class];
        ////reload
        Method reload_fromMethod = class_getInstanceMethod(class, @selector(reloadData));
        Method reload_toMethod = class_getInstanceMethod(class, @selector(js_reloadData));
        method_exchangeImplementations(reload_fromMethod, reload_toMethod);

        
        //reload indexps
        Method reload_indexps_fromMethod = class_getInstanceMethod(class, @selector(reloadRowsAtIndexPaths:withRowAnimation:));
        Method reload_indexps_toMethod = class_getInstanceMethod(class, @selector(js_reloadRowsAtIndexPaths:withRowAnimation:));
        method_exchangeImplementations(reload_indexps_fromMethod, reload_indexps_toMethod);
        
        //delete indexps
        Method delete_indexps_fromMethod = class_getInstanceMethod(class, @selector(deleteRowsAtIndexPaths:withRowAnimation:));
        Method delete_indexps_toMethod = class_getInstanceMethod(class, @selector(js_deleteRowsAtIndexPaths:withRowAnimation:));
        method_exchangeImplementations(delete_indexps_fromMethod, delete_indexps_toMethod);
        
        //insert indexps
        Method insert_indexps_fromMethod = class_getInstanceMethod(class, @selector(insertRowsAtIndexPaths:withRowAnimation:));
        Method insert_indexps_toMethod = class_getInstanceMethod(class, @selector(js_insertRowsAtIndexPaths:withRowAnimation:));
        method_exchangeImplementations(insert_indexps_fromMethod, insert_indexps_toMethod);
        
        
        //delete sections
        Method delete_sections_fromMethod = class_getInstanceMethod(class, @selector(deleteSections:withRowAnimation:));
        Method delete_sections_toMethod = class_getInstanceMethod(class, @selector(js_deleteSections:withRowAnimation:));
        method_exchangeImplementations(delete_sections_fromMethod, delete_sections_toMethod);
        
        
        //insert sections
        Method insert_sections_fromMethod = class_getInstanceMethod(class, @selector(insertSections:withRowAnimation:));
        Method insert_sections_toMethod = class_getInstanceMethod(class, @selector(js_insertSections:withRowAnimation:));
        method_exchangeImplementations(insert_sections_fromMethod, insert_sections_toMethod);
        
        
        //reload sections
        Method reload_sections_fromMethod = class_getInstanceMethod(class, @selector(reloadSections:withRowAnimation:));
        Method reload_sections_toMethod = class_getInstanceMethod(class, @selector(js_reloadSections:withRowAnimation:));
        method_exchangeImplementations(reload_sections_fromMethod, reload_sections_toMethod);
    });
    
}

- (NSMutableArray *)dataArray{
    return objc_getAssociatedObject(self, &data_key);
}

- (void)setIsShowFooterSignView:(BOOL)isShowFooterSignView{
    if (isShowFooterSignView) {
        self.tableFooterView = [[YBLFooterSignView alloc] initWithFrame:CGRectMake(0, 0, self.width, 80)];
    } else {
        self.tableFooterView = nil;
    }
    objc_setAssociatedObject(self, &isShowFooter_key, @(isShowFooterSignView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isShowFooterSignView{
    return [objc_getAssociatedObject(self, &isShowFooter_key) boolValue];
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    if (dataArray.count==0) {
        self.tableFooterView.hidden = YES;
    } else {
        self.tableFooterView.hidden = NO;
    }
    objc_setAssociatedObject(self, &data_key, dataArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ViewPrestrainBlock)prestrainBlock{
    return objc_getAssociatedObject(self, &prestrain_block_key);
}

- (void)setPrestrainBlock:(ViewPrestrainBlock)prestrainBlock{
    objc_setAssociatedObject(self, &prestrain_block_key, prestrainBlock, OBJC_ASSOCIATION_COPY);
}

- (void)setYbl_delegate:(id<YBLTableViewDelegate>)ybl_delegate{
    objc_setAssociatedObject(self, &ybl_delegate_key, ybl_delegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id <YBLTableViewDelegate>)ybl_delegate{
    return objc_getAssociatedObject(self, &ybl_delegate_key);
}
/**
 *  new
 */
- (void)js_reloadData{
    if ([self checkEverythingIsAllRight]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self js_reloadData];
        });
    }
}

- (void)js_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    if ([self checkEverythingIsAllRight]) {
        [self js_reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    }
}

- (void)js_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    if ([self checkEverythingIsAllRight]) {
        [self js_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    }
}

- (void)js_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    if ([self checkEverythingIsAllRight]) {
//        [self js_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
        [self js_reloadData];
    }
}

- (void)js_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    if ([self checkEverythingIsAllRight]) {
        [self js_deleteSections:sections withRowAnimation:animation];
    }
}

- (void)js_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    if ([self checkEverythingIsAllRight]) {
        [self js_reloadSections:sections withRowAnimation:animation];
    }
}

- (void)js_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    if ([self checkEverythingIsAllRight]) {
//        [self js_insertSections:sections withRowAnimation:animation];
        [self js_reloadData];
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

/*  old  */

- (void)jsReloadData{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData];
    });
}

- (void)jsInsertRowIndexps:(NSMutableArray *)indexps{

    [self jsInsertRowIndexps:indexps withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)jsInsertRowIndexps:(NSMutableArray *)indexps withRowAnimation:(UITableViewRowAnimation)animation{
    [self jsReloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.dataArray.count == 0) {
        return;
    }
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;

    if (distanceFromBottom < height) {
        BLOCK_EXEC(self.prestrainBlock,);
    }
}

@end
