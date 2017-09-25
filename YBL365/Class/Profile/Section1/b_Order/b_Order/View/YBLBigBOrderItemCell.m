//
//  YBLBigBOrderItemCell.m
//  YC168
//
//  Created by 乔同新 on 2017/4/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLBigBOrderItemCell.h"
#import "YBLOrderItemModel.h"
#import "YBLEvaluatePicCollection.h"

static NSInteger const tag_undefine_button = 464;

@interface YBLBigBOrderItemCell ()

@property (nonatomic, strong) UIImageView *goodImageView;

@property (nonatomic, retain) UILabel *goodTitleLabel;

@property (nonatomic, retain) UILabel *goodSiganlLabel;

@property (nonatomic, retain) UILabel *goodPriceLabel;

@property (nonatomic, retain) UILabel *goodQuantityLabel;

@property (nonatomic, retain) UILabel *shopNameLabel;

@property (nonatomic, retain) UILabel *shopAddressLabel;

@property (nonatomic, weak  ) YBLEvaluatePicCollection *picCollectionView;

@property (nonatomic, strong) UIView *singleItemView;

@property (nonatomic, weak  ) YBLOrderItemModel *itemOrderModel;
/**
 *  订单类型图片
 */
@property (nonatomic, strong) UIImageView *orderStateImageView;
/**
 *  订单完成图片
 */
@property (nonatomic, strong) UIImageView *orderDoneImageView;

@property (nonatomic, retain) UILabel *finishTimeLabel;

@end

@implementation YBLBigBOrderItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat hi = [YBLBigBOrderItemCell getHI];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 4;
    CGFloat ccwi = 90;
    layout.itemSize = CGSizeMake(ccwi, ccwi);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    YBLEvaluatePicCollection *picCollectionView = [[YBLEvaluatePicCollection alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, ccwi) collectionViewLayout:layout];
    WEAK
    picCollectionView.evaluatePicCollectionDidSelectBlock = ^(NSInteger index,UIImageView *imageView){
        STRONG
        BLOCK_EXEC(self.bigBOrderItemCellDiDSelectBlock,);
    };
    [self.contentView addSubview:picCollectionView];
    picCollectionView.hidden = YES;
    self.picCollectionView = picCollectionView;

    UIView *singleItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, ccwi)];
    [self.contentView addSubview:singleItemView];
    self.singleItemView = singleItemView;
    
    self.goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, 70, 70)];
