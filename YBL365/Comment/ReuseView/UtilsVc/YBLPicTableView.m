//
//  YBLPicTableView.m
//  YC168
//
//  Created by 乔同新 on 2017/6/2.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPicTableView.h"
#import "YBLPicDetailCell.h"
#import "YBLEvaluateBaseCell.h"
#import "YBLOrderCommentsItemModel.h"

@interface YBLPicTableView ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *finDataArray;

@property (nonatomic, assign) PicTableViewType picTableViewType;

@property (nonatomic, strong) YBLEvaluateBaseCell *commentCell;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *customHeaderView;

@property (nonatomic, strong) UIView *commentsHeaderView;


@end

@implementation YBLPicTableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style{
    
    return [self initWithFrame:frame
                         style:style
              picTableViewType:PicTableViewTypeNoHeader];
}

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
             picTableViewType:(PicTableViewType)picTableViewType{

    if (self = [super initWithFrame:frame style:style]) {
        
        _picTableViewType = picTableViewType;
        
        self.dataSource = self;
        self.delegate   = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableFooterView = [UIView new];
        
        if (_picTableViewType == PicTableViewTypeHasCustomHeader) {
            self.tableHeaderView = self.customHeaderView;
        } else if (_picTableViewType == PicTableViewTypeCommentsHeader){
            self.tableHeaderView = self.commentsHeaderView;;
        }
    }
    return self;

}

- (NSMutableArray *)finDataArray{
    if (!_finDataArray) {
        _finDataArray = [NSMutableArray array];
    }
    return _finDataArray;
}

- (void)setImageURLsArray:(NSMutableArray *)imageURLsArray{
    _imageURLsArray = imageURLsArray;
 
    NSMutableArray *tempArray = @[].mutableCopy;
    for (NSString *url in _imageURLsArray) {
        PICModel *model = [PICModel new];
        model.cell_height = @(210.0f);
        model.cellIdentifier = url;
        model.image_url = url;
        [self.finDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PICModel *obj_model = (PICModel *)obj;
            if ([obj_model.cellIdentifier isEqualToString:url]) {
                model.cell_height =obj_model.cell_height;
            }
        }];
        [tempArray addObject:model];
    }
    if (self.finDataArray.count>0) {
        [self.finDataArray removeAllObjects];
    }
    self.finDataArray = tempArray;
    
    [self reloadData];
}

- (void)setCommentModel:(YBLOrderCommentsModel *)commentModel{
    _commentModel = commentModel;
    if (!_commentModel.k_user_name) {
        if (_commentModel.anonymity.boolValue) {
            _commentModel.k_user_name = [YBLMethodTools changeToNiMing:_commentModel.user_name];
        } else {
            _commentModel.k_user_name = _commentModel.user_name;
        }
        CGSize contentSize = [_commentModel.content heightWithFont:YBLFont(14) MaxWidth:YBLWindowWidth-space];
        _commentModel.content_height = @(contentSize.height);
    }
    
    [self.commentCell updateItemCellModel:_commentModel];
    CGFloat height = [YBLEvaluateBaseCell getItemCellHeightWithModel:_commentModel]-_commentModel.gridView_height.floatValue;
    self.commentsHeaderView.height = height;
    self.lineView.bottom = self.commentsHeaderView.height;
    self.imageURLsArray = _commentModel.pictures;
}

- (UIView *)customHeaderView{
    
    if (!_customHeaderView) {
        _customHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowWidth+kBottomBarHeight)];
        YBLGoodsBannerView *bannerView = [[YBLGoodsBannerView alloc] initWithFrame:CGRectMake(0, 0, _customHeaderView.width, YBLWindowWidth)
                                                                     imageURLArray:nil];
        [_customHeaderView addSubview:bannerView];
        self.goodBannerView = bannerView;
        YBLGoodsManageItemButton *itemButton = [[YBLGoodsManageItemButton alloc] initWithFrame:CGRectMake(0, self.goodBannerView.bottom, self.goodBannerView.width, kBottomBarHeight)
                                                           titleArray:@[@"主图",
                                                                        @"详情图",
                                                                        @"营销图"]];
        itemButton.backgroundColor = YBLColor(247, 247, 247, 1);
        [_customHeaderView addSubview:itemButton];
        self.itemButton = itemButton;
    }
    return _customHeaderView;
}

- (UIView *)commentsHeaderView{
    if (!_commentsHeaderView) {
        _commentsHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 200)];
        _commentsHeaderView.backgroundColor = [UIColor whiteColor];
        self.commentCell = [[YBLEvaluateBaseCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        [_commentsHeaderView addSubview:self.commentCell];
        UIView *lineView = [YBLMethodTools addLineView:CGRectMake(0, 0, _commentsHeaderView.width, .5)];
        [_commentsHeaderView addSubview:lineView];
        self.lineView = lineView;
    }
    return _commentsHeaderView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.finDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PICModel *model = self.finDataArray[indexPath.row];
    return model.cell_height.floatValue;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PICModel *model = self.finDataArray[indexPath.row];
//    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    YBLPicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:model.cellIdentifier];
    if (!cell) {
        cell = [[YBLPicDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:model.cellIdentifier];
        [cell updateItemCellModel:model];
    }
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat y = scrollView.contentOffset.y;
    if (y<-scroll_top) {
        BLOCK_EXEC(self.picDetailScrollPullBlock,)
    }
}

@end
