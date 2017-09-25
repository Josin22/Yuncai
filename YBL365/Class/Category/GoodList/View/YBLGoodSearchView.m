//
//  YBLGoodSearchView.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodSearchView.h"
#import "YBLSearchModel.h"
#import "YBLGoodListViewController.h"
#import "YBLStoreListViewController.h"

static NSInteger const Max_Count = 10;

@interface SearchStoreCell : UITableViewCell

@property (nonatomic, strong) UIButton *clickButton;

@property (nonatomic, strong) NSString *storeName;

@property (nonatomic, retain) UILabel *searchStoreLabel;

+ (CGFloat)getHI;

@end

@implementation SearchStoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat height = [SearchStoreCell getHI];
    
    self.clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.clickButton.frame = CGRectMake(0, 0, YBLWindowWidth, height);
    [self.contentView addSubview:self.clickButton];
    
    UIImageView *storeIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_search_store_icon"]];
    storeIconImageView.frame = CGRectMake(space, 0, 20, 20);
    storeIconImageView.centerY = self.clickButton.height/2;
    [self.clickButton addSubview:storeIconImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(storeIconImageView.right+space, 0, YBLWindowWidth-space*2-storeIconImageView.right, height)];
    label.font = YBLFont(14);
    label.textColor = YBLColor(113, 113, 113, 1);
    [self.clickButton addSubview:label];
    self.searchStoreLabel = label;
    [self.clickButton addSubview:[YBLMethodTools addLineView:CGRectMake(space, height-.5, self.clickButton.width, 0.5)]];
    
}

- (void)setStoreName:(NSString *)storeName{
    _storeName = storeName;

    NSString *appendingStoreText = [NSString stringWithFormat:@"搜索“%@”店铺",_storeName];
    self.searchStoreLabel.text = appendingStoreText;
}

+ (CGFloat)getHI{
    return 40;
}

@end

@interface SearchHistoryCell : UITableViewCell

@property (nonatomic, strong) UIButton *clickButton;

@property (nonatomic, retain) UILabel *searchTextLabel;

+ (CGFloat)getHI;

@end

@implementation SearchHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    
    CGFloat height = [SearchHistoryCell getHI];
    
    self.clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.clickButton.frame = CGRectMake(0, 0, YBLWindowWidth, height);
    [self.contentView addSubview:self.clickButton];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, YBLWindowWidth-space, height)];
    label.font = YBLFont(14);
    label.textColor = YBLColor(113, 113, 113, 1);
    [self.contentView addSubview:label];
    self.searchTextLabel = label;
    [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(space, height-.5, label.width, 0.5)]];
}

- (void)updateItemCellModel:(YBLSearchModel *)itemModel{
    if (itemModel.searchType == SearchTypeGood) {
        self.searchTextLabel.text = itemModel.keyWord;
    } else {
        NSString *appendingStoreText = [NSString stringWithFormat:@"“%@”店铺",itemModel.keyWord];
        self.searchTextLabel.text = appendingStoreText;
    }
}

+ (CGFloat)getHI{
    return 40;
}

@end



static YBLGoodSearchView *searchView = nil;

@interface YBLGoodSearchView ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITextField                 *searchTextFeild;
@property (nonatomic, strong) UIButton                    *messageButton;
@property (nonatomic, strong) UIButton                    *cancleButton;
@property (nonatomic, strong) UIView                      *navView;
@property (nonatomic, strong) UIButton                    *bgMissView;
@property (nonatomic, strong) UIView                      *textfieldView;
@property (nonatomic, strong) UITableView                 *historyTableView;
@property (nonatomic, weak  ) UIViewController            *Vc;
@property (nonatomic, strong) UIView                      *footerView;
@property (nonatomic, assign) SearchType                  searchType;
@property (nonatomic, assign) rightItemViewType           itemType;
@property (nonatomic, copy  ) GoodSearchClickBlock        searchBlock;
@property (nonatomic, copy  ) GoodSearchCancelBlock       cancelBlock;
@property (nonatomic, copy  ) GoodSearchAnimationEndBlock endBlock;

@property (nonatomic, strong) NSMutableArray              *dataArray;
@property (nonatomic, strong) NSString                    *currentText;

@end

@implementation YBLGoodSearchView


+ (void)showGoodSearchViewWithRightItemViewType:(rightItemViewType)itemType
                                   SearchHandle:(GoodSearchClickBlock)searchBlock
                                   cancleHandle:(GoodSearchCancelBlock)cancelBlock
                             animationEndHandle:(GoodSearchAnimationEndBlock)endBlock
                                    currentText:(NSString *)currentText{
    
    [self showGoodSearchViewWithVC:nil
                 RightItemViewType:itemType
                      SearchHandle:searchBlock
                      cancleHandle:cancelBlock
                animationEndHandle:endBlock
                       currentText:currentText];
}


+ (void)showGoodSearchViewWithVC:(UIViewController *)Vc
               RightItemViewType:(rightItemViewType)itemType
                    SearchHandle:(GoodSearchClickBlock)searchBlock
                    cancleHandle:(GoodSearchCancelBlock)cancelBlock
              animationEndHandle:(GoodSearchAnimationEndBlock)endBlock
                     currentText:(NSString *)currentText{
    if (!searchView) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        searchView = [[YBLGoodSearchView alloc] initWithFrame:[window bounds]
                                                           Vc:Vc
                                            rightItemViewType:itemType
                                                 SearchHandle:searchBlock
                                                 cancleHandle:cancelBlock
                                           animationEndHandle:endBlock
                                                  currentText:currentText];
        [window addSubview:searchView];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
                           Vc:(UIViewController *)Vc
            rightItemViewType:(rightItemViewType)itemType
                 SearchHandle:(GoodSearchClickBlock)searchBlock
                 cancleHandle:(GoodSearchCancelBlock)cancelBlock
           animationEndHandle:(GoodSearchAnimationEndBlock)endBlock
                  currentText:(NSString *)currentText{
    
    if (self = [super initWithFrame:frame]) {
        
        _itemType = itemType;
        _searchBlock = searchBlock;
        _cancelBlock = cancelBlock;
        _endBlock = endBlock;
        _currentText = currentText;
        _Vc = Vc;
        
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:false];
    
    /* navView  */
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kNavigationbarHeight)];
    navView.backgroundColor = [UIColor whiteColor];
    [self addSubview:navView];
    self.navView = navView;
    
    UIView *textfieldView = [[UIView alloc] initWithFrame:CGRectMake(54, 20+7, navView.width - 54*2, 30)];
    textfieldView.backgroundColor = YBLColor(240, 242, 245, 1);
    textfieldView.layer.cornerRadius = textfieldView.height/2;
    textfieldView.layer.masksToBounds = YES;
    [self addSubview:textfieldView];
    self.textfieldView = textfieldView;

    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 7.5, 15, 15)];
    searchImageView.image = [UIImage imageNamed:@"new_search_icon"];
    [textfieldView addSubview:searchImageView];
    
    UITextField *searchTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(searchImageView.right+5, 0, textfieldView.width-searchImageView.right-20, textfieldView.height)];
    searchTextFeild.borderStyle = UITextBorderStyleNone;
    searchTextFeild.font = YBLFont(14);
    searchTextFeild.delegate = self;
    searchTextFeild.placeholder = @"搜索商品";
    searchTextFeild.text = self.currentText;
    searchTextFeild.backgroundColor = [UIColor clearColor];
    searchTextFeild.returnKeyType = UIReturnKeySearch;
    [searchTextFeild becomeFirstResponder];
    [textfieldView addSubview:searchTextFeild];
    self.searchTextFeild = searchTextFeild;
 
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    messageButton.frame = CGRectMake(navView.width - 44 - 5, 20, 44, 44);
    [navView addSubview:messageButton];
    self.messageButton = messageButton;
    
    /*取消*/
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(navView.width - 44 - 5, 20, 44, 44);
    [navView addSubview:cancleButton];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:YBLColor(155, 155, 155, 1.0) forState:UIControlStateNormal];
    cancleButton.titleLabel.font = YBLFont(14);
    cancleButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
    WEAK
    [[cancleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        [self dismissAllView];
    }];
    self.cancleButton = cancleButton;
    [navView addSubview:[YBLMethodTools addLineView:CGRectMake(0, navView.height-0.5, navView.width, 0.5)]];
    
    if (_itemType == rightItemViewTypeNoView) {
        
        UIButton *bgMissView = [UIButton buttonWithType:UIButtonTypeCustom];
        bgMissView.frame = CGRectMake(0, navView.bottom, self.width, self.height-navView.bottom);
        bgMissView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
        [self addSubview:bgMissView];
        self.bgMissView = bgMissView;
        [[bgMissView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG
            [self dismissAllView];
        }];
    } else {
        if (_itemType == rightItemViewTypeHomeNews) {
            [messageButton setTitle:@"消息" forState:UIControlStateNormal];
            [messageButton setImage:[UIImage imageNamed:@"JDMainPage_icon_message02_18x18_"] forState:UIControlStateNormal];
            [messageButton setTitleColor:YBLColor(47, 47, 47, 1.0) forState:UIControlStateNormal];
            messageButton.titleLabel.font = YBLFont(11);
            [messageButton setImageEdgeInsets:UIEdgeInsetsMake(-10, 10, 0, 0)];
            [messageButton setTitleEdgeInsets:UIEdgeInsetsMake(25, -19, 0, 0)];
            
        } else if (_itemType == rightItemViewTypeCatgeoryNews){
            
            [messageButton setImage:[UIImage imageNamed:@"NewFinderNaviMessageIcon_20x20_"] forState:UIControlStateNormal];
            
        }
        /* table view */
        self.historyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navView.bottom, self.width, self.height-navView.bottom) style:UITableViewStylePlain];
        self.historyTableView.dataSource = self;
        self.historyTableView.delegate  = self;
        self.historyTableView.backgroundColor = [UIColor whiteColor];
        self.historyTableView.rowHeight = [SearchHistoryCell getHI];
        self.historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.historyTableView registerClass:NSClassFromString(@"SearchHistoryCell") forCellReuseIdentifier:@"SearchHistoryCell"];
        [self.historyTableView registerClass:NSClassFromString(@"SearchStoreCell") forCellReuseIdentifier:@"SearchStoreCell"];
        [self addSubview:self.historyTableView];
        
        [[self.searchTextFeild rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
            STRONG
            [self.historyTableView jsReloadData];
        }];
    }

    /* animation */
    [UIView animateWithDuration:.2f
                     animations:^{
                         CGFloat left = self.textfieldView.left-space;
                         self.textfieldView.left = space;
                         self.textfieldView.width += left;
                         self.searchTextFeild.width += left;
                         self.messageButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
                     }
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:.3 animations:^{
                             self.cancleButton.transform = CGAffineTransformIdentity;
                         } completion:^(BOOL finished) {
                             
                         }];
                     }];
}

