//
//  MessagePhotoTableViewController.m
//  iAfamily
//
//  Created by shepard zhao on 13/10/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "MessagePhotoTableViewController.h"
#import "MessagePhotoTableViewCell.h"
#import "AnimationAndUIAndImage.h"
#import "MorePhotosCollectionViewController.h"
#import "MessageModel.h"
#import "MessageViewController.h"
@interface MessagePhotoTableViewController (){
    long index;
    NSMutableArray* messageIDArrays;
    UIImageView *navBarHairlineImageView;

}

@end

@implementation MessagePhotoTableViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    navBarHairlineImageView.hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = self.singleUserDetailArray[@"senderName"];
     self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    navBarHairlineImageView = [AnimationAndUIAndImage findHairlineImageViewUnder:self.navigationController.navigationBar];

    //to mark the new message has been read already
    [self setMessageIDArrays];
}


-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    
    
    MessageViewController* messControl = [[MessageViewController alloc]init];
    
    [messControl getMessageRequest:@"fetchDetailOfMessages"];
 

}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
}



//analysis array and take the message id from old multableArray to new multableArray
-(void)setMessageIDArrays{
    
    messageIDArrays = [[NSMutableArray alloc] init];
    
    
    for (int i=0; i<[self.singleUserDetailArray[@"content"] count]; i++) {
        [messageIDArrays addObject:self.singleUserDetailArray[@"content"][i][@"message_id"]];
    }

    [MessageModel removeNumberOfMessage:self.tabBarController :messageIDArrays];



}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.singleUserDetailArray[@"content"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessagePhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoMessageCell"];

    
    
    cell.timeLabel.text = self.singleUserDetailArray[@"content"][indexPath.row][@"create_date"];
    [AnimationAndUIAndImage tableImageAsyncDownload:self.singleUserDetailArray[@"senderUrl"] :cell.userProfile :1];
    
    

    
    
    //description
   
    cell.imageDescription.text =self.singleUserDetailArray[@"content"][indexPath.row][@"message_content"][0][@"Description"] ;
    
    long photoLength = [self.singleUserDetailArray[@"content"][indexPath.row][@"message_content"] count];
    
    
   
    
    
    //check the number of photos, if more then 6 then display more
    if (photoLength>6) {
        [cell.moreButton setHidden:NO];
        cell.moreButton.tag = indexPath.row;
        [cell.moreButton addTarget:self action:@selector(morePhotos:) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
        
    }
    else{
        [cell.moreButton setHidden:YES];
    }
    

    
    
    //display number of photos
    UILabel* numbersPhotos= [[UILabel alloc] init];

    if (photoLength>3) {
        numbersPhotos.frame= CGRectMake(46, 235, 57, 21);
    }else{
        numbersPhotos.frame= CGRectMake(46, 160, 57, 21);

    }
    
    [numbersPhotos setFont:[UIFont fontWithName:@"Lato-Regular" size:12]];
    [numbersPhotos setTextColor:[UIColor darkGrayColor]];
    [numbersPhotos setText:[NSString stringWithFormat:@"%lu photos",photoLength]];
    
    
    [cell addSubview:numbersPhotos];

    if (photoLength==1) {
        
        [cell.imageTwo setImage:nil];
        [cell.imageThree setImage:nil];
        [cell.imageFour setImage:nil];
        [cell.imageFive setImage:nil];
        [cell.imageSix setImage:nil];

        
        
        [AnimationAndUIAndImage collectionImageAsynDownload:self.singleUserDetailArray[@"content"][indexPath.row][@"message_content"][0][@"image_id"][2] :cell.imageOne :@"photoPlaceHolder_thumb" :NO];
        
        
    
        
    }
    else if (photoLength==2) {
        
        [cell.imageThree setImage:nil];
        [cell.imageFour setImage:nil];
        [cell.imageFive setImage:nil];
        [cell.imageSix setImage:nil];

        
        
        [AnimationAndUIAndImage collectionImageAsynDownload:self.singleUserDetailArray[@"content"][indexPath.row][@"message_content"][0][@"image_id"][2] :cell.imageOne :@"photoPlaceHolder_thumb" :NO];
        [AnimationAndUIAndImage collectionImageAsynDownload:self.singleUserDetailArray[@"content"][indexPath.row][@"message_content"][1][@"image_id"][2] :cell.imageTwo :@"photoPlaceHolder_thumb" :NO];
        
    }
    else if (photoLength==3) {
        
        
        [cell.imageFour setImage:nil];
        [cell.imageFive setImage:nil];
        [cell.imageSix setImage:nil];

        [AnimationAndUIAndImage collectionImageAsynDownload:self.singleUserDetailArray[@"content"][indexPath.row][@"message_content"][0][@"image_id"][2] :cell.imageOne :@"photoPlaceHolder_thumb" :NO];
        [AnimationAndUIAndImage collectionImageAsynDownload:self.singleUserDetailArray[@"content"][indexPath.row][@"message_content"][1][@"image_id"][2] :cell.imageTwo :@"photoPlaceHolder_thumb" :NO];
        
        [AnimationAndUIAndImage collectionImageAsynDownload:self.singleUserDetailArray[@"content"][indexPath.row][@"message_content"][2][@"image_id"][2] :cell.imageThree :@"photoPlaceHolder_thumb" :NO];
    
    }
    else if (photoLength==4){
        
        [cell.imageFive setImage:nil];
        [cell.imageSix setImage:nil];
        
        [AnimationAndUIAndImage collectionImageAsynDownload:self.singleUserDetailArray[@"content"][indexPath.row][@"message_content"][0][@"image_id"][2] :cell.imageOne :@"photoPlaceHolder_thumb" :NO];
        [AnimationAndUIAndImage collectionImageAsynDownload:self.singleUserDetailArray[@"content"][indexPath.row][@"message_content"][1][@"image_id"][2] :cell.imageTwo :@"photoPlaceHolder_thumb" :NO];
        
        [AnimationAndUIAndImage collectionImageAsynDownload:self.singleUserDetailArray[@"content"][indexPath.row][@"message_content"][2][@"image_id"][2] :cell.imageThree :@"photoPlaceHolder_thumb" :NO];
        [AnimationAndUIAndImage collectionImageAsynDownload:self.singleUserDetailArray[@"content"][indexPath.row][@"message_content"][3][@"image_id"][2] :cell.imageFour :@"photoPlaceHolder_thumb" :NO];
        
    
    }
    else if (photoLength==5){
        
        [cell.imageSix setImage:nil];
        
        [AnimationAndUIAndImage collectionImageAsynDownload:self.singleUserDetailArray[@"content"][indexPath.row][@"message_content"][0][@"image_id"][2] :cell.imageOne :@"photoPlaceHolder_thumb" :NO];
        [AnimationAndUIAndImage collectionImageAsynDownload:self.singleUserDetailArray[@"content"][indexPath.row][@"message_content"][1][@"image_id"][2] :cell.imageTwo :@"photoPlaceHolder_thumb" :NO];
        
        [AnimationAndUIAndImage collectionImageAsynDownload:self.singleUserDetailArray[@"content"][indexPath.row][@"message_content"][2][@"image_id"][2] :cell.imageThree :@"photoPlaceHolder_thumb" :NO];
        [AnimationAndUIAndImage collectionImageAsynDownload:self.singleUserDetailArray[@"content"][indexPath.row][@"message_content"][3][@"image_id"][2] :cell.imageFour :@"photoPlaceHolder_thumb" :NO];
        [AnimationAndUIAndImage collectionImageAsynDownload:self.singleUserDetailArray[@"content"][indexPath.row][@"message_content"][4][@"image_id"][2] :cell.imageFive :@"photoPlaceHolder_thumb" :NO];
        
        
    }
    else if (photoLength==6 || photoLength>6){
        [AnimationAndUIAndImage collectionImageAsynDownload:self.singleUserDetailArray[@"content"][indexPath.row][@"message_content"][0][@"image_id"][2] :cell.imageOne :@"photoPlaceHolder_thumb" :NO];
        [AnimationAndUIAndImage collectionImageAsynDownload:self.singleUserDetailArray[@"content"][indexPath.row][@"message_content"][1][@"image_id"][2] :cell.imageTwo :@"photoPlaceHolder_thumb" :NO];
        
        [AnimationAndUIAndImage collectionImageAsynDownload:self.singleUserDetailArray[@"content"][indexPath.row][@"message_content"][2][@"image_id"][2] :cell.imageThree :@"photoPlaceHolder_thumb" :NO];
        [AnimationAndUIAndImage collectionImageAsynDownload:self.singleUserDetailArray[@"content"][indexPath.row][@"message_content"][3][@"image_id"][2] :cell.imageFour :@"photoPlaceHolder_thumb" :NO];
        [AnimationAndUIAndImage collectionImageAsynDownload:self.singleUserDetailArray[@"content"][indexPath.row][@"message_content"][4][@"image_id"][2] :cell.imageFive:@"photoPlaceHolder_thumb" :NO];
        [AnimationAndUIAndImage collectionImageAsynDownload:self.singleUserDetailArray[@"content"][indexPath.row][@"message_content"][5][@"image_id"][2] :cell.imageSix :@"photoPlaceHolder_thumb" :NO];
        
    }
    
    [cell setClipsToBounds:YES];

    return cell;
}



    
-(void)morePhotos:(id)sender{
    
    UIButton* getbuttonTag = (UIButton*)sender;
    index= getbuttonTag.tag;
    [self performSegueWithIdentifier:@"messageMorePhotosSegue" sender:self];
    
    

}
    





- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat calculatedHeight = 263;
    
    
    long photoLength = [self.singleUserDetailArray[@"content"][indexPath.row][@"message_content"] count];

    if(photoLength>3){
        return calculatedHeight;
    }
    else{
        return calculatedHeight-75;
    }
    
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"messageMorePhotosSegue"]) {
         MorePhotosCollectionViewController* moreCont = (MorePhotosCollectionViewController*)segue.destinationViewController;
        moreCont.morePhotosUrls = self.singleUserDetailArray[@"content"][index];
        
    }
   
    
    
    
    
    
}


@end
