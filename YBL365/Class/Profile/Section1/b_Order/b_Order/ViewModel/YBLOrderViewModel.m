//
//  YBLOrderViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/3/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderViewModel.h"
#import "YBLOrderItemModel.h"
#import "YBLPopWriteCodeView.h"

#import "YBLChooseReasonView.h"
#import "YBLGoodsDetailViewModel.h"
#import "YBLShopCarViewController.h"
#import "YBLOrderRefuseReasonModel.h"
#import "YBLOrderTableView.h"
#import "YBLPhotoHeplerViewController.h"

@interface YBLOrderViewModel ()
{
    NSArray *orderTitleArray;
}
@property (nonatomic, copy) OrderDeleteBlock orderDeleteBlock;
@property (nonatomic, copy) OrderRequestBlock orderRequestBlock;
@property (nonatomic, copy) OrderRebuyBlock orderRebuyBlock;

@end

@implementation YBLOrderViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        orderTitleArray = @[yanchiTihuoString,delayShipString,buyAgainString];
    }
    return self;
}

- (NSMutableDictionary *)selectImageDict{
    
    if (!_selectImageDict) {
        _selectImageDict = [NSMutableDictionary dictionary];
    }
    return _selectImageDict;
}

- (void)setOrderSource:(OrderSource)orderSource{
    _orderSource = orderSource;
    
    if (_orderSource == OrderSourceBuyer) {
        self.titleArray = @[@[@"全部",@"待付款"  ,@"待收货"   ,@"已完成"      ,@"已取消"],
                            @[@"all",@"all"    ,@"all"     ,@"completed"  ,@"canceled"],
                            @[@"all",@"payment",@"shipment",@"all"        ,@"all"],];
    } else {
        self.titleArray = @[@[@"全部",@"待完成"   ,@"已完成"      ,@"已取消"],
                            @[@"all",@"normal"  ,@"completed"  ,@"canceled"],
                            @[@"all",@"all"     ,@"all"        ,@"all"],];
    }
    
    [self hanldeTitleData];
}

- (RACSignal *)SingalForOrderIsReload:(BOOL)isReload{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    YBLCategoryTreeModel *commentModel = self.all_title_data_array[self.currentFoundIndex];
    para[@"completed_or_cancelled"] = commentModel.para_value;
    para[@"payment_or_shipment_or_comment"] = commentModel.para_three_value;
    NSString *categoryID = commentModel.id;
    NSString *url = url_orders_customer;
    if (self.orderSource == OrderSourceSeller) {
        url = url_orders_seller;
    }
    [[self siganlForManyListViewRequestLoadMoreWithPara:para
                                                    url:url
                                               isReload:isReload] subscribeNext:^(id  _Nullable x) {
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:[YBLOrderItemModel class] json:x];
        /**
         *  很重要
         */
        for (YBLOrderItemModel *itemModel in dataArray) {
            [self handleRequestDataModel:itemModel];
        }
        NSMutableArray *fin_indexps = [self getNewIndexpathWithDataArray:dataArray categotyID:categoryID isReload:isReload isFromSection:YES];
        [subject sendNext:fin_indexps];
        [subject sendCompleted];
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    
    return subject;
}

+ (RACSignal *)signalForUpLoadShippingEvidence:(UIImage *)image
                                           Ids:(NSString *)_id{
    
    return [[self alloc] signalForUpLoadShippingEvidence:image Ids:_id];
}

- (RACSignal *)signalForUpLoadShippingEvidence:(UIImage *)image Ids:(NSString *)_id{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:@"上传中..."];
    });
    NSData *thumbImageData = UIImageJPEGRepresentation(image, .8);
    YBLFileConfig *fileConfig = [YBLFileConfig
                                 fileConfigWithfileData:thumbImageData
                                 name:@"asset"
                                 fileName:@"upload_shipping_evidence"
                                 mimeType:@"image/png"];
    NSString *url = [url_order_state_state(_id) stringByAppendingString:[NSString stringWithFormat:@"/%@",@"upload_shipping_evidence"]];
    [YBLRequstTools updateRequest:url
                           params:nil
                  fileConfigArray:[@[fileConfig] mutableCopy]
                          success:^(id result, NSInteger statusCode) {
                              [SVProgressHUD showSuccessWithStatus:@"上传成功~"];
                              [subject sendNext:result];
                              [subject sendCompleted];
                          }
                          failure:^(NSError *error, NSInteger errorCode) {
                              [subject sendError:error];
                          }];
    
    return subject;
}


