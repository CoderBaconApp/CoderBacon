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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    [_messageCollectionView scrollToBottom];
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
    return CGSizeMake(self.view.bounds.size.width, 35);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_messageTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (void)keyboardWillShow:(NSNotification *)notif {
    CGSize keyboardSize = [[[notif userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect rect = self.view.frame;
    CGRect messageEditFrame = _messageView.frame;
    
    messageEditFrame.origin.y -= keyboardSize.height;
    _messageView.frame = messageEditFrame;
}

- (void)keyboardWillHide:(NSNotification *)notif {
    CGRect frame = self.messageView.frame;
    frame.origin.y = self.view.frame.size.height - frame.size.height;
    self.messageView.frame = frame;
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
