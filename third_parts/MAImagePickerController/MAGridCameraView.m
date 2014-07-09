//
//  MAGridCameraView.m
//  instaoverlay
//
//  Created by Xinyuan4 on 14-4-3.
//  Copyright (c) 2014年 mackh ag. All rights reserved.
//

#import "MAGridCameraView.h"

@implementation MAGridCameraView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    UIColor* gridColor = [UIColor colorWithRed:84.0f/255.0f green:89.0f/255.0f blue:172.0f/255.0f alpha:1.0];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, gridColor.CGColor);
    CGContextSetLineWidth(context, 2.0);
    
    //Horizontal line
    CGContextMoveToPoint(context, self.bounds.origin.x, 150);
    CGContextAddLineToPoint(context, self.bounds.origin.x+self.bounds.size.width, 150);
    
    CGContextMoveToPoint(context, self.bounds.origin.x, 350);
    CGContextAddLineToPoint(context, self.bounds.origin.x+self.bounds.size.width, 350);
    
    //Vertical line
    CGContextMoveToPoint(context, 50, self.bounds.origin.y);
    CGContextAddLineToPoint(context, 50 ,self.bounds.origin.y + self.bounds.size.height);
    
    CGContextMoveToPoint(context, 270, self.bounds.origin.y);
    CGContextAddLineToPoint(context, 270 ,self.bounds.origin.y + self.bounds.size.height);
    
    CGContextStrokePath(context);

    CGContextRestoreGState(context);
}


@end
