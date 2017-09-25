//
//  YBLLittlebOrderItemCell.m
//  YC168
//
//  Created by 乔同新 on 2017/3/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLlittlebOrderItemCell.h"
#import "YBLOrderItemModel.h"
#import "YBLEvaluatePicCollection.h"

static NSInteger const tag_undefine_button = 22;

@interface YBLLittlebOrderItemCell ()

@property (nonatomic, retain) UILabel *storeNameLabel;

@property (nonatomic, retain) UILabel *orderStatusLabel;

@property (nonatomic, retain) UILabel *goodNameLabel;

@property (nonatomic, strong) UIImageView *goodImageView;

@property (nonatomic, retain) UILabel *goodNumLabel;

@property (nonatomic, strong) UIView *singleItemView;

@property (nonatomic, retain) UILabel *priceCountLabel;

@property (nonatomic, weak  ) YBLEvaluatePicCollection *picCollectionView;
/**
 *  订单类型图片
 */
@property (nonatomic, strong) UIImageView *orderStateImageView;
/**
 *  订单完成图片
 */
@property (nonatomic, strong) UIImageView *orderDoneImageView;

@property (nonatomic, weak  ) YBLOrderItemModel *orderItemModel;

@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, retain) UILabel *finishTimeLabel;

@end

@implementation YBLLittlebOrderItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    UIImageView *storeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goods_store"]];
    storeIcon.frame = CGRectMake(space, space, 20, 20);
    [self.contentView addSubview:storeIcon];

    self.storeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(storeIcon.right+3, space, YBLWindowWidth/2-space-3-storeIcon.right, 20)];
    self.storeNameLabel.text = loadString;
    self.storeNameLabel.textColor = BlackTextColor;
    self.storeNameLabel.font = YBLFont(14);
    [self.contentView addSubview:self.storeNameLabel];
    
    self.orderStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.storeNameLabel.right, self.storeNameLabel.top,YBLWindowWidth-self.storeNameLabel.right-space, self.storeNameLabel.height)];
    self.orderStatusLabel.text = loadString;
    self.orderStatusLabel.textColor = YBLThemeColor;
    self.orderStatusLabel.textAlignment = NSTextAlignmentRight;
    self.orderStatusLabel.font = YBLFont(14);
    [self.contentView addSubview:self.orderStatusLabel];
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton.frame = CGRectMake(0, space, 30, 30);
    self.deleteButton.right = YBLWindowWidth-space;
    self.deleteButton.centerY = self.orderStatusLabel.centerY;
    [self.deleteButton setImage:[UIImage imageNamed:@"order_delete"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.deleteButton];
    [self.deleteButton addTarget:self action:@selector(orderDelete:) forControlEvents:UIControlEventTouchUpInside];
    self.deleteButton.hidden = YES;
    
    ///单个商品
    self.singleItemView = [[UIView alloc] initWithFrame:CGRectMake(0, self.storeNameLabel.bottom+space, YBLWindowWidth, 90)];
    self.singleItemView.backgroundColor = YBLColor(247, 247, 247, 1);
    [self.contentView addSubview:self.singleItemView];

    self.goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, self.singleItemView.height-2*space, self.singleItemView.height-2*space)];
    self.goodImageView.layer.cornerRadius = 2;
    self.goodImageView.layer.masksToBounds = YES;
    self.goodImageView.layer.borderColor = YBLLineColor.CGColor;
    self.goodImageView.layer.borderWidth = .5;
    [self.singleItemView addSubview:self.goodImageView];
    
    self.goodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.goodImageView.right+space, self.goodImageView.top, self.singleItemView.width-self.goodImageView.right-space*2, 40)];
    self.goodNameLabel.text = loadString;
    self.goodNameLabel.textColor = BlackTextColor;
    self.goodNameLabel.numberOfLines = 2;
    self.goodNameLabel.font = YBLFont(14);
    [self.singleItemView addSubview:self.goodNameLabel];
    
    self.goodNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.goodNameLabel.left, self.goodNameLabel.bottom, self.goodNameLabel.width, 20)];
    self.goodNumLabel.textColor = YBLTextColor;
    self.goodNumLabel.font = YBLFont(12);
    self.goodNumLabel.text = loadString;
    [self.singleItemView addSubview:self.goodNumLabel];
    
    ///多个商品
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 4;
    CGFloat ccwi = self.singleItemView.height;
    layout.itemSize = CGSizeMake(ccwi, ccwi);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    YBLEvaluatePicCollection *picCollectionView = [[YBLEvaluatePicCollection alloc] initWithFrame:CGRectMake(0, self.singleItemView.top, self.singleItemView.width, ccwi) collectionViewLayout:layout];
    picCollectionView.backgroundColor = YBLColor(247, 247, 247, 1);
    WEAK
    picCollectionView.evaluatePicCollectionDidSelectBlock = ^(NSInteger index,UIImageView *imageView){
        STRONG
        BLOCK_EXEC(self.littlebOrderItemCellDiDSelectBlock,self.orderItemModel,index);
    };
    [self.contentView addSubview:picCollectionView];
    self.picCollectionView = picCollectionView;
    
    
    self.priceCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, self.singleItemView.bottom+space, self.singleItemView.width-2*space, 20)];
    self.priceCountLabel.text = @"共 0 件商品 实付款 : ¥000.00";
    self.priceCountLabel.textColor = BlackTextColor;
    self.priceCountLabel.font = YBLFont(13);
    self.priceCountLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.priceCountLabel];
    
    [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(space, self.priceCountLabel.bottom+space, YBLWindowWidth-space, 0.5)]];
    ///
    CGFloat buttonwi = 80;
    CGFloat buttonhi = 32;
    for (int i = 0; i < 3; i++) {
        UIButton *undefineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        undefineButton.frame = CGRectMake(YBLWindowWidth-(buttonwi+space)*(i+1), self.priceCountLabel.bottom+space*2, buttonwi, buttonhi);
        undefineButton.layer.cornerRadius = 3;
        undefineButton.layer.masksToBounds = YES;
        undefineButton.titleLabel.font = YBLFont(14);
        undefineButton.tag = tag_undefine_button+i;
        [undefineButton setTitleColor:YBLThemeColor forState:UIControlStateNormal];
        undefineButton.layer.borderColor = YBLThemeColor.CGColor;
        undefineButton.layer.borderWidth = .5;
        [undefineButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:undefineButton];
    }
 
    /* Image View */
    self.orderStateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_for_purchase"]];
    self.orderStateImageView.frame = CGRectMake(space, 0, 25, 25);
