//
//  TableViewController.m
//  iafamily
//
//  Created by shepard zhao on 26/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "FamilyViewDetailTableViewController.h"
#import "SingleMemberDetailViewController.h"
#import "FamilyUserSearchViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AnimationAndUIAndImage.h"
#import "ODRefreshControl.h"

@interface FamilyViewDetailTableViewController (){
    UIImageView *navBarHairlineImageView;
}
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation FamilyViewDetailTableViewController


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    navBarHairlineImageView = [AnimationAndUIAndImage findHairlineImageViewUnder:self.navigationController.navigationBar];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    navBarHairlineImageView.hidden = YES;

    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = self.familyTitle;
    
    //if current cache does not include any data
    if (![self getResearchFromNsUserDefault]) {
        [self getAllMemberFromCurrentFamilyID];
    }
    else{
        //you dont have to define any statement thats to reload the table/

        self.membersDicitonary = [self getResearchFromNsUserDefault];
    }
    
    
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableview];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    
}



- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self getAllMemberFromCurrentFamilyID];
        [refreshControl endRefreshing];
        
        
    });
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.membersDicitonary count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"memberFamilyCells" forIndexPath:indexPath];
    //set the deatil for the each cell - the cell has 2 lines for maxium displaying the infomation
    UIImageView* memberOnlineStatusButton = [[UIImageView alloc] initWithFrame:CGRectMake(270, 25, 15, 15)];
    

    if ([self.membersDicitonary[indexPath.row][@"user_status"] intValue] == 1) {
        memberOnlineStatusButton.image = [UIImage imageNamed:@"online"];
        
    }
    else{
        memberOnlineStatusButton.image = [UIImage imageNamed:@"offline"];

    }
    
    [cell addSubview:memberOnlineStatusButton];
    cell.textLabel.text = self.membersDicitonary[indexPath.row][@"user_name"];
    
    [AnimationAndUIAndImage tableImageAsyncDownload:self.membersDicitonary[indexPath.row][@"user_avatar"] : cell.imageView];
    
    return cell;




}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}
/**
 **fetch the members info by family id
 */

-(void)getAllMemberFromCurrentFamilyID{
    //check the text field is not empty

    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"waiting...";
    HUD.delegate = self;
    
    [ServerEnd fetchJson:[ServerEnd setBaseUrl:@"familyGroup.php"] :@{@"requestType":@"fetchFamilyMembers",@"familyID":self.familyId} onCompletion:^(NSDictionary *dictionary) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if ([dictionary[@"success"] isEqualToString:@"true"]) {
            
            //set members list to NsUserDefault
           // [NsUserDefaultModel setUserDefault:dictionary[@"membersDetails"] :GroupFamilyMembers];
            
            [self insertRecord:dictionary[@"membersDetails"]];
            
            //get family data
            self.membersDicitonary = dictionary[@"membersDetails"];
           
            
            //here's to refresh the table
            
            dispatch_async(dispatch_get_main_queue(), ^{
                             [self.tableview reloadData];
                
            });
            
        }
        else{
            
            
            
            //here's to disply the error message
            
        }
        
        
    }];
    
}



/**
 **end
 **/


/**
 **insert the record into the NsUserDefault
 **/

-(void) insertRecord:(NSDictionary*) currentFamilyMembers{
    
    NSMutableDictionary* list  = (NSMutableDictionary*) [NsUserDefaultModel getCurrentData:GroupFamilyMembers];

    [list setObject:currentFamilyMembers forKey:self.familyId];
    
    //set members list to NsUserDefault
    
   [NsUserDefaultModel setUserDefault:list :GroupFamilyMembers];

}
 /**
  **end
  */




/**
 ** read the current dictionary from NsUserDefault 
 **/

-(NSMutableArray*) getResearchFromNsUserDefault{
 NSMutableDictionary* list  = (NSMutableDictionary*) [NsUserDefaultModel getCurrentData:GroupFamilyMembers];
    return list[self.familyId];
}


/**
 **end
 **/




/**
 *prepare to segue
 **/


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showMemberDetailSegue"]) {
        NSIndexPath *indexPath = [self.tableview indexPathForCell:sender];
        
        SingleMemberDetailViewController *SignleController = (SingleMemberDetailViewController *)segue.destinationViewController;
        SignleController.singleMemberDetail = self.membersDicitonary[indexPath.row];
    }
    
    
    if([segue.identifier isEqualToString:@"searchUserSegue"]){
        
        FamilyUserSearchViewController *searchController = (FamilyUserSearchViewController*) segue.destinationViewController;
        searchController.familyID = self.familyId;
        searchController.familyTitle = self.familyTitle;
        
        
    }
    
   

}





/**
 *end
 **/








@end
