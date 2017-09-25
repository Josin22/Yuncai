//
//  YBLCategoryLeftView.m
//  YBL365
//
//  Created by 乔同新 on 16/12/19.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLCategoryLeftView.h"
#import "YBLCategoryLeftCell.h"
#import "YBLCategoryTreeModel.h"

@interface YBLCategoryLeftView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation YBLCategoryLeftView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if(self = [super initWithFrame:frame style:style]){
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.rowHeight = 44;
        self.dataSource = self;
        self.showsHorizontalScrollIndicator = true;
        self.selectedIndex = 0;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[YBLCategoryLeftCell class] forCellReuseIdentifier:@"cellId"];
    }
    return self;
}

- (void)setLeftDataArray:(NSMutableArray *)leftDataArray{
    _leftDataArray = leftDataArray;
    self.selectedIndex = 0;
    
    [self jsReloadData];
}

- (void)updateWithIndex:(NSInteger )index {
    if(index == self.selectedIndex) return;
    NSInteger lastIndex = self.selectedIndex;
    self.selectedIndex = index;
    [self reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.selectedIndex inSection:0],[NSIndexPath indexPathForRow:lastIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
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

#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _leftDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YBLCategoryLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
//    cell.nameLabel.text = [self.categoryArray[indexPath.row] objectForKey:@"name"];
    YBLCategoryTreeModel *model = _leftDataArray[row];
    cell.nameLabel.text = model.title;
    
    if(indexPath.row == self.selectedIndex){
        cell.nameLabel.textColor = [UIColor redColor];
        cell.rightLineView.hidden = YES;
        cell.backgroundColor = YBLViewBGColor;
    }else {
        cell.nameLabel.textColor = YBLColor(70, 70, 70, 1.0);
        cell.rightLineView.hidden = NO;
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if(row == self.selectedIndex) return;
    [self updateWithIndex:indexPath.row];
    YBLCategoryTreeModel *model = _leftDataArray[row];
    BLOCK_EXEC(self.self.cellClickBlock,row,model.id);
}


@end
