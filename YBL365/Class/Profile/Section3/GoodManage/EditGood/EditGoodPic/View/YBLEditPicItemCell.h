//
//  YBLEditPicItemCell.h
//  YC168
//
//  Created by 乔同新 on 2017/6/3.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLEditPicItemModel;

@interface YBLEditPicItemCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *iconImageView;

//@property (nonatomic, strong) UIImageView *deleteIconImageView;
@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, retain) UILabel *infoLabel;

- (void)updateModel:(YBLEditPicItemModel *)itemModel row:(NSInteger)row;

- (UIView *)snapshotView ;

@end
