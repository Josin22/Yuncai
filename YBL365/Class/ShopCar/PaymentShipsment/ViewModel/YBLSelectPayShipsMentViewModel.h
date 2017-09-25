//
//  YBLSelectPayShipsMentViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/3/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lineitems.h"

typedef void(^SelectPayShipsMentBlock)(NSInteger index,NSMutableArray *lineItemsArray);

@interface YBLSelectPayShipsMentViewModel : NSObject

@property (nonatomic, copy) SelectPayShipsMentBlock selectPayShipsMentBlock;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) NSMutableArray *lineItemsArray;
/**
 *  para array
 */
@property (nonatomic, strong) NSMutableArray *paraLineItemsArray;

- (void)resetPayShipmentLineitemsModel:(lineitems *)lineitemsModel isPayment:(BOOL)isPayment isWLZT:(BOOL)isWLZT;

- (void)chooseWLZTShipPaymentModelWith:(lineitems *)lineitemsModel;

- (BOOL)checkAllPayShippingmentIsSelect;

- (void)handleParaPayShippingmentArray;

@end
