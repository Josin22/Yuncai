//
//  YBLFourLevelAddressItemCollectionView.h
//  YC168
//
//  Created by 乔同新 on 2017/4/17.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLAddressAreaModel;

typedef void(^FourLevelAddressItemCollectionViewCellDidSelectBlock)(BOOL arrowOrNot,BOOL buttonSelect, YBLAddressAreaModel *model);

@interface YBLFourLevelAddressItemCollectionView : UICollectionView

@property (nonatomic, copy  ) FourLevelAddressItemCollectionViewCellDidSelectBlock fourLevelAddressItemCollectionViewCellDidSelectBlock;

- (void)updateArray:(NSMutableArray *)dataArray Dict:(NSMutableDictionary *)dict;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout collectionType:(TableType)collectionType;

@end
