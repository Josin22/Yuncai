//
//  YBLScanContentViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLScanContentViewController.h"

@interface YBLScanContentViewController ()

@end

@implementation YBLScanContentViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setIsPopGestureRecognizerEnable:NO];
    
    [self setMyTranslucent:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"扫描结果";
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(space, space, YBLWindowWidth-2*space, 200)];
    textView.font = [UIFont systemFontOfSize:14];
    textView.textColor = YBLColor(40, 40, 40, 1);
    textView.text = self.content;
    textView.layer.cornerRadius = 3;
    textView.layer.masksToBounds = YES;
    [self.view addSubview:textView];
    
}



@end
