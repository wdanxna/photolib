//
//  Card.m
//  Photolib
//
//  Created by bravo on 14-6-9.
//  Copyright (c) 2014年 bravo. All rights reserved.
//

#import "Card.h"

@implementation Card
@synthesize path, photo, thumb, name, isAlbum, password, thumb_path;

-(id)initWithPath:(NSURL*)apath thumb:(UIImage*)athumb thumbPath:(NSURL*)thumbPath name:(NSString*)aname album:(BOOL)album{
    self= [super init];
    if (self){
        if ([apath isKindOfClass:[NSString class]]){
            self.path = [NSURL URLWithString:(NSString*)apath];
        }else{
            self.path = apath;
        }
        if ([thumbPath isKindOfClass:[NSString class]]){
            self.thumb_path = [NSURL URLWithString:(NSString*)thumbPath];
        }else{
            self.thumb_path = thumbPath;
        }
        
        self.thumb = athumb;
        self.isAlbum = album;
        self.name = aname;
        self.password = @"";
        if (!self.isAlbum && self.path){
            self.photo = [[MWPhoto alloc] initWithURL:apath];
        }
    }
    return self;
}

-(NSString*) localizedTitle{
    return self.name;
}

@end
