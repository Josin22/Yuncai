//
//  YBLCouponsLabelsCell.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCouponsLabelsCell.h"
#import "YBLGoodDetailCouponsModel.h"

static NSInteger const tag_coupons_label = 21;

static NSInteger const tag_coupons_imageview = 2121;

@interface YBLCouponsLabelsCell ()
{
    NSInteger _couponsCount;
}
@end

@implementation YBLCouponsLabelsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
  
    [self handleTextLabel:@"领券"];
    
    CGFloat couponsHi = 23;
    CGFloat couponsWi = 100;
    CGFloat couponSpace = 5;
    CGFloat lessWi = self.moreButton.left-self.ttLabel.right-space;
    
    _couponsCount = lessWi/(couponsWi+couponSpace);
    NSLog(@"coupons_count:%ld",_couponsCount);

    for (int i = 0 ; i < _couponsCount; i++) {
        UIImageView *couponsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coupons_detail_bg"]];
        couponsImageView.frame = CGRectMake(self.ttLabel.right+5+(couponsWi+couponSpace)*i, 0, couponsWi, couponsHi);
        couponsImageView.centerY = self.ttLabel.centerY;
        couponsImageView.hidden = YES;
        couponsImageView.userInteractionEnabled  = YES;
        couponsImageView.tag = tag_coupons_imageview+i;
        [self.contentView addSubview:couponsImageView];
        UILabel *couponsLabel = [[UILabel alloc] init];
        couponsLabel.frame = [couponsImageView bounds];
        couponsLabel.textAlignment = NSTextAlignmentCenter;
        couponsLabel.textColor = [UIColor whiteColor];
        couponsLabel.font = YBLFont(13);
        couponsLabel.tag = tag_coupons_label+i;
        [couponsImageView addSubview:couponsLabel];
    }
    
}

- (void)updateItemCellModel:(id)itemModel{
 
    NSMutableArray *dataArray = (NSMutableArray *)itemModel;
    if (dataArray.count==0) {
        return;
    }
    for (int i = 0; i < _couponsCount; i++) {
        UIImageView *couponsImageView = (UIImageView *)[self viewWithTag:tag_coupons_imageview+i];
        couponsImageView.hidden = YES;
        UILabel *couponsLabel = (UILabel *)[self viewWithTag:tag_coupons_label+i];
        couponsLabel.text = nil;
        if (i<dataArray.count) {
            YBLGoodDetailCouponsModel *model = dataArray[i];
            couponsImageView.hidden = NO;
            couponsLabel.text = [NSString stringWithFormat:@"满%.1f可用",model.condition.doubleValue];
        }
    }
    
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    return [super getItemCellHeightWithModel:itemModel];
}

@end
