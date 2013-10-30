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

#define MESSAGE_SENT_CELL @"MessageSentCell"
#define MESSAGE_RECEIVED_CELL @"MessageReceivedCell"

@interface MessageDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;

- (IBAction)collectionTapGesture:(id)sender;

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
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

- (NSInteger)collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.bounds.size.width, 35);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_messageTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (void)keyboardWillShow:(NSNotification *)notif {
    CGSize keyboardSize = [[[notif userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect messageEditFrame = _messageView.frame;
    
    messageEditFrame.origin.y -= keyboardSize.height;
    _messageView.frame = messageEditFrame;
}

- (void)keyboardWillHide:(NSNotification *)notif {
    CGRect frame = self.messageView.frame;
    frame.origin.y -= self.view.frame.size.height - frame.size.height;
    self.messageView.frame = frame;
}

- (IBAction)collectionTapGesture:(id)sender {
    [_messageTextField resignFirstResponder];
}
@end
