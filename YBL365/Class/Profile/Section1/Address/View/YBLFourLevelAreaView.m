//
//  YBLFourLevelAreaView.m
//  YC168
//
//  Created by 乔同新 on 2017/6/26.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFourLevelAreaView.h"
#import "YBLAddressViewModel.h"
#import "YBLTextSegmentControl.h"
#import "YBLAreaTableView.h"

static NSInteger const tag_area_table_view = 7807;
#define AreaTop  (YBLWindowHeight/2-100)

static YBLFourLevelAreaView *fourLevelAreaView = nil;

@interface YBLFourLevelAreaView ()<YBLTextSegmentControlDelegate,UIScrollViewDelegate>
{
    NSInteger currentIndex;
}
@property (nonatomic, weak  ) UIViewController *fromVc;
@property (nonatomic, assign) NSInteger areaLevelCount;
@property (nonatomic, assign) AreaViewType areaViewType;
@property (nonatomic, copy  ) AreaViewCompletionBlcok completionBlock;
@property (nonatomic, copy  ) AreaViewCancelBlcok cancelBlock;
@property (nonatomic, strong) NSMutableArray *echoDataArray;

@property (nonatomic, strong) YBLTextSegmentControl *areaTextSegment;
@property (nonatomic, strong) UIView                *contentView;
@property (nonatomic, strong) UIView                *blackBGView;
@property (nonatomic, strong) UIScrollView          *contentScrollView;

@property (nonatomic, strong) NSMutableArray        *titleArray;
@property (nonatomic, strong) YBLAddressViewModel   *viewModel;

@end

@implementation YBLFourLevelAreaView

+ (void)showFourLevelAreaViewFromVc:(UIViewController *)fromVc
                           echoData:(NSMutableArray *)echoData
                       areaViewType:(AreaViewType)areaViewType
                     areaLevelCount:(NSInteger)areaLevelCount
                    completionBlock:(AreaViewCompletionBlcok)completionBlock
                        cancelBlock:(AreaViewCancelBlcok)cancelBlock{
    
    if (!fourLevelAreaView) {
        fourLevelAreaView = [[YBLFourLevelAreaView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight)
                                                                 fromVc:fromVc
                                                               echoData:echoData
                                                           areaViewType:areaViewType
                                                         areaLevelCount:areaLevelCount
                                                        completionBlock:completionBlock
                                                            cancelBlock:cancelBlock];
        
        [YBLMethodTools transformOpenView:fourLevelAreaView.contentView
                                SuperView:fourLevelAreaView
                                  fromeVC:fromVc
                                      Top:AreaTop];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
                       fromVc:(UIViewController *)fromVc
                     echoData:(NSMutableArray *)echoData
                 areaViewType:(AreaViewType)areaViewType
               areaLevelCount:(NSInteger)areaLevelCount
              completionBlock:(AreaViewCompletionBlcok)completionBlock
                  cancelBlock:(AreaViewCancelBlcok)cancelBlock{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _fromVc          = fromVc;
        _echoDataArray   = echoData;
        _areaViewType    = areaViewType;
        _areaLevelCount  = areaLevelCount;
        _completionBlock = completionBlock;
        _cancelBlock     = cancelBlock;
        
        [self createUI];
    }
    return self;
}

- (void)createUI {

    self.blackBGView = [[UIView alloc] initWithFrame:[self bounds]];
    self.blackBGView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.blackBGView];
    UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAreaView)];
    [self.blackBGView addGestureRecognizer:dismissTap];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, self.height-AreaTop)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    [YBLMethodTools addTopShadowToView:self.contentView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 70)];
    [self.contentView addSubview:topView];
    
    UILabel *areaInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 80, 20)];
    areaInfoLabel.textAlignment = NSTextAlignmentCenter;
    areaInfoLabel.font = YBLFont(15);
    areaInfoLabel.text = @"所在地区";
    areaInfoLabel.textColor = YBLColor(150, 150, 150, 1);
    areaInfoLabel.centerX = topView.width/2;
    [topView addSubview:areaInfoLabel];
    
    UIButton *undineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    undineButton.frame = CGRectMake(self.width - 50, 0, 50, 50);
    if (_areaViewType == AreaViewTypeWithDoneButton) {
        [undineButton setTitle:@"完成" forState:UIControlStateNormal];
        [undineButton setTitleColor:YBLThemeColor forState:UIControlStateNormal];
        undineButton.titleLabel.font = YBLFont(15);
    } else {
        [undineButton setImage:[UIImage imageNamed:@"address_close"] forState:UIControlStateNormal];
    }
    [undineButton addTarget:self action:@selector(undineButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    undineButton.centerY = areaInfoLabel.centerY;
    [topView addSubview:undineButton];
    
    self.areaTextSegment = [[YBLTextSegmentControl alloc] initWithFrame:CGRectMake(0, areaInfoLabel.bottom, topView.width, topView.height-areaInfoLabel.bottom)
                                                        TextSegmentType:TextSegmentTypeNoArrow];
    self.areaTextSegment.textFont = YBLFont(13);
    self.areaTextSegment.delegate = self;
    [self.areaTextSegment updateTitleData:self.titleArray];
    [topView addSubview:self.areaTextSegment];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, topView.width, 0.5)];
    lineView.backgroundColor = LINE_BASE_COLOR;
    lineView.bottom = topView.height;
    [topView addSubview:lineView];
    
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topView.bottom, self.contentView.width, self.contentView.height-topView.bottom)];
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
    self.contentScrollView.backgroundColor = [UIColor whiteColor];
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.bounces = NO;
    [self.contentView addSubview:self.contentScrollView];

    [self requestFourLevelAreaDataWithId:0 index:currentIndex title:nil];
}

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"请选择"].mutableCopy;
    }
    return _titleArray;
}

