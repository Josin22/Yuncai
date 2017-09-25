//
//  YBLSelectZitiAddressCell.m
//  YC168
//
//  Created by 乔同新 on 2017/4/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSelectZitiAddressCell.h"
#import "YBLAddressModel.h"

@interface YBLSelectZitiAddressCell ()

@property (nonatomic, retain) UILabel *nameLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, retain) UILabel *phoneLabel;


@end

@implementation YBLSelectZitiAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 5, 100, 30)];
    self.nameLabel.textColor = BlackTextColor;
    self.nameLabel.textColor = YBLColor(70, 70, 70, 1.0);
    self.nameLabel.font = YBLFont(16);
    [self.contentView addSubview:self.nameLabel];
    
    self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.right+space, self.nameLabel.top, 100, self.nameLabel.height)];
    self.phoneLabel.textColor = BlackTextColor;
    self.phoneLabel.textColor = YBLColor(70, 70, 70, 1.0);
    self.phoneLabel.font = YBLFont(16);
    [self.contentView addSubview:self.phoneLabel];
    
    CGFloat buwwi = YBLWindowWidth-2*space-40;
    CGFloat buwhi = 40;
    
    self.fullAddressButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    self.fullAddressButton.frame = CGRectMake(space, self.nameLabel.bottom, buwwi, buwhi);
    [self.fullAddressButton setTitleColor:YBLColor(170, 170, 170, 1) forState:UIControlStateNormal];
    [self.fullAddressButton setImage:[UIImage imageNamed:@"orderMM_location"] forState:UIControlStateNormal];
    self.fullAddressButton.titleLabel.font = YBLFont(14);
    self.fullAddressButton.titleLabel.numberOfLines = 0;
    self.fullAddressButton.userInteractionEnabled = NO;
    self.fullAddressButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.fullAddressButton.imageRect = CGRectMake(0, (buwhi-17)/2, 13, 17);
    self.fullAddressButton.titleRect = CGRectMake(17, 0, buwwi-17, buwhi);
    [self.contentView addSubview:self.fullAddressButton];
    
    UIImageView *duihaoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"duihao_map"]];
    duihaoImageView.frame = CGRectMake(0, 0, 20, 20);
    duihaoImageView.right = YBLWindowWidth-space;
    [self.contentView addSubview:duihaoImageView];
    self.duihaoImageView = duihaoImageView;
    
    UIView *lineView = [YBLMethodTools addLineView:CGRectMake(0, self.fullAddressButton.bottom, YBLWindowWidth-2*space, .5)];
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
}

- (void)updateItemCellModel:(id)itemModel{
    
    YBLAddressModel *model = (YBLAddressModel *)itemModel;
    self.duihaoImageView.centerY = self.height/2;
    self.nameLabel.text = model.consignee_name;
    self.phoneLabel.text = model.consignee_phone;
    [self.fullAddressButton setTitle:model.full_address forState:UIControlStateNormal];
    CGFloat lessHeight  = self.height-self.nameLabel.bottom;;
    self.fullAddressButton.height = lessHeight;
    CGFloat imageHi = 40;
    if (self.duihaoImageView.hidden) {
        imageHi = 0;
    }
    self.fullAddressButton.titleRect = CGRectMake(17, 0, self.width-2*space-17-imageHi, lessHeight);
    self.fullAddressButton.imageRect = CGRectMake(0, (lessHeight-17)/2, 13, 17);
    self.lineView.bottom = self.height;
    CGSize nameSize = [model.consignee_name heightWithFont:YBLFont(16) MaxWidth:YBLWindowWidth];
    self.nameLabel.width = nameSize.width+space;
    self.phoneLabel.left = self.nameLabel.right;
    self.phoneLabel.width = self.width-self.nameLabel.right-2*space;

}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    YBLAddressModel *model = (YBLAddressModel *)itemModel;
    return 35+model.text_height+5;
}


@end
