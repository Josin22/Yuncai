//
//  YBLOrderMakeCommentsViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/6/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderMakeCommentsViewController.h"
#import "LEEStarRating.h"
#import "YBLlimmitTextView.h"
#import "YBLEditPicCollectionView.h"
#import "YBLOrderCommentsSuccessViewController.h"

@interface YBLOrderMakeCommentsViewController ()<YBLEditPicCollectionViewDelegate>

@property (nonatomic, retain) UILabel *showLengthLabel;

@property (nonatomic, strong) YBLlimmitTextView *contenTextView;

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) UIView *niView;

@property (nonatomic, strong) YBLEditPicCollectionView *pickerPhtotCollectionView;

@end

@implementation YBLOrderMakeCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评价晒单";
    
    UIBarButtonItem *commitItem = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(commitComments)];
    commitItem.tintColor = YBLThemeColor;
    self.navigationItem.rightBarButtonItem = commitItem;
    
    [self createUI];
}

- (void)commitComments {
    
    if (self.contenTextView.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"您还没有填写内容哟~"];
        return;
    }
    if (self.contenTextView.text.length<10) {
        [SVProgressHUD showErrorWithStatus:@"评价内容不得少于10个字哟~"];
//        [SVProgressHUD showErrorWithStatus:@"评价内容大于20元的商品就有机会获得云币~"];
        return;
    }
    WEAK
    [[self.viewModel siganlForCreateCommentsWithContentText:self.contenTextView.text] subscribeNext:^(id  _Nullable x) {
        STRONG
        YBLOrderCommentsSuccessViewController *successVc = [YBLOrderCommentsSuccessViewController new];
        [self.navigationController pushViewController:successVc animated:YES];
        
    } error:^(NSError * _Nullable error) {
        
    }];
}

- (void)goback1{
    
    [YBLOrderActionView showTitle:@"您正在晒单评价 \n 确定要离开吗?"
                           cancle:@"继续评价"
                             sure:@"暂不评价"
                  WithSubmitBlock:^{
                      [self.navigationController popViewControllerAnimated:YES];
                  }
                      cancelBlock:^{
                          
                      }];
}

- (void)createUI {

    self.contentScrollView = [[UIScrollView alloc] initWithFrame:[self.view bounds]];
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.bounces = NO;
    self.contentScrollView.backgroundColor = YBLViewBGColor;
    [self.view addSubview:self.contentScrollView];
    
    UIView *goodView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentScrollView.width, 80)];
    goodView.backgroundColor = [UIColor whiteColor];
    [self.contentScrollView addSubview:goodView];
    
    CGFloat image_space = 5;
    
    UIImageView *goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(image_space, image_space, goodView.height-image_space*2, goodView.height-image_space*2)];
    [goodImageView js_scale_setImageWithURL:[NSURL URLWithString:self.viewModel.commentsModel.product_thumb] placeholderImage:smallImagePlaceholder];
    [goodView addSubview:goodImageView];
    
    UILabel *commentsInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodImageView.right+space, image_space, 100, 20)];
    commentsInfoLabel.textColor = BlackTextColor;
    commentsInfoLabel.text = @"评分";
    commentsInfoLabel.font = YBLFont(14);
    commentsInfoLabel.bottom = goodView.height/2-image_space;
    [goodView addSubview:commentsInfoLabel];
    
    LEEStarRating *ratingView = [[LEEStarRating alloc] initWithFrame:CGRectMake(goodImageView.right, goodView.height/2+image_space, 150, 25) Count:5]; //初始化并设置frame和个数
    ratingView.spacing = 10.0f; //间距
    ratingView.checkedImage = [UIImage imageNamed:@"goods_start_select"]; //选中图片
    ratingView.uncheckedImage = [UIImage imageNamed:@"goods_start_normal"]; //未选中图片
    ratingView.type = RatingTypeWhole; //评分类型
    ratingView.touchEnabled = YES; //是否启用点击评分 如果纯为展示则不需要设置
    ratingView.slideEnabled = YES; //是否启用滑动评分 如果纯为展示则不需要设置
    ratingView.maximumScore = 10.0f; //最大分数
    ratingView.minimumScore = 0.0f; //最小分数
    ratingView.currentScore = self.viewModel.ratingCount;
    [self.view addSubview:ratingView];
    // 当前分数变更事件回调
    WEAK
    ratingView.currentScoreChangeBlock = ^(CGFloat score){
        STRONG
        self.viewModel.ratingCount = score;
    };
    //
    YBLlimmitTextView *contenTextView = [[YBLlimmitTextView alloc] initWithFrame:CGRectMake(0, goodImageView.bottom+image_space, self.contentScrollView.width, goodView.height*1.5)];
    contenTextView.limmteTextLength = 500;
    contenTextView.backgroundColor = YBLColor(248, 248, 248, 1);
    contenTextView.font = YBLFont(14);
    contenTextView.textColor = YBLColor(70, 70, 70, 1);
    [self.contentScrollView addSubview:contenTextView];
    self.contenTextView = contenTextView;
    self.contenTextView.limmitTextViewTextChangeLengthBlock = ^(NSInteger changeLength) {
        STRONG
        self.showLengthLabel.text = [NSString stringWithFormat:@"%@",@(500-changeLength)];
    };
    self.showLengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 15)];
    self.showLengthLabel.text  = @"500";
    self.showLengthLabel.textColor = YBLColor(200, 200, 200, 1);
    self.showLengthLabel.font = YBLFont(12);
    self.showLengthLabel.textAlignment = NSTextAlignmentRight;
    self.showLengthLabel.bottom = contenTextView.bottom-space;
    self.showLengthLabel.right = contenTextView.width-space;
    [self.contentScrollView addSubview:self.showLengthLabel];

    LxGridViewFlowLayout *layout = [LxGridViewFlowLayout new];
    //        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.footerReferenceSize = CGSizeZero;
    layout.headerReferenceSize = CGSizeZero;
    layout.sectionInset = UIEdgeInsetsMake(space, space, space, space);
    layout.minimumLineSpacing = space;
    layout.minimumInteritemSpacing = space;
    layout.itemSize = [self getCollectionSize];
    self.pickerPhtotCollectionView = [[YBLEditPicCollectionView alloc] initWithFrame:CGRectMake(0, self.contenTextView.bottom, self.contentScrollView.width, layout.itemSize.height+space)
                                                        collectionViewLayout:layout];
    self.pickerPhtotCollectionView.edit_delegate = self;
    self.pickerPhtotCollectionView.isEditMode = YES;
    self.pickerPhtotCollectionView.scrollEnabled = NO;
    [self.contentScrollView addSubview:self.pickerPhtotCollectionView];
    self.pickerPhtotCollectionView.picDataArray = self.viewModel.picDataArray;
    
    UIView *niView = [[UIView alloc] initWithFrame:CGRectMake(0, self.pickerPhtotCollectionView.bottom, self.pickerPhtotCollectionView.width, 30)];
    niView.backgroundColor = [UIColor whiteColor];
    [self.contentScrollView addSubview:niView];
    self.niView = niView;
    
    YBLButton *niButton = [YBLMethodTools getImageTextButtonWithText:@"匿名评价" buttonSize:CGSizeMake(niView.height, niView.height)];
    niButton.left = space;
    niButton.centerY = niView.height/2;
    niButton.selected = self.viewModel.isNiMing;
    [niView addSubview:niButton];
    [[niButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        self.viewModel.isNiMing = !self.viewModel.isNiMing;
        niButton.selected = self.viewModel.isNiMing;
    }];
    
    [self reloadContentSize];
}

