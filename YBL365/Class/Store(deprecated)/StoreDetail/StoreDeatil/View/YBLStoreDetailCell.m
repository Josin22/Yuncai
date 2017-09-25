//
//  YBLStoreDetailCell.m
//  YBL365
//
//  Created by 陶 on 2016/12/23.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreDetailCell.h"

@interface YBLStoreDetailCell ()
@property (nonatomic, strong) UILabel * titleLab;
@property (nonatomic, strong) UILabel * detailLab;
@property (nonatomic, strong) UIImageView * logoImage;
@end

@implementation YBLStoreDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createrUI];
    }
    return self;
}

- (void)createrUI {
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, 100, 20)];
    _titleLab.textColor = BlackTextColor;
    _titleLab.font = YBLFont(16);
    [self.contentView addSubview:_titleLab];
    _detailLab = [[UILabel alloc]initWithFrame:CGRectMake(105, 8, YBLWindowWidth-115, 20)];
    _detailLab.textColor = [UIColor lightGrayColor];
    _detailLab.font = YBLFont(14);
    _detailLab.numberOfLines = 0;
    [self.contentView addSubview:_detailLab];
    
    _logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(YBLWindowWidth-30, 10, 20, 20)];
    _logoImage.image = [UIImage imageNamed:@""];
    [self.contentView addSubview:self.logoImage];
    self.logoImage.hidden = YES;
    
}

- (void)updateCellWithTitle:(NSString *)title detail:(NSString *)detail indexPatn:(NSIndexPath *)indexPatn {
    _titleLab.text = title;
    if (detail.length>0) {
        if (indexPatn.section == 1) {
            self.logoImage.hidden = YES;
            for (int i = 0; i<[detail integerValue]; i++) {
                UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(105+20*i, 9, 20, 20)];
                if (indexPatn.row == 0) {
                    imageview.image = [UIImage imageNamed:@"store_score"];
                }else if (indexPatn.row == 1) {
                    imageview.image = [UIImage imageNamed:@"store_medal"];
                }
                [self.contentView addSubview:imageview];
            }
            self.detailLab.hidden = YES;
            

        }else if (indexPatn.section == 2) {
            self.logoImage.hidden = NO;
            self.detailLab.hidden = YES;
            self.logoImage.image = [UIImage imageNamed:detail];
        
        }else if (indexPatn.section == 0) {
            self.logoImage.hidden = YES;
            self.detailLab.hidden = NO;
            self.detailLab.text = detail;
        }
        
        
        
    }
    
}

+ (CGFloat)getCellHeightWithDetail:(NSString *)detail {
    CGFloat height = [detail heightWithFont:YBLFont(14) MaxWidth:YBLWindowWidth-115].height;
    return height+20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
