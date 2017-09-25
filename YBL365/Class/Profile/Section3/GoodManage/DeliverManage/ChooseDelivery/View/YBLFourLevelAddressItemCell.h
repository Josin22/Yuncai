//
//  YBLFourLevelAddressItemCell.h
//  YC168
//
//  Created by 乔同新 on 2017/4/17.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FourLevelAddressItemEventType){
    FourLevelAddressItemEventTypeCancle = 0,
    FourLevelAddressItemEventTypeClick
};

typedef void(^FourLevelAddressItemCellEventsBlock)(FourLevelAddressItemEventType,UIButton *currentButton);

@class YBLAreaItemButton,YBLAddressAreaModel;

@interface YBLFourLevelAddressItemCell : UICollectionViewCell

@property (nonatomic, strong) YBLAreaItemButton *itemButton;

//@property (nonatomic, copy  ) FourLevelAddressItemCellEventsBlock fourLevelAddressItemCellEventsBlock;

- (void)updateModel:(YBLAddressAreaModel *)model;

@end
