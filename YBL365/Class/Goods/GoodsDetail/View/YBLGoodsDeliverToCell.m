//
//  YBLGoodsDeliverToCell.m
//  YBL365
//
//  Created by 乔同新 on 12/24/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLGoodsDeliverToCell.h"
#import "YBLAddressModel.h"

@interface YBLGoodsDeliverToCell ()

@property (nonatomic, retain) UILabel *addressInfoLabel;

@end

@implementation YBLGoodsDeliverToCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createDeliverToUI];
    }
    return self;
}

- (void)createDeliverToUI{
    
    NSString *labelText = @"送至";
    [self handleTextLabel:labelText];
    
    _addressButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    _addressButton.frame = CGRectMake(self.ttLabel.right+5, self.ttLabel.top, YBLWindowWidth-self.ttLabel.right-5-5-30, self.ttLabel.height);
    _addressButton.titleRect = CGRectMake(self.ttLabel.height+3, 0, YBLWindowWidth-self.ttLabel.right-5-5-30-self.ttLabel.height-3, self.ttLabel.height);
    _addressButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_addressButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [_addressButton setImage:[UIImage imageNamed:@"orderMM_location"] forState:UIControlStateNormal];
    _addressButton.imageRect = CGRectMake(0, 0, self.ttLabel.height-3, self.ttLabel.height);
    _addressButton.titleRect = CGRectMake(self.ttLabel.height+3, 0, YBLWindowWidth-CGRectGetMaxX(self.ttLabel.frame)-5-5-30-self.ttLabel.height*2-3-3, self.ttLabel.height);
    _addressButton.titleLabel.font = YBLFont(14);
    [self.contentView addSubview:_addressButton];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.ttLabel.frame),self.ttLabel.bottom+space,self.ttLabel.width,self.ttLabel.height)];
    label1.text  = @"毛重";
    label1.textColor = YBLTextColor;
    label1.font = YBLFont(13);
    [self.contentView addSubview:label1];
    
    _kgLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame)+5, CGRectGetMinY(label1.frame), 200, label1.height)];
    _kgLabel.text = @"0.0kg";
    _kgLabel.font = YBLFont(13);
    [self.contentView addSubview:_kgLabel];
    

}

- (void)updateItemCellModel:(id)itemModel{
    
    YBLAddressModel *selectAddressModel = (YBLAddressModel *)itemModel;
    if (selectAddressModel) {
        [self.addressButton setTitle:selectAddressModel.full_address forState:UIControlStateNormal];
    } else {
        [self.addressButton setTitle:@"请添加默认收货地址" forState:UIControlStateNormal];
    }
}


+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    
    YBLAddressModel *selectAddressModel = (YBLAddressModel *)itemModel;
    if (selectAddressModel) {
//        CGSize addressSize = [selectAddressModel.full_address heightWithFont:YBLFont(14) MaxWidth:<#(float)#>];
        return 65;
    } else {
        
        return 65;
    }
}

@end
