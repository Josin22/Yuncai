//
//  YBLAddInvoiceViewController.h
//  YC168
//
//  Created by 乔同新 on 2017/3/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMMainViewController.h"
#import "YBLInvoiceModel.h"

typedef void(^AddInvoiceBlock)(YBLInvoiceModel *invoiceModel);

@interface YBLAddInvoiceViewController : YBLMMainViewController

@property (nonatomic, strong) YBLInvoiceModel *invoiceModel;

@property (nonatomic, copy) AddInvoiceBlock addInvoiceBlock;

@end
