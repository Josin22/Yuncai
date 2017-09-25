//
//  YBLShopCarItemCell.m
//  YBL365
//
//  Created by 乔同新 on 2017/3/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLShopCarItemCell.h"
#import "YBLCartModel.h"
#import "YBLShopCarViewModel.h"

@interface YBLShopCarItemCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *goodImageView; //商品图
@property (nonatomic, retain) UILabel *goodNameLabel; //商品名
@property (nonatomic, retain) UILabel *descLabel; // 描述
@property (nonatomic, retain) UILabel *priceLabel; //价格
@property (nonatomic, strong) UIView *noStockView;

@end

@implementation YBLShopCarItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat height_cell = [YBLShopCarItemCell getItemCellHi];
    
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.top.equalTo(@0);
    }];
    
    self.checkAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkAllButton setImage:[UIImage imageNamed:@"syncart_round_check2New"] forState:UIControlStateSelected];
    [self.checkAllButton setImage:[UIImage imageNamed:@"syncart_round_check1New"] forState:UIControlStateNormal];
    [self.bgView addSubview:self.checkAllButton];
    [self.checkAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.width.equalTo(@40);
        make.height.with.equalTo(@60);
        make.centerY.equalTo(self.bgView.mas_centerY);
    }];
    
    self.goodImageView = [[UIImageView alloc] init];
    self.goodImageView.layer.cornerRadius = 3;
    self.goodImageView.layer.borderColor = LINE_BASE_COLOR.CGColor;
    self.goodImageView.layer.borderWidth = 0.5;
    self.goodImageView.backgroundColor = LINE_BASE_COLOR;
    [self.bgView addSubview:self.goodImageView];
    [self.goodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkAllButton.mas_right);
        make.height.width.equalTo(@80);
        make.centerY.equalTo(self.bgView.mas_centerY);
    }];
    
    self.noStockView = [[UIView alloc] init];
    self.noStockView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    [self.goodImageView addSubview:self.noStockView];
    [self.noStockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.equalTo(@0);
    }];
    
    UIImageView *noStockImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shop_car_no_stock"]];
    [self.noStockView addSubview:noStockImageView];
    [noStockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@10);
        make.right.bottom.equalTo(@-10);
    }];
    
    
    self.goodNameLabel = [[UILabel alloc] init];
    self.goodNameLabel.font = YBLFont(13);
    self.goodNameLabel.textColor = YBLColor(70, 70, 70, 1.0);
    self.goodNameLabel.numberOfLines = 2;
    [self.bgView addSubview:self.goodNameLabel];
    [self.goodNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.lessThanOrEqualTo(@-20);
        make.left.equalTo(self.goodImageView.mas_right).with.offset(8);
        make.top.equalTo(@10);
    }];
    
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.font = YBLFont(11);
    self.descLabel.textColor = YBLColor(140, 140, 140, 1.0);
    [self.bgView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.lessThanOrEqualTo(@-20);
        make.left.equalTo(self.goodImageView.mas_right).with.offset(8);
        make.top.equalTo(self.goodNameLabel.mas_bottom).with.offset(5);
    }];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.font = YBLFont(15);
    self.priceLabel.textColor = [UIColor redColor];
    [self.bgView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodImageView.mas_right).with.offset(8);
        make.bottom.equalTo(@-10);
    }];
    
    YBLAddSubtractView *addSubtractView = [[YBLAddSubtractView alloc] initWithFrame:CGRectMake(0, 0, 100, 24)];
    addSubtractView.right = YBLWindowWidth-space;
    addSubtractView.bottom = height_cell-space;
    [self.bgView addSubview:addSubtractView];
    self.addSubtractView = addSubtractView;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = LINE_BASE_COLOR;
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}

- (void)updateItemsModel:(lineitems *)model{
     //商品图
    [self.goodImageView js_alpha_setImageWithURL:[NSURL URLWithString:model.product.avatar_url]
                                placeholderImage:smallImagePlaceholder];
    //商品名
    self.goodNameLabel.text = model.product.title;
     // 描述
    self.descLabel.text = model.product.specification;
     //价格
    NSString *price = [NSString stringWithFormat:@"%.2f",model.lineitems_price.doubleValue];
    self.priceLabel.attributedText = [NSString price:price color:YBLThemeColor font:16];
    
    self.addSubtractView.maxCount = model.product.stock.integerValue;
    self.addSubtractView.minCount = model.product.minCount.integerValue;
    self.addSubtractView.currentCount = model.quantity.integerValue;
    self.checkAllButton.selected = model.lineitems_select;
    
    //库存
    if (model.no_permit_check_result.no_permit.boolValue) {
        self.noStockView.hidden = NO;
        if (model.product.stock.integerValue == 0) {
            self.addSubtractView.hidden = YES;
        } else {
            self.addSubtractView.hidden = NO;    
        }
    } else {
        self.noStockView.hidden = YES;
        self.addSubtractView.hidden = NO;
    }
    
}

+ (CGFloat)getItemCellHi{
    
    return 100;
}

@end
