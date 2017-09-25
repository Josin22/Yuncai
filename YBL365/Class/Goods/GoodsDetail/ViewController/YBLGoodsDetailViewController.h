//
//  YBLGoodsDetailViewController.h
//  YBL365
//
//  Created by 乔同新 on 12/24/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLMainViewController.h"
#import "YBLGoodsDetailViewModel.h"


typedef NS_ENUM(NSInteger,GoodsDetailType) {
    GoodsDetailTypeDefault = 0,//默认商品详情
    GoodsDetailTypeSeckilling,  //秒杀详情
    GoodsDetailTypeSeckillNotTime//未开始秒杀
};
@interface YBLGoodsDetailViewController : YBLMainViewController

@property (nonatomic, strong) YBLGoodsDetailViewModel *viewModel;

- (instancetype)initWithType:(GoodsDetailType)type;

@end