//    self.orderStateImageView.bottom = 215;
    self.orderStateImageView.top = self.priceCountLabel.bottom+space*2;
    [self.contentView addSubview:self.orderStateImageView];
    self.orderStateImageView.hidden = YES;
    
    self.finishTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, YBLWindowWidth-(buttonwi+space)*3, 15)];
    self.finishTimeLabel.textColor = YBLTextLightColor;
    self.finishTimeLabel.font = YBLFont(12);
    self.finishTimeLabel.bottom = self.orderStateImageView.bottom;
    [self.contentView addSubview:self.finishTimeLabel];
    self.finishTimeLabel.hidden = YES;
    
    self.orderDoneImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_for_fullcomplete"]];
    self.orderDoneImageView.frame = CGRectMake(0, 0, 70,54);
    self.orderDoneImageView.right = self.deleteButton.left-space;
    [self.contentView addSubview:self.orderDoneImageView];
    self.orderDoneImageView.hidden = YES;

}

+ (CGFloat)getlittlebOrderItemCellHi{
    
    return 225;
}

- (void)orderDelete:(UIButton *)btn{
    
    YBLOrderPropertyItemModel *new_itemModel = nil;
    
    for (YBLOrderPropertyItemModel *itemModel in self.orderItemModel.property_order.orderStateCount) {
        if ([itemModel.order_state isEqualToString:@"full_complete"]||[itemModel.order_state isEqualToString:@"canceled"]) {
            new_itemModel = itemModel;
        }
    }
    BLOCK_EXEC(self.littlebOrderItemCellButtonBlock,deleteOrderString,new_itemModel);
}

