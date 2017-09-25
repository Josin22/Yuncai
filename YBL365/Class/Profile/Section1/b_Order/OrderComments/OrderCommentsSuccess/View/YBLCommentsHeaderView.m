//
//  YBLCommentsHeaderView.m
//  YC168
//
//  Created by 乔同新 on 2017/6/17.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCommentsHeaderView.h"

@interface YBLCommentsHeaderView (){
    CGFloat imageHi;
}

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, retain) UILabel *infoLabel;

@end

@implementation YBLCommentsHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {

    self.backgroundColor = [UIColor whiteColor];
    
    UIImage *bgImage = [UIImage contentFileWithName:@"comment_bg" Type:@"jpg"];;
    imageHi =  (double)bgImage.size.height/bgImage.size.width*self.width;
    self.height = imageHi;
    self.bgImageView = [[UIImageView alloc] initWithFrame:[self bounds]];
    self.bgImageView.image = bgImage;
    [self addSubview:self.bgImageView];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bgImageView.width, self.bgImageView.height/2)];
    contentLabel.centerY = self.bgImageView.height/2;
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgImageView addSubview:contentLabel];
    
    NSString *contentText = @"感谢您的评价!\n \n 赠人玫瑰，手留余香~";
    NSMutableAttributedString *muatt = [[NSMutableAttributedString alloc] initWithString:contentText];
    NSInteger kong_loc = [contentText rangeOfString:@"!"].location;
    [muatt addAttributes:@{NSFontAttributeName:YBLFont(14),NSForegroundColorAttributeName:BlackTextColor} range:NSMakeRange(0, kong_loc)];
    [muatt addAttributes:@{NSFontAttributeName:YBLFont(15),NSForegroundColorAttributeName:BlackTextColor} range:NSMakeRange(kong_loc, contentText.length-kong_loc)];
    contentLabel.attributedText = muatt;

    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bgImageView.bottom, self.width, 35)];
    self.infoLabel.backgroundColor = YBLViewBGColor;
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.font = YBLFont(12);
    self.infoLabel.textColor = YBLTextColor;
    self.infoLabel.text = @"心情不错~ 继续评价赚云币";
    [self addSubview:self.infoLabel];
    self.infoLabel.hidden = YES;
}

- (void)setIsHasComments:(BOOL)isHasComments{
    _isHasComments = isHasComments;
    if (_isHasComments) {
        self.infoLabel.hidden = NO;
        self.height = self.infoLabel.bottom;
    } else {
        self.infoLabel.hidden = YES;
        self.height = imageHi;
    }
}

@end
