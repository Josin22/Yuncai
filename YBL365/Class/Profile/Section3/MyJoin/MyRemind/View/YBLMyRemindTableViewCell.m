//
//  YBLMyRemindTableViewCell.m
//  YBL365
//
//  Created by 代恒彬 on 2017/1/9.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMyRemindTableViewCell.h"
@interface YBLMyRemindTableViewCell()
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *nowPriceLabel;
@property (nonatomic,strong)UILabel *endTimeLabel;
@property (nonatomic,strong)UIButton *remindButton;
@property (nonatomic,strong)UILabel *priceNumberLabel;
@property (nonatomic,assign)BOOL remind;
@end
@implementation YBLMyRemindTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    CGFloat height = [YBLMyRemindTableViewCell getMyRemindCellHeight];
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(space,15,height-15*2,height-15*2)];
    self.iconImageView.layer.cornerRadius = 3;
    self.iconImageView.layer.borderWidth = 0.5;
    self.iconImageView.layer.borderColor = YBLLineColor.CGColor;
    self.iconImageView.image = [UIImage imageNamed:@"56fb4677af48430c06dd06c3.jpg@!avatar.jpeg"];
    [self.contentView addSubview:self.iconImageView];

    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImageView.right + 2*space,15,YBLWindowWidth -4*space-self.iconImageView.width,16)];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.textColor = BlackTextColor;
    self.nameLabel.font = YBLFont(15);
    self.nameLabel.text = @"正牌玛歌庄园红酒1993年2支";
    [self.contentView addSubview:self.nameLabel];
    
    self.nowPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.left,self.nameLabel.bottom + 2*space,80,16)];
    self.nowPriceLabel.textColor = YBLTextColor;
    self.nowPriceLabel.font = YBLFont(15);
    self.nowPriceLabel.text = @"当前价格：";
    self.nowPriceLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.nowPriceLabel];
    
    self.priceNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nowPriceLabel.right,self.nowPriceLabel.top,120,16)];
    self.priceNumberLabel.textAlignment = NSTextAlignmentLeft;
    self.priceNumberLabel.text = @"¥6200";
    self.priceNumberLabel.font = YBLFont(15);
    self.priceNumberLabel.textColor = YBLThemeColor;
    [self.contentView addSubview:self.priceNumberLabel];
    
    
    self.endTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.left,self.nowPriceLabel.bottom + 2*space,250,16)];
    self.endTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.endTimeLabel.textColor = YBLTextColor;
    self.endTimeLabel.font = YBLFont(15);
    self.endTimeLabel.text = @"01月07日22:00结束";
    [self.contentView addSubview:self.endTimeLabel];
    
    self.remindButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.remindButton setFrame:CGRectMake(YBLWindowWidth -space-90,self.nameLabel.bottom + space,90, 35)];
    self.remindButton.layer.cornerRadius = 3;
    self.remindButton.layer.borderWidth = 1;
    self.remindButton.layer.borderColor = YBLColor(147, 139, 222, 1).CGColor;
    self.remindButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.remindButton setTitle:@"提醒我" forState:UIControlStateNormal];
    self.remindButton.titleLabel.font = YBLFont(15);
    [self.remindButton setTitleColor:YBLColor(147, 139, 222, 1) forState:UIControlStateNormal];
    [self.remindButton addTarget:self action:@selector(remindButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.remind = NO;
    [self.contentView addSubview:self.remindButton];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(space,height-0.5,YBLWindowWidth-space,0.5)];
    line.backgroundColor = YBLLineColor;
    [self.contentView addSubview:line];
    
}
- (void)remindButtonClicked:(UIButton*)button{
    NSLog(@"提醒我");
    if (self.remind == NO) {
        [self.remindButton setTitleColor:YBLColor(216,127, 128, 1) forState:UIControlStateNormal];
        [self.remindButton setTitle:@"取消提醒" forState:UIControlStateNormal];
        self.remindButton.layer.borderColor = YBLColor(216,127, 128, 1).CGColor;
    }else{
    self.remindButton.layer.borderColor = YBLColor(147, 139, 222, 1).CGColor;
    [self.remindButton setTitle:@"提醒我" forState:UIControlStateNormal];
    [self.remindButton setTitleColor:YBLColor(147, 139, 222, 1) forState:UIControlStateNormal];
    }
    self.remind = !self.remind;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
+ (CGFloat)getMyRemindCellHeight{
    
    return 130;
}
@end
