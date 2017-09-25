//
//  YBLGoodsPriceDownViewController.m
//  YBL365
//
//  Created by 乔同新 on 2016/12/29.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLGoodsPriceDownViewController.h"

@interface YBLGoodsPriceDownViewController ()

@property (nonatomic, strong) NSMutableArray *testArray;

@end

@implementation YBLGoodsPriceDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"降价通知";
    
    [self createUI];
    
}

- (void)createUI{
 
    self.view.backgroundColor = YBBGViewColor;
    
    CGFloat space = 10;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(space, kNavigationbarHeight+space, YBLWindowWidth-2*space, 40)];
    label.numberOfLines = 2;
    label.text = @"一旦此商品在3个月内降价,您将收到手机推送消息以及短信通知(需设置).";
    label.textColor = YBLTextColor;
    label.font = YBLFont(13);
    [self.view addSubview:label];
    
    for (int i = 0 ; i < self.testArray.count ; i++) {
    
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(-1, CGRectGetMaxY(label.frame)+space+i*(50+space), YBLWindowWidth+2, 50)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.borderColor = YBLLineColor.CGColor;
        bgView.layer.borderWidth = 0.5;
        [self.view addSubview:bgView];
        
        NSString *text = self.testArray[i];
        CGSize textSize = [text heightWithFont:YBLFont(16) MaxWidth:200];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(space, space, textSize.width, bgView.height-2*space)];
        label.text = text;
        label.font = YBLFont(16);
        [bgView addSubview:label];
        
        if (i == 0) {
            
            UILabel *priceLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+space, CGRectGetMinY(label.frame), 200, label.height)];
            priceLable.attributedText = [NSString stringPrice:@"¥ 900.00" color:YBLThemeColor font:19 isBoldFont:NO appendingString:nil];
            [bgView addSubview:priceLable];
            
        } else if (i == 1) {
            
            NSString *moenyString = @"¥";
            
            CGSize moneySize = [moenyString heightWithFont:YBLFont(16) MaxWidth:50];
            
            UILabel *moneyLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+space, CGRectGetMinY(label.frame), moneySize.width, label.height)];
            moneyLable.text = moenyString;
            moneyLable.font = YBLFont(16);
            [bgView addSubview:moneyLable];
            
            UITextField *moneyTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(moneyLable.frame), CGRectGetMinY(moneyLable.frame), 200, label.height)];
            moneyTextFeild.borderStyle = UITextBorderStyleNone;
            moneyTextFeild.backgroundColor = [UIColor whiteColor];
            moneyTextFeild.placeholder = @"低于此价会通知您";
            [bgView addSubview:moneyTextFeild];
            
        }else {
            
            UISwitch *textNotiSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(bgView.width-space-60, CGRectGetMinY(label.frame), 60, label.height)];
            textNotiSwitch.tintColor = YBLThemeColor;
            textNotiSwitch.onTintColor = YBLThemeColor;
            [bgView addSubview:textNotiSwitch];
            
            UILabel *notifiLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, CGRectGetMaxY(bgView.frame)+space, 200, 20)];
            notifiLabel.text = @"通知栏也会提醒您哦";
            notifiLabel.textColor = YBLTextColor;
            notifiLabel.font = YBLFont(13);
            [self.view addSubview:notifiLabel];
            
            UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
            sureButton.frame = CGRectMake(space, CGRectGetMaxY(notifiLabel.frame)+80, YBLWindowWidth-2*space, 35);
            sureButton.backgroundColor = YBLThemeColor;
            [sureButton setTitle:@"确定" forState:UIControlStateNormal];
            [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            sureButton.titleLabel.font = YBLFont(16);
            sureButton.layer.cornerRadius = 3;
            sureButton.layer.masksToBounds = YES;
            [self.view addSubview:sureButton];
            
        }
        
    }
    
}

- (NSMutableArray *)testArray{
    
    if (!_testArray) {
        _testArray = [NSMutableArray array];
        [_testArray addObject:@"当前价格:"];
        [_testArray addObject:@"期望价格:"];
        [_testArray addObject:@"短信通知"];
    }
    return _testArray;
}

@end
