//
//  YBLShopCarGoodCell.h
//  YBL365
//
//  Created by 乔同新 on 16/12/20.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLShopCarGoodCell : UITableViewCell

@property (nonatomic, strong) UIButton *checkAllButton; //选中按钮
@property (nonatomic, strong) UIImageView *goodImageView; //商品图
@property (nonatomic, strong) UILabel *goodNameLabel; //商品名
@property (nonatomic, strong) UILabel *descLabel; // 描述
@property (nonatomic, strong) UILabel *priceLabel; //价格

@property (nonatomic, strong) UIButton *subtractButton; //减号
@property (nonatomic, strong) UIButton *addButton; //加号
@property (nonatomic, strong) UILabel *numberLabel; // 数量

@property (nonatomic, strong) UIButton *deleteButton; //删除按钮
@property (nonatomic, strong) UIButton *collectionButton; //收藏按钮

@property (nonatomic, strong) UIView *lineView; //线

/**
 *  回复背景  隐藏删除按钮
 */
- (void)reloadBgView;



@end
