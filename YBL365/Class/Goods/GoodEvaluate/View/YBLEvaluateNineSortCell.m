//
//  YBLEvaluateNineSortCell.m
//  YC168
//
//  Created by 乔同新 on 2017/6/20.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEvaluateNineSortCell.h"
#import "YBLGridView.h"

@implementation YBLEvaluateNineSortCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createssUI];
    }
    return self;
}

- (void)createssUI{
 
    YBLGridView *gridView = [[YBLGridView alloc] initWithFrame:CGRectMake(self.contentLabel.left, self.contentLabel.bottom+space, self.contentLabel.width, 100)
                                                  gridViewType:GridViewTypeNineSort];
    [self.contentView addSubview:gridView];
    self.gridView = gridView;
}

- (void)updateItemCellModel:(id)itemModel{
    
    [super updateItemCellModel:itemModel];

}

@end
