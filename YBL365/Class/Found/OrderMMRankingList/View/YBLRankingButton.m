//
//  YBLRankingLabel.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLRankingButton.h"

@interface YBLRankingButton ()

@property (nonatomic, retain) UILabel *smallLabel;

@property (nonatomic, retain) UILabel *bigLabel;

@end

@implementation YBLRankingButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat spacec = 5;
        
        UILabel *bigLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width*2/3-spacec, self.height)];
        bigLabel.textColor = BlackTextColor;
        bigLabel.font = YBLFont(18);
        bigLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:bigLabel];
        self.bigLabel = bigLabel;
        
        UILabel *smallLabel = [[UILabel alloc] initWithFrame:CGRectMake(bigLabel.right+spacec, bigLabel.top, self.width/3, bigLabel.height)];
        smallLabel.textColor = YBLTextColor;
        smallLabel.textAlignment = NSTextAlignmentLeft;
        smallLabel.font = YBLFont(12);
        [self addSubview:smallLabel];
        self.smallLabel = smallLabel;

    }
    return self;
}

- (void)setBigText:(NSString *)bigText{
    
    self.bigLabel.text = bigText;
}

- (void)setSmallText:(NSString *)smallText{
 
    self.smallLabel.text = smallText;

}

@end
