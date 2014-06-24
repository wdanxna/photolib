//
//  ExportArrayDataSource.h
//  Photolib
//
//  Created by bravo on 14-6-20.
//  Copyright (c) 2014年 bravo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TableViewCellConfigureBlock)(id cell, id item);

@interface ExportArrayDataSource : NSObject<UITableViewDataSource>

-(id) initWithItems:(NSArray*)aitems
     cellIdentifier:(NSString*)cellIndentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureBlock;

-(void) updateItems:(NSArray*)items;

-(id) itemAtIndex:(NSIndexPath*)indexPath;

@end
