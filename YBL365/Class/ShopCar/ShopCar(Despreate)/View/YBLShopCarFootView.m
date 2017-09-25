//
//  YBLShopCarFootView.m
//  YBL365
//
//  Created by 乔同新 on 16/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLShopCarFootView.h"

@implementation YBLShopCarFootView

- (void)setFrame:(CGRect)frame{
    CGRect sectionRect = [self.tableView rectForSection:self.section];
    CGRect newFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMaxY(sectionRect)-10, CGRectGetWidth(frame), CGRectGetHeight(frame));
    [super setFrame:newFrame];
}

- (void)dealloc {
    NSLog(@"%@-dealloc",[self class]);
}

@end
