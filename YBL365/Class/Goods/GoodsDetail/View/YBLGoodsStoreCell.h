//
//  YBLGoodsStoreCell.h
//  YBL365
//
//  Created by 乔同新 on 12/24/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLGoodsStoreCell : UITableViewCell

@property (nonatomic, strong) UIImageView *storeImageView;
@property (nonatomic, retain) UILabel *storeNameLabel;
@property (nonatomic, strong) YBLButton *callButton;
@property (nonatomic, strong) YBLButton *goStoreButton;


+ (CGFloat)getGoodsStoreCellHeight;

@end
