//
//  YBLMyJoinTableViewCell.m
//  YBL365
//
//  Created by 代恒彬 on 2017/1/9.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMyJoinTableViewCell.h"
@interface YBLMyJoinTableViewCell ()
@property (nonatomic,strong)UIImageView *titleImage;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *allLabel;
@property (nonatomic,strong)UIImageView *image;
@end

@implementation YBLMyJoinTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }

    return self;
}
- (void)createUI{
    
    CGFloat height = [YBLMyJoinTableViewCell getMyJoinCellHeight];
    self.titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(space,space*1.25,height-space*2.5,height - 2.5*space)];
     self.titleImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.titleImage];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleImage.right + space,height/2-15/2,100,15)];
    self.titleLabel.textColor = YBLTextColor;
    self.titleLabel.font = YBLFont(14);
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLabel];
    
    self.image = [[UIImageView alloc]initWithFrame:CGRectMake(YBLWindowWidth - space*2,height/2-space*1.5/2 ,space,space*1.5)];
    self.image.contentMode = UIViewContentModeScaleAspectFit;
    self.image.image = [UIImage imageNamed:@"flight_back_arrow_common"];
    [self.contentView addSubview:self.image];
    
    self.allLabel = [[UILabel alloc]initWithFrame:CGRectMake(YBLWindowWidth - 3*space - 50,height/2-15/2,50,15)];
    self.allLabel.textColor = YBLTextColor;
    self.allLabel.font = YBLFont(14);
    self.allLabel.text = @"全部";
    self.allLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.allLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,height-0.5,YBLWindowWidth,0.5)];
    line.backgroundColor = YBLLineColor;
    [self.contentView addSubview:line];

}
- (void)setDataForCell:(NSString *)title and:(NSString *)picture{
    self.titleImage.image = [UIImage imageNamed:picture];
    self.titleLabel.text = title;
}

+ (CGFloat)getMyJoinCellHeight{
    
    return 50;
}
@end