//    self.goodImageView.layer.cornerRadius = 2;
//    self.goodImageView.layer.masksToBounds = YES;
    self.goodImageView.cornerRadius = 3;
    self.goodImageView.layer.borderColor = YBLLineColor.CGColor;
    self.goodImageView.layer.borderWidth = .5;
    [self.singleItemView addSubview:self.goodImageView];
    
    self.goodSiganlLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.goodImageView.width, 20)];
    self.goodSiganlLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4];
    self.goodSiganlLabel.textColor = [UIColor whiteColor];
    self.goodSiganlLabel.font = YBLFont(12);
    self.goodSiganlLabel.textAlignment = NSTextAlignmentCenter;
    [self.goodImageView addSubview:self.goodSiganlLabel];
    
    self.goodTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.goodImageView.right+space, self.goodImageView.top, self.singleItemView.width-self.goodImageView.right-2*space, 40)];
    self.goodTitleLabel.font = YBLFont(14);
    self.goodTitleLabel.numberOfLines = 2;
    self.goodTitleLabel.textColor = BlackTextColor;
    [self.singleItemView addSubview:self.goodTitleLabel];
    
    self.goodPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.goodTitleLabel.left, self.goodTitleLabel.bottom, self.goodTitleLabel.width, 15)];
    self.goodPriceLabel.textColor = YBLThemeColor;
    self.goodPriceLabel.font = YBLFont(12);
    [self.singleItemView addSubview:self.goodPriceLabel];
    
    self.goodQuantityLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.goodPriceLabel.left, self.goodPriceLabel.bottom, self.goodPriceLabel.width, 15)];
    self.goodQuantityLabel.font = YBLFont(12);
    self.goodQuantityLabel.textColor = YBLTextColor;
    [self.singleItemView addSubview:self.goodQuantityLabel];
    
    [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(self.goodImageView.left, self.goodImageView.bottom+space-.5, self.singleItemView.width-space, .5)]];
    
    self.shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.goodImageView.left, self.goodImageView.bottom+space*2, YBLWindowWidth-self.goodImageView.left-space*2, 20)];
    self.shopNameLabel.textColor = BlackTextColor;
    self.shopNameLabel.font = YBLFont(14);
    [self.contentView addSubview:self.shopNameLabel];
    
    self.shopAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.shopNameLabel.left, self.shopNameLabel.bottom, self.shopNameLabel.width, self.shopNameLabel.height)];
    self.shopAddressLabel.font = YBLFont(13);
    self.shopAddressLabel.textColor = YBLTextColor;
    [self.contentView addSubview:self.shopAddressLabel];

    [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(space, self.shopAddressLabel.bottom+space-.5, YBLWindowWidth, .5)]];

    CGFloat buttonwi = 80;
    CGFloat buttonhi = 32;
    for (int i = 0; i < 3; i++) {
        UIButton *undefineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        undefineButton.frame = CGRectMake(YBLWindowWidth-(buttonwi+space)*(i+1), 0, buttonwi, buttonhi);
        undefineButton.bottom = hi-space;
        undefineButton.layer.cornerRadius = 3;
        undefineButton.layer.masksToBounds = YES;
        undefineButton.titleLabel.font = YBLFont(14);
        undefineButton.tag = tag_undefine_button+i;
        if (i == 0) {
            [undefineButton setTitleColor:YBLColor(0, 121, 0, 1) forState:UIControlStateNormal];
            undefineButton.layer.borderColor = YBLColor(0, 121, 0, 1).CGColor;
        } else {
            [undefineButton setTitleColor:YBLThemeColor forState:UIControlStateNormal];
            undefineButton.layer.borderColor = YBLThemeColor.CGColor;
        }
        undefineButton.layer.borderWidth = .5;
        [undefineButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:undefineButton];
    }
    [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(0, hi-.5, YBLWindowWidth, .5)]];
    
    /* Image View */
    self.orderStateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_for_purchase"]];
    self.orderStateImageView.frame = CGRectMake(space, 0, 25, 25);
    self.orderStateImageView.bottom = hi-space;
    [self.contentView addSubview:self.orderStateImageView];
    self.orderStateImageView.hidden = YES;
    
    self.finishTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, YBLWindowWidth-(buttonwi+space)*3, 15)];
    self.finishTimeLabel.bottom = self.orderStateImageView.bottom;
    self.finishTimeLabel.textColor = YBLTextLightColor;
    self.finishTimeLabel.font = YBLFont(12);
    [self.contentView addSubview:self.finishTimeLabel];
    self.finishTimeLabel.hidden = YES;
    
    self.orderDoneImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_for_fullcomplete"]];
    self.orderDoneImageView.frame = CGRectMake(0, 0, 70,54);
    self.orderDoneImageView.right = YBLWindowWidth-space;
    [self.contentView addSubview:self.orderDoneImageView];
    self.orderDoneImageView.hidden = YES;
}

- (void)buttonClick:(UIButton *)btn {
    NSInteger index = btn.tag-tag_undefine_button;
    NSMutableArray *newButtonsArray = [NSMutableArray array];
    [newButtonsArray addObjectsFromArray:self.itemOrderModel.property_order.orderStateCount];
    if (self.itemOrderModel.property_order.purchaseOrderStateCount>0&&self.itemOrderModel.purchase_order) {
        [newButtonsArray addObjectsFromArray:self.itemOrderModel.property_order.purchaseOrderStateCount];
    }
    YBLOrderPropertyItemModel *itemModel = newButtonsArray[index];
    BLOCK_EXEC(self.bigBOrderItemCellButtonClickBlock,btn.currentTitle,itemModel);
}

