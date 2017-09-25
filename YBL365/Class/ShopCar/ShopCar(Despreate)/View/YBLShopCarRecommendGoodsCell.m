//
//  YBLShopCarGoodsCell.m
//  YBL365
//
//  Created by 乔同新 on 16/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLShopCarRecommendGoodsCell.h"
#import "YBLHomeRecommendGoodCell.h"
#import "YBLCategoryItemCell.h"

@interface YBLShopCarRecommendGoodsCell ()

@property (nonatomic, strong) YBLCategoryItemCell *leftGood;
@property (nonatomic, strong) YBLCategoryItemCell *rightGood;

@end

@implementation YBLShopCarRecommendGoodsCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createGoodsView];
        self.backgroundColor = VIEW_BASE_COLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (void)createGoodsView {
    CGFloat itemHeight = [YBLShopCarRecommendGoodsCell getCellHi]-5;
    self.leftGood = [[YBLCategoryItemCell alloc] initWithFrame:CGRectMake(5, 5, (YBLWindowWidth-15)/2,itemHeight)];
//    self.leftGood.carButton.hidden = NO;
//    self.leftGood.goodButton.hidden = YES;
    self.rightGood = [[YBLCategoryItemCell alloc] initWithFrame:CGRectMake(self.leftGood.right+5, self.leftGood.top, self.leftGood.width, itemHeight)];
//    self.rightGood.carButton.hidden = NO;
//    self.rightGood.goodButton.hidden = YES;
    [self addSubview:self.leftGood];
    [self addSubview:self.rightGood];
//    [[self.leftGood.carButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        [[YBLShopCarModel shareInstance] addGoodToCar:nil];
//        SVPSHOWSUCCESS(@"加入购物车成功");
//        NOSHOWSVP(1.0);
//    }];
//    [[self.rightGood.carButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        [[YBLShopCarModel shareInstance] addGoodToCar:nil];
//        SVPSHOWSUCCESS(@"加入购物车成功");
//        NOSHOWSVP(1.0);
//    }];
//    
}

- (void)updateWithLeftGood:(id)leftGood rightGood:(id)rightGood {
    [self.leftGood updateWithGood:leftGood];
    [self.rightGood updateWithGood:rightGood];
}


+ (CGFloat)getCellHi{
    CGFloat hi = (YBLWindowHeight-64-49-50)/2;
    return hi;
}

- (void)dealloc {
    NSLog(@"%@-dealloc",[self class]);
}

@end
