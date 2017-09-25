//
//  YBLOrderMMHeaderView.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderMMHeaderView.h"

static NSInteger button_tag = 555;

@interface YBLOrderMMButton : UIButton

@property (nonatomic, strong) UIImageView *buttonImageView;

@property (nonatomic, strong) UILabel *buttonTextLabel;

@property (nonatomic, assign) BOOL isSelect;

@end

@implementation YBLOrderMMButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.buttonTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width/2+10-2, self.height)];
        self.buttonTextLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.buttonTextLabel];
       
        self.buttonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width/2+10+2, (self.height-15)/2, 15, 15)];
        self.buttonImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.buttonImageView];
    }
    return self;
}

- (void)setIsSelect:(BOOL)isSelect{
    
    if (isSelect) {
        
        self.buttonImageView.image = [UIImage imageNamed:@"jshop_category_arrow_down"];
        
        self.buttonTextLabel.textColor = YBLThemeColor;
        
    } else {
        
        self.buttonImageView.image = [UIImage imageNamed:@"jshop_category_arrow_down"];
        
        self.buttonTextLabel.textColor = BlackTextColor;
    }
}


@end

@implementation YBLOrderMMHeaderView

- (instancetype)initWithFrame:(CGRect)frame ValueArray:(NSArray *)array;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        for (int i= 0; i<2; i++) {
            YBLOrderMMButton *button = [[YBLOrderMMButton alloc] initWithFrame:CGRectMake(i*(YBLWindowWidth/2), 0, YBLWindowWidth/2, self.height-0.5)];
            button.tag = button_tag+i;
            if (i == 0) {
                button.isSelect = YES;
            } else {
                button.isSelect = NO;
            }
            button.buttonTextLabel.text = array[i];
            [button addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-0.5, self.width, 0.5)];
        lineView.backgroundColor = YBLLineColor;
        [self addSubview:lineView];
    }
    return self;
}

- (void)buttonclick:(UIButton *)btn{
    
    BLOCK_EXEC(self.headerClickBlock,btn.tag-button_tag);
    
}


@end
