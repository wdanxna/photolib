//
//  MAMagnifierView.m
//  instaoverlay
//
//  Created by Xinyuan4 on 14-4-3.
//  Copyright (c) 2014年 mackh ag. All rights reserved.
//

#import "MAMagnifierView.h"

@interface MAMagnifierView ()

@property (strong, nonatomic) CALayer *contentLayer;

@end

@implementation MAMagnifierView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 120, 120);
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.layer.cornerRadius = 60;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

- (void)setPointToMagnify:(CGPoint)pointToMagnify
{
    _pointToMagnify = pointToMagnify;
    
    CGPoint center = CGPointMake(pointToMagnify.x, self.center.y);
    if (pointToMagnify.y > CGRectGetHeight(self.bounds) * 0.5) {
        center.y = pointToMagnify.y -  CGRectGetHeight(self.bounds) / 2;
    }
    self.center = center;
    
//    [self setNeedsDisplay];
}


 - (void)drawRect:(CGRect)rect
 {
     CGContextRef ctx = UIGraphicsGetCurrentContext();
     CGContextTranslateCTM(ctx, self.frame.size.width * 0.5, self.frame.size.height * 0.5);
	CGContextScaleCTM(ctx, 1.5, 1.5);
     CGContextTranslateCTM(ctx, -1 * self.pointToMagnify.x, -1 * self.pointToMagnify.y);
     [self.viewToMagnify.layer renderInContext:ctx];
 }



@end
