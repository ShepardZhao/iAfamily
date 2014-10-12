//
//  MessageViewController.m
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 8/15/14.
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//


#import "CommentController.h"
#import "CommentTableViewCell.h"
#import "AnimationAndUIAndImage.h"
#import "NsUserDefaultModel.h"
#import "ServerEnd.h"
#import "SystemNSObject.h"

static NSString *CommentCellIdentifier = @"CommentCell";

@interface CommentController (){
    UIImageView *navBarHairlineImageView;
    NSString* commentType;
}

@property (nonatomic, strong) NSMutableArray *comments;

@end

@implementation CommentController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //show left back button
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered  target:self action:@selector(backTapped:)];
    self.navigationItem.leftBarButtonItem = back;
    

    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSArray *reversed = [[array reverseObjectEnumerator] allObjects];
    
    self.comments = [[NSMutableArray alloc] initWithArray:reversed];

    self.bounces = YES;
    self.undoShakingEnabled = YES;
    self.keyboardPanningEnabled = YES;
    self.inverted = YES;
    
    [self.tableView registerClass:[CommentTableViewCell class] forCellReuseIdentifier:CommentCellIdentifier];

    self.textView.placeholder = NSLocalizedString(@"Leave a Comment", nil);
    self.textView.placeholderColor = [UIColor lightGrayColor];
    self.textView.layer.borderColor = [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0].CGColor;
    [self.textView setKeyboardAppearance:UIKeyboardAppearanceDark];
    
    [self.leftButton setImage:[UIImage imageNamed:@"multipleFunctions"] forState:UIControlStateNormal];
    [self.leftButton setTintColor:[UIColor grayColor]];
    
    [self.rightButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
    [self.rightButton setTintColor:Rgb2UIColor(26, 188, 156,1.0)];
    
    
    [self.textInputbar.editorTitle setTextColor:[UIColor darkGrayColor]];
    [self.textInputbar.editortLeftButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [self.textInputbar.editortRightButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
    
    self.textInputbar.autoHideRightButton = YES;
    self.textInputbar.maxCharCount = 500;
    self.textInputbar.counterStyle = SLKCounterStyleSplit;
    
    self.typingIndicatorView.canResignByTouch = YES;
    
    //wipe out button line of navigation bar
    
    navBarHairlineImageView = [AnimationAndUIAndImage findHairlineImageViewUnder:self.navigationController.navigationBar];
    
    //set title
    
    self.title =@"Comment";
    
    
    //set tableview background
    [self.tableView setBackgroundColor:Rgb2UIColor(242, 236, 229, 1.0)];
    
    
    //initial commentType
    commentType = [[NSString alloc] init];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
}

- (void)backTapped:(id)sender {
    [[self view] endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];

    });
    
}



- (void)viewDidAppear:(BOOL)animated
{
    

    [super viewDidAppear:animated];
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    navBarHairlineImageView.hidden = YES;
    [self getComments];

}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;


}


- (void)editCellMessage:(UIGestureRecognizer *)gesture
{
  /*
    CommentTableViewCell *cell = (CommentTableViewCell *)gesture.view;
    NSString *message = self.comments[cell.indexPath.row];
    
    [self editText:message];
    
    [self.tableView scrollToRowAtIndexPath:cell.indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
   */
    
}



- (void)editLastMessage:(id)sender
{   /*
    NSString *lastMessage = [self.comments firstObject];
    [self editText:lastMessage];
    
    [self.tableView slk_scrollToTopAnimated:YES];
     */
}

- (void)didSaveLastMessageEditing:(id)sender
{
    /*
    NSString *message = [self.textView.text copy];
    
    [self.comments removeLastObject];
    [self.comments addObject:message];
    
    [self.tableView reloadData];
     */
}


#pragma mark - Overriden Methods

- (void)didChangeKeyboardStatus:(SLKKeyboardStatus)status
{
    // Notifies the view controller that the keyboard changed status.
}

- (void)textWillUpdate
{
    // Notifies the view controller that the text will update.

    [super textWillUpdate];
}

- (void)textDidUpdate:(BOOL)animated
{
    // Notifies the view controller that the text did update.

    [super textDidUpdate:animated];
}

- (void)didPressLeftButton:(id)sender
{
    // Notifies the view controller when the left button's action has been triggered, manually.
    
    [super didPressLeftButton:sender];
}

- (void)didPressRightButton:(id)sender
{
    // Notifies the view controller when the right button's action has been triggered, manually or by using the keyboard return key.
    
    // This little trick validates any pending auto-correction or auto-spelling just after hitting the 'Send' button
    [self.textView refreshFirstResponder];
    
    
    NSData *message = [self.textView.text copy];
    commentType = [NSString stringWithFormat:@"words"];
    
    
    [self submitComment:message:self.tableView];

    
    
    
    [super didPressRightButton:sender];
    
    //send comment to server
    
    
    
    
    
}

