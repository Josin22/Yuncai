//
//  YBLFurtureDetailViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/21.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFurtureDetailViewController.h"

@interface YBLFurtureDetailCell : UITableViewCell

+ (CGFloat)getHI;

@end

@implementation YBLFurtureDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat hei = [YBLFurtureDetailCell getHI];
    
    CGFloat imageWi = hei-2*space;
    
    UIImageView *storeIamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, imageWi, imageWi)];
    storeIamgeView.image = [UIImage imageNamed:smallImagePlaceholder];
    storeIamgeView.layer.borderColor = YBLLineColor.CGColor;
    storeIamgeView.layer.borderWidth = 0.5;
    storeIamgeView.layer.cornerRadius = 3;
    storeIamgeView.layer.masksToBounds = YES;
    [self addSubview:storeIamgeView];
    
    CGFloat buttonWi = 0;
    
    UILabel *manNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(storeIamgeView.right+space, storeIamgeView.top, YBLWindowWidth-storeIamgeView.right-space*3-buttonWi, 20)];
    manNameLabel.text = @"九阳旗舰店";
    manNameLabel.font = YBLFont(14);
    manNameLabel.textColor = BlackTextColor;
    [self addSubview:manNameLabel];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(manNameLabel.left, manNameLabel.bottom, manNameLabel.width, 20)];
    statusLabel.text = @"张三";
    statusLabel.textColor = YBLTextColor;
    statusLabel.font = YBLFont(12);
    [self addSubview:statusLabel];
    
    UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(statusLabel.left, statusLabel.bottom, manNameLabel.width, 20)];
    categoryLabel.text = @"收益已到账";
    categoryLabel.textColor = YBLTextColor;
    categoryLabel.font = YBLFont(12);
    [self addSubview:categoryLabel];
    
    
    [self addSubview:[YBLMethodTools addLineView:CGRectMake(0, hei-0.5, YBLWindowWidth, 0.5)]];
}

+ (CGFloat)getHI{
    
    return 80;
}

@end

@interface YBLFurtureDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *furtureDetailTableView;

@end

@implementation YBLFurtureDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"未来收益详情";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.furtureDetailTableView];

    
}

- (UITableView *)furtureDetailTableView{
    
    if (!_furtureDetailTableView) {
        _furtureDetailTableView = [[UITableView alloc] initWithFrame:[self.view bounds] style:UITableViewStylePlain];
        _furtureDetailTableView.rowHeight = [YBLFurtureDetailCell getHI];
        [_furtureDetailTableView registerClass:NSClassFromString(@"YBLFurtureDetailCell") forCellReuseIdentifier:@"YBLFurtureDetailCell"];
        _furtureDetailTableView.backgroundColor = [UIColor whiteColor];
        _furtureDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _furtureDetailTableView.dataSource = self;
        _furtureDetailTableView.delegate = self;
    }
    return _furtureDetailTableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLFurtureDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLFurtureDetailCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLFurtureDetailCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}


@end
