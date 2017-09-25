//
//  YBLFoundPurchaseViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFoundPurchaseViewController.h"
#import "YBLFoundPurchaseService.h"

@interface YBLFoundPurchaseViewController ()

@property (nonatomic, strong) YBLFoundPurchaseService *servic;

@end

@implementation YBLFoundPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (self.purchaseType == PurchaseTypeSingle) {
        self.title = @"我要采购";
    }
    
    self.servic = [[YBLFoundPurchaseService alloc] initWithVC:self ViewModel:[YBLFoundPurchaseViewModel new]];
    
}

@end
