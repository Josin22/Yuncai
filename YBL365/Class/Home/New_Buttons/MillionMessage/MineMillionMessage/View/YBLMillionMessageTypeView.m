//
//  YBLMillionMessageTypeView.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMillionMessageTypeView.h"

static NSInteger const tag_button = 15782;


@implementation YBLMillionMessageTypeItemModel

@end

@interface YBLMillionMessageTypeView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) UIPageControl *control;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation YBLMillionMessageTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[];
        NSArray *titleArray = @[ @[@{
                                       @"name":@"商超便利",
                                       @"image":@"scbl",
                                       @"type":@"",},
                                   @{
                                       @"name":@"餐饮饭店",
                                       @"image":@"cyfd",
                                       @"type":@"",},
                                   
                                   @{
                                       @"name":@"名烟名酒",
                                       @"image":@"mymj",
                                       @"type":@"",},
                                   @{
                                       @"name":@"酒店宾馆",
                                       @"image":@"jdbg",
                                       @"type":@"",},
                                   @{
                                       @"name":@"日杂百货",
                                       @"image":@"rzbh",
                                       @"type":@"",},
                                   
                                   @{
                                       @"name":@"休闲场所",
                                       @"image":@"xxcs",
                                       @"type":@"",},
                                   @{
                                       @"name":@"公共场所",
                                       @"image":@"ggcs",
                                       @"type":@"",},
                                   @{
                                       @"name":@"护肤日化",
                                       @"image":@"hfrh",
                                       @"type":@"",},
                                   @{
                                       @"name":@"水果蔬菜",
                                       @"image":@"sgsc",
                                       @"type":@"",},
                                   @{
                                       @"name":@"母婴用品",
                                       @"image":@"myyp-1",
                                       @"type":@"",},],
                                @[@{@"name":@"酒水饮料",
                                    @"image":@"jsyl",
                                    @"type":@""},
                                  @{@"name":@"休闲零食",
                                    @"image":@"xxls",
                                    @"type":@""},
                                  @{@"name":@"调料干货",
                                    @"image":@"tlgh",
                                    @"type":@""},
                                  @{@"name":@"米面粮油",
                                    @"image":@"mmly",
                                    @"type":@""},
                                  @{@"name":@"生鲜冻品",
                                    @"image":@"sxdp",
                                    @"type":@""},
                                  
                                  @{@"name":@"日用百货",
                                    @"image":@"rybh",
                                    @"type":@"",},
                                  
                                  @{@"name":@"酒店厨房",
                                    @"image":@"jdcf",
                                    @"type":@"",},
                                  @{@"name":@"美妆个护",
                                    @"image":@"mzgh",
                                    @"type":@"",},
                                  @{@"name":@"母婴用品",
                                    @"image":@"myyp",
                                    @"type":@"",},
                                  @{@"name":@"饰品礼品",
                                    @"image":@"splp",
                                    @"type":@"",},],
                                ];
        
        NSMutableArray *all_dataArray = @[].mutableCopy;
        for (NSArray *itemArray in titleArray) {
            NSMutableArray *dataArray = @[].mutableCopy;
            for (NSDictionary *dict in itemArray) {
                NSString *name = dict[@"name"];
                NSString *image = dict[@"image"];
                YBLMillionMessageTypeItemModel *model = [YBLMillionMessageTypeItemModel new];
                model.itemName = name;
                model.itemImage = image;
                [dataArray addObject:model];
            }
            [all_dataArray addObject:dataArray];
        }
        _dataArray = all_dataArray.copy;
    }
    return _dataArray;
}

- (void)createUI {

    NSInteger data_count = self.dataArray.count;
    
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-20)];
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.delegate = self;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.width*data_count, self.contentScrollView.height);
    [self addSubview:self.contentScrollView];
    
    NSInteger index = 0;
    
    for (NSArray *itemArray in self.dataArray) {
        
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(index*self.contentScrollView.width, 0, self.contentScrollView.width, self.contentScrollView.height)];
        itemView.backgroundColor = [UIColor whiteColor];
        itemView.tag = index;
        [self.contentScrollView addSubview:itemView];
        
        NSInteger index_1 = 0;
        
//        NSInteger item_count = itemArray.count;
        NSInteger item_max = 5;
        
        int margin = 10;
        int marginRow = 10;
        int width = (self.contentScrollView.width-margin*(item_max+1))/item_max;
        int height = 60;
        
        
        for (YBLMillionMessageTypeItemModel *itemModel in itemArray) {
            
            NSInteger row = index_1/item_max;
            NSInteger col = index_1%item_max;
            
            CGRect frame = CGRectMake(margin+col*(width+margin), marginRow+row*(height+marginRow), width, height);
            
            YBLButton *button = [YBLButton buttonWithType:UIButtonTypeCustom];
            button.frame = frame;
            [button setTitle:itemModel.itemName forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:itemModel.itemImage] forState:UIControlStateNormal];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.titleLabel.font = YBLFont(10);
            [button setTitleColor:BlackTextColor forState:UIControlStateNormal];
            
            CGFloat itemHi = height-20;
            button.imageRect = CGRectMake((width-itemHi)/2, 0, itemHi, itemHi);
            button.titleRect = CGRectMake(0, itemHi, width, 20);
            button.tag = (tag_button+index_1);
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [itemView addSubview:button];
            
            index_1++;
        }
        if (index == self.dataArray.count-1) {
            self.height = data_count*(marginRow+height)+20;
        }
        index++;
    }
    
    self.control = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    self.control.bottom = self.height;
    self.control.centerX = self.width/2;
    self.control.pageIndicatorTintColor = YBLTextLightColor;
    self.control.currentPageIndicatorTintColor = YBLThemeColor;
    self.control.currentPage = 0;
    self.control.numberOfPages = data_count;
    [self addSubview:self.control];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / self.width;
    self.control.currentPage = index;
}

- (void)buttonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(millionMessageItemClickModel:)]) {
        NSInteger index =  sender.superview.tag;
        NSInteger index_button = sender.tag-tag_button;
        YBLMillionMessageTypeItemModel *itemModel = self.dataArray[index][index_button];
        [self.delegate millionMessageItemClickModel:itemModel];
    }
}

@end
