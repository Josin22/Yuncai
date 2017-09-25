//
//  SMTextField.m
//  SM
//
//  Created by 乔同新 on 12/28/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "SMTextField.h"

@implementation SMTextField

//控制placeHolder的位置，左右缩20
-(CGRect)placeholderRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, self.leftView.width+space, 0);
}

//控制显示文本的位置

-(CGRect)textRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, self.leftView.width+space, 0);
}
//控制编辑文本的位置

-(CGRect)editingRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, self.leftView.width+space, 0);

}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += space; //像右边偏15
    return iconRect;
}

@end
