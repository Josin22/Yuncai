//
//  YBLStaffManageCell.m
//  YC168
//
//  Created by 乔同新 on 2017/4/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStaffManageCell.h"
#import "YBLStaffManageModel.h"

@interface YBLStaffManageCell ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, retain) UILabel *manNameLabel;

@property (nonatomic, retain) UILabel *phoneLabel;

@property (nonatomic, retain) UILabel *timeLabel;

@end

@implementation YBLStaffManageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat hei = [YBLStaffManageCell getItemCellHeightWithModel:nil];
    CGFloat imageWi = hei-2*space;
    CGFloat buttonWi = 30;
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, imageWi, imageWi)];
    iconImageView.image = [UIImage imageNamed:smallImagePlaceholder];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UILabel *manNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImageView.right+space, 5, YBLWindowWidth-iconImageView.right-2*space-buttonWi, 30)];
    manNameLabel.font = YBLFont(14);
    manNameLabel.textColor = BlackTextColor;
    [self.contentView addSubview:manNameLabel];
    self.manNameLabel = manNameLabel;
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(manNameLabel.left, manNameLabel.bottom, manNameLabel.width/2, 15)];
    phoneLabel.textColor = BlackTextColor;
    phoneLabel.font = YBLFont(14);
    phoneLabel.bottom = iconImageView.bottom;
    [self.contentView addSubview:phoneLabel];
    self.phoneLabel = phoneLabel;
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, phoneLabel.top, YBLWindowWidth-phoneLabel.right, phoneLabel.height)];
    timeLabel.textColor = YBLTextColor;
    timeLabel.font = YBLFont(12);
    timeLabel.right = YBLWindowWidth-space;
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.bottom = phoneLabel.bottom;
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(YBLWindowWidth-space-buttonWi, space, buttonWi, buttonWi);
//    editButton.centerY = hei/2;
    [editButton setImage:[UIImage imageNamed:@"staff_edit"] forState:UIControlStateNormal];
    [self.contentView addSubview:editButton];
    self.editButton = editButton;

    [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(manNameLabel.left, hei-0.5, YBLWindowWidth-manNameLabel.left, 0.5)]];
}

- (void)updateItemCellModel:(id)itemModel{
    
    YBLStaffManageModel *staffModel = (YBLStaffManageModel *)itemModel;
    if (staffModel.avatar.length>0) {
        [self.iconImageView js_alpha_setImageWithURL:[NSURL URLWithString:staffModel.avatar] placeholderImage:smallImagePlaceholder];   
    }
    self.phoneLabel.text = staffModel.mobile;
    self.timeLabel.text = staffModel.created_at;
    NSString *roleName = [YBLMethodTools getStaffRoleNamesWithArray:staffModel.role_names];
    NSString *manName = [NSString stringWithFormat:@"%@(%@)",staffModel.name,roleName];
    self.manNameLabel.text = manName;
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    
    return 80;
}

@end
