//
//  YBLPayshipmentCell.m
//  YC168
//
//  Created by 乔同新 on 2017/3/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPayshipmentCell.h"
#import "lineitems.h"
#import "YBLPayshipmentItemButtonCollectionView.h"


@interface YBLPayshipmentCell()

@property (nonatomic, strong) UIImageView *goodImageView;

@property (nonatomic, strong) YBLPayshipmentItemButtonCollectionView *wayCollectionView;

@property (nonatomic, strong) lineitems *lineitems;

@end

@implementation YBLPayshipmentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, 80, 80)];
    self.goodImageView.layer.borderColor = YBLLineColor.CGColor;
    self.goodImageView.layer.cornerRadius = 3;
    self.goodImageView.layer.masksToBounds = YES;
    self.goodImageView.layer.borderWidth = .5;
    [self.contentView addSubview:self.goodImageView];
    
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake((YBLWindowWidth-space)/4, 30);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, space);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.headerReferenceSize = CGSizeZero;
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.wayCollectionView = [[YBLPayshipmentItemButtonCollectionView alloc] initWithFrame:CGRectMake(0, self.goodImageView.bottom+space, YBLWindowWidth, 30)
                                                                      collectionViewLayout:layout
                                                                 payShipMentItemButtonType:PayShipMentItemButtonTypeTakeOrderChooseMent];
    WEAK
    self.wayCollectionView.payshipmentItemButtonCollectionViewButtonClickBlock = ^(id select_model,NSInteger index,BOOL isDefault) {
        STRONG
        BLOCK_EXEC(self.payshipmentCellButtonClickBlock,select_model,index)

    };
    [self.contentView addSubview:self.wayCollectionView];
    
}



- (void)updateModel:(lineitems *)model{
    _lineitems = model;
    
    if (_wayType == WayTypePay) {
        self.wayCollectionView.dataArray = model.product.filter_product_payment_methods;
    } else {
        self.wayCollectionView.dataArray = model.product.filter_product_shiping_methods;
    }
    [self.goodImageView js_alpha_setImageWithURL:[NSURL URLWithString:model.product.avatar_url] placeholderImage:smallImagePlaceholder];

}


+ (CGFloat)getHi{
    
    return 140;
}

@end
