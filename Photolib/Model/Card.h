//
//  Card.h
//  Photolib
//
//  Created by bravo on 14-6-9.
//  Copyright (c) 2014年 bravo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWPhoto.h"

@interface Card : NSObject

@property(nonatomic,strong)NSURL* path;
@property(nonatomic,strong)MWPhoto* photo;
@property(nonatomic,strong)UIImage* thumb;
@property(nonatomic,strong)NSString* name;
@property(nonatomic,assign)BOOL isAlbum;

-(id)initWithPath:(NSURL*)path thumb:(UIImage*)image name:(NSString*)name album:(BOOL)album;

@end
