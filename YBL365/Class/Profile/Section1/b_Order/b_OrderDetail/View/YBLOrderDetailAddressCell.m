//
//  YBLOrderDetailAddressCell.m
//  YC168
//
//  Created by 乔同新 on 2017/3/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderDetailAddressCell.h"
#import "YBLOrderAddressView.h"

@interface YBLOrderDetailAddressCell ()

@property (nonatomic, strong) YBLOrderAddressView *addressView;

@end

@implementation YBLOrderDetailAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.addressView = [[YBLOrderAddressView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 70)];
    self.addressView.arrowImageView.hidden = YES;
    [self.contentView addSubview:self.addressView];
}

- (void)updateItemCellModel:(id)itemModel{
    
    YBLAddressModel *model = (YBLAddressModel *)itemModel;
    [self.addressView updateAdressModel:model];
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{

    YBLOrderDetailAddressCell *cekk = [YBLOrderDetailAddressCell new];
    YBLAddressModel *model = (YBLAddressModel *)itemModel;
    [cekk.addressView updateAdressModel:model];
    
    return cekk.addressView.height;
}


@end
