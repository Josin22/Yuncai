//
//  YBLOrderAddressCell.m
//  YBL365
//
//  Created by 乔同新 on 16/12/24.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLOrderAddressCell.h"
#import "YBLAddressModel.h"

@interface YBLOrderAddressCell ()

@property (nonatomic, strong) UILabel *namePhoneLabel;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *lineViewMiddel;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIView *lineViewBottom;

@end

@implementation YBLOrderAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self createSubViews];
    }
    return self;
}

-(void)createSubViews {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.namePhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 5, YBLWindowWidth-2*space, 17)];
    self.namePhoneLabel.font = YBLBFont(16);
    self.namePhoneLabel.textColor = BlackTextColor;
    [self.contentView addSubview:self.namePhoneLabel];
    
    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.namePhoneLabel.left, self.namePhoneLabel.bottom+5, self.namePhoneLabel.width, 20)];
    self.addressLabel.numberOfLines = 0;
    self.addressLabel.textColor = YBLTextColor;
    self.addressLabel.font = YBLFont(14);
    [self.contentView addSubview:self.addressLabel];

    self.lineViewMiddel = [YBLMethodTools addLineView:CGRectMake(space, self.addressLabel.bottom, YBLWindowWidth-space, .5)];
    [self.contentView addSubview:self.lineViewMiddel];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.lineViewMiddel.bottom, YBLWindowWidth, 40)];
    [self.contentView addSubview:bottomView];
    self.bottomView = bottomView;
    //设为默认 编辑 删除
    self.defaultButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    self.defaultButton.frame = CGRectMake(space, 0, 100, bottomView.height);
    [self.defaultButton setImage:[UIImage imageNamed:@"syncart_round_check1New"] forState:UIControlStateNormal];
    [self.defaultButton setImage:[UIImage imageNamed:@"syncart_round_check2New"] forState:UIControlStateSelected];
    [self.defaultButton setTitle:@"设为默认" forState:UIControlStateNormal];
    [self.defaultButton setTitle:@"默认地址" forState:UIControlStateSelected];
    self.defaultButton.titleRect = CGRectMake(25, 0, self.defaultButton.width-25, self.defaultButton.height);
    self.defaultButton.imageRect = CGRectMake(0, 10, 20, 20);
    self.defaultButton.titleLabel.font = YBLFont(14);
    [self.defaultButton setTitleColor:YBLColor(90, 90, 90, 1) forState:UIControlStateNormal];
    [bottomView addSubview:self.defaultButton];
    
    CGFloat buttonWi = 60;
    
    self.editButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    self.editButton.frame = CGRectMake(0, 0, buttonWi, bottomView.height);
    [self.editButton setImage:[UIImage imageNamed:@"address_edit"] forState:UIControlStateNormal];
    [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
    self.editButton.titleRect = CGRectMake(25, 0, self.editButton.width-25, self.deleteButton.height);
    self.editButton.imageRect = CGRectMake(0, 10, 20, 20);
    self.editButton.titleLabel.font = YBLFont(14);
    [self.editButton setTitleColor:YBLColor(90, 90, 90, 1) forState:UIControlStateNormal];
    [bottomView addSubview:self.editButton];
    
    self.deleteButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton.frame = CGRectMake(0, 0, buttonWi, bottomView.height);
    [self.deleteButton setImage:[UIImage imageNamed:@"order_delete"] forState:UIControlStateNormal];
    [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    self.deleteButton.titleLabel.font = YBLFont(14);
    [self.deleteButton setTitleColor:YBLColor(90, 90, 90, 1) forState:UIControlStateNormal];
    self.deleteButton.right = bottomView.width-space;
    self.editButton.right = self.deleteButton.left-space;
    self.deleteButton.titleRect = CGRectMake(25, 0, self.deleteButton.width-25, self.deleteButton.height);
    self.deleteButton.imageRect = CGRectMake(0, 10, 20, 20);
    [bottomView addSubview:self.deleteButton];

    self.lineViewBottom = [YBLMethodTools addLineView:CGRectMake(0, self.bottomView.height-.5, self.bottomView.width, .5)];
    [self.bottomView addSubview:self.lineViewBottom];
}

- (void)updateItemCellModel:(id)itemModel{
    
    YBLAddressModel *model = (YBLAddressModel *)itemModel;
    self.namePhoneLabel.text = [NSString stringWithFormat:@"%@    %@",model.consignee_name,model.consignee_phone];
    self.addressLabel.text = model.full_address;
    self.defaultButton.selected = model._default.boolValue;
    self.addressLabel.height = self.height-self.namePhoneLabel.bottom-5-self.bottomView.height;
    self.lineViewMiddel.top = self.addressLabel.bottom;
    self.bottomView.top = self.lineViewMiddel.bottom;
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    
    YBLAddressModel *model = (YBLAddressModel *)itemModel;
    return model.text_height+40+27;
}

@end
