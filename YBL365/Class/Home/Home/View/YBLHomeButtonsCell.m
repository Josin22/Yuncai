//
//  YBLHomeButtonsCell.m
//  YBL365
//
//  Created by 乔同新 on 12/20/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLHomeButtonsCell.h"

NSInteger button_tag  = 534343;

@interface YBLHomeButtonsCell ()

@end

@implementation YBLHomeButtonsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createButtonsUI];
    }
    return self;
}

- (void)createButtonsUI{
    

    NSArray *titleArray = @[
                            @"店铺红包",
                            @"我的红包",
                            @"商家名录",
                            @"我要赚钱",
                            @"领券中心",
                            ];

    self.contentView.backgroundColor = YBLColor(243, 243, 243, 1);
    
    NSInteger count = titleArray.count;
    
    int margin = 40;
    int leftspace = 20;
//    int width = (self.width-leftspace*2-margin*(count-1))/count;
    int width = self.width/count;
    int height = 65;
    
    for (int i = 0; i < count; i++) {
        
        int row = i/count;
        int col = i%count;
        
        CGRect frame = CGRectMake(col*(width), space+row*(height), width, height);
        
        YBLButton *button = [YBLButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        [button setTitleColor:YBLColor(138,135,137,1) forState:UIControlStateNormal];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        NSString *imageName = [NSString stringWithFormat:@"jimi_serv_%d",i+1];
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        button.titleLabel.font = YBLFont(12);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.tag = button_tag+i;
        [button addTarget:self action:@selector(buttonScrollClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat itemHi = height-25;
        button.imageRect = CGRectMake((width-itemHi)/2, 0, itemHi, itemHi);
        button.titleRect = CGRectMake(0, itemHi, width, 25);
        [self.contentView addSubview:button];
        
    }

}

+ (CGFloat)getButtonsCellHeight{

//    int margin = 40;
//    int leftspace = 20;
//    int width = (YBLWindowWidth-leftspace*2-margin*3)/4;
//    return (width+10);
    return 75;
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    return [YBLHomeButtonsCell getButtonsCellHeight];
}

- (void)buttonScrollClick:(UIButton *)btn{
    BLOCK_EXEC(self.buttonsClickBlock,btn.tag
               -button_tag);
}


@end
