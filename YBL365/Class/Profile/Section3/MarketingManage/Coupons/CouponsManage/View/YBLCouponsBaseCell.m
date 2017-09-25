//
//  YBLCouponsBaseCell.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCouponsBaseCell.h"

@implementation YBLCouponsBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCouponsBaseCellUI];
    }
    return self;
}

- (void)createCouponsBaseCellUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentView.backgroundColor = YBLColor(243, 243, 243, 1);

    CGFloat cellHi = [YBLCouponsBaseCell getItemCellHeightWithModel:nil];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, YBLWindowWidth-2*space, cellHi-space*2)];
    bgImageView.userInteractionEnabled = YES;
    //    bgImageView.image = [UIImage imageNamed:@"Coupons_enable_bg"];
    [self.contentView addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
}

- (void)updateItemCellModel:(id)itemModel{

   
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    UIImage *couponsImage = [UIImage imageNamed:@"Coupons_enable_bg"];
    CGFloat otherHi = space*2;
    if ([itemModel isKindOfClass:[NSString class]]) {
        couponsImage = [UIImage imageNamed:itemModel];
        otherHi = space;
    }
    CGFloat couponsImageHi = (double)YBLWindowWidth*(couponsImage.size.height/couponsImage.size.width);
    return couponsImageHi+otherHi;
}

@end
