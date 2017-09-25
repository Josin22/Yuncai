//
//  YBLMapItemCell.m
//  YC168
//
//  Created by 乔同新 on 2017/4/20.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMapItemCell.h"

@interface YBLMapItemCell ()

@end

@implementation YBLMapItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
 
    CGFloat imageWi = 20;
    CGFloat height = [YBLMapItemCell getItemCellHeightWithModel:nil];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, YBLWindowWidth-3*space-imageWi, 30)];
    self.titleLabel.textColor = BlackTextColor;
    self.titleLabel.font = YBLFont(16);
    [self.contentView addSubview:self.titleLabel];
    
    self.titleInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, self.titleLabel.width, height-self.titleLabel.height)];
    self.titleInfoLabel.textColor = YBLTextColor;
    self.titleInfoLabel.font = YBLFont(12);
    [self.contentView addSubview:self.titleInfoLabel];
    
    self.duihaoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWi, imageWi)];
    self.duihaoImageView.image = [UIImage imageNamed:@"duihao_map"];
    self.duihaoImageView.right = YBLWindowWidth-space;
    self.duihaoImageView.centerY = height/2;
    [self.contentView addSubview:self.duihaoImageView];
    
    [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(0, height-0.5,YBLWindowWidth, 0.5)]];
}

- (void)setIsSelectAddress:(BOOL)isSelectAddress{
    _isSelectAddress = isSelectAddress;
    if (_isSelectAddress) {
        
        self.titleLabel.top = 0;
        self.titleLabel.height = self.height;
        self.titleInfoLabel.hidden = YES;
        
    } else {
        
        self.titleInfoLabel.hidden = NO;
        self.titleLabel.top = 0;
        self.titleLabel.height = 30;
        self.titleInfoLabel.top = self.titleLabel.bottom;
    }
}


+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    
    return 50;
}

@end
