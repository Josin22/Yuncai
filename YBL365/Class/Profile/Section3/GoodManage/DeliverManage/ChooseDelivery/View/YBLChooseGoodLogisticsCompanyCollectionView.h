//
//  YBLChooseGoodLogisticsCompanyCollectionView.h
//  YC168
//
//  Created by 乔同新 on 2017/4/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChooseGoodLogisticsCompanyCollectionViewCellDidSelectBlock)(id model);

@interface YBLChooseGoodLogisticsCompanyCollectionView : UICollectionView

@property (nonatomic, strong) ChooseGoodLogisticsCompanyCollectionViewCellDidSelectBlock chooseGoodLogisticsCompanyCollectionViewCellDidSelectBlock;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end
