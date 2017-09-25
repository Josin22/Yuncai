//
//  YBLScanRecordsViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLScanRecordsViewController.h"
#import "YBLScanContentViewController.h"
#import "YBLScanRecordsModel.h"
#import "YBLGoodsDetailViewModel.h"

@interface YBLScanRecordsCell : UITableViewCell

//@property (nonatomic, strong) NSString *valueString;
@property (nonatomic, strong) YBLScanRecordsModel *recordModel;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *contentLabel;
@property (nonatomic, retain) UILabel *timeLabel;

@end

@implementation YBLScanRecordsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.contentView.backgroundColor = YBLColor(243, 245, 247, 1);
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, 80, 80)];
    [self addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(iconImageView.right+space, space, 100, 20)];
    titleLabel.textColor = YBLColor(40, 40, 40, 1);
    titleLabel.font = YBLFont(13);
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom+5, YBLWindowWidth-titleLabel.left-space-30,50)];
    contentLabel.font = YBLFont(12);
    contentLabel.textColor = YBLColor(166, 166, 166, 1);
    [self addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabel.left, iconImageView.bottom-15, contentLabel.width, 15)];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.font = YBLFont(12);
    timeLabel.textColor = YBLColor(166, 166, 166, 1);
    timeLabel.text = @"2017-02-14";
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"found_arrow"]];
    arrowImageView.frame = CGRectMake(0, 0, 8, 16.5);
    arrowImageView.center = CGPointMake(contentLabel.right+20, 50);
    [self addSubview:arrowImageView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, iconImageView.bottom+space-0.5, YBLWindowWidth, 0.5)];
    lineView.backgroundColor = YBLLineColor;
    [self addSubview:lineView];
}

- (CGFloat)getHI{
    
    return self.iconImageView.bottom+space;
}

+ (CGFloat)getCellHi{
    
    return [[YBLScanRecordsCell new] getHI];
}

- (void)setRecordModel:(YBLScanRecordsModel *)recordModel{
    _recordModel = recordModel;
    
    self.titleLabel.text = _recordModel.content_title;
    self.contentLabel.text = _recordModel.content;
    if (_recordModel.scanType ==ScanTypeText) {
        self.iconImageView.image = [UIImage imageNamed:@"newbarcode_history_barcodeimage"];
    } else {
        self.iconImageView.image = [UIImage imageNamed:@"newbarcode_history_qrcodeimage"];
    }
    self.contentLabel.height = _recordModel.content_height;
    self.timeLabel.text = _recordModel.time;
}

@end

@interface YBLScanRecordsViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *recordsTableView;

@property (nonatomic, strong) NSMutableArray *recordsData;

@end

@implementation YBLScanRecordsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫描记录";
    
    [self.view addSubview:self.recordsTableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(clearData:)];
}


- (void)clearData:(UIBarButtonItem *)item{
    
    [YBLScanRecordsModel bg_deleteWhere:nil];
    [self.recordsData removeAllObjects];
    [self.recordsTableView jsReloadData];
}


-(NSMutableArray *)recordsData{
    
    if (!_recordsData) {
        _recordsData = [YBLScanRecordsModel bg_findAll].mutableCopy;
//        [_recordsData addObject:@"123123123"];
//        [_recordsData addObject:@"65645746123"];
//        [_recordsData addObject:@"123123123"];
//        [_recordsData addObject:@"http://yuncai.com"];
//        [_recordsData addObject:@"http://yuncai.com"];
//        [_recordsData addObject:@"http://yuncai.com"];
//        [_recordsData addObject:@"123123123"];
//        [_recordsData addObject:@"http://yuncai.com"];
    }
    return _recordsData;
}

- (UITableView *)recordsTableView{
    
    if (!_recordsTableView) {
        _recordsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight-kNavigationbarHeight) style:UITableViewStylePlain];
        _recordsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _recordsTableView.dataSource = self;
        _recordsTableView.delegate = self;
        _recordsTableView.emptyDataSetSource = self;
        _recordsTableView.emptyDataSetDelegate = self;
        _recordsTableView.rowHeight = [YBLScanRecordsCell getCellHi];
        [_recordsTableView registerClass:NSClassFromString(@"YBLScanRecordsCell") forCellReuseIdentifier:@"YBLScanRecordsCell"];
    }
    return _recordsTableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.recordsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLScanRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLScanRecordsCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLScanRecordsCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.recordModel = self.recordsData[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YBLScanRecordsModel *model = self.recordsData[indexPath.row];
    if (model.scanType == ScanTypeText) {
        YBLScanContentViewController *contentVC = [[YBLScanContentViewController alloc] init];
        contentVC.content = model.content;
        [self.navigationController pushViewController:contentVC animated:YES];
    } else if (model.scanType == ScanTypeURL) {
        [YBLMethodTools pushWebVcFrom:self URL:model.content title:nil];
    } else if (model.scanType == ScanTypeGood) {
        [YBLGoodsDetailViewModel singalForGoodIDWithQrcid:model.content selfVc:self];
    }

//    YBLScanContentViewController *contentVC = [[YBLScanContentViewController alloc] init];
//    contentVC.content = self.recordsData[indexPath.row];
//    [self.navigationController pushViewController:contentVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    YBLScanRecordsModel *model = self.recordsData[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [YBLScanRecordsModel bg_deleteWhere:[NSString stringWithFormat:@"where content='%@'",model.content]];
        [self.recordsData removeObjectAtIndex:indexPath.row];
        [self.recordsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - empty datasource delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"null_records";
    return [UIImage imageNamed:imageName];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"您还没有扫描过哟~";
    
    NSDictionary *attributes = @{NSFontAttributeName: YBLFont(17),
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -kNavigationbarHeight;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 20.0f;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

@end
