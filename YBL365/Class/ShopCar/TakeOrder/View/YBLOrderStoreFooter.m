//
//  YBLOrderStoreFooter.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderStoreFooter.h"
#import "SMTextField.h"
#import "YBLCartModel.h"


@interface YBLOrderStoreFooter ()

@property (nonatomic, retain) UILabel *xiaojiLabel;

@property (nonatomic, retain) UILabel *yunfeiLabel;

@end

@implementation YBLOrderStoreFooter

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    /* 支付配送 */
    UIButton *zhifupeisongView = [UIButton buttonWithType:UIButtonTypeCustom];
    zhifupeisongView.frame = CGRectMake(space, 0, YBLWindowWidth-2*space, 60);
    [self.contentView addSubview:zhifupeisongView];
    self.zhifupeisongBtn = zhifupeisongView;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    label1.centerY = zhifupeisongView.centerY;
    label1.text = @"支付配送";
    label1.font = YBLFont(15);
    label1.textColor = BlackTextColor;
    [zhifupeisongView addSubview:label1];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"found_arrow"]];
    arrowImageView.frame = CGRectMake(0, 0, 8, 16.5);
    arrowImageView.centerY = label1.centerY;
    arrowImageView.left = zhifupeisongView.width-8;
    [zhifupeisongView addSubview:arrowImageView];
    
    UILabel *zfps_1_label = [[UILabel alloc] initWithFrame:CGRectMake(label1.right, 5, zhifupeisongView.width-label1.right-arrowImageView.width-space, zhifupeisongView.height/2)];
    zfps_1_label.text = @"";
    zfps_1_label.font = YBLFont(10);
    zfps_1_label.textColor = BlackTextColor;
    zfps_1_label.textAlignment = NSTextAlignmentRight;
    [zhifupeisongView addSubview:zfps_1_label];
    self.zfps_1_label = zfps_1_label;
    
    UILabel *zfps_2_label = [[UILabel alloc] initWithFrame:CGRectMake(zfps_1_label.left, zfps_1_label.bottom-5, zfps_1_label.width, zfps_1_label.height)];
    zfps_2_label.text = @"";
    zfps_2_label.font = YBLFont(10);
    zfps_2_label.textColor = BlackTextColor;
    zfps_2_label.textAlignment = NSTextAlignmentRight;
    [zhifupeisongView addSubview:zfps_2_label];
    self.zfps_2_label = zfps_2_label;

