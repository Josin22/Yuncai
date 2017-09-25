//
//  YBLProductShareManageCell.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLProductShareManageCell.h"
#import "YBLProductShareModel.h"

@implementation YBLProductShareManageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createProductShareManageCellUI];
    }
    return self;
}

- (void)createProductShareManageCellUI{
    
    self.addToStoreButton.hidden = YES;
    self.saleCountName.font = YBLFont(12);
    
    UILabel *total_per_label = [[UILabel alloc] initWithFrame:CGRectMake(self.goodNameLabel.left, self.goodNameLabel.bottom+space, self.goodNameLabel.width, self.saleCountName.height)];
    total_per_label.font = YBLFont(12);
    total_per_label.textColor = YBLTextColor;
    [self.contentView addSubview:total_per_label];
    self.total_per_label = total_per_label;

    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.saleCountName.top, 80, self.saleCountName.height)];
    stateLabel.right = YBLWindowWidth-space;
    stateLabel.font = YBLFont(12);
    stateLabel.textColor = YBLTextColor;
    stateLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:stateLabel];
    self.stateLabel = stateLabel;
    
}

- (void)updateItemCellModel:(id)itemModel{

    YBLProductShareModel *model = (YBLProductShareModel *)itemModel;
    self.goodArrowImageView.centerY = self.height/2;
    [self.goodImageView js_alpha_setImageWithURL:[NSURL URLWithString:model.product.avatar_url] placeholderImage:smallImagePlaceholder];
    self.goodNameLabel.text = model.product.title;
    self.total_per_label.text = model.han_total_per;
    self.saleCountName.text = model.han_shared_visit_count;
    self.stateLabel.text = model.han_status;
}

@end
