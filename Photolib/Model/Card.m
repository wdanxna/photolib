//
//  Card.m
//  Photolib
//
//  Created by bravo on 14-6-9.
//  Copyright (c) 2014年 bravo. All rights reserved.
//

#import "Card.h"

@implementation Card
@synthesize path, photo, thumb, name, isAlbum;

-(id)initWithPath:(NSURL*)apath thumb:(UIImage*)athumb name:(NSString*)aname album:(BOOL)album{
    self= [super init];
    if (self){
        self.path = apath;
        self.thumb = athumb;
        self.isAlbum = album;
        self.name = aname;
        
        if (!self.isAlbum && self.path){
            self.photo = [[MWPhoto alloc] initWithURL:apath];
        }
    }
    return self;
}

@end