- (void)dismissAllView{
    
    BLOCK_EXEC(self.cancelBlock,);
    [self.navView removeFromSuperview];
    if (self.historyTableView) {
     [self.historyTableView removeFromSuperview];
    }
    if (self.bgMissView) {
        [self.bgMissView removeFromSuperview];
    }
    self.searchTextFeild.text = nil;
    [self.searchTextFeild resignFirstResponder];
    
    [UIView animateWithDuration:.2 animations:^{
        self.textfieldView.left = 54;
        self.textfieldView.width -= 44;
        self.searchTextFeild.width -= 44;
        
    } completion:^(BOOL finished) {
        BLOCK_EXEC(self.endBlock,);
        [self dismissView];
    }];
}


- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSMutableArray *get_search_array = [self keyArray];
        if (get_search_array.count>0) {
            self.historyTableView.tableFooterView = self.footerView;
        } else {
            self.historyTableView.tableFooterView = [UIView new];
        }
        _dataArray = get_search_array;
    }
    return _dataArray;
}

- (UIView *)footerView{
    
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 80)];
        _footerView.backgroundColor = [UIColor whiteColor];
        CGFloat buttonwi = _footerView.width-60*2;
        YBLButton *cleanButton = [YBLButton buttonWithType:UIButtonTypeCustom];
        cleanButton.frame = CGRectMake(60, 0, buttonwi, 40);
        cleanButton.layer.cornerRadius = 3;
        cleanButton.layer.masksToBounds = YES;
        cleanButton.layer.borderColor = YBLLineColor.CGColor;
        cleanButton.layer.borderWidth = 0.5;
        [cleanButton setTitle:@"清空历史搜索" forState:UIControlStateNormal];
        cleanButton.titleLabel.font = YBLFont(15);
        cleanButton.centerY = _footerView.height/2;
        [cleanButton setTitleColor:YBLColor(113, 113, 113, 1) forState:UIControlStateNormal];
        [cleanButton setImage:[UIImage imageNamed:@"order_delete"] forState:UIControlStateNormal];
        cleanButton.titleRect = CGRectMake(buttonwi/3, 0, buttonwi*2/3, 40);
        CGFloat imageWi = 20;
        cleanButton.imageRect = CGRectMake(buttonwi/3-imageWi-5, 10, imageWi, imageWi);
        [_footerView addSubview:cleanButton];
        WEAK
        [[cleanButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            [self removeAllHistoryData];
        }];
    }
    return _footerView;
}

#pragma mark -  data source