- (void)updateModel:(YBLOrderItemModel *)model{
    
    self.itemOrderModel = model;
    self.goodSiganlLabel.text = model.state_cn;
    self.shopNameLabel.text = [NSString stringWithFormat:@"%@ %@",model.auto_address.consignee_name,model.auto_address.consignee_phone];
    self.shopAddressLabel.text = model.auto_address.full_address;
    self.goodPriceLabel.text = [NSString stringWithFormat:@"总额 : ¥%.2f",model.total.doubleValue];
    self.orderStateImageView.hidden = YES;
    /**
     *  采购订单
     */
    NSString *titleText = @"";
    if (model.purchase_order) {
        
        self.orderStateImageView.hidden = NO;
        [self.goodImageView js_alpha_setImageWithURL:[NSURL URLWithString:model.purchase_order.avatar] placeholderImage:smallImagePlaceholder];
        titleText = model.purchase_order.title;
        self.goodQuantityLabel.text = [NSString stringWithFormat:@"数量 : %d%@",model.purchase_order.quantity.intValue,model.purchase_order.unit];
        self.picCollectionView.hidden = YES;
        self.singleItemView.hidden = NO;
        
    } else {
        /**
         *  正向订单
         */
        if (model.line_items.count>1) {
            self.picCollectionView.hidden = NO;
            self.singleItemView.hidden = YES;
            NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:model.line_items.count];
            for (lineitems *itemModel in model.line_items) {
                [imageArray addObject:itemModel.product.avatar_url];
            }
            self.picCollectionView.dataArray = imageArray;
        } else {
            //单个
            self.singleItemView.hidden = NO;
            self.picCollectionView.hidden = YES;
            lineitems *iyte = model.line_items[0];
            [self.goodImageView js_alpha_setImageWithURL:[NSURL URLWithString:iyte.product.avatar_url] placeholderImage:smallImagePlaceholder];
            self.goodQuantityLabel.text = [NSString stringWithFormat:@"数量 : %d%@",iyte.quantity.intValue,iyte.product.unit];
            titleText = iyte.product.title;
        }
    }
    CGSize titleSize = [titleText heightWithFont:YBLFont(14) MaxWidth:self.width-self.goodImageView.right-space*2];
    self.goodTitleLabel.height = titleSize.height+3>40?40:titleSize.height+3;
    self.goodTitleLabel.text = titleText;
    /* 按钮 */
    self.orderDoneImageView.hidden = YES;
    NSInteger count = model.property_order.orderStateCount.count;
    NSMutableArray *newButtonsArray = [NSMutableArray array];
    [newButtonsArray addObjectsFromArray:model.property_order.orderStateCount];
    if (model.property_order.purchaseOrderStateCount>0&&model.purchase_order) {
        count += model.property_order.purchaseOrderStateCount.count;
        [newButtonsArray addObjectsFromArray:model.property_order.purchaseOrderStateCount];
    }
    for (int i = 0; i < 3; i++) {
        UIButton *undefineButton = (UIButton *)[self viewWithTag:tag_undefine_button+i];
        undefineButton.hidden = YES;
        if (i<count) {
            undefineButton.hidden = NO;
            YBLOrderPropertyItemModel *itemModel = newButtonsArray[i];
            [undefineButton setTitle:itemModel.order_button_title forState:UIControlStateNormal];
            //再次购买
            if ([itemModel.order_state isEqualToString:@"full_complete"]) {
                self.orderDoneImageView.hidden = NO;
            }
        }
    }
    if ([model.state_en isEqualToString:@"full_complete"]) {
        self.finishTimeLabel.text = model.full_completed_at;
        self.finishTimeLabel.hidden = NO;
        if (self.orderStateImageView.isHidden) {
            self.finishTimeLabel.left = space;
        } else {
            self.finishTimeLabel.left = space+self.orderStateImageView.right;
        }
        self.finishTimeLabel.centerY = self.orderStateImageView.centerY;
    } else {
        self.finishTimeLabel.hidden = YES;
    }
}

+ (CGFloat)getHI{
    return 150+50;
}



@end
