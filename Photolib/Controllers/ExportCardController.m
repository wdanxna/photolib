//
//  ImportCardController.m
//  Photolib
//
//  Created by bravo on 14-6-20.
//  Copyright (c) 2014年 bravo. All rights reserved.
//

#import "ExportCardController.h"
#import "ExportArrayDataSource.h"
#import "WDSearchTableView.h"

@interface ExportCardController ()

@property(nonatomic,strong) ExportArrayDataSource* dataSource;
@property(nonatomic,weak) WDSearchTableView* searchTable;

@end

@implementation ExportCardController
@synthesize delegate;

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        
    }
    return self;
}

-(void) setDataSourceObj:(id)obj{
    self.dataSource = obj;
    NSLog(@"hihi");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchTable = [self.childViewControllers firstObject];
    NSAssert(self.dataSource != nil, @"search table datasource cannot be nil");
    self.searchTable.tableView.dataSource = self.dataSource;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancleAction:(id)sender {
    [self.delegate exportCardControllerDidCancle:self];
}

- (IBAction)doneAction:(id)sender {
    [self.delegate exportCardController:self didImportDatas:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