- (void)dismissAreaView {
	
    [YBLMethodTools transformCloseView:fourLevelAreaView.contentView
                             SuperView:fourLevelAreaView
                               fromeVC:self.fromVc
                                   Top:self.height
                            completion:^(BOOL finished) {
                                [fourLevelAreaView removeFromSuperview];
                                fourLevelAreaView = nil;
                            }];
}

- (YBLAddressViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [YBLAddressViewModel new];
    }
    return _viewModel;
}

- (void)undineButtonClick:(id)sender {
	
}

- (void)requestFourLevelAreaDataWithId:(NSInteger)_id index:(NSInteger)index title:(NSString *)title{

    WEAK
    [[self.viewModel areaListSignalWithId:_id Index:index] subscribeError:^(NSError * _Nullable error) {
    } completed:^{
        STRONG
        NSInteger lessCount = labs(currentIndex-index);
        if (lessCount==1) {
            lessCount-=1;
        }
        currentIndex = index;
        NSMutableArray *data = self.viewModel.areaDict[@(index)];
        if (data.count==0) {
            return ;
        }
        [self.titleArray removeObjectsInRange:NSMakeRange(0, lessCount)];
        if (title) {
            [self.titleArray insertObject:title atIndex:currentIndex];
        }
        [self.areaTextSegment updateTitleData:self.titleArray];
        self.areaTextSegment.currentIndex = currentIndex;
        YBLAreaTableView *tableView = [self getAreaTableViewWithIndex:index];
        tableView.dataArray = data;
        [tableView jsReloadData];
        self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.width*(index+1), self.contentScrollView.height);
        [self.contentScrollView setContentOffset:CGPointMake(self.contentScrollView.width*index, 0) animated:YES];
    }];
}

- (YBLAreaTableView *)getAreaTableViewWithIndex:(NSInteger)index{
    
    YBLAreaTableView *areaTableView = [self viewWithTag:tag_area_table_view+index];
    if (!areaTableView) {
        areaTableView = [[YBLAreaTableView alloc] initWithFrame:[self.contentScrollView bounds]
                                                          style:UITableViewStylePlain];
        areaTableView.tag = tag_area_table_view+index;
        areaTableView.showsVerticalScrollIndicator = NO;
        WEAK
        areaTableView.areaTableViewCellDidSelectBlock = ^(YBLAddressAreaModel *areaModel) {
            STRONG
            if (currentIndex>=self.areaLevelCount-1) {
                return ;
            }
            [self requestFourLevelAreaDataWithId:areaModel.id.integerValue index:index+1 title:areaModel.text];
        };
        areaTableView.left = index*self.contentScrollView.width;
        [self.contentScrollView addSubview:areaTableView];
    }
    return areaTableView;
}


#pragma mark - delegate
- (void)textSegmentControlIndex:(NSInteger)index selectModel:(id)model{
//    currentIndex = index;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    currentIndex = index;
}

@end
