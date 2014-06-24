//
//  DataProvider.h
//  Photolib
//
//  Created by bravo on 14-6-11.
//  Copyright (c) 2014年 bravo. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^createAlbumCallback)(NSError* error);
typedef void (^deleteItemCallback)(NSError* error);

@protocol DataProvider <NSObject>

-(NSDictionary*)dataAtFirstLevel;

-(NSDictionary*)dataWithPath:(NSString*)path;

-(NSArray*)photosArray;
-(NSDictionary*) currentLevelData;

-(NSString*) rootPath;

-(NSArray*)getAlbums;

-(void) removeItemWithNames:(NSArray*)names complete:(deleteItemCallback)callback;

-(void) createAlbumAtPath:(NSString*)path name:(NSString*)name passwd:(NSString*)passwd complete:(createAlbumCallback)callback;

@end