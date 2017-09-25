//
//  YBLAreaTableView.m
//  YC168
//
//  Created by 乔同新 on 2017/3/11.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAreaTableView.h"
#import "YBLAddressViewModel.h"

@interface YBLAreaCell : UITableViewCell

//@property (nonatomic, strong) UILabel *areaLabel;
@property (nonatomic, strong) UIButton *areaButton;

+ (CGFloat)getAreaCellHi;

@end

@implementation YBLAreaCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    /*
    UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, space, YBLWindowWidth-2*space, 20)];
    areaLabel.textColor = BlackTextColor;
    areaLabel.font = YBLFont(12);
    [self.contentView addSubview:areaLabel];
    self.areaLabel = areaLabel;
    */
    UIButton *areaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    areaButton.frame = CGRectMake(space, 0, YBLWindowWidth-2*space, 40);
    areaButton.titleLabel.font = YBLFont(13);
    [areaButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [areaButton setTitleColor:YBLThemeColor forState:UIControlStateSelected];
    areaButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.contentView addSubview:areaButton];
    self.areaButton = areaButton;
}

+ (CGFloat)getAreaCellHi{
    
    return 40;
}

@end

@interface YBLAreaTableView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger index;
}
@end

@implementation YBLAreaTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    if (self = [super initWithFrame:frame style:style]) {
     
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.rowHeight = [YBLAreaCell getAreaCellHi];
        [self registerClass:[YBLAreaCell class] forCellReuseIdentifier:@"YBLAreaCell"];
    }
    return self;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLAreaCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLAreaCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = indexPath.row;
    YBLAddressAreaModel *areaModel = self.dataArray[row];
    [cell.areaButton setTitle:areaModel.text forState:UIControlStateNormal];
    cell.areaButton.selected = areaModel.isSelect;
    WEAK
    [[[cell.areaButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *x) {
        STRONG
        if (x.selected) {
            BLOCK_EXEC(self.areaTableViewCellDidSelectBlock,areaModel);
            return ;
        }
        BLOCK_EXEC(self.areaTableViewCellDidSelectBlock,areaModel);
        for (YBLAddressAreaModel *areaModel in self.dataArray) {
            areaModel.isSelect = NO;
        }
        YBLAddressAreaModel *areaModel = self.dataArray[row];
        x.selected = YES;
        [areaModel setValue:@(x.selected) forKey:@"isSelect"];
        [self jsReloadData];
        
    }];
}


@end
