//
//  YBLShengTableView.m
//  YC168
//
//  Created by 乔同新 on 2017/3/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLShengTableView.h"
#import "YBLAddressAreaModel.h"
#import "YBLAreaItemButton.h"

@interface YBLShengItemCell : UITableViewCell

@property (nonatomic, strong) YBLAreaItemButton *itemButton;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation YBLShengItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
 
    CGFloat wi = YBLWindowWidth/4;
    
    self.itemButton = [[YBLAreaItemButton alloc] initWithFrame:CGRectMake(0, 0, wi, 44)];
    [self.itemButton setBackgroundColor:YBLColor(230, 230, 230, 1) forState:UIControlStateNormal];
    [self.itemButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.contentView addSubview:self.itemButton];
    
    self.lineView = [YBLMethodTools addLineView:CGRectMake(0, self.itemButton.height-0.5, self.itemButton.width, 0.5)];
    self.lineView.backgroundColor = [UIColor whiteColor];
    [self.itemButton addSubview:self.lineView];
}

@end

@interface YBLShengTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSMutableDictionary *dataDict;

@end

@implementation YBLShengTableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = 44;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.selectedIndex = 0;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[YBLShengItemCell class] forCellReuseIdentifier:@"YBLShengItemCell"];
        
    }
    return self;
}

- (void)updateArray:(NSArray *)dataArray Dict:(NSMutableDictionary *)dict{
    
    _dataArray = dataArray;
    _dataDict = dict;
    
    [self jsReloadData];
}
- (void)updateWithIndex:(NSInteger )index {
    
    UITableViewCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    CGFloat offset = cell.center.y - self.frame.size.height * 0.5;
    if (offset < 0) {
        offset = 0;
    }
    CGFloat maxOffset  = self.contentSize.height - self.frame.size.height;
    if (maxOffset < 0) {
        maxOffset = 0;
    }
    if (offset > maxOffset) {
        offset = maxOffset;
    }
    [self setContentOffset:CGPointMake(0, offset) animated:YES];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLShengItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLShengItemCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLShengItemCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = indexPath.row;
    YBLAddressAreaModel *areaModel = _dataArray[row];
    cell.itemButton.width = self.width;
    cell.lineView.width = self.width;;
    cell.itemButton.textLabel.text = areaModel.text;

    if ([[self.dataDict allKeys] containsObject:areaModel.id]) {
      cell.itemButton.selected = YES;
    } else {
      cell.itemButton.selected = NO;
    }
    cell.itemButton.arrowButton.selected = areaModel.isArrowSelect;
    if (row==0) {
        cell.itemButton.arrowButton.hidden = YES;
    }
    WEAK
    //选择
    [[[cell.itemButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        STRONG
        UIButton *itemButton = (UIButton *)x;
        itemButton.selected = !itemButton.selected;
        for (YBLAddressAreaModel *model in self.dataArray) {
            [model setValue:@(NO) forKey:@"isArrowSelect"];
        }
        [self updateWithIndex:row];
        [self jsReloadData];
        BLOCK_EXEC(self.shengTableViewCellDidSelectBlock,NO,itemButton.selected,areaModel);
        /*
        UIButton *itemButton = (UIButton *)x;
        itemButton.selected = !itemButton.selected;
        for (YBLAddressAreaModel *model in self.dataArray) {
            [model setValue:@(NO) forKey:@"isArrowSelect"];
        }
        if (row == 0) {
            for (YBLAddressAreaModel *model in self.dataArray) {
                [model setValue:@(NO) forKey:@"isSelect"];
            }
        } else {
            YBLAddressAreaModel *areaModel = self.dataArray[0];
            [areaModel setValue:@(NO) forKey:@"isSelect"];
        }
        [areaModel setValue:@(itemButton.selected) forKey:@"isSelect"];
        [self updateWithIndex:row];
        [self jsReloadData];
         BLOCK_EXEC(self.shengTableViewCellDidSelectBlock,NO,itemButton.selected,areaModel);
         */
        
    }];
    //箭头
    [[[cell.itemButton.arrowButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        STRONG
        UIButton *itemArrowButton = (UIButton *)x;
        itemArrowButton.selected = !itemArrowButton.selected;
        
        for (YBLAddressAreaModel *model in self.dataArray) {
            model.isArrowSelect = NO;
        }
        [areaModel setValue:@(itemArrowButton.selected) forKey:@"isArrowSelect"];
        [self updateWithIndex:row];
        [self jsReloadData];
        BLOCK_EXEC(self.shengTableViewCellDidSelectBlock,YES,itemArrowButton.selected,areaModel);
    }];
    
}

@end
