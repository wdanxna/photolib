//
//  DataProvider.h
//  Photolib
//
//  Created by bravo on 14-6-11.
//  Copyright (c) 2014年 bravo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataProvider <NSObject>

-(NSDictionary*)dataAtFirstLevel;

-(NSDictionary*)dataWithPath:(NSString*)path;

-(NSArray*)photosArray;

-(NSString*) rootPath;

@end
