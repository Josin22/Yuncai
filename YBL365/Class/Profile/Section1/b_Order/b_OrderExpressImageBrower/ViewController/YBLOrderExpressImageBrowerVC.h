//
//  YBLOrderExpressImageBrowerVC.h
//  YC168
//
//  Created by 乔同新 on 2017/5/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMainViewController.h"
#import "YBLCustomNavgationBar.h"

@interface YBLOrderExpressImageBrowerVC : YBLMainViewController

@property (nonatomic, strong) YBLCustomNavgationBar *navBar;

@property (nonatomic, strong) NSMutableArray *urlImageArray;

@property (nonatomic, assign) NSInteger currentPicIndex;

@end
