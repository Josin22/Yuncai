//
//  YBLGoodsDetailInfoCell.m
//  YBL365
//
//  Created by 乔同新 on 12/24/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLGoodsDetailInfoCell.h"
#import "YBLGoodModel.h"

@interface YBLGoodsDetailInfoCell ()


@end

@implementation YBLGoodsDetailInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createGoodsDetailUI];
    }
    return self;
}

- (void)createGoodsDetailUI{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _goodsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, space/2, YBLWindowWidth-space*2, 40)];
    _goodsTitleLabel.numberOfLines = 2;
    _goodsTitleLabel.font = YBLFont(16);
    _goodsTitleLabel.textColor = YBLColor(40, 40, 40, 1);
    [self addSubview:_goodsTitleLabel];
    
    _goodsInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_goodsTitleLabel.frame), CGRectGetMaxY(_goodsTitleLabel.frame), _goodsTitleLabel.width, 0)];
    _goodsInfoLabel.textColor = YBLThemeColor;
    _goodsInfoLabel.numberOfLines = 0;
    _goodsInfoLabel.font = YBLFont(11);
    [self addSubview:_goodsInfoLabel];
    

}

- (void)updateItemCellModel:(id)itemModel{
    
    YBLGoodModel *goodModel = (YBLGoodModel *)itemModel;
    _goodsTitleLabel.text = goodModel.title;
    _goodsInfoLabel.text = goodModel.self_description;
    CGSize titleSize = [goodModel.title heightWithFont:YBLFont(17) MaxWidth:YBLWindowWidth-2*space];
    CGSize textSize = [goodModel.self_description heightWithFont:YBLFont(12) MaxWidth:YBLWindowWidth-2*space];
    _goodsTitleLabel.height = titleSize.height;
    _goodsInfoLabel.top = _goodsTitleLabel.bottom;
    _goodsInfoLabel.height = textSize.height;
}


+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    
    YBLGoodModel *goodModel = (YBLGoodModel *)itemModel;
    CGSize titleSize = [goodModel.title heightWithFont:YBLFont(17) MaxWidth:YBLWindowWidth-2*space];
    CGSize textSize = [goodModel.self_description heightWithFont:YBLFont(12) MaxWidth:YBLWindowWidth-2*space];
    return titleSize.height+textSize.height+space;
}

@end
