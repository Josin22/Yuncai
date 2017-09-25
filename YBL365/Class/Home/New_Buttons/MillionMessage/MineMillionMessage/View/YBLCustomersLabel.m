
//
//  YBLCustomersLabel.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/1.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCustomersLabel.h"

@implementation YBLCustomersLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = YBLFont(25);
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
//        self.layer.cornerRadius  = self.height/2;
//        self.layer.masksToBounds = YES;
    }
    return self;
}

@end
