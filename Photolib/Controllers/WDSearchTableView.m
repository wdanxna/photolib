//
//  WDSearchTableView.m
//  Photolib
//
//  Created by bravo on 14-6-24.
//  Copyright (c) 2014年 bravo. All rights reserved.
//

#import "WDSearchTableView.h"
#import "ExportArrayDataSource.h"

@interface WDSearchTableView ()<UISearchBarDelegate,UISearchDisplayDelegate>
@property(nonatomic,strong) NSArray* sections;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchController;
@property (nonatomic,strong) NSMutableArray* searchArray;

@end

@implementation WDSearchTableView

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self setAutomaticallyAdjustsScrollViewInsets:YES];
//    [self setExtendedLayoutIncludesOpaqueBars:YES];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - search display
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    [UIView beginAnimations:@"hide" context:nil];
    [UIView setAnimationDuration:0.3];
    self.navigationController.navigationBarHidden = YES;
    [UIView commitAnimations];
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray*) getDataSource{
    NSArray* dataSource = [((ExportArrayDataSource*)self.tableView.dataSource) items];
    NSMutableArray* flattenSets = [[NSMutableArray alloc] initWithCapacity:dataSource.count];
    
    for (NSArray* section in dataSource){
        if (section.count > 0){
            [flattenSets addObjectsFromArray:section];
        }
    }
    return flattenSets;
}

#pragma mark -
-(void) filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    self.searchArray = [[self getDataSource] mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    self.searchArray = [NSMutableArray arrayWithArray:[self.searchArray filteredArrayUsingPredicate:predicate]];
    NSLog(@"xxx");
}

#pragma mark - Tableview delegate

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

#pragma mark -
#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:nil];
    return YES;
}

//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
//    // 当用户改变搜索范围时，让列表的数据来源重新加载数据
//    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:nil];
//
//    return YES;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
