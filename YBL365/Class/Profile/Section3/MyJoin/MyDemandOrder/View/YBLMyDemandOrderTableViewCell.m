//
//  YBLMyDemandOrderTableViewCell.m
//  YBL365
//
//  Created by 代恒彬 on 2017/1/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMyDemandOrderTableViewCell.h"

@implementation YBLMyDemandOrderTableViewCell

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
- (void)createUI{
    CGFloat heigth = [YBLMyDemandOrderTableViewCell getMyDemandOrderCellHeight];
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(space,space,100,100)];
    self.iconImageView.layer.cornerRadius = 3;
    self.iconImageView.layer.borderWidth = 0.5;
    self.iconImageView.layer.borderColor = YBLLineColor.CGColor;
    self.iconImageView.image = [UIImage imageNamed:@"IMG_0591.png"];
    [self.contentView addSubview:self.iconImageView];
    
    self.productnameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImageView.right + 2*space,space,YBLWindowWidth - self.iconImageView.width - 4*space , 16)];
    self.productnameLabel.textColor = BlackTextColor;
    self.productnameLabel.textAlignment = NSTextAlignmentLeft;
    self.productnameLabel.text = @"正牌玛歌庄园红酒1993年2支";
    self.productnameLabel.font = YBLFont(15);
    [self.contentView addSubview:self.productnameLabel];
    
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.productnameLabel.left,self.productnameLabel.bottom + space,150,16)];
    self.priceLabel.font = YBLFont(15);
    NSString *price = @"¥kNavigationbarHeight22.00";
    self.priceLabel.attributedText = [self changeLabelWithText:price];
    self.priceLabel.textAlignment = NSTextAlignmentLeft;
    self.priceLabel.textColor = YBLThemeColor;
    [self.contentView addSubview:self.priceLabel];
    
    self.remainingTime = [[YBLTimeDown alloc]initWithFrame:CGRectMake(self.productnameLabel.left,self.priceLabel.bottom +1.5*space, 200, 12)WithType:TimeDownTypeText];
    self.remainingTime.textColor = YBLColor(113, 194,85, 1);
    self.remainingTime.textTimerLabel.textAlignment = NSTextAlignmentLeft;
    self.remainingTime.textTimerLabel.font = YBLFont(10);
    NSString *testTime = @"2017-02-09 9:06:30";
    [self.remainingTime setEndTime:testTime begainText:@"剩余时间:"];
    [self.contentView addSubview:self.remainingTime];
    
    self.remainPricelabel = [[UILabel alloc]initWithFrame:CGRectMake(self.productnameLabel.left,self.remainingTime.bottom+space*1.5,100, 12)];
    self.remainPricelabel.textColor = YBLTextColor;
    self.remainPricelabel.textAlignment = NSTextAlignmentLeft;
    self.remainPricelabel.text = @"需求价格：5565.00";
    self.remainPricelabel.font =YBLFont(10);
    [self.contentView addSubview:self.remainPricelabel];
    
    self.lowPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.remainPricelabel.right,self.remainPricelabel.top,90,12)];
    self.lowPriceLabel.textAlignment = NSTextAlignmentLeft;
    self.lowPriceLabel.textColor = YBLTextColor;
    self.lowPriceLabel.text = @"参标底价:5341.00";
    self.lowPriceLabel.font =YBLFont(10);
    [self.contentView addSubview:self.lowPriceLabel];
    
    self.arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.lowPriceLabel.right, self.lowPriceLabel.top+6-5,10, 10)];
    self.arrowImageView.image = [UIImage imageNamed:@"myjoinArrow2"];
    [self.contentView addSubview:self.arrowImageView];
    
    self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.payButton setFrame:CGRectMake(YBLWindowWidth - space*1.5-60,self.productnameLabel.bottom + space ,60, 25)];
    self.payButton.layer.borderColor = YBLLineColor.CGColor;
    self.payButton.layer.borderWidth = 0.5;
    self.payButton.layer.cornerRadius = 2;
    [self.payButton setTitle:@"已支付" forState:UIControlStateNormal];
    [self.payButton setTitleColor:YBLTextColor forState:UIControlStateNormal];
    self.payButton.titleLabel.font = YBLFont(13);
    [self.payButton addTarget:self action:@selector(payClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.payButton];
    
    self.numberOfParticipateLabel = [[UILabel alloc]initWithFrame:CGRectMake(YBLWindowWidth - 200- space,self.lowPriceLabel.bottom,200,12)];
    self.numberOfParticipateLabel.textColor = YBLTextColor;
    self.numberOfParticipateLabel.font = YBLFont(12);
    self.numberOfParticipateLabel.text = @"共300个人参与";
    self.numberOfParticipateLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.numberOfParticipateLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(self.iconImageView.right,heigth-0.5,YBLWindowWidth - self.iconImageView.width - space,0.5)];
    line.backgroundColor = YBLLineColor;
    [self.contentView addSubview:line];
}
- (void)payClicked:(UIButton*)clicked
{
    NSLog(@"已支付");

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
+(CGFloat)getMyDemandOrderCellHeight
{
    return 130;
}
-(NSMutableAttributedString*) changeLabelWithText:(NSString*)needText

{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
    
    UIFont *font = YBLFont(14);
    
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,needText.length-2)];
    [attrString addAttribute:NSFontAttributeName value:YBLFont(10) range:NSMakeRange(needText.length - 2,2)];
    return attrString;
}
@end
