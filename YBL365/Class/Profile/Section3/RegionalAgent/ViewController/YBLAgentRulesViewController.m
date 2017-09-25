//
//  YBLAgentRulesViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAgentRulesViewController.h"

@interface YBLAgentRulesViewController ()

@end

@implementation YBLAgentRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"代理细则";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIImage *image = [UIImage imageNamed:@"profile_daili_xize"];
    UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight-kNavigationbarHeight)];
    CGFloat hi = ((double)1193/750)*imageScrollView.width;
    imageScrollView.contentSize = CGSizeMake(imageScrollView.width, hi);
    [self.view addSubview:imageScrollView];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageScrollView.width, hi)];
    imageView.image = image;
    [imageScrollView addSubview:imageView];
}



@end
