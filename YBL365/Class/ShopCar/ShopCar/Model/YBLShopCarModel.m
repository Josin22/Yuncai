//
//  YBLShopCarModel.m
//  YBL365
//
//  Created by 乔同新 on 16/12/20.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLShopCarModel.h"

@interface YBLShopCarModel ()

@end

@implementation YBLShopCarModel


- (NSArray*)tempGoods {
    if (!_tempGoods) {
        _tempGoods=@[@{@"name":@"【云采超市】强生美肌（Johnson）恒生水嫩护手霜50g",
                       @"image":@"IMG_0589.PNG",
                       @"shop":@"云采自营",
                       @"express":@0,
                       @"types":@[
                               @{@"price":@"¥ 8.90",@"desc":@"颜色:红色;重量:0.176kg",@"num":@3,@"id":@"1"},
                               @{@"price":@"¥ 8.90",@"desc":@"颜色:蓝色;重量:0.176kg",@"num":@2,@"id":@"2"},
                               @{@"price":@"¥ 8.90",@"desc":@"颜色:紫色;重量:0.176kg",@"num":@2,@"id":@"4"}
                               ]
                       },
                     @{@"name":@"【云采超市】光明 莫斯利安 巴氏杀菌常温酸牛奶350g*8盒",
                       @"image":@"IMG_0590.PNG",
                       @"shop":@"云采自营",
                       @"express":@50,
                       @"types":@[
                               @{@"price":@"¥ 39.90",@"desc":@"重量:3.12kg ",@"num":@3,@"id":@"5"}
                               ]
                       },
                     @{@"name":@"【云采超市】海天 招牌拌饭酱 香菇酱 (香辣香菇味) 200g",
                       @"image":@"IMG_0591.PNG",
                       @"shop":@"云采自营",
                       @"express":@60,
                       @"types":@[
                               @{@"price":@"¥ 9.9",@"desc":@"重量:重量:0.35kg ",@"num":@5,@"id":@"6"}
                               ]
                       },
                     @{@"name":@"现货包邮 C Primer Plus 第6版 中文版第六版 c语言程序设计经典教材初学",
                       @"image":@"IMG_0592.PNG",
                       @"shop":@"福州文豪图书专营店",
                       @"express":@10,
                       @"types":@[
                               @{@"price":@"¥ 72.00",@"desc":@"",@"num":@1,@"id":@"7"}
                               ]
                       },
                     @{@"name":@"52°酒鬼内品优级",
                       @"image":@"569ca61daf48435e20003b7a.jpg@!thumb.jpeg",
                       @"shop":@"同心酒行",
                       @"express":@66,
                       @"types":@[
                               @{@"price":@"¥ 218.00",@"desc":@"香型:浓香型",@"num":@5,@"id":@"8"},
                               @{@"price":@"¥ 198.00",@"desc":@"香型:清香型型",@"num":@2,@"id":@"9"}
                               ]
                       },
                     @{@"name":@"【368元/瓶】50° 众源碱性酒鼎品（买一瓶送一瓶珍品碱性酒）",
                       @"image":@"57aea498af48431fa2bfe923.jpg@!thumb.jpeg",
                       @"shop":@"同心酒行",
                       @"express":@88,
                       @"types":@[
                               @{@"price":@"¥ 368.00",@"desc":@"香型:浓香型, 包装:普通包装",@"num":@7,@"id":@"10"},
                               @{@"price":@"¥ 668.00",@"desc":@"香型:清香型型, 包装:豪华包装",@"num":@1,@"id":@"11"}
                               ]
                       },
                     @{@"name":@"【58元/瓶】50°众源尚品碱性酒（买一瓶送一瓶众源碱性酒125ml）",
                       @"image":@"57a9adf3af48431f98bfe042.jpg@!thumb.jpeg",
                       @"shop":@"同心酒行",
                       @"express":@80,
                       @"types":@[
                               @{@"price":@"¥ 58.00",@"desc":@"500ml*1/瓶；50度",@"num":@2,@"id":@"12"},
                               @{@"price":@"¥ 68.00",@"desc":@"600ml*1/瓶；52度",@"num":@3,@"id":@"13"}
                               ]
                       },
                     @{@"name":@"【78元/瓶】45°西凤大曲V6（买一瓶送四瓶喜尔登啤酒330ml）",
                       @"image":@"56fb4677af48430c06dd06c3.jpg@!thumb.jpeg",
                       @"shop":@"同心酒行",
                       @"express":@100,
                       @"types":@[
                               @{@"price":@"¥ 78.00",@"desc":@"460ml*1/瓶；45度",@"num":@5,@"id":@"14"},
                               @{@"price":@"¥ 78.00",@"desc":@"600ml*1/瓶；52度",@"num":@2,@"id":@"15"}
                               ]
                       },
                     @{@"name":@"52°泸州老窖酒香-福运双喜",
                       @"image":@"56c58534af48431bd1cd7dc7.jpg@!thumb.jpeg",
                       @"shop":@"小贵酒行",
                       @"express":@0,
                       @"types":@[
                               @{@"price":@"¥ 78.00",@"desc":@"500ml*1/瓶；52°",@"num":@5,@"id":@"16"}
                               ]
                       }];
    }
    return _tempGoods;
}

+ (instancetype)shareInstance {
    static YBLShopCarModel *shopCarModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shopCarModel = [[YBLShopCarModel alloc] init];
        shopCarModel.carGoodArray = [NSMutableArray array];
    });
    return shopCarModel;
}



//添加商品到购物车
- (void)addGoodToCar:(id)good {
    if (good == nil) {
        good = [NSMutableDictionary dictionaryWithDictionary:self.tempGoods[arc4random()%9]];
    }else if ([good isKindOfClass:[NSDictionary class]]){
        good = [NSMutableDictionary dictionaryWithDictionary:good];
    }
    
    NSMutableArray *array =  [NSMutableArray arrayWithArray:[YBLShopCarModel shareInstance].carGoodArray];
    if ([array count] == 0) {
        [array addObject:good];
    }else {
        BOOL isHave = NO;
        for (NSMutableDictionary *dic in array) {
            if ([[dic objectForKey:@"name"] isEqualToString:good[@"name"]]) {
                isHave = YES;
                break;
            }
        }
        if (!isHave) {
            [array addObject:good];
        }
    }
    
    NSInteger total = 0;
    for (NSMutableDictionary *dic in array) {
        for (NSDictionary *type in dic[@"types"]) {
            total+=[type[@"num"] integerValue];
        }
    }
    [YBLShopCarModel shareInstance].carNumber = total;
    [YBLShopCarModel shareInstance].carGoodArray = array;
}
//减少商品到购物车
- (void)subtractGoodToCar:(id)good {

}





@end
