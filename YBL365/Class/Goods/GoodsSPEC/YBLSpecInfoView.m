//
//  YBLSpecInfoView.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSpecInfoView.h"

static YBLSpecInfoView *specInfoView = nil;

#define view_top YBLWindowHeight/7

@interface YBLSpecInfoView ()

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong  ) UIViewController *vc;

@end

@implementation YBLSpecInfoView

+ (void)showSpecInfoViewfromeVC:(UIViewController *)rootVC WithData:(NSMutableArray *)data{
    if (!specInfoView) {
        
        specInfoView = [[YBLSpecInfoView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight) Data:data];
        specInfoView.vc = rootVC;
    }
    
    [UIView transformOpenView:specInfoView.contentView SuperView:specInfoView fromeVC:rootVC Top:view_top];

}
- (instancetype)initWithFrame:(CGRect)frame Data:(NSMutableArray *)data{
    self = [super initWithFrame:frame];
    if (self) {
        
        _data = data;
        
        [self creatUI];
        
    }
    return self;
}

- (void)creatUI{
    
    UIView *bg = [[UIView alloc] initWithFrame:[self bounds]];
    bg.backgroundColor = [UIColor clearColor];
    [self addSubview:bg];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
    [bg addGestureRecognizer:tap];
    
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, YBLWindowHeight+space, self.width, self.height-view_top)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    [YBLMethodTools addTopShadowToView:contentView];
    self.contentView = contentView;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
    [self.contentView addSubview:titleView];
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    titleLable.text = @"规格";
    titleLable.textColor = YBLTextColor;
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = YBLFont(16);
    titleLable.centerX = titleView.width/2;
    titleLable.centerY = titleView.height/2;
    [titleView addSubview:titleLable];
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton setImage:[UIImage imageNamed:@"address_close"] forState:UIControlStateNormal];
    [dismissButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:dismissButton];
    dismissButton.frame = CGRectMake(titleView.width - 50, 0, 50, 50);
    
    [titleView addSubview:[YBLMethodTools addLineView:CGRectMake(0, titleView.height-0.5, titleView.width, 0.5)]];
    
    
    NSArray *labelArray = _data[0];
    NSArray *valueArray = _data[1];
     NSInteger index = 0;
     
     //    CGFloat hei = 15;
     
     for (NSString *labelString in labelArray) {
         
         CGSize labelSize = [labelString heightWithFont:YBLFont(14) MaxWidth:200];
         
         UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, titleView.bottom+index*(40), self.width, 40)];
         [self.contentView addSubview:itemView];
         
         [itemView addSubview:[YBLMethodTools addLineView:CGRectMake(0, itemView.height-0.5, itemView.width, 0.5)]];
         
         UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, labelSize.width, labelSize.height)];
         label.font = YBLFont(13);
         label.text = labelString;
         label.centerY = itemView.height/2;
         label.textColor = YBLTextColor;
         [itemView addSubview:label];
         
         NSString *valueString = valueArray[index];
         
         UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.right+space, label.top, itemView.width-label.right-space*2, label.height)];
         valueLabel.textColor = YBLColor(40, 40, 40, 1);
         valueLabel.font = YBLFont(12);
         valueLabel.text = valueString;
         [itemView addSubview:valueLabel];
         
         if (index == labelArray.count-1) {
            
         }
         index++;
     }
     
     
}

- (void)dismissView{
    

    [UIView transformCloseView:specInfoView.contentView
                     SuperView:specInfoView
                       fromeVC:specInfoView.vc
                           Top:YBLWindowHeight
                    completion:^(BOOL finished) {
                        [specInfoView removeFromSuperview];
                        specInfoView = nil;
                    }];


}

@end