- (NSInteger )getTextFeildCount{
    NSInteger storeCount = 0;
    if ([self checkTextVaild:self.searchTextFeild.text]) {
        storeCount = 1;
    }
    return storeCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger storeCount = [self getTextFeildCount];
    NSInteger historyCount = self.dataArray.count>0?1:0;
    return storeCount+historyCount;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
   if ([self getTextFeildCount] == 1&&section==0) {
       return 1;
   }
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self getTextFeildCount] == 1&&section==0) {
        return 0;
    }
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([self getTextFeildCount] == 1&&section==0) {
        return 0;
    } else {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, self.width-space, headerView.height)];
        label.text = @"历史搜索";
        label.textColor = BlackTextColor;
        label.font = YBLBFont(15);
        [headerView addSubview:label];
        [headerView addSubview:[YBLMethodTools addLineView:CGRectMake(0, headerView.height-0.5, headerView.width, 0.5)]];
        return headerView;
   
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self getTextFeildCount] == 1&&indexPath.section==0) {
        
        SearchStoreCell *storeCell = [tableView dequeueReusableCellWithIdentifier:@"SearchStoreCell" forIndexPath:indexPath];
        
        storeCell.storeName = self.searchTextFeild.text;
        WEAK
        [[[storeCell.clickButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:storeCell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            [self recieveText:self.searchTextFeild.text searchType:SearchTypeStore];
        }];
        
        return storeCell;
        
    } else {
        
        SearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchHistoryCell" forIndexPath:indexPath];
        
        [self configureCell:cell forRowAtIndexPath:indexPath];
        
        return cell;
    }
}

- (void)configureCell:(SearchHistoryCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YBLSearchModel *searModel = self.dataArray[indexPath.row];
    [cell updateItemCellModel:searModel];
    [[[cell.clickButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self recieveText:searModel.keyWord searchType:searModel.searchType];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([self checkTextVaild:textField.text]) {
        [self recieveText:textField.text searchType:SearchTypeGood];
        return YES;
    }
    return NO;
}
/**
 *  搜索
 *
 *  @param text       文字
 *  @param searchType searchType
 */
- (void)recieveText:(NSString *)text searchType:(SearchType)searchType{
    
    YBLSearchModel *model = [YBLSearchModel getSearchModelWithKeyword:text searchType:searchType];
    [self saveHistoryTextModel:model];
    if (self.Vc) {
        if (searchType == SearchTypeGood) {
            //商品
            YBLGoodListViewModel *listViewModel = [YBLGoodListViewModel new];
            listViewModel.keyWord = text;
            YBLGoodListViewController *listVC = [YBLGoodListViewController new];
            listVC.viewModel = listViewModel;
            [self.Vc.navigationController pushViewController:listVC animated:YES];
        } else {
            //店铺
            YBLStoreListViewModel *store_view_model = [YBLStoreListViewModel new];
            store_view_model.storeName = text;
            YBLStoreListViewController *store_vc = [YBLStoreListViewController new];
            store_vc.viewModel = store_view_model;
            [self.Vc.navigationController pushViewController:store_vc animated:YES];
        }

    }
    BLOCK_EXEC(self.searchBlock,text,searchType);
    BLOCK_EXEC(self.endBlock,);
    [self.searchTextFeild resignFirstResponder];
    [self dismissView];
}

- (void)saveHistoryTextModel:(YBLSearchModel *)model{

    NSMutableArray *get_search_array = [self keyArray];
    if (!get_search_array) {
        get_search_array = [NSMutableArray arrayWithCapacity:10];
    }
    if (get_search_array.count==Max_Count) {
        [get_search_array removeObject:[get_search_array lastObject]];
    }
    BOOL isSame = NO;
    for (YBLSearchModel *seaModel in get_search_array) {
        if ([seaModel.keyWord isEqualToString:model.keyWord]) {
            isSame = YES;
        }
    }
    if (!isSame) {
        [get_search_array insertObject:model atIndex:0];
        [self setKeyArray:get_search_array];
    }
}

- (void)removeAllHistoryData{
    
    NSMutableArray *get_search_array = [self keyArray];
    [get_search_array removeAllObjects];
    [self setKeyArray:get_search_array];
    self.dataArray = nil;
    [self.historyTableView jsReloadData];
}

- (void)setKeyArray:(NSMutableArray *)keyarray{
    NSData *save_data = [NSKeyedArchiver archivedDataWithRootObject:keyarray];
    [[NSUserDefaults standardUserDefaults] setObject:save_data forKey:search_key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray *)keyArray{
    NSData *get_search_data = [[NSUserDefaults standardUserDefaults] objectForKey:search_key];
    NSMutableArray *get_search_array = [NSKeyedUnarchiver unarchiveObjectWithData:get_search_data];
    return get_search_array;
}

- (BOOL)checkTextVaild:(NSString *)text{
    BOOL isVaild = NO;
    if (text.length>0&&![text hasPrefix:@" "]) {
        isVaild = YES;
    }
    return isVaild;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self endEditing:YES];
}
- (void)dismissView{
    
    [searchView removeFromSuperview];
    searchView = nil;
}

@end
