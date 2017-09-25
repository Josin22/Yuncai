//
//  YBLMyBrowsingHistoryTableViewCell.m
//  YBL365
//
//  Created by 代恒彬 on 2017/1/9.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMyBrowsingHistoryTableViewCell.h"
@interface YBLMyBrowsingHistoryTableViewCell()
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *productNameLabel;
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UIButton *sameButton;
@property (nonatomic,strong)UIButton *selectBtn;
@property (nonatomic,strong)UIView *leftView;

@end
@implementation YBLMyBrowsingHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
#pragma mark - set frame (重写frame方法)
- (void)setFrame:(CGRect)frame{
    frame.size.width = YBLWindowWidth + 37;
    
    if (self.isEditting==NO) {
        frame.origin.x = -37;
    }else{
        
        frame.origin.x =  0;
    }
    [super setFrame:frame];
}
#pragma mark - 重写get和set方法

-(void)setIsEditting:(BOOL)isEditting{
    _isEditting = isEditting;
    
    if (!isEditting) {
        self.isSelected = NO;
    }
}


-(void)setIsSelected:(BOOL)isSelected{
    
    self.selectBtn.selected = isSelected;
    
}

-(BOOL)isSelected{
    return self.selectBtn.selected;
}
- (void)createUI{
    CGFloat height = [YBLMyBrowsingHistoryTableViewCell getMyBrowsingHistoryCellHeight];
    
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,40 ,height)];
    _leftView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.leftView];
    
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectBtn setFrame: CGRectMake(space,height/2-20/2,20, 20)];
    [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"syncart_round_check1New"] forState:UIControlStateNormal];
    [self.selectBtn addTarget:self action:@selector(seletBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"syncart_round_check2New"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.selectBtn];
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(space+self.selectBtn.right, space,100,height-2*space)];
    self.iconImageView.image = [UIImage imageNamed:@"56fb4677af48430c06dd06c3.jpg@!avatar.jpeg"];
    [self.contentView addSubview:self.iconImageView];
    
    self.productNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImageView.right + space,2*space,YBLWindowWidth - 3*space- self.iconImageView.width,40)];
    self.productNameLabel.numberOfLines = 2;
    self.productNameLabel.font = YBLFont(14);
    self.productNameLabel.textAlignment= NSTextAlignmentRight;
    self.productNameLabel.textColor = BlackTextColor;
    NSString *nameText = @"洋河蓝色经典海之蓝42度375ML白酒金龙鱼黄金比例调和油5l（产品包装更新、新老包装）";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:nameText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [nameText length])];
    self.productNameLabel.attributedText = attributedString;
    [self.contentView addSubview:self.productNameLabel];
    
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.productNameLabel.left, self.productNameLabel.bottom + 2*space,YBLWindowWidth - 100 - self.iconImageView.width - 2*space,30)];
    self.priceLabel.textAlignment = NSTextAlignmentLeft;
    self.priceLabel.textColor = YBLThemeColor;
    NSString *priceLabel = @"¥4500.00";
    [self.priceLabel setAttributedText:[self changeLabelWithText:priceLabel]];
    [self.contentView addSubview:self.priceLabel];
    
    self.sameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sameButton setFrame:CGRectMake(YBLWindowWidth - 50-space+40,self.productNameLabel.bottom +1.5*space,50,25)];
    self.sameButton.layer.cornerRadius = 3;
    self.sameButton.layer.borderColor = YBLLineColor.CGColor;
    self.sameButton.layer.borderWidth = 0.5;
    [self.sameButton setTitle:@"看相似" forState:UIControlStateNormal];
    [self.sameButton setTitleColor:YBLTextColor forState:UIControlStateNormal];
    self.sameButton.titleLabel.font = YBLFont(12);
    [self.sameButton addTarget:self action:@selector(findSameProduct:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.sameButton];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(self.productNameLabel.left,height-0.5,YBLWindowWidth,0.5)];
    line.backgroundColor = YBLLineColor;
    [self.contentView addSubview:line];
    

}
#pragma mark - selectBtn action
- (void)seletBtnClicked:(UIButton*)button{
    button.selected = !button.selected;
}
- (void)findSameProduct:(UIButton*)button{
    NSLog(@"找相似");

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(NSMutableAttributedString*) changeLabelWithText:(NSString*)needText

{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
    
    UIFont *font = YBLFont(14);
    
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,needText.length-2)];
    [attrString addAttribute:NSFontAttributeName value:YBLFont(10) range:NSMakeRange(needText.length - 2,2)];
    return attrString;
}
+ (CGFloat)getMyBrowsingHistoryCellHeight{
    
    return 120;
}
@end
