//
//  YBLBriberyItemCell.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLBriberyItemCell.h"

@implementation YBLBriberyItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.briberyMoenyView = [[YBLBriberyItemView alloc] initWithFrame:CGRectMake(space*3, 0, YBLWindowWidth-space*6, itemViewHI)];
    [self.contentView addSubview:self.briberyMoenyView];
    
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    return itemViewHI;
}

- (void)updateItemCellModel:(id)itemModel{
    YBLUserInfoModel *userInfoModel = (YBLUserInfoModel *)itemModel;
    self.briberyMoenyView.briberyInfoLabel.text = userInfoModel.shopname;
    if (userInfoModel.follow_state.boolValue) {
        self.briberyMoenyView.briberyType = BriberyTypeReceived;
    } else {
        self.briberyMoenyView.briberyType = BriberyTypeNormal;
    }
}

@end