- (void)didPasteImage:(UIImage *)image
{
    // Notifies the view controller when the user has pasted an image inside of the text view.
    UIImageView* setTempUIimage= [[UIImageView alloc]  initWithImage:[AnimationAndUIAndImage squareImageWithImage:image scaledToSize:CGSizeMake(100, 100)]];

    [self.textView addSubview:setTempUIimage];
    [self.textView  setFrame:CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.frame.size.width, 150)];
    
    
}

- (void)willRequestUndo
{
    // Notifies the view controller when a user did shake the device to undo the typed text
    
    [super willRequestUndo];
}

- (void)didCommitTextEditing:(id)sender
{
    /*
    // Notifies the view controller when tapped on the right "Accept" button for commiting the edited text
    
    NSString *message = [self.textView.text copy];
    
    [self.comments removeObjectAtIndex:0];
    [self.comments insertObject:message atIndex:0];
    [self.tableView reloadData];
    
     */
    [super didCommitTextEditing:sender];
}

- (void)didCancelTextEditing:(id)sender
{
    // Notifies the view controller when tapped on the left "Cancel" button

    [super didCancelTextEditing:sender];
}

- (BOOL)canPressRightButton
{
    return [super canPressRightButton];
}





- (NSArray *)keyCommands
{
    NSMutableArray *commands = [NSMutableArray arrayWithArray:[super keyCommands]];
    
    // Edit last message
    [commands addObject:[UIKeyCommand keyCommandWithInput:UIKeyInputUpArrow
                                           modifierFlags:0
                                                   action:@selector(editLastMessage:)]];
    
    return commands;
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{        return self.comments.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self messageCellForRowAtIndexPath:indexPath];

}

- (CommentTableViewCell *)messageCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = (CommentTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CommentCellIdentifier];
    
    if (!cell.textLabel.text) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(editCellMessage:)];
        [cell addGestureRecognizer:longPress];
    }
    
    cell.textLabel.text = self.comments[indexPath.row][@"comment_content"];

    cell.detailTextLabel.text = self.comments[indexPath.row][@"comment_date"];
    
    [AnimationAndUIAndImage tableImageAsyncDownload:self.comments[indexPath.row][@"user_avatar"] :cell.imageView :1];
    
    // Cells must inherit the table view's transform
    // This is very important, since the main table view may be inverted
    cell.transform = self.tableView.transform;
    

    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView]) {
        NSString *message = self.comments[indexPath.row][@"comment_content"];
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0],
                                     NSParagraphStyleAttributeName: paragraphStyle};
        
        CGFloat width = CGRectGetWidth(tableView.frame)-(kAvatarSize*2.0+10);
        
        CGRect bounds = [message boundingRectWithSize:CGSizeMake(width, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
        
        if (message.length == 0) {
            return 0.0;
        }
        
        CGFloat height = roundf(CGRectGetHeight(bounds)+kAvatarSize);
        
        if (height < kMinimumHeight) {
            height = kMinimumHeight;
        }
        
        return height;
    }
    else {
        return kMinimumHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.0;
}


#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",@"1");
}




#pragma private function

-(void)submitComment:(NSData*)messageContent : (UITableView*) tableView {

    //submit the comment
    [ServerEnd fetchJson:[ServerEnd setBaseUrl:@"submitCommentRestful.php"] :@{@"requestType":@"submitComment",@"userId":[NsUserDefaultModel getUserIDFromCurrentSession],@"imageID":self.setid,@"commentContent":messageContent,@"commentType":commentType,@"commentID":[SystemNSObject getCurrentTimeStamp]} onCompletion:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"success"] isEqualToString:@"true"]) {
            
            //prepare object and insert to tableview
            NSMutableDictionary* newRecord = [[NSMutableDictionary alloc] init];
            [newRecord setObject:messageContent forKey:@"comment_content"];
            [newRecord setObject:@"words" forKey:@"comment_type"];
            [newRecord setObject:[SystemNSObject getCurrentTimeStamp] forKey:@"comments_id"];
            [newRecord setObject:[NsUserDefaultModel getUserDictionaryFromSession][@"user_avatar"] forKey:@"user_avatar"];
            [newRecord setObject:[NsUserDefaultModel getUserIDFromCurrentSession] forKey:@"user_id"];
            
              [newRecord setObject:[SystemNSObject getCurrentCommentDate] forKey:@"comment_date"];

            self.comments = [self.comments mutableCopy];
            
            [self.tableView beginUpdates];
            
            [self.comments insertObject:newRecord atIndex:0];

           [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView endUpdates];
            
            [self.tableView slk_scrollToTopAnimated:YES];
        }
    }];
    
    
    
}


-(void)getComments{
    //get comment
    [ServerEnd fetchJson:[ServerEnd setBaseUrl:@"getCommentRestful.php"] :@{@"requestType":@"getComment",@"imageID":self.setid} onCompletion:^(NSDictionary *dictionary) {
        if ([dictionary[@"success"] isEqualToString:@"true"]) {
            NSLog(@"%@",dictionary);
            self.comments = dictionary[@"comments"];
            [self.tableView reloadData];
        }
    }];

}











@end