//    NSString *text = @"工作日、双休日、节假日均可送货";
//    CGSize textSize = [text heightWithFont:YBLFont(10) MaxWidth:300];
//    YBLButton *zfps_3_button = [YBLButton buttonWithType:UIButtonTypeCustom];
//    zfps_3_button.frame = CGRectMake(zfps_2_label.left, zfps_2_label.bottom, zfps_2_label.width, zfps_2_label.height);
//    [zfps_3_button setTitle:text forState:UIControlStateNormal];
//    [zfps_3_button setTitleColor:BlackTextColor forState:UIControlStateNormal];
//    [zfps_3_button setImage:[UIImage imageNamed:@"order_homepage_timer_14x14_"] forState:UIControlStateNormal];
////    [zfps_3_button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//    zfps_3_button.titleLabel.font = YBLFont(10);
//    [zfps_3_button setImageRect:CGRectMake(zfps_2_label.width-textSize.width-10-3, 5, 10, 10)];
//    [zfps_3_button setTitleRect:CGRectMake(zfps_2_label.width-textSize.width, 0, textSize.width, 20)];
//    [zhifupeisongView addSubview:zfps_3_button];
    
    [zhifupeisongView addSubview:[YBLMethodTools addLineView:CGRectMake(0, zhifupeisongView.height-0.5, zhifupeisongView.width+space, 0.5)]];
    /* 票据信息 */
    UIButton *invoiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    invoiceButton.frame = CGRectMake(space, zhifupeisongView.bottom, zhifupeisongView.width, 40);
    [self.contentView addSubview:invoiceButton];
    self.invoiceButton = invoiceButton;
    
    UILabel *pjxx_label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, invoiceButton.height)];
    pjxx_label1.font = YBLFont(15);
    pjxx_label1.text = @"票据信息";
    pjxx_label1.textColor = BlackTextColor;
    [invoiceButton addSubview:pjxx_label1];
    
    UIImageView *arrowImageView00 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"found_arrow"]];
    arrowImageView00.frame = CGRectMake(0, 0, 8, 16.5);
    arrowImageView00.centerY = invoiceButton.height/2;
    arrowImageView00.left = invoiceButton.width-8;
    [invoiceButton addSubview:arrowImageView00];
    
    UILabel *invoiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(pjxx_label1.right, 0, invoiceButton.width-pjxx_label1.right-arrowImageView00.width-space, invoiceButton.height)];
    invoiceLabel.text = @"";
    invoiceLabel.textAlignment = NSTextAlignmentRight;
    invoiceLabel.textColor = BlackTextColor;
    invoiceLabel.font = YBLFont(13);
    [invoiceButton addSubview:invoiceLabel];
    self.invoiceLabel = invoiceLabel;
    
    [invoiceButton addSubview:[YBLMethodTools addLineView:CGRectMake(0, invoiceButton.height-0.5, invoiceButton.width+space, 0.5)]];
    
    /* 交易方式 */
    /*
    UIView *jiaoyifangshiView = [[UIView alloc] initWithFrame:CGRectMake(space, invoiceButton.bottom, invoiceButton.width, 40)];
    [self.contentView addSubview:jiaoyifangshiView];
    UILabel *jyfs_label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, jiaoyifangshiView.height)];
    jyfs_label1.font = YBLFont(15);
    jyfs_label1.text = @"交易方式";
    jyfs_label1.textColor = BlackTextColor;
    [jiaoyifangshiView addSubview:jyfs_label1];
    
    
    UILabel *jyfs_label2 = [[UILabel alloc] initWithFrame:CGRectMake(jyfs_label1.right, jyfs_label1.top, jiaoyifangshiView.width-jyfs_label1.right, jyfs_label1.height)];
    jyfs_label2.font = YBLFont(13);
    jyfs_label2.text = @"商城担保交易";
    jyfs_label2.textColor = YBLTextColor;
    jyfs_label2.textAlignment = NSTextAlignmentRight;
    [jiaoyifangshiView addSubview:jyfs_label2];

    [jiaoyifangshiView addSubview:[YBLMethodTools addLineView:CGRectMake(0, jiaoyifangshiView.height-0.5, jiaoyifangshiView.width+space, 0.5)]];
    */
    /*核算运费*/
     UIButton *hesuanyunfeiButton = [UIButton buttonWithType:UIButtonTypeCustom];
     hesuanyunfeiButton.frame = CGRectMake(space, invoiceButton.bottom, invoiceButton.width, 40);
     [self.contentView addSubview:hesuanyunfeiButton];
     self.hesuanyunfeiButton = hesuanyunfeiButton;
     
     UILabel *hsyf_label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, hesuanyunfeiButton.height)];
     hsyf_label1.font = YBLFont(15);
     hsyf_label1.text = @"运费";
     hsyf_label1.textColor = BlackTextColor;
     [hesuanyunfeiButton addSubview:hsyf_label1];