- (CGSize)getCollectionSize{
    CGFloat itemWi = (YBLWindowWidth-5*space)/4;
    CGFloat itemHi = itemWi;
    return CGSizeMake(itemWi, itemHi);
}

- (void)reloadContentSize{
    float row = (float)(self.viewModel.picDataArray.count+1)/4;
    row = ceilf(row);
    CGSize itemSize = [self getCollectionSize];
    self.pickerPhtotCollectionView.height = (itemSize.height+space)*row;
    self.niView.top = self.pickerPhtotCollectionView.bottom;
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.width, self.niView.bottom+space);
}

#pragma mark - delegate
/**
 *  添加图片
 *
 *  @return return value
 */
- (NSInteger)getMaxCountBeforeClickAddImageButton{
    return 9;
}
/**
 *  查看大图
 *
 *  @return return value
 */
- (UIViewController *)getVcWithEditPicItemClickToLookPic{
    return self;
}
/**
 *  点击删除
 *
 *  @param indexPath indexParth
 */
- (void)editPicItemClickToDeleteImageWithIndexPath:(NSIndexPath *)indexPath selectModel:(YBLEditPicItemModel *)selectModel{
    [self.viewModel.picDataArray removeObjectAtIndex:indexPath.row];
    [self.pickerPhtotCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    [self reloadContentSize];
}
/**
 *  替换图片
 *
 *  @param indexPath indexParth
 */
- (void)editPicItemClickToReplaceImageWithIndexPath:(NSIndexPath *)indexPath repalceImage:(UIImage *)repalceImage{
    
    WEAK
    [[self.viewModel siganlForUploadImage:repalceImage index:indexPath.row]subscribeNext:^(id  _Nullable x) {
        STRONG
        [self.pickerPhtotCollectionView reloadItemsAtIndexPaths:@[indexPath]];
    } error:^(NSError * _Nullable error) {
        
    }];
    /*
    YBLEditPicItemModel *oldModel = self.viewModel.picDataArray[indexPath.row];
    oldModel.good_Image_url = repalceImage;
    [self.viewModel.picDataArray replaceObjectAtIndex:indexPath.row withObject:oldModel];
    [self.pickerPhtotCollectionView reloadItemsAtIndexPaths:@[indexPath]];
     */
}
/**
 *  添加图片
 *
 *  @param images images
 */
- (void)editPicItemClickAddImages:(NSArray *)images{
    
//    [self.viewModel.picDataArray removeAllObjects];
    WEAK
    [[self.viewModel siganlForMutilUploadImage:images] subscribeNext:^(id  _Nullable x) {
        STRONG
        NSInteger count = self.viewModel.picDataArray.count;
        NSIndexPath *indexp = [NSIndexPath indexPathForRow:count-1 inSection:0];
        [self.pickerPhtotCollectionView insertItemsAtIndexPaths:@[indexp]];
        [self reloadContentSize];
    } error:^(NSError * _Nullable error) {
        
    }];
    /*
    NSMutableArray *indexps = [YBLMethodTools getNewAppendingIndexPathsWithIndex:self.viewModel.picDataArray.count appendingCount:images.count];
    for (UIImage *image in images) {
        YBLEditPicItemModel *picItemModel = [YBLEditPicItemModel new];
        picItemModel.good_Image_url = image;
        [self.viewModel.picDataArray addObject:picItemModel];
    }
    [self.pickerPhtotCollectionView insertItemsAtIndexPaths:indexps];
//    [self.pickerPhtotCollectionView jsReloadData];
    [self reloadContentSize];
     */
}

@end
