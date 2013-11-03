//
//  ViewController.m
//  Bromance
//
//  Created by Justin Steffen on 10/26/13.
//  Copyright (c) 2013 Pamela Ocampo. All rights reserved.
//

#import "MessageSentCell.h"
#import "MessageDetailViewController.h"
#import "Message.h"
#import "THSpringyFlowLayout.h"
#import "UIScrollView+ScrollPositions.h"
#import "MessageViewController.h"

#define MESSAGE_SENT_CELL @"MessageSentCell"
#define MESSAGE_RECEIVED_CELL @"MessageReceivedCell"

#define COLLECTION_VIEW_PADDING 10

@interface MessageDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;

- (IBAction)collectionTapGesture:(id)sender;
- (IBAction)sendMessageTouch:(id)sender;

@end

@implementation MessageDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UINib *sentCell = [UINib nibWithNibName:MESSAGE_SENT_CELL bundle:nil];
    [self.messageCollectionView registerNib:sentCell forCellWithReuseIdentifier:MESSAGE_SENT_CELL];
    
    UINib *receiverCell = [UINib nibWithNibName:MESSAGE_RECEIVED_CELL bundle:nil];
    [self.messageCollectionView registerNib:receiverCell forCellWithReuseIdentifier:MESSAGE_RECEIVED_CELL];
    
    UIEdgeInsets contentInsets = self.messageCollectionView.contentInset;
    
    contentInsets.top += COLLECTION_VIEW_PADDING;
    contentInsets.bottom = _messageView.frame.size.height + COLLECTION_VIEW_PADDING;
    
    self.messageCollectionView.contentInset = contentInsets;
    self.messageCollectionView.scrollIndicatorInsets = contentInsets;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.messageCollectionView scrollToBottom];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource & Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _messages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Message *msg = _messages[indexPath.row];
    NSString *type = ([msg.receiver.objectId isEqualToString:[PFUser currentUser].objectId] ? MESSAGE_RECEIVED_CELL : MESSAGE_SENT_CELL);
    MessageSentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:type forIndexPath:indexPath];
    
    cell.messageLabel.text = msg.text;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Message *msg = _messages[indexPath.row];
    CGSize size = [msg.text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:12] constrainedToSize:CGSizeMake(200, 300.f) lineBreakMode:NSLineBreakByWordWrapping];
        
    return CGSizeMake(self.view.bounds.size.width, 12 + size.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,0,0,0);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_messageTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (void)keyboardWillShow:(NSNotification *)notif {
    CGSize keyboardSize = [[[notif userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect messageEditFrame = _messageView.frame;
    messageEditFrame.origin.y -= keyboardSize.height;
    
    UIEdgeInsets contentInsets = self.messageCollectionView.contentInset;
    
    contentInsets.bottom += keyboardSize.height;
    
    self.messageCollectionView.contentInset = contentInsets;
    self.messageCollectionView.scrollIndicatorInsets = contentInsets;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _messageView.frame = messageEditFrame;
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    CGSize keyboardSize = [[[notif userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect frame = self.messageView.frame;
    frame.origin.y = self.view.frame.size.height - frame.size.height;
    
    UIEdgeInsets contentInsets = self.messageCollectionView.contentInset;
    
    contentInsets.bottom -= keyboardSize.height;
    
    self.messageCollectionView.contentInset = contentInsets;
    self.messageCollectionView.scrollIndicatorInsets = contentInsets;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _messageView.frame = frame;
    } completion:nil];
}

- (IBAction)collectionTapGesture:(id)sender {
    [_messageTextField resignFirstResponder];
}

- (void)updateMessages {
    [Message allMessagesBetweenUser:_otherUser
                     withCompletion:^(NSArray *messages, NSError *error) {
                         _messages = messages;
                         [self.messageCollectionView reloadData];
                         [self.messageCollectionView scrollToBottom];
    }];
}

- (IBAction)sendMessageTouch:(id)sender {
    Message *messageNew = [[Message alloc] initWithText:_messageTextField.text andReceiver:_otherUser];
    
    [[messageNew toPFObject] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error sending message" message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
            [alert show];
        }
        else {
            [self updateMessages];
        }
    }];
    
    [_messageTextField resignFirstResponder];
    _messageTextField.text = @"";
}
@end