//     
//     UIImageView *arrowImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"found_arrow"]];
//     arrowImageView1.frame = CGRectMake(0, 0, 8, 16.5);
//     arrowImageView1.centerY = hesuanyunfeiButton.height/2;
//     arrowImageView1.left = hesuanyunfeiButton.width-8;
//     [hesuanyunfeiButton addSubview:arrowImageView1];
    
     UILabel *yunfeiLabel = [[UILabel alloc] initWithFrame:CGRectMake(hsyf_label1.right, 0, hesuanyunfeiButton.width-hsyf_label1.right-space, hesuanyunfeiButton.height)];
     yunfeiLabel.text = @"0.00";
     yunfeiLabel.textAlignment = NSTextAlignmentRight;
     yunfeiLabel.textColor = YBLThemeColor;
     yunfeiLabel.font = YBLFont(13);
     [hesuanyunfeiButton addSubview:yunfeiLabel];
     self.yunfeiLabel = yunfeiLabel;
     
     [hesuanyunfeiButton addSubview:[YBLMethodTools addLineView:CGRectMake(0, hesuanyunfeiButton.height-0.5, hesuanyunfeiButton.width+space, 0.5)]];
    
    
    /* 商家留言 */
    UIView *liuyanView = [[UIView alloc] initWithFrame:CGRectMake(space, hesuanyunfeiButton.bottom, hesuanyunfeiButton.width, 60)];
    [self.contentView addSubview:liuyanView];
    
    XXTextField *liuyanTextFeild = [[XXTextField alloc] initWithFrame:CGRectMake(0, 10, liuyanView.width-10, 40)];
    liuyanTextFeild.textColor = BlackTextColor;
    liuyanTextFeild.font = YBLFont(14);
    liuyanTextFeild.maxLength = maxLength_for_massage;
    liuyanTextFeild.isAutoSpaceInLeft = YES;
    liuyanTextFeild.placeholder = @"给商家留言";
    liuyanTextFeild.borderStyle = UITextBorderStyleNone;
    liuyanTextFeild.layer.borderColor = YBLLineColor.CGColor;
    liuyanTextFeild.layer.masksToBounds = YES;
    liuyanTextFeild.layer.cornerRadius = 3;
    liuyanTextFeild.layer.borderWidth = 0.5;
    [liuyanView addSubview:liuyanTextFeild];
    self.liuyanTextFeild = liuyanTextFeild;
    
    
    [liuyanView addSubview:[YBLMethodTools addLineView:CGRectMake(0, liuyanView.height-0.5, liuyanView.width+space, 0.5)]];
    
    /* 小计 */
    UIView *xiaojiView = [[UIView alloc] initWithFrame:CGRectMake(0, liuyanView.bottom, YBLWindowWidth, liuyanView.height)];
    [self.contentView addSubview:xiaojiView];
    
    UILabel *xiaojiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, xiaojiView.width-space, xiaojiView.height)];
    xiaojiLabel.text = @"100箱 | 小计(含运费) : ¥100.00";
    xiaojiLabel.textAlignment = NSTextAlignmentRight;
    xiaojiLabel.font = YBLFont(14);
    [xiaojiView addSubview:xiaojiLabel];
    self.xiaojiLabel = xiaojiLabel;
    
    [xiaojiView addSubview:[YBLMethodTools addLineView:CGRectMake(0, xiaojiView.height-0.5, xiaojiView.width, 0.5)]];
    
}

- (void)updateShopModel:(YBLCartModel *)model{
    
    NSString *xiaojiText = [NSString stringWithFormat:@"%ld件 | 小计(含运费) : ¥%.2f",(long)model.item_count.integerValue,model.total.doubleValue];
    self.xiaojiLabel.text = xiaojiText;
    self.yunfeiLabel.text = [NSString stringWithFormat:@"%.2f",model.shipment_total.doubleValue];

    /*
    NSString *paymentString = @"";
    NSString *shippingString = @"";
    NSString *default_paymentString = @"";
    NSString *default_shippingString = @"";
    for (lineitems *itemModel in model.line_items) {
        if (!itemModel.no_permit_check_result.no_permit.boolValue) {
            if (itemModel.select_product_payment_methods) {
                //支付方式
                paymentString = [paymentString stringByAppendingString:[itemModel.select_product_payment_methods.payment_method.name stringByAppendingString:@"+"]];
            }
            if (itemModel.select_product_shipping_methods){
                //配送方式
                shippingString = [shippingString stringByAppendingString:[itemModel.select_product_shipping_methods.shipping_method.name stringByAppendingString:@"+"]];
            }
            //默认支付方式
            for (YBLShowPayShippingsmentModel *takeModel in itemModel.product.filter_product_payment_methods) {
                if (takeModel.is_default.boolValue) {
                    default_paymentString = [default_paymentString stringByAppendingString:[takeModel.payment_method.name stringByAppendingString:@"+"]];
                }
            }
            //默认配送方式
            for (YBLShowPayShippingsmentModel *takeModel in itemModel.product.filter_product_shiping_methods) {
                if (takeModel.is_default.boolValue) {
                    default_shippingString = [default_shippingString stringByAppendingString:[takeModel.shipping_method.name stringByAppendingString:@"+"]];
                }
            }
            
        }
    }
    
    if (default_paymentString.length>0) {
        default_paymentString = [default_paymentString substringToIndex:default_paymentString.length-1];
        self.zfps_1_label.text = default_paymentString;
    }
    
    if (paymentString.length>0) {
        paymentString = [paymentString substringToIndex:paymentString.length-1];
        self.zfps_1_label.text = paymentString;
    }
    
    if (default_shippingString.length>0) {
        default_shippingString = [default_shippingString substringToIndex:default_shippingString.length-1];
        self.zfps_2_label.text = default_shippingString;
    }
    if (shippingString.length>0) {
        shippingString = [shippingString substringToIndex:shippingString.length-1];
        self.zfps_2_label.text = shippingString;
    }
    */
}

+ (CGFloat)getOrderStoreFooterHi{
    
    return 260;
}

@end
