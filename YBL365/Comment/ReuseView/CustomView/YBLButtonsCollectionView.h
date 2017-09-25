//
//  YBLButtonsCollectionView.h
//  YC168
//
//  Created by 乔同新 on 2017/6/21.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ButtonsHasAllSelect) {
    /**
     *  有全部
     */
    ButtonsHasAllSelectYES = 0,
    /**
     *  没有全部
     */
    ButtonsHasAllSelectNO
};

@interface YBLButtonsCollectionView : UICollectionView

@property (nonatomic, strong) NSMutableArray *dataArray;

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
                  chooseStyle:(ButtonsChooseStyle)chooseStyle
                 hasAllSelect:(ButtonsHasAllSelect)hasAllSelect;

@end