- (void)buttonClick:(UIButton *)btn{
    
    NSInteger index = btn.tag-tag_undefine_button;
    NSMutableArray *newButtonsArray = [NSMutableArray array];
    [newButtonsArray addObjectsFromArray:self.orderItemModel.property_order.orderStateCount];
    if (self.orderItemModel.property_order.purchaseOrderStateCount>0&&self.orderItemModel.purchase_order) {
        [newButtonsArray addObjectsFromArray:self.orderItemModel.property_order.purchaseOrderStateCount];
    }
    YBLOrderPropertyItemModel *itemModel = newButtonsArray[index];
    NSString *title = btn.currentTitle;
    BLOCK_EXEC(self.littlebOrderItemCellButtonBlock,title,itemModel);
}


- (void)updateOrderItemModel:(YBLOrderItemModel *)model{
    self.orderItemModel = model;
    /* 赋值 */
    self.orderStatusLabel.text = model.state_cn;
    self.priceCountLabel.text = [NSString stringWithFormat:@"共 %ld 件商品 总额 : ¥%.2f",(long)model.item_count.integerValue,model.total.doubleValue];
    self.storeNameLabel.text = model.seller_shopname;

    self.picCollectionView.hidden = YES;
    self.orderStateImageView.hidden = YES;
    /* 按钮 */
    self.orderDoneImageView.hidden = YES;
    self.deleteButton.hidden = YES;
    self.orderStatusLabel.hidden = NO;
    
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
        self.orderStateImageView.hidden = YES;
        if (model.purchase_order) {
            self.orderStateImageView.hidden = NO;
            [self.goodImageView js_alpha_setImageWithURL:[NSURL URLWithString:model.purchase_order.avatar] placeholderImage:smallImagePlaceholder];
            self.goodNumLabel.text = [NSString stringWithFormat:@"X %d%@",model.purchase_order.quantity.intValue,model.purchase_order.unit];
            self.priceCountLabel.text = [NSString stringWithFormat:@"共 %ld 件商品 总额 : ¥%.2f",(long)model.purchase_order.quantity.integerValue,model.total.doubleValue];
            self.goodNameLabel.text = model.purchase_order.title;
    
        } else {
            self.orderStateImageView.hidden = YES;
            lineitems *firstItem = model.line_items[0];
            [self.goodImageView js_alpha_setImageWithURL:[NSURL URLWithString:firstItem.product.avatar_url] placeholderImage:smallImagePlaceholder];
            self.goodNumLabel.text = [NSString stringWithFormat:@"X %d%@",firstItem.quantity.intValue,firstItem.product.unit];
            self.goodNameLabel.text = firstItem.product.title;
        }
    }
    self.orderStatusLabel.textColor = YBLThemeColor;
    self.orderStatusLabel.right = YBLWindowWidth-space;
    NSInteger count = model.property_order.orderStateCount.count;
    NSMutableArray *newButtonsArray = [NSMutableArray array];
    [newButtonsArray addObjectsFromArray:model.property_order.orderStateCount];
    if (model.property_order.purchaseOrderStateCount>0&&model.purchase_order) {
        YBLOrderPropertyItemModel *firstItemModel ;
        if (model.property_order.orderStateCount.count>0) {
            firstItemModel = model.property_order.orderStateCount[0];
        }
        if (model.property_order.orderStateCount.count==1&&[firstItemModel.order_button_title isEqualToString:cancleOrderString]) {
            
        } else {
            count += model.property_order.purchaseOrderStateCount.count;
            [newButtonsArray addObjectsFromArray:model.property_order.purchaseOrderStateCount];
        }
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
                self.deleteButton.hidden = NO;
                self.orderStatusLabel.hidden = YES;
            }
            if ([itemModel.order_state isEqualToString:@"canceled"]) {
                self.orderDoneImageView.hidden = YES;
                self.deleteButton.hidden = NO;
                self.orderStatusLabel.hidden = NO;
                self.orderStatusLabel.textColor = YBLColor(130, 130, 130, 1);
                self.orderStatusLabel.right = self.deleteButton.left-space;
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
        self.orderStateImageView.centerY = self.finishTimeLabel.centerY;
    } else {
        self.finishTimeLabel.hidden = YES;
    }
    
}

@end
