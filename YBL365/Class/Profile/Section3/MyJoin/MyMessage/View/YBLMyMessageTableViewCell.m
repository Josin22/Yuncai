//
//  YBLMyMessageTableViewCell.m
//  YBL365
//
//  Created by 代恒彬 on 2017/1/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMyMessageTableViewCell.h"

@implementation YBLMyMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    CGFloat height = [YBLMyMessageTableViewCell getMyMessageTableViewCellRowHeight];
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(3*space,2*space,height - 4*space, height - 4*space)];
    self.iconImageView.layer.borderColor = YBLLineColor.CGColor;
    self.iconImageView.layer.borderWidth = 0.5;
    self.iconImageView.layer.cornerRadius = 3;
    self.iconImageView.image = [UIImage imageNamed:@"IMG_0589.png"];
    [self.contentView addSubview:self.iconImageView];

    self.productNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImageView.right + 2*space,self.iconImageView.top +space,YBLWindowWidth - 5*space - self.iconImageView.width -100,18)];
    self.productNameLabel.textAlignment = NSTextAlignmentLeft;
    self.productNameLabel.text = @"正牌玛歌庄园红酒1993年2支";
    self.productNameLabel.textColor = BlackTextColor;
    self.productNameLabel.font = YBLFont(15);
    [self.contentView addSubview:self.productNameLabel];
    
    self.focusLabel = [[UILabel alloc]initWithFrame:CGRectMake(YBLWindowWidth - space -100,self.productNameLabel.top+9-6,100, 12)];
    self.focusLabel.textColor = YBLTextColor;
    self.focusLabel.text = @"2981人关注";
    self.focusLabel.font = YBLFont(12);
    self.focusLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.focusLabel];
    
    self.noticelabel = [[UILabel alloc]initWithFrame:CGRectMake(YBLWindowWidth - space -50,self.productNameLabel.bottom + 2*space,50,14)];
    self.noticelabel.textColor = YBLThemeColor;
    self.noticelabel.textAlignment = NSTextAlignmentRight;
    self.noticelabel.text = @"已通知";
    self.noticelabel.font = YBLFont(14);
    [self.contentView addSubview:self.noticelabel];
    
    self.leftTimeView = [[YBLTimeDown alloc]initWithFrame:CGRectMake(self.productNameLabel.left, self.productNameLabel.bottom + 2*space,YBLWindowWidth - 50 -4*space - self.iconImageView.width, 14) WithType:TimeDownTypeText];
    self.leftTimeView.textColor = YBLTextColor;
    self.leftTimeView.textTimerLabel.textAlignment = NSTextAlignmentLeft;
    self.leftTimeView.textTimerLabel.font = YBLFont(14);
    NSString *testTime = @"2017-02-09 9:06:30";
    [self.leftTimeView setEndTime:testTime begainText:@"剩余时间:"];
    [self.contentView addSubview:self.leftTimeView];

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(CGFloat)getMyMessageTableViewCellRowHeight{
    return 115;

}
@end
