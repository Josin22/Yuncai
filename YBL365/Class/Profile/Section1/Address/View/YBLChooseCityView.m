//
//  YBLChooseCityView.m
//  YBL365
//
//  Created by 乔同新 on 16/12/24.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLChooseCityView.h"
#import "YBLAreaTableView.h"

static NSInteger tag_select_button = 133;
static NSInteger tag_areaTableView = 233;

static YBLChooseCityView *chooseCityView = nil;

@interface YBLChooseCityView ()<UIScrollViewDelegate>
{
    NSInteger limmitCount;
    NSInteger currentIndex;
    YBLAddressAreaModel *lastModel;
}
@property (nonatomic, weak  ) UIViewController *vc;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *areaScrollView;
@property (nonatomic, strong) UIView *redLineView;
@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) NSMutableArray *selectArray;

@property (nonatomic, assign) NSInteger cityCount;
@property (nonatomic, assign) ChooseCityViewType cityViewType;
@property (nonatomic, copy  ) ChooseCitySuccessBlcok successBlock;

@property (nonatomic, strong) YBLAddressViewModel *viewModel;

@end

@implementation YBLChooseCityView

+ (void)chooseCityWithViewController:(UIViewController *)VC
                           cityCount:(NSInteger)cityCount
                        cityViewType:(ChooseCityViewType)cityViewType
                        successBlock:(ChooseCitySuccessBlcok)successBlock{
    
    if (!chooseCityView) {
        
        chooseCityView = [[YBLChooseCityView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight)
                          
                                                       controller:VC
                                                        cityCount:cityCount
                                                     cityViewType:cityViewType
                                                     successBlock:successBlock];
            [YBLMethodTools transformOpenView:chooseCityView.contentView SuperView:chooseCityView fromeVC:VC Top:YBLWindowHeight/2-100];
    }
    
}


- (instancetype)initWithFrame:(CGRect)frame
                   controller:(UIViewController *)VC
                    cityCount:(NSInteger)cityCount
                 cityViewType:(ChooseCityViewType)cityViewType
                 successBlock:(ChooseCitySuccessBlcok)successBlock{
    
    if(self = [super initWithFrame:frame]){

        _vc = VC;
        _cityCount = cityCount;
        _cityViewType = cityViewType;
        _successBlock = successBlock;
        
        [self createSubViews];
    }
    return self;
}

- (NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (void)createSubViews {
    
    UIView *bgView = [[UIView alloc] initWithFrame:[self bounds]];
    bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgView];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [bgView addGestureRecognizer:tap];
    self.bgView = bgView;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, YBLWindowHeight, YBLWindowWidth, YBLWindowHeight/2+100)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    [YBLMethodTools addTopShadowToView:contentView];
    self.contentView = contentView;
    
    UILabel *areaInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 80, 20)];
    areaInfoLabel.textAlignment = NSTextAlignmentCenter;
    areaInfoLabel.font = YBLFont(15);
    areaInfoLabel.text = @"所在地区";
    areaInfoLabel.textColor = YBLColor(150, 150, 150, 1);
    areaInfoLabel.centerX = self.width/2;
    [contentView addSubview:areaInfoLabel];
    
    UIButton *undineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    undineButton.frame = CGRectMake(self.width - 50, 0, 50, 50);
    if (_cityViewType == ChooseCityViewTypeWithDoneButton) {
        [undineButton setTitle:@"完成" forState:UIControlStateNormal];
        [undineButton setTitleColor:YBLThemeColor forState:UIControlStateNormal];
        undineButton.titleLabel.font = YBLFont(15);
    } else {
        [undineButton setImage:[UIImage imageNamed:@"address_close"] forState:UIControlStateNormal];
    }
    [undineButton addTarget:self action:@selector(undineButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    undineButton.centerY = areaInfoLabel.centerY;
    [contentView addSubview:undineButton];

    CGFloat buttonWi = 50;
    CGFloat buttonHi = 30;
    
    limmitCount = _cityCount-1;
    
    NSString *title_select = @"请选择";
    CGSize lineSize = [title_select heightWithFont:YBLFont(13) MaxWidth:200];
    
    for (int i = 0; i < limmitCount; i++) {
        UIButton *selectTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectTitleButton.frame = CGRectMake(space+i*buttonWi, areaInfoLabel.bottom+15, buttonWi, buttonHi);
        selectTitleButton.tag = tag_select_button+i;
        selectTitleButton.titleLabel.font = YBLFont(13);
        selectTitleButton.hidden = YES;
        [selectTitleButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
        [selectTitleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:selectTitleButton];
        if (i==0) {
            
            self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.selectButton setTitle:title_select forState:UIControlStateNormal];
            [self.selectButton setTitleColor:YBLThemeColor forState:UIControlStateNormal];
            self.selectButton.titleLabel.font = YBLFont(13);
            self.selectButton.frame = CGRectMake(space, selectTitleButton.top, lineSize.width, buttonHi);
            [self.selectButton addTarget:self action:@selector(selectbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:self.selectButton];
        }
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.selectButton.bottom, contentView.width, 0.5)];
    lineView.backgroundColor = LINE_BASE_COLOR;
    [contentView addSubview:lineView];

    self.redLineView = [[UIView alloc]initWithFrame:CGRectMake(0, lineView.bottom-1.2, lineSize.width, 1.2)];
    self.redLineView.backgroundColor = YBLThemeColor;
    self.redLineView.centerX = self.selectButton.centerX;
    [contentView addSubview:self.redLineView];
    
    self.areaScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.redLineView.bottom, contentView.width, contentView.height-self.redLineView.bottom)];
    self.areaScrollView.pagingEnabled = YES;
    self.areaScrollView.bounces = NO;
    self.areaScrollView.delegate = self;
    self.areaScrollView.showsHorizontalScrollIndicator = NO;
    self.areaScrollView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:self.areaScrollView];
    
    self.viewModel = [YBLAddressViewModel new];
 
    [self checkAreaTableViewIsExsitWithIndex:0 _id:0];
}

