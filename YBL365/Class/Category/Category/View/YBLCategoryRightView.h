//
//  YBLCategoryRightView.h
//  YBL365
//
//  Created by 乔同新 on 16/12/19.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLCategoryTreeModel;

typedef void(^ScrollChangeBlock)(BOOL isAdd);

typedef void(^ItemClickBlock)(YBLCategoryTreeModel *model);

typedef NS_ENUM(NSInteger, TypeHeader) {
    TypeHeaderHave = 0, //默认有header
    TypeHeaderNone      //无
};

@interface YBLCategoryRightView : UICollectionView

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
                   typeHeader:(TypeHeader)typeHeader;

@property (nonatomic, copy  ) ItemClickBlock    itemClickBlock;

@property (nonatomic, copy  ) ScrollChangeBlock scrollChangeBlock;

@property (nonatomic, strong) NSMutableArray    *rightDataArray;

@end
