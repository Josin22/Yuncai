//
//  YBLOrderMMRecommendMeView.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderMMRecommendMeView.h"
#import "YBLPurchaseGoodsDetailVC.h"


static YBLOrderMMRecommendMeView *RecommendMeView = nil;

@interface YBLOrderMMRecommendMeView ()

@property (nonatomic, weak) YBLPurchaseGoodsDetailVC *VC;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, assign) CGFloat Top;


@property (nonatomic, strong) NSMutableArray *testArray;

@end

@implementation YBLOrderMMRecommendMeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (NSMutableArray *)testArray{
    
    if (!_testArray) {
        _testArray = [NSMutableArray array];
        [_testArray addObject:@"当前价格:"];
        [_testArray addObject:@"结束前30分钟提醒我"];
        [_testArray addObject:@"短信通知"];
    }
    return _testArray;
}

- (CGFloat)Top{

    return YBLWindowHeight-250;
}

- (void)createUI{
    
    UIView *bg = [[UIView alloc] initWithFrame:[self bounds ]];
    bg.backgroundColor = [UIColor clearColor];
    [self addSubview:bg];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [bg addGestureRecognizer:tap];
    
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, YBLWindowHeight+space, self.width, self.height-self.Top)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    self.bgView = bgView;
    
    for (int i = 0 ; i < self.testArray.count ; i++) {
        
        UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(-1, i*(50+space), YBLWindowWidth+2, 50)];
        bgView1.backgroundColor = [UIColor whiteColor];
        bgView1.layer.borderColor = YBLLineColor.CGColor;
        bgView1.layer.borderWidth = 0.5;
        [bgView addSubview:bgView1];
        
        NSString *text = self.testArray[i];
        CGSize textSize = [text heightWithFont:YBLFont(16) MaxWidth:200];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(space, space, textSize.width, bgView1.height-2*space)];
        label.text = text;
        label.font = YBLFont(16);
        [bgView1 addSubview:label];
        
        if (i == 0) {
            
            UILabel *priceLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+space, CGRectGetMinY(label.frame), 200, label.height)];
            priceLable.attributedText = [NSString stringPrice:@"¥ 900.00" color:YBLThemeColor font:19 isBoldFont:NO appendingString:nil];
            [bgView1 addSubview:priceLable];
            
        } else if (i == 1) {
            
            UILabel *moneyLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+space, CGRectGetMinY(label.frame), YBLWindowWidth-label.width-space*3, label.height)];
            moneyLable.text = @"2016年12月15日 21:30";
            moneyLable.textColor = [UIColor yellowColor];
            moneyLable.font = YBLFont(12);
            moneyLable.textAlignment = NSTextAlignmentRight;
            [bgView1 addSubview:moneyLable];
            
            
        }else {
            
            UISwitch *textNotiSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(bgView1.width-space-60, CGRectGetMinY(label.frame), 60, label.height)];
            textNotiSwitch.tintColor = YBLThemeColor;
            textNotiSwitch.onTintColor = YBLThemeColor;
            [bgView1 addSubview:textNotiSwitch];
            
            UILabel *notifiLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, CGRectGetMaxY(bgView1.frame)+space/2, 200, 20)];
            notifiLabel.text = @"通知栏也会提醒您哦";
            notifiLabel.textColor = YBLTextColor;
            notifiLabel.font = YBLFont(12);
            [bgView addSubview:notifiLabel];
            
            UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
            sureButton.frame = CGRectMake(0, bgView.height-45, YBLWindowWidth, 45);
            sureButton.backgroundColor = YBLThemeColor;
            [sureButton setTitle:@"确定" forState:UIControlStateNormal];
            [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            sureButton.titleLabel.font = YBLFont(16);
            [bgView addSubview:sureButton];
            
        }
        
    }

    
}

+ (void)showRecommendMeInVC:(UIViewController *)VC{
    
    if (!RecommendMeView) {
        RecommendMeView = [[YBLOrderMMRecommendMeView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight)];
        RecommendMeView.backgroundColor = YBLColor(0, 0, 0, 0);
        RecommendMeView.VC = (YBLPurchaseGoodsDetailVC *)VC;
    }
    [YBLMethodTools transformOpenView:RecommendMeView.bgView SuperView:RecommendMeView fromeVC:VC.navigationController Top:RecommendMeView.Top];
}

- (void)dismiss{
    
    [YBLMethodTools transformCloseView:self.bgView SuperView:RecommendMeView fromeVC:_VC.navigationController Top:YBLWindowHeight completion:^(BOOL finished) {
         [RecommendMeView removeFromSuperview];
    }];
}

@end