+ (RACSignal *)siganlForDeleteOrderWithID:(NSString *)_id{
    
    return [[self alloc] siganlForDeleteOrderWithID:_id];
}

- (RACSignal *)siganlForDeleteOrderWithID:(NSString *)_id{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"删除中..."];
    
    [YBLRequstTools HTTPDELETEWithUrl:url_orders_detail(_id)
                              Parames:nil
                            commplete:^(id result, NSInteger statusCode) {
                                [SVProgressHUD showSuccessWithStatus:@"删除成功~"];
                                [subject sendCompleted];
                            }
                              failure:^(NSError *error, NSInteger errorCode) {
                                  [subject sendError:error];
                              }];
    
    return subject;
}


+ (RACSignal *)signalForChangeOrderStatusWithIds:(NSString *)_id appdingURLString:(NSString *)appendingURL confirmCode:(NSString *)confirmCode{
    
    return [[self alloc] signalForChangeOrderStatusWithIds:_id appdingURLString:appendingURL confirmCode:confirmCode reason:nil process_method:nil];
}

- (RACSignal *)signalForChangeOrderStatusWithIds:(NSString *)_id
                                appdingURLString:(NSString *)appendingURL
                                     confirmCode:(NSString *)confirmCode
                                          reason:(NSString *)reason
                                  process_method:(NSString *)process_method{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    NSString *url = [url_order_state_state(_id) stringByAppendingString:[NSString stringWithFormat:@"/%@",appendingURL]];
    
    NSMutableDictionary *para = nil;
    if (confirmCode) {
        para = [NSMutableDictionary dictionary];
        para[@"confirm_code"] = confirmCode;
    }
    if (reason) {
        para = [NSMutableDictionary dictionary];
        para[@"reason"] = reason;
    }
    if (process_method) {
        para = [NSMutableDictionary dictionary];
        para[@"process_method"] = process_method;
    }
    [YBLRequstTools HTTPPostWithUrl:url
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              [SVProgressHUD dismiss];
                              [subject sendNext:result];
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}

/*
- (RACSignal *)SingalForOrderIsReload:(BOOL)isReload{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    if (isReload) {
//        [SVProgressHUD showWithStatus:@"加载中..."];
        [YBLLogLoadingView showInWindow];
    }
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"completed_or_cancelled"] = self.completed_or_cancelled;
    para[@"payment_or_shipment_or_comment"] = self.payment_or_shipment_or_comment;
    if (isReload) {
        self.page = 1;
    }
    para[@"page"] = @(self.page++);
    para[@"per_page"] = @(page_size);
    
    NSString *url = url_orders_customer;
    if (self.orderSource == OrderSourceSeller) {
        url = url_orders_seller;
    }
    [YBLRequstTools HTTPGetDataWithUrl:url
                               Parames:para
                             commplete:^(id result, NSInteger statusCode) {
                                 [SVProgressHUD dismiss];
                                 NSArray *dataArray = [NSArray yy_modelArrayWithClass:[YBLOrderItemModel class] json:result];
                                 if (isReload) {
                                     [YBLLogLoadingView dismissInWindow];
                                     [self.allOrderDataArray removeAllObjects];
                                 }
                                 if (dataArray.count==0) {
                                     [subject sendNext:@YES];
                                     self.isNoMoreData = YES;
                                 } else {
                                     self.isNoMoreData = NO;
                                     for (YBLOrderItemModel *itemModel in dataArray) {
                                         [self handleRequestDataModel:itemModel];
                                     }
                                     [self.allOrderDataArray addObjectsFromArray:dataArray];
                                     [subject sendNext:@NO];
                                     [SVProgressHUD dismiss];
                                 }
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}
*/

#pragma mark -  处理订单按钮
- (void)handleRequestDataModel:(YBLOrderItemModel *)itemModel{
    [self handleRequestDataModel:itemModel isDetail:NO];
}

- (void)handleRequestDataModel:(YBLOrderItemModel *)itemModel isDetail:(BOOL)isDetail{
    
    if (self.orderSource == OrderSourceSeller) {
        
        [self resetModel:itemModel x:nil isSeller:YES isDetail:isDetail];
        
    } else {
        
        [self resetModel:itemModel x:nil isSeller:NO isDetail:isDetail];
    }
    
}

#pragma mark - 按钮点击事件
- (void)dealWithSellerAndBuyerCellButtonActionEventWithModel:(YBLOrderItemModel *)model
                                                   indexPath:(NSIndexPath *)indexPath
                                                currentTitle:(NSString *)currentTitle
                                      orderPropertyItemModel:(YBLOrderPropertyItemModel *)clickButtonModel
                                                        cell:(UITableViewCell *)cell
                                                    isSeller:(BOOL)isSeller
                                               isOrderDetail:(BOOL)isOrderDetail
                                            orderDeleteBlock:(OrderDeleteBlock)orderDeleteBlock
                                           orderRequestBlock:(OrderRequestBlock)orderRequestBlock
                                            currentTableView:(UITableView *)currentTableView{
    WEAK
    NSString *action = clickButtonModel.order_action;
    _orderDeleteBlock = orderDeleteBlock;
    _orderRequestBlock = orderRequestBlock;
    if (isSeller) {
#pragma mark 大B
        //0.判断物流自提和shipping 意味着配送完成
        if ([model.shipping_method.code isEqualToString:@"wlzt"]&&[currentTitle isEqualToString:shipDoneString]) {
            return ;
        }
        //1.上传物流凭证upload_shipping_evidence
        if ([model.shipping_method.code isEqualToString:@"wlzt"]&&[clickButtonModel.order_state isEqualToString:@"wait_ship"]) {
            if ([currentTitle isEqualToString:delayShipString]) {
                //延迟配送
                //延迟配送
                if ([action isEqualToString:@"delay_ship"]&&model.delay_shipping_count.intValue > Delay_Click_Count) {
                    [SVProgressHUD showErrorWithStatus:@"最多延迟两次哟~"];
                    return;
                }
                [self requestChangeOrderWithModel:model
                                       appdingURL:clickButtonModel.order_action
                                      confirmCode:nil
                                        currentCell:cell
                                         isSeller:YES
                                    isOrderDetail:isOrderDetail];
                
            } else if ([currentTitle isEqualToString:begainShipString]) {
                //开始配送
                NSInteger maxPhoto = 9;
                //1.已上传过
                NSMutableArray *item_select_image_array = self.selectImageDict[model.order_id];
                if (!item_select_image_array) {
                    NSMutableArray *photoArray = [NSMutableArray array];
                    [self.selectImageDict setObject:photoArray forKey:model.order_id];
                }
                if (item_select_image_array.count>0&&item_select_image_array.count<maxPhoto) {
                    NSInteger count = item_select_image_array.count;
                    NSString *firstTitle = [NSString stringWithFormat:@"已上传%ld张图片,继续上传",(long)count];
                    NSString *secondTitle = @"开始配送";
                    [YBLActionSheetView showActionSheetWithTitles:@[firstTitle,secondTitle] handleClick:^(NSInteger index) {
                        STRONG
                        switch (index) {
                            case 0:
                            {
                                //继续上传
                                [self uploadImageWithOrderId:model];
                            }
                                break;
                            case 1:
                            {
                                //开始配送
                                //4.start_ship
                                [self requestChangeOrderWithModel:model
                                                       appdingURL:clickButtonModel.order_action
                                                      confirmCode:nil
                                                        currentCell:cell
                                                         isSeller:YES
                                                    isOrderDetail:isOrderDetail];
                            }
                                break;
                                
                            default:
                                break;
                        }
                    }];
                    
                } else if (item_select_image_array.count>maxPhoto){
                    
                    [self requestChangeOrderWithModel:model
                                           appdingURL:clickButtonModel.order_action
                                          confirmCode:nil
                                            currentCell:cell
                                             isSeller:YES
                                        isOrderDetail:isOrderDetail];
                } else {
                    //未上传过
                    [self uploadImageWithOrderId:model];
                }
            }
            
        } else if ([action isEqualToString:shipDoneActionString]||[action isEqualToString:pickUpDoneActionString]) {
            
            //配送完成 shipped //自提完成 pick_up 提货码
            [YBLPopWriteCodeView showPopWriteCodeViewWithPopWriteCodeViewSureBlock:^(NSString *codeText) {
                STRONG
                if (codeText.length<6) {
                    return ;
                }
                [self requestChangeOrderWithModel:model
                                       appdingURL:action
                                      confirmCode:codeText
                                        currentCell:cell
                                         isSeller:YES
                                    isOrderDetail:isOrderDetail];
            }];
            
        } else if ([currentTitle isEqualToString:deleteOrderString]){
            [YBLOrderActionView showTitle:@"确认删除此订单?"
                                   cancle:@"取消"
                                     sure:@"删除"
                          WithSubmitBlock:^{
                              STRONG
                              //删除订单
                              [[self siganlForDeleteOrderWithID:model.order_id] subscribeError:^(NSError * _Nullable error) {
                              } completed:^{
                                  STRONG
                                  if (isOrderDetail) {
                                      BLOCK_EXEC(self.orderDeleteBlock,);
                                  } else {
                                      YBLOrderTableView *currentTabelView = [self getCurrentTableView];
                                      NSIndexPath *getPath = [currentTabelView indexPathForCell:cell];
                                      NSMutableArray *currentData = [self getCurrentDataArrayWithIndex:self.currentFoundIndex];
                                      [currentData removeObjectAtIndex:getPath.section];
                                      if (currentData.count==0) {
                                          [currentTabelView reloadData];
                                      } else {
                                          [currentTabelView deleteSections:[NSIndexSet indexSetWithIndex:getPath.section] withRowAnimation:UITableViewRowAnimationLeft];
                                      }
                                  }
                              }];
                              
                          } cancelBlock:^{
                              
                          }];
            
        } else if ([currentTitle isEqualToString:refundOrderString]){
            //拒绝接单
            [YBLChooseReasonView showChooseReasonInView:self.Vc.navigationController
                                            orderSource:OrderSourceSeller
                                   handleCompeleteBlock:^(YBLOrderRefuseReasonModel *selectReason,NSInteger selectIndex) {
                                       STRONG
                                       NSString *selectName = selectReason.name[selectIndex];
                                       if (selectName.length==0) {
                                           return ;
                                       }
                                       [self requestChangeOrderWithModel:model
                                                              appdingURL:clickButtonModel.order_action
                                                             confirmCode:nil
                                                               currentCell:cell
                                                                isSeller:YES
                                                           isOrderDetail:isOrderDetail
                                                                  reason:selectName];
                                   }];
            
        } else if ([currentTitle isEqualToString:cancleOrderString]) {
            ///取消订单
            if (model.purchase_order && [clickButtonModel.order_state isEqualToString:@"shipping"]) {
                //1.采购订单
                [YBLChooseReasonView showChooseReasonInView:self.Vc.navigationController
                                                    stateEn:clickButtonModel.order_state
                                                orderSource:OrderSourcePurchaseSeller
                                       handleCompeleteBlock:^(YBLOrderRefuseReasonModel *selectReason,NSInteger selectIndex) {
                                           STRONG
                                           NSString *selectName = selectReason.name[selectIndex];
                                           if (selectName.length==0) {
                                               return ;
                                           }
                                           NSArray *componeArray = [selectReason.code componentsSeparatedByString:@","];
                                           NSString *select_compone_string = componeArray[selectIndex];
                                           if ([select_compone_string isEqualToString:@"1"]) {
                                               [YBLOrderActionView showTitle:@"由于您取消配送，系统将您的配送保证金赔付给采购商"
                                                                      cancle:@"我再想想"
                                                                        sure:@"确定取消"
                                                             WithSubmitBlock:^{
                                                                 STRONG
                                                                 [self requestChangeOrderWithModel:model
                                                                                        appdingURL:clickButtonModel.order_action
                                                                                       confirmCode:nil
                                                                                         currentCell:cell
                                                                                          isSeller:YES
                                                                                     isOrderDetail:isOrderDetail
                                                                                            reason:selectName];
                                                             }
                                                                 cancelBlock:^{
                                                                 }];
                                           } else {
                                               [self requestChangeOrderWithModel:model
                                                                      appdingURL:clickButtonModel.order_action
                                                                     confirmCode:nil
                                                                       currentCell:cell
                                                                        isSeller:YES
                                                                   isOrderDetail:isOrderDetail
                                                                          reason:selectName];
                                           }
                                           
                                       }];

            } else {
                [self requestChangeOrderWithModel:model
                                       appdingURL:clickButtonModel.order_action
                                      confirmCode:nil
                                        currentCell:cell
                                         isSeller:YES
                                    isOrderDetail:isOrderDetail
                                           reason:@" "];
            }
            /*
            //DB取消订单1
            [YBLOrderActionView showTitle:@"由于您取消配送，系统将您的配送保证金赔付给采购商"
                                   cancle:@"我再想想"
                                     sure:@"确定取消"
                          WithSubmitBlock:^{
                              STRONG
                              [self requestChangeOrderWithModel:model
                                                     appdingURL:clickButtonModel.order_action
                                                    confirmCode:nil
                                                      indexPath:indexPath
                                                       isSeller:YES
                                                  isOrderDetail:isOrderDetail
                                                         reason:@" "];
                          }
                              cancelBlock:^{
                              }];
            */
        } else if ([currentTitle isEqualToString:IAlsoAgreeCancelString]||[currentTitle isEqualToString:IAgreeString]||[currentTitle isEqualToString:IDisAgreeString]) {
            
            NSString *title = nil;
            NSString *process_method = nil;
            if ([currentTitle isEqualToString:IAlsoAgreeCancelString]) {
                title = @"采购商描述您的配送商品(非正品)取消订单,如您也主动取消订单，系统将视为双方线下达成和解，平台将终止订单，订单保证金将退回各自账户，如您确认取消订单后进入钱包查询保证金到账情况";
                process_method = @"both_cancel";
            } else if ([currentTitle isEqualToString:IAgreeString]) {
                title = @"采购商描述您的商品(非正品)取消订单,如您同意采购商取消订单要求，系统将您的配送保证金赔付采购商请慎重考虑";
                process_method = @"accept";
            } else if ([currentTitle isEqualToString:IDisAgreeString]) {
                title = @"采购商描述您的商品(非正品)取消订单,如您拒绝采购商取消订单要求，由于采购订单非正常完成，系统将在7个工作日终结订单，您的配送保证金将有50%赔付采购商";
                process_method = @"reject";
            }
            [YBLOrderActionView showTitle:title
                                   cancle:@"我再想想"
                                     sure:@"确认"
                          WithSubmitBlock:^{
                              [self requestChangeOrderWithModel:model
                                                     appdingURL:action
                                                      currentCell:cell
                                                       isSeller:YES
                                                  isOrderDetail:isOrderDetail
                                                 process_method:process_method];
                          }
                              cancelBlock:^{}];
            
        } else {
            //延迟配送
            if ([action isEqualToString:@"delay_ship"]&&model.delay_shipping_count.intValue >= Delay_Click_Count) {
                [SVProgressHUD showErrorWithStatus:@"最多延迟两次哟~"];
                return;
            }
            [self requestChangeOrderWithModel:model
                                   appdingURL:action
                                  confirmCode:nil
                                    currentCell:cell
                                     isSeller:YES
                                isOrderDetail:isOrderDetail];
        }

    } else {
#pragma mark 小B
        
        if ([currentTitle isEqualToString:goPayString]) {
            //去支付
            
        } else if ([currentTitle isEqualToString:wuliuPayString]) {
            //物流支付
            
            
        } else if ([currentTitle isEqualToString:pingzhengPayString]) {
            //凭证支付
            
            
        }
        else if ([currentTitle isEqualToString:cancleOrderString]) {
            ///取消订单
            NSString *actionValue = action;
            OrderSource orderSource = OrderSourcePurchaseBuyer;
            if (model.purchase_order) {
                //1.采购订单
                orderSource = OrderSourcePurchaseBuyer;
                actionValue = key_purchase_request_cancel;
            } else {
                //2.正向订单
                orderSource = OrderSourceBuyer;
            }
            [YBLChooseReasonView showChooseReasonInView:self.Vc.navigationController
                                                stateEn:clickButtonModel.order_state
                                            orderSource:orderSource
                                   handleCompeleteBlock:^(YBLOrderRefuseReasonModel *selectReason,NSInteger selectIndex) {
                                       STRONG
                                       NSString *selectName = selectReason.name[selectIndex];
                                       if (selectName.length==0) {
                                           return ;
                                       }
                                       [self requestChangeOrderWithModel:model
                                                              appdingURL:actionValue
                                                             confirmCode:nil
                                                             currentCell:cell
                                                                isSeller:NO
                                                           isOrderDetail:isOrderDetail
                                                                  reason:selectName];
                                   }];
        }
        else if ([currentTitle isEqualToString:deleteOrderString]){
            [YBLOrderActionView showTitle:@"确认删除此订单?"
                                   cancle:@"取消"
                                     sure:@"删除"
                          WithSubmitBlock:^{
                              //删除订单
                              [[self siganlForDeleteOrderWithID:model.order_id] subscribeError:^(NSError * _Nullable error) {
                              } completed:^{
                                  STRONG
                                  if (isOrderDetail) {
                                      BLOCK_EXEC(self.orderDeleteBlock,);
                                  } else {
                                      YBLOrderTableView *currentTabelView = [self getCurrentTableView];
                                      NSIndexPath *getPath = [currentTabelView indexPathForCell:cell];
                                      NSMutableArray *currentData = [self getCurrentDataArrayWithIndex:self.currentFoundIndex];
                                      [currentData removeObjectAtIndex:getPath.section];
                                      if (currentData.count==0) {
                                          [currentTabelView reloadData];
                                      } else {
                                          [currentTabelView deleteSections:[NSIndexSet indexSetWithIndex:getPath.section] withRowAnimation:UITableViewRowAnimationLeft];
                                      }
                                  }
                              }];
                
                            } cancelBlock:^{
                                
                            }];
        } else if ([currentTitle isEqualToString:buyAgainString]){
            //再次购买
            [[self singalForRebuyWithItemArray:model.line_items] subscribeError:^(NSError * _Nullable error) {
            } completed:^{
                STRONG
                YBLShopCarViewModel *viewModel = [[YBLShopCarViewModel alloc] init];
                viewModel.carVCType = CarVCTypeSpecial;
                YBLShopCarViewController *shopCarVC = [[YBLShopCarViewController alloc] init];
                shopCarVC.viewModel = viewModel;
                [self.Vc.navigationController pushViewController:shopCarVC animated:YES];
            }];
            
        } else {
            if ([action isEqualToString:@"delay_receive_shipped"]&&model.delay_receive_ship_count.intValue >= Delay_Click_Count) {
                [SVProgressHUD showErrorWithStatus:@"最多延迟两次哟~"];
                return;
            }
            //延迟提货 确认提货
            if ([action isEqualToString:@"delay_pick_up"]&&model.delay_pick_up_count.intValue >= Delay_Click_Count) {
                [SVProgressHUD showErrorWithStatus:@"最多延迟两次哟~"];
                return;
            }
            [self requestChangeOrderWithModel:model
                                   appdingURL:clickButtonModel.order_action
                                  confirmCode:nil
                                    currentCell:cell
                                     isSeller:NO
                                isOrderDetail:isOrderDetail];
        }
    }
    
}


- (void)uploadImageWithOrderId:(YBLOrderItemModel *)order{
    WEAK
    [[YBLPhotoHeplerViewController shareHelper] showImageViewSelcteWithResultBlock:^(UIImage *image) {
        if (image) {
            //3.上传物流凭证
            [[self signalForUpLoadShippingEvidence:image Ids:order.order_id] subscribeNext:^(id x) {
                STRONG
                NSMutableArray *item_select_image_array = self.selectImageDict[order.order_id];
                if (!item_select_image_array) {
                    NSMutableArray *photoArray = [NSMutableArray array];
                    [self.selectImageDict setObject:photoArray forKey:order.order_id];
                } else {
                    item_select_image_array = self.selectImageDict[order.order_id];
                }
                [item_select_image_array addObject:image];
                [self.selectImageDict setObject:item_select_image_array forKey:order.order_id];
                
            } error:^(NSError *error) {
                
            }];
        }

    }
                                                                            isEdit:NO
                                                                       isJustPhoto:NO];
    /*
    [YBLTakePhotoSheetPhotoView showPickerWithVC:self.Vc PikerDoneHandle:^(UIImage *image) {
        STRONG
        if (image) {
            //3.上传物流凭证
            [[self signalForUpLoadShippingEvidence:image Ids:order.order_id] subscribeNext:^(id x) {
                STRONG
                NSMutableArray *item_select_image_array = self.selectImageDict[order.order_id];
                if (!item_select_image_array) {
                    NSMutableArray *photoArray = [NSMutableArray array];
                    [self.selectImageDict setObject:photoArray forKey:order.order_id];
                } else {
                    item_select_image_array = self.selectImageDict[order.order_id];
                }
                [item_select_image_array addObject:image];
                [self.selectImageDict setObject:item_select_image_array forKey:order.order_id];
                
            } error:^(NSError *error) {
                
            }];
        }
    }];
     */
    
}



- (void)requestChangeOrderWithModel:(YBLOrderItemModel *)model
                         appdingURL:(NSString *)url
                        confirmCode:(NSString *)confirmCode
                        currentCell:(UITableViewCell *)currentCell
                           isSeller:(BOOL)isSeller
                      isOrderDetail:(BOOL)isOrderDetail{
    
    [self requestChangeOrderWithModel:model
                           appdingURL:url
                          confirmCode:confirmCode
                            currentCell:currentCell
                             isSeller:isSeller
                        isOrderDetail:isOrderDetail
                               reason:nil];
}
- (void)requestChangeOrderWithModel:(YBLOrderItemModel *)model
                         appdingURL:(NSString *)url
                        confirmCode:(NSString *)confirmCode
                          currentCell:(UITableViewCell *)currentCell
                           isSeller:(BOOL)isSeller
                      isOrderDetail:(BOOL)isOrderDetail
                             reason:(NSString *)reason{
    
    [self requestChangeOrderWithModel:model
                           appdingURL:url
                          confirmCode:confirmCode
                            currentCell:currentCell
                             isSeller:isSeller
                        isOrderDetail:isOrderDetail
                               reason:reason
                       process_method:nil];
}

- (void)requestChangeOrderWithModel:(YBLOrderItemModel *)model
                         appdingURL:(NSString *)url
                        currentCell:(UITableViewCell *)currentCell
                           isSeller:(BOOL)isSeller
                      isOrderDetail:(BOOL)isOrderDetail
                     process_method:(NSString *)process_method{
    
    [self requestChangeOrderWithModel:model
                           appdingURL:url
                          confirmCode:nil
                          currentCell:currentCell
                             isSeller:isSeller
                        isOrderDetail:isOrderDetail
                               reason:nil
                       process_method:process_method];
}
- (void)requestChangeOrderWithModel:(YBLOrderItemModel *)model
                         appdingURL:(NSString *)url
                        confirmCode:(NSString *)confirmCode
                        currentCell:(UITableViewCell *)currentCell
                           isSeller:(BOOL)isSeller
                      isOrderDetail:(BOOL)isOrderDetail
                             reason:(NSString *)reason
                     process_method:(NSString *)process_method{
    if (!url) {
        return;
    }
    WEAK
    [[self signalForChangeOrderStatusWithIds:model.order_id
                            appdingURLString:url
                                 confirmCode:confirmCode
                                      reason:reason
                              process_method:process_method]
     subscribeNext:^(NSDictionary *x) {
         STRONG
         if (x) {
             [self resetModel:model x:x isSeller:isSeller];
             if (isOrderDetail) {
                 BLOCK_EXEC(self.orderRequestBlock,)
             } else {
                 YBLOrderTableView *currentTabelView = [self getCurrentTableView];
                 NSIndexPath *getIndexPath = [currentTabelView indexPathForCell:currentCell];
                 //待收货 && 确认收货
                 if (self.currentFoundIndex == 2&&([url isEqualToString:@"receive_shipped"]||[url isEqualToString:@"request_cancel"])) {
                     NSMutableArray *data = [self getCurrentDataArrayWithIndex:self.currentFoundIndex];
                     [data removeObjectAtIndex:getIndexPath.section];
                     if (data.count==0) {
                         [currentTabelView reloadData];
                     } else {
                         [currentTabelView deleteSections:[NSIndexSet indexSetWithIndex:getIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                     }
                 } else {
                     [currentTabelView reloadSections:[NSIndexSet indexSetWithIndex:getIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                 }
             }
         }
     } error:^(NSError *error) {
     }];
}

- (YBLOrderTableView *)getCurrentTableView{
    YBLOrderTableView *currentTabelView = (YBLOrderTableView *)[self.Vc.view viewWithTag:tag_order_table_view+self.currentFoundIndex];
    return currentTabelView;
}

#pragma mark 处理订单模型数据
- (void)resetModel:(YBLOrderItemModel *)model x:(NSDictionary *)x isSeller:(BOOL)isSeller{
    [self resetModel:model x:x isSeller:isSeller isDetail:NO];
}

- (void)resetModel:(YBLOrderItemModel *)model x:(NSDictionary *)x isSeller:(BOOL)isSeller isDetail:(BOOL)isDetail{
    if (x) {
        NSString *state_en = x[@"state_en"];
        NSString *state_cn = x[@"state_cn"];
        [model setValue:state_en forKey:@"state_en"];
        [model setValue:state_cn forKey:@"state_cn"];
    }
    YBLOrderPropertyModel *propertyModel = nil;
     if (isSeller) {
     
         if ([model.shipping_method.code isEqualToString:@"wlzt"] && [model.state_en isEqualToString:@"shipping"]) {
             propertyModel = [YBLMethodTools sellerOrderStateWith:@"wlzt_shipping"];
             } else {
             propertyModel = [YBLMethodTools sellerOrderStateWith:model.state_en];
         }
         
     } else {
         
         if ((([model.payment_state isEqualToString:@"checkout"]||[model.payment_state isEqualToString:@"balance_due"])&&([model.payment_method.type isEqualToString:@"PaymentMethod::Online"]||[model.payment_method.type isEqualToString:@"PaymentMethod::ExpressCollecting"]))&&![model.state_en isEqualToString:@"wait_cancel"]&&![model.state_en isEqualToString:@"canceled"]) {
         
             propertyModel = [YBLMethodTools buyerOrderStateWith:model.payment_state];
         
         } else if ([model.shipping_method.code isEqualToString:@"wlzt"]&&[model.state_en isEqualToString:@"shipping"]){
         
             propertyModel = [YBLMethodTools buyerOrderStateWith:@"wlzt_shipping"];
         
         } else {
         
             propertyModel = [YBLMethodTools buyerOrderStateWith:model.state_en];
         }
         if (x) {
             NSString *currenTime = x[@"current_time"];
             NSString *current_state_expire_at = x[@"current_state_expire_at"];
             [model setValue:currenTime forKey:@"current_time"];
             [model setValue:current_state_expire_at forKey:@"current_state_expire_at"];
         }
     }
    if (model.purchase_order) {
        /**
         *  如果是采购订单删除 延迟 再次 按钮
         */
        NSMutableArray *orderButtonArray = [propertyModel.orderStateCount mutableCopy];
        for (NSString *buttonText in orderTitleArray) {
            [orderButtonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YBLOrderPropertyItemModel *orderProitemModel = (YBLOrderPropertyItemModel *)obj;
                if ([orderProitemModel.order_button_title isEqualToString:buttonText]) {
                    [orderButtonArray removeObject:orderProitemModel];
                    *stop = YES;
                }
            }];
        }
        if (!isSeller&&([model.state_en isEqualToString:@"full_complete"]||[model.state_en isEqualToString:@"canceled"])) {
            
            [orderButtonArray addObject: [YBLOrderPropertyItemModel getItemModelWithOrderState:@"full_complete"
                                                                                  order_action:nil
                                                                            order_button_title:deleteOrderString]];
        }
        propertyModel.orderStateCount = orderButtonArray;
        
    }
    if (!isSeller&&!model.purchase_order&&isDetail&&([model.state_en isEqualToString:@"full_complete"]||[model.state_en isEqualToString:@"canceled"])) {
        
        NSMutableArray *orderButtonArray = [propertyModel.orderStateCount mutableCopy];
        
        [orderButtonArray addObject: [YBLOrderPropertyItemModel getItemModelWithOrderState:@"full_complete"
                                                                              order_action:nil
                                                                        order_button_title:deleteOrderString]];
        propertyModel.orderStateCount = orderButtonArray;
    }
    
    [model setValue:propertyModel forKey:@"property_order"];
}


+ (RACSignal *)getCancelOrderReason:(NSString *)subtype{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"type"] = @"order";
    para[@"subtype"] = subtype;
    
    [YBLRequstTools HTTPGetDataWithUrl:url_orders_customer_cancel_reason
                               Parames:para
                             commplete:^(id result, NSInteger statusCode) {
                                 YBLOrderRefuseReasonModel *reasonModel = [YBLOrderRefuseReasonModel yy_modelWithJSON:result];
                                 [subject sendNext:reasonModel];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

- (RACSignal *)singalForRebuyWithItemArray:(NSArray *)itemArray{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    NSMutableArray *rebuyArray = [NSMutableArray array];
    for (lineitems *itemModel in itemArray) {
        NSMutableDictionary *item_para = [NSMutableDictionary dictionary];
        item_para[@"product_id"] = itemModel.product.id;
        item_para[@"quantity"] = itemModel.quantity;
        [rebuyArray addObject:item_para];
    }
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"buy"] = [rebuyArray yy_modelToJSONString];
    
    [YBLRequstTools HTTPPostWithUrl:url_carts_rebuy
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              
                              [SVProgressHUD showSuccessWithStatus:@"加入购物车成功"];
                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                 [subject sendCompleted];
                              });
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return  subject;
}

@end
