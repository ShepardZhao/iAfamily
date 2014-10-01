//
//  detailPhotoCollectionViewCell.m
//  iafamily
//
//  Created by shepard zhao on 24/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "detailPhotoCollectionViewCell.h"
#import "AnimationAndUIAndImage.h"
#import "detailPhotoTableViewCell.h"
@implementation detailPhotoCollectionViewCell




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section;
    return 10;
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath {
    
    detailPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoTableCell" forIndexPath:indexPath];
    //set the deatil for the each cell - the cell has 2 lines for maxium displaying the infomation
   
    cell.content.text = @"avc";
    
    return cell;
    
}


/**
 **get latest comments
 **/

-(void)getLatestComment{




}

/**
 **end
 **/








@end
