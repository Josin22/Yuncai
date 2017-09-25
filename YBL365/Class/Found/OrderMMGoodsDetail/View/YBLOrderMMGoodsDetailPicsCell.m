//
//  YBLOrderMMGoodsDetailPicsCell.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderMMGoodsDetailPicsCell.h"

@interface YBLOrderMMGoodsDetailPicsCell ()

@property (nonatomic, strong) UIImageView *picImageView;

@end

@implementation YBLOrderMMGoodsDetailPicsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
        
    }
    return self;
}

- (void)createUI{
    
    UIImage *image = [UIImage imageNamed:@"maotai_detail.png"];
    CGFloat hi = [self getHi];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, hi)];
    imageView.image = image;
    [self addSubview:imageView];
    self.picImageView = imageView;
    
}

- (CGFloat)getHi{
    
    return ((double)3744/750)*YBLWindowWidth;
}


+ (CGFloat)getGoodsDetailPicsCellHeight{
    
    return [[YBLOrderMMGoodsDetailPicsCell new] getHi]+64;
}

@end
