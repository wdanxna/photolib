//
//  UIImage+fixOrientation.m
//  instaoverlay
//
//  Created by Maximilian Mackh on 11/11/12.
//  Copyright (c) 2012 mackh ag. All rights reserved.
//

#import "UIImage+fixOrientation.h"

@implementation UIImage (fixOrientation)

- (UIImage *)fixOrientation
{
    UIImage *src = [[UIImage alloc] initWithCGImage: self.CGImage
                                                         scale: 1.0
                                                   orientation: UIImageOrientationRight];

    return src;
//    if (self.imageOrientation == UIImageOrientationUp) return self;
//    
//    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
//    [self drawInRect:(CGRect){0, 0, self.size}];
//    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return normalizedImage;
}

@end
