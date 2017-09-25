//
//  YBLOrderMMGoodsDetailMiningSupplyProcessCell.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderMMGoodsDetailMiningSupplyProcessCell.h"

@implementation YBLOrderMMGoodsDetailMiningSupplyProcessCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    
    CGFloat hi = [YBLOrderMMGoodsDetailMiningSupplyProcessCell getGoodsDetailMiningSupplyProcessCellHeight];
    
    UILabel *caiLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, space, 100, 20)];
    caiLabel.text = @"采供流程";
    caiLabel.textColor = YBLTextColor;
    caiLabel.font = YBLFont(13);
    [self.contentView addSubview:caiLabel];
    
    NSArray *titleArray = @[@"我要采购",@"供应报价",@"成功采供",@"支付货款",@"配送验货"];
    NSInteger index = 0;
    CGFloat imageWi = 15;
    CGFloat itemWi = (YBLWindowWidth-2*space-imageWi*4)/5;
    CGFloat itemHi = 65;
    
    for (NSString *title in titleArray) {
        
        YBLButton *processButton = [YBLButton buttonWithType:UIButtonTypeCustom];
        NSString *imageName1 = [NSString stringWithFormat:@"orderMM_process%@",@(index+1)];
        [processButton setImage:[UIImage imageNamed:imageName1] forState:UIControlStateNormal];
        [processButton setTitle:title forState:UIControlStateNormal];
        [processButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
//        [processButton setBackgroundColor:YBLColor(255, 242, 233, 1)];
        processButton.titleLabel.font = YBLFont(10);
        processButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        processButton.frame = CGRectMake(space+index*(itemWi+imageWi), caiLabel.bottom+space, itemWi, itemHi);
        processButton.titleRect = CGRectMake(0, itemHi-23, itemWi, 20);
        processButton.imageRect = CGRectMake((itemWi-40)/2, 0, 40, 40);
        [self.contentView addSubview:processButton];
        
        if (index<4) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(processButton.right, processButton.top, imageWi, processButton.height/2)];
            imageView.image = [UIImage imageNamed:@"orderMM_direction"];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:imageView];
        }
        index++;
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(space, caiLabel.bottom+itemHi+space, YBLWindowWidth-space, 0.5)];
    lineView.backgroundColor = YBLLineColor;
    [self.contentView addSubview:lineView];
//    
//    YBLButton *guiZeButton = [YBLButton buttonWithType:UIButtonTypeCustom];
//    [guiZeButton setTitle:@"采供保证金规则" forState:UIControlStateNormal];
//    [guiZeButton setImage:[UIImage imageNamed:@"orderMM_more"] forState:UIControlStateNormal];
//    guiZeButton.titleLabel.font = YBLFont(14);
//    guiZeButton.titleLabel.textAlignment = NSTextAlignmentLeft;
//    [guiZeButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
//    guiZeButton.frame = CGRectMake(space, lineView.bottom+space, YBLWindowWidth-2*space, 20);
//    guiZeButton.titleRect = CGRectMake(0, 0, 200, 20);
//    guiZeButton.imageRect = CGRectMake(YBLWindowWidth-2*space-7, 5, 7, 10);
//    [self.contentView addSubview:guiZeButton];
//    
//    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(space, hi-.5, YBLWindowWidth-space, 0.5)];
//    lineView1.backgroundColor = YBLLineColor;
//    [self.contentView addSubview:lineView1];
    
    UIButton *guizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    guizeButton.frame = CGRectMake(0, lineView.bottom, YBLWindowWidth, 40);
    [self.contentView addSubview:guizeButton];
    self.guizeButton = guizeButton;
    
    UILabel *askLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, 100, 20)];
    askLabel.text = @"采购保证金规则";
    askLabel.textColor = BlackTextColor;
    askLabel.font = YBLFont(14);
    askLabel.centerY = self.guizeButton.height/2;
    [guizeButton addSubview:askLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"found_arrow"]];
    arrowImageView.frame = CGRectMake(YBLWindowWidth-space-8, 0, 8, 16.5);
    arrowImageView.centerY = self.guizeButton.height/2;
    [guizeButton addSubview:arrowImageView];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(space, hi-.5, YBLWindowWidth-space, 0.5)];
    lineView1.backgroundColor = YBLLineColor;
    [self addSubview:lineView1];

}


+ (CGFloat)getGoodsDetailMiningSupplyProcessCellHeight{
    
    return 145;
}

@end
