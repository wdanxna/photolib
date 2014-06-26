//
//  ExportArrayDataSource.m
//  Photolib
//
//  Created by bravo on 14-6-20.
//  Copyright (c) 2014年 bravo. All rights reserved.
//

#import "ExportArrayDataSource.h"
#import "Card.h"

@interface ExportArrayDataSource()
@property(nonatomic,strong) NSArray* sections;
@property(nonatomic,strong) NSString* cellIdentifier;
@property(nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;
@end

@implementation ExportArrayDataSource{
    NSMutableArray* _valid_section_index;
}

-(NSArray*)items{
    return self.sections;
}

-(id) initWithItems:(NSArray *)aitems cellIdentifier:(NSString *)cellIndentifier configureCellBlock:(TableViewCellConfigureBlock)aConfigureBlock{
    self = [super init];
    if (self){
        [self setObjects:aitems];
        self.cellIdentifier = cellIndentifier;
        self.configureCellBlock = aConfigureBlock;
    }
    return self;
}

-(void) setObjects:(NSArray *)objects{
    SEL selector = @selector(localizedTitle);
    NSInteger sectionTitlesCount = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
    
    NSMutableArray* mutableSections = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    for (NSUInteger idx = 0; idx < sectionTitlesCount; idx++){
        [mutableSections addObject:[NSMutableArray array]];
    }
    
    _valid_section_index = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    for (Card* object in objects){
        NSInteger sectionNumber = [[UILocalizedIndexedCollation currentCollation] sectionForObject:object collationStringSelector:selector];
        if (((NSArray*)[mutableSections objectAtIndex:sectionNumber]).count == 0){
            // For traditional chinese, there is a mismatch between sectionTitles and sectionIndexTitle, which the first one has 37 strange
            // characters index ranging from 25 to 61.
            if (sectionNumber > 61) sectionNumber -= 37;
            [_valid_section_index addObject:[NSNumber numberWithInt:sectionNumber]];
        }
        [[mutableSections objectAtIndex:sectionNumber] addObject:object];
    }
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"intValue"
                                                                        ascending:YES];
  _valid_section_index = [[_valid_section_index sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
    
    for (NSUInteger idx = 0; idx < sectionTitlesCount; idx++){
        NSArray *objectsForSection = [mutableSections objectAtIndex:idx];
        [mutableSections replaceObjectAtIndex:idx withObject:[[UILocalizedIndexedCollation currentCollation] sortedArrayFromArray:objectsForSection collationStringSelector:selector]];
    }
    
    self.sections = mutableSections;
}

-(id) itemAtIndex:(NSIndexPath *)indexPath{
    return [self.sections[indexPath.section] objectAtIndex:indexPath.row];
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray* rows = [self.sections objectAtIndex:section];
    return rows.count;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([self tableView:tableView numberOfRowsInSection:section] < 1) return nil;
    //don't forget to shift it back
    int validSection = section;
    if ([[UILocalizedIndexedCollation currentCollation] sectionTitles].count > 62 && validSection > 24) validSection += 37;
    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:validSection];
}

-(NSArray*) sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray* titles = [[NSMutableArray alloc] initWithCapacity:_valid_section_index.count + 1];
    [titles addObject:UITableViewIndexSearch];
    NSArray* raw = [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
    for (NSNumber* sectionIdx in _valid_section_index){
        [titles addObject: [raw objectAtIndex:sectionIdx.intValue]];
    }
    return titles;
}

-(NSInteger) tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index
{
    if (index == 0){
        return -1;
    }
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:((NSNumber*)_valid_section_index[index-1]).intValue];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    id item = [self itemAtIndex:indexPath];
    self.configureCellBlock(cell, item);
    return cell;
}

@end
