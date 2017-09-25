//
//  YBLLabel.m
//  YBL365
//
//  Created by 乔同新 on 12/24/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLLabel.h"

@implementation YBLLabel


- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
    
        self.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

- (CGSize)intrinsicContentSize{
    
    CGSize size = [super intrinsicContentSize];
    
    size.width  += self.edgeInsets.left + self.edgeInsets.right;
    
    size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    
    return size;
    
}
- (void)drawRect:(CGRect)rect {
    
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
    
    CGSize textSize = [[self text] heightWithFont:[self font] MaxWidth:YBLWindowWidth];
    
    CGFloat strikeWidth = textSize.width;
    
    CGRect lineRect;
    
    CGFloat lineWidth = 0.8;
    
    if ([self textAlignment] == NSTextAlignmentRight)
    {
        // 画线居中
        lineRect = CGRectMake(rect.size.width - strikeWidth, rect.size.height/2, strikeWidth, lineWidth);
        
        // 画线居下
        //lineRect = CGRectMake(rect.size.width - strikeWidth, rect.size.height/2 + textSize.height/2, strikeWidth, 1);
    }
    else if ([self textAlignment] == NSTextAlignmentCenter)
    {
        // 画线居中
        lineRect = CGRectMake(rect.size.width/2 - strikeWidth/2, rect.size.height/2, strikeWidth, lineWidth);
        
        // 画线居下
        //lineRect = CGRectMake(rect.size.width/2 - strikeWidth/2, rect.size.height/2 + textSize.height/2, strikeWidth, 1);
    }
    else
    {
        // 画线居中
        lineRect = CGRectMake(0, rect.size.height/2, strikeWidth, lineWidth);
        
        // 画线居下
        //lineRect = CGRectMake(0, rect.size.height/2 + textSize.height/2, strikeWidth, 1);
    }
    
    if (self.strikeThroughEnabled)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [self strikeThroughColor].CGColor);
        
        CGContextFillRect(context, lineRect);
    }

}


@end
