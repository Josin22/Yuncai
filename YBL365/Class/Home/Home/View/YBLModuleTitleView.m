//
//  YBLModuleTitleView.m
//  YBL365
//
//  Created by 乔同新 on 12/21/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

static double titleViewScale = (double)129/1242;

#import "YBLModuleTitleView.h"
#import "YBLFloorsModel.h"

@interface YBLModuleTitleView ()

@end

@implementation YBLModuleTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createModuleTitleUI];
    }
    return self;
}

- (void)createModuleTitleUI{
    
    self.backgroundColor = YBLColor(250, 250, 250, 1);
    
    _moduleTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _moduleTitleButton.frame = self.bounds;
    [self addSubview:_moduleTitleButton];
    
}

- (void)updateModuleTitleImageValue:(id )value{
    if ([value isKindOfClass:[YBLFloorsModel class]]) {
        YBLFloorsModel *model = (YBLFloorsModel *)value;
        [_moduleTitleButton sd_setImageWithURL:[NSURL URLWithString:model.avatar]
                                      forState:UIControlStateNormal
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         
                                     }];
    } else {
        NSString *imageNameString = (NSString *)value;
        [_moduleTitleButton setImage:[UIImage imageNamed:imageNameString] forState:UIControlStateNormal];
    }


    
}

+ (CGFloat)getModuleHeight{
    
    return YBLWindowWidth*titleViewScale;
}

@end
