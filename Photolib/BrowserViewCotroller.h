//
//  ViewController.h
//  Photolib
//
//  Created by bravo on 14-5-22.
//  Copyright (c) 2014年 bravo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BrowserViewCotroller;
@protocol WDBrowserDelegate <NSObject>

-(void) WDBrowser:(BrowserViewCotroller *)browser didSelectItemAtIndex:(NSInteger)index;

-(void) WDBrowser:(BrowserViewCotroller *)browser didViewPhotoAtIndex:(NSInteger)index;
-(void) WDBrowser:(BrowserViewCotroller *)browser didEnterFolder:(NSString *)path;
-(void) WDBrowser:(BrowserViewCotroller *)browser didUpdateDataWithPath:(NSString*)path;

@end

@interface BrowserViewCotroller : UICollectionViewController

@property(nonatomic,strong) NSString* current_path;
@property(nonatomic,strong) id<WDBrowserDelegate> delegate;

-(void) setDataSource:(id)dataSource;
-(void) changeSelection:(BOOL)selected onCell:(UICollectionViewCell*)cell;
-(void) enterCell:(UICollectionViewCell*)cell;

-(void) pushPath:(NSString*)path;
-(void) back;

@end