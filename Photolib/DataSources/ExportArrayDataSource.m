//
//  ExportArrayDataSource.m
//  Photolib
//
//  Created by bravo on 14-6-20.
//  Copyright (c) 2014年 bravo. All rights reserved.
//

#import "ExportArrayDataSource.h"

@interface ExportArrayDataSource()
@property(nonatomic,strong) NSArray* items;
@property(nonatomic,strong) NSString* cellIdentifier;
@property(nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;
@end

@implementation ExportArrayDataSource

-(id) initWithItems:(NSArray *)aitems cellIdentifier:(NSString *)cellIndentifier configureCellBlock:(TableViewCellConfigureBlock)aConfigureBlock{
    self = [super init];
    if (self){
        self.items = aitems;
        self.cellIdentifier = cellIndentifier;
        self.configureCellBlock = aConfigureBlock;
    }
    return self;
}

-(void) updateItems:(NSArray *)items{
    self.items = items;
}

-(id) itemAtIndex:(NSIndexPath *)indexPath{
    return [self.items objectAtIndex:indexPath.row];
}

#pragma mark - tableView dataSource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    id item = [self itemAtIndex:indexPath];
    self.configureCellBlock(cell, item);
    return cell;
}

@end