#pragma mark - method

- (void)selectbuttonClick:(UIButton *)btn{
    
    NSInteger index = self.selectArray.count;
    [self redLineSlideToIndex:index];
    [self.areaScrollView setContentOffset:CGPointMake(index*self.areaScrollView.width, 0) animated:YES];
}

- (void)checkAreaTableViewIsExsitWithIndex:(NSInteger)index _id:(NSInteger)_id{
    
    WEAK
    [[self.viewModel areaListSignalWithId:_id Index:index] subscribeError:^(NSError *error) {
        STRONG
        [self handleWithModel:lastModel selectArray:self.selectArray isDoneClick:NO];
    } completed:^{
        STRONG
        //判断下级地区数据是否为空
        NSMutableArray *data = self.viewModel.areaDict[@(index)];
        if (data.count==0) {
            currentIndex = index-1;
            NSArray *data = self.viewModel.areaDict[@(currentIndex)];
            [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YBLAddressAreaModel *model  = (YBLAddressAreaModel *)obj;
                if (model.isSelect) {
                    [self handleWithModel:model selectArray:self.selectArray isDoneClick:NO];
                    *stop = YES;
                }
            }];
        } else {
            //已创建
            YBLAreaTableView *areaTableView = [self getAreaTabelViewWith:index];
            areaTableView.dataArray = data;
            [areaTableView jsReloadData];
        }
        [self.areaScrollView setContentOffset:CGPointMake(self.areaScrollView.width*index, 0) animated:YES];
        self.areaScrollView.contentSize = CGSizeMake(self.areaScrollView.width*(index+1), self.areaScrollView.height);
        currentIndex = index;
    }];
    
}

- (YBLAreaTableView *)getAreaTabelViewWith:(NSInteger)index{
    YBLAreaTableView *areaTableView = (YBLAreaTableView *)[self viewWithTag:index+tag_areaTableView];
    if (!areaTableView) {
        WEAK
        areaTableView = [[YBLAreaTableView alloc] initWithFrame:[self.areaScrollView bounds] style:UITableViewStylePlain];
        areaTableView.tag = tag_areaTableView+index;
        areaTableView.left = self.areaScrollView.width*index;
        ///选中事件
        areaTableView.areaTableViewCellDidSelectBlock = ^(YBLAddressAreaModel *model){
            STRONG
            lastModel = model;
            ///1.到达极限
            if (index!=limmitCount) {
                currentIndex = index+1;
            }
            ///2.未选中
            if (!model.isSelect&&index!=limmitCount) {
                [self checkAreaTableViewIsExsitWithIndex:currentIndex _id:(model.id.integerValue)];
            } else {
                //滚
                [self.areaScrollView setContentOffset:CGPointMake(self.areaScrollView.width*(currentIndex), 0) animated:YES];
            }
            ///3.添加到数据
            
            //1.判断是否存在对象
            if (![self.selectArray containsObject:model]) {
                if (index<self.selectArray.count) {
                    NSMutableIndexSet *selectIndexSet = [NSMutableIndexSet indexSet];
                    for (int i = 0; i < self.selectArray.count; i++) {
                        if (i>=index) {
                            [selectIndexSet addIndex:i];
                        }
                    }
                    [self.selectArray removeObjectsAtIndexes:selectIndexSet];
                }
                [self.selectArray addObject:model];
                //2.刷新title seg
                [self reloadTitleSegment];
            } else {
                //直接
                [self redLineSlideToIndex:currentIndex];
            }
            if (index==limmitCount) {
                [self handleWithModel:model selectArray:self.selectArray isDoneClick:NO];
            }
        };
        [self.areaScrollView addSubview:areaTableView];
    }
    return areaTableView;
}

- (void)handleWithModel:(YBLAddressAreaModel *)model selectArray:(NSMutableArray *)selectArray isDoneClick:(BOOL)isDoneClick{
    if (_cityViewType != ChooseCityViewTypeWithDoneButton||isDoneClick) {
        BLOCK_EXEC(self.successBlock,model,selectArray);
        [self dismiss];
    }
}

- (void)titleButtonClick:(UIButton *)btn{
    
    NSInteger index = btn.tag-tag_select_button;
    
    [self redLineSlideToIndex:index];
    
    [self.areaScrollView setContentOffset:CGPointMake(index*self.areaScrollView.width, 0) animated:YES];
}

- (void)redLineSlideToIndex:(NSInteger)index{
    
    UIButton *selectTitleButton = (UIButton *)[self viewWithTag:tag_select_button+index];
    [UIView animateWithDuration:.2f
                          delay:0
         usingSpringWithDamping:.8
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (selectTitleButton.isHidden||index==limmitCount) {
                             self.redLineView.width = self.selectButton.width;
                             self.redLineView.centerX = self.selectButton.centerX;
                         } else {
                             self.redLineView.width = selectTitleButton.width;
                             self.redLineView.centerX = selectTitleButton.centerX;
                         }
                         
                     }
                     completion:^(BOOL finished) {
                         
                     }];

}

- (void)reloadTitleSegment{
    
    NSInteger index = 0;
    CGFloat maxWidthLeft = space;
    
    for (int i = 0; i < limmitCount; i++) {
        UIButton *selectTitleButton = (UIButton *)[self viewWithTag:tag_select_button+i];
        selectTitleButton.hidden = YES;
    }
    
    for (YBLAddressAreaModel *model in self.selectArray) {
        UIButton *selectTitleButton = (UIButton *)[self viewWithTag:tag_select_button+index];
        if (!selectTitleButton) {
            return;
        }
        [selectTitleButton setTitle:model.text forState:UIControlStateNormal];
        selectTitleButton.hidden = NO;
        CGSize textSize = [model.text heightWithFont:YBLFont(13) MaxWidth:200];
        selectTitleButton.width = textSize.width;
        maxWidthLeft += textSize.width+space;
        selectTitleButton.left = maxWidthLeft-textSize.width-space;
        index++;
    }
    [UIView animateWithDuration:.2f
                          delay:0
         usingSpringWithDamping:.8
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.selectButton.left = maxWidthLeft;
                         self.redLineView.width = self.selectButton.width;
                         self.redLineView.centerX = self.selectButton.centerX;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
   
}

- (void)dismiss{
 
    [YBLMethodTools transformCloseView:chooseCityView.contentView SuperView:chooseCityView fromeVC:_vc Top:YBLWindowHeight completion:^(BOOL finished) {
        [chooseCityView removeFromSuperview];
        chooseCityView = nil;
    }];
}

#pragma mark - scroll delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    currentIndex = index;
    [self redLineSlideToIndex:index];
}

- (void)undineButtonClick:(id)sender {

    [self handleWithModel:lastModel selectArray:self.selectArray isDoneClick:YES];
}

@end
