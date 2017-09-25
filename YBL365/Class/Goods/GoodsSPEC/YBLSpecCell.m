//
//  YBLSpecCell.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/18.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSpecCell.h"

@interface YBLSpecCell ()

@end

@implementation YBLSpecCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
 
    CGFloat hi = [YBLSpecCell getSpecHi];
    
    UILabel *spec1Label = [[UILabel alloc] initWithFrame:CGRectMake(space, space, YBLWindowWidth-space*2-110, 20)];
    spec1Label.textColor = BlackTextColor;
    spec1Label.centerY = hi/2;
    spec1Label.font = YBLFont(16);
    [self.contentView addSubview:spec1Label];
    self.spec1Label = spec1Label;
    
//    UILabel *spec2Label = [[UILabel alloc] initWithFrame:CGRectMake(space, spec1Label.bottom, 100, spec1Label.height)];
//    spec2Label.textColor = YBLTextColor;
//    spec2Label.font = YBLFont(16);
//    [self addSubview:spec2Label];
//    self.spec2Label = spec2Label;
    
    
    YBLAddSubtractView *addSubtractView = [[YBLAddSubtractView alloc] initWithFrame:CGRectMake(YBLWindowWidth-space-110, 0, 110, 27)];
    addSubtractView.centerY = hi/2;
    [self.contentView addSubview:addSubtractView];
    self.addSubtractView = addSubtractView;
    
//    UILabel *storgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(addSubtractView.left-space-100, 0, 100, hi/2)];
//    storgeLabel.textAlignment = NSTextAlignmentRight;
//    storgeLabel.textColor = YBLTextColor;
//    storgeLabel.centerY = hi/2;
//    storgeLabel.font = YBLFont(13);
//    [self addSubview:storgeLabel];
//    self.storgeLabel = storgeLabel;
    
    [self addSubview:[YBLMethodTools addLineView:CGRectMake(space, hi-0.5, YBLWindowWidth-space, 0.5)]];
    
}

+ (CGFloat)getSpecHi{
    
    return 60;
}


@end
