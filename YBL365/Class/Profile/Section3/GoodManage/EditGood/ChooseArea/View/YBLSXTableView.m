//
//  YBLSXTableView.m
//  YC168
//
//  Created by 乔同新 on 2017/3/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSXTableView.h"
#import "YBLAreaItemButton.h"
#import "YBLAddressAreaModel.h"

@interface YBLSXItemCell : UITableViewCell

@property (nonatomic, strong) YBLAreaItemButton *itemButton;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation YBLSXItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat wi = YBLWindowWidth/4;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.itemButton = [[YBLAreaItemButton alloc] initWithFrame:CGRectMake(3, 3, wi-6, 38)];
    self.itemButton.normalColor = YBLTextColor;
    self.itemButton.selectColor = [UIColor whiteColor];
    self.itemButton.layer.cornerRadius = 3;
    self.itemButton.layer.masksToBounds = YES;
    self.itemButton.textLabel.font = YBLFont(13);
    [self.itemButton setBackgroundColor:YBLColor(241, 241, 241, 1) forState:UIControlStateNormal];
    [self.itemButton setBackgroundColor:YBLThemeColor forState:UIControlStateSelected];
    [self.contentView addSubview:self.itemButton];
    
    self.lineView = [YBLMethodTools addLineView:CGRectMake(0, self.itemButton.height-0.5, self.itemButton.width, 0.5)];
    [self.itemButton addSubview:self.lineView];
}

@end

@interface YBLSXTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) TableType tableType;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSMutableDictionary *dataDict;

@end

@implementation YBLSXTableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                    tableType:(TableType)tableType{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        _tableType = tableType;
        
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = 44;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[YBLSXItemCell class] forCellReuseIdentifier:@"YBLSXItemCell"];
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
    YBLSXItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLSXItemCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLSXItemCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = indexPath.row;
    YBLAddressAreaModel *areaModel = _dataArray[row];
    cell.itemButton.textLabel.text = areaModel.text;
    cell.itemButton.width = self.width;
    cell.lineView.width = self.width;;
    cell.itemButton.arrowButton.right = self.width-5;
    if ([[self.dataDict allKeys] containsObject:areaModel.id]) {
        cell.itemButton.selected = YES;
    } else {
        cell.itemButton.selected = NO;
    }
    cell.itemButton.arrowButton.selected = areaModel.isArrowSelect;
    if (_tableType == tableTypeSXNoneArrow) {
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
        BLOCK_EXEC(self.sxTableViewCellDidSelectBlock,NO,itemButton.selected,areaModel);
        /*
        for (YBLAddressAreaModel *model in self.dataArray) {
            [model setValue:@(NO) forKey:@"isArrowSelect"];
        }
        [areaModel setValue:@(itemButton.selected) forKey:@"isSelect"];
        [self updateWithIndex:row];
        if (_tableType == tableTypeSXNoneArrow) {
            cell.itemButton.arrowButton.hidden = YES;
        }
        [self jsReloadData];
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
        BLOCK_EXEC(self.sxTableViewCellDidSelectBlock,YES,itemArrowButton.selected,areaModel);
    }];
    
}


@end
