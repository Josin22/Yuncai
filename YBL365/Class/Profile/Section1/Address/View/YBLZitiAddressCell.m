//
//  YBLZitiAddressCell.m
//  YC168
//
//  Created by 乔同新 on 2017/4/12.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLZitiAddressCell.h"
#import "YBLAddressModel.h"

@interface YBLZitiAddressCell ()

@property (nonatomic, retain) UILabel *isDefaultLabel;

@property (nonatomic, retain) UILabel *nameLabel;

@property (nonatomic, retain) UILabel *phoneLabel;

@property (nonatomic, retain) UILabel *fullAddressLabel;

@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *lineView1;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation YBLZitiAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat selectButtonWi = 30;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 70)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:topView];
    self.topView = topView;
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 5, 100, 30)];
    self.nameLabel.textColor = BlackTextColor;
    self.nameLabel.textColor = YBLColor(70, 70, 70, 1.0);
    self.nameLabel.font = YBLFont(16);
    [topView addSubview:self.nameLabel];
    
    self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.right+space, self.nameLabel.top, 100, self.nameLabel.height)];
    self.phoneLabel.textColor = BlackTextColor;
    self.phoneLabel.textColor = YBLColor(70, 70, 70, 1.0);
    self.phoneLabel.font = YBLFont(16);
    [topView addSubview:self.phoneLabel];
    
    self.fullAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.left, self.nameLabel.bottom, topView.width-space*2-selectButtonWi, topView.height-self.nameLabel.height)];
    self.fullAddressLabel.textColor = YBLColor(100, 100, 100, 1.0);
    self.fullAddressLabel.font = YBLFont(14);
    self.fullAddressLabel.numberOfLines = 0;
    [topView addSubview:self.fullAddressLabel];
    
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectButton.frame = CGRectMake(0, 0, selectButtonWi, selectButtonWi);
    self.selectButton.right = topView.width-space;
    self.selectButton.centerY = topView.height/2;
    [self.selectButton setImage:[UIImage imageNamed:@"syncart_round_check1New"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"syncart_round_check2New"] forState:UIControlStateSelected];
//    self.selectButton.enabled = NO;
    [topView addSubview:self.selectButton];

    UIView *line1View = [YBLMethodTools addLineView:CGRectMake(space, topView.height-.5, topView.width, .5)];
    [topView addSubview:line1View];
    self.lineView1 = line1View;

    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.bottom, topView.width, 40)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bottomView];
    self.bottomView = bottomView;
    
    self.isDefaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 5, 50, 20)];
    self.isDefaultLabel.layer.cornerRadius = 3;
    self.isDefaultLabel.layer.masksToBounds = YES;
    self.isDefaultLabel.backgroundColor = YBLThemeColor;
    self.isDefaultLabel.text = @"默认";
    self.isDefaultLabel.centerY = bottomView.height/2;
    self.isDefaultLabel.textColor = [UIColor whiteColor];
    self.isDefaultLabel.textAlignment = NSTextAlignmentCenter;
    self.isDefaultLabel.font = YBLFont(13);
    [bottomView addSubview:self.isDefaultLabel];
    
    //
    CGFloat imageWi = 20;
    
    self.deleteButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton.frame = CGRectMake(0, 0, buttonHeight*2, buttonHeight);
    self.deleteButton.right = bottomView.width;
    self.deleteButton.centerY = bottomView.height/2;
    [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:YBLTextColor forState:UIControlStateNormal];
    [self.deleteButton setImage:[UIImage imageNamed:@"order_delete"] forState:UIControlStateNormal];
    self.deleteButton.titleLabel.font = YBLFont(13);
    self.deleteButton.titleRect = CGRectMake(imageWi+3, 0, buttonHeight*2-(imageWi+3), buttonHeight);
    self.deleteButton.imageRect = CGRectMake(0, (buttonHeight-imageWi)/2, imageWi, imageWi);
    [bottomView addSubview:self.deleteButton];
    
    self.editButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    self.editButton.frame = CGRectMake(0, 0, buttonHeight*2, buttonHeight);
    self.editButton.right = self.deleteButton.left;
    self.editButton.centerY = bottomView.height/2;
    [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editButton setTitleColor:YBLTextColor forState:UIControlStateNormal];
    self.editButton.titleLabel.font = YBLFont(13);
    [self.editButton setImage:[UIImage imageNamed:@"order_address_edit_19x19_"] forState:UIControlStateNormal];
    self.editButton.titleRect = CGRectMake(imageWi+3, 0, buttonHeight*2-(imageWi+3), buttonHeight);
    self.editButton.imageRect = CGRectMake(0, (buttonHeight-imageWi)/2, imageWi, imageWi);
    [bottomView addSubview:self.editButton];
    
    UIView *lineView = [YBLMethodTools addLineView:CGRectMake(0, bottomView.height-.5, bottomView.width, 0.5)];
    [bottomView addSubview:lineView];
    self.lineView = lineView;
}

- (void)updateItemCellModel:(id)itemModel{
    
    YBLAddressModel *model = (YBLAddressModel *)itemModel;
    self.isDefaultLabel.hidden = !model._default.boolValue;
    self.nameLabel.text = model.consignee_name;
    self.phoneLabel.text = model.consignee_phone;
    self.fullAddressLabel.height = self.height-self.bottomView.height-self.nameLabel.height;
    self.topView.height = self.fullAddressLabel.bottom;
    self.lineView1.bottom = self.topView.height;
    self.bottomView.top = self.topView.bottom;
    self.fullAddressLabel.text = model.full_address;
    self.selectButton.selected = model.is_select;
    CGSize nameSize = [model.consignee_name heightWithFont:YBLFont(16) MaxWidth:YBLWindowWidth];
    self.nameLabel.width = nameSize.width+space;
    self.phoneLabel.left = self.nameLabel.right;
    self.phoneLabel.width = YBLWindowWidth-self.nameLabel.right-self.selectButton.width-2*space;
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    
    YBLAddressModel *model = (YBLAddressModel *)itemModel;
    
    return 70+model.text_height+space;
}

@end
