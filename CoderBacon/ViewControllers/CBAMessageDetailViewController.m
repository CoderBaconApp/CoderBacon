//  MessageDetailViewController.m
//
//  Copyright (C) 2013 CoderBacon
//
//  Licensed under Creative Commons BY-NC-SA
//  http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

#import "CBAMessageSentCell.h"
#import "CBAMessageDetailViewController.h"
#import "CBAMessage.h"
#import "UIScrollView+ScrollPositions.h"
#import "CBAMessageViewController.h"

#define MESSAGE_SENT_CELL @"CBAMessageSentCell"
#define MESSAGE_RECEIVED_CELL @"CBAMessageReceivedCell"

#define COLLECTION_VIEW_PADDING 10

@interface CBAMessageDetailViewController () {
    CBAMessageSentCell *mss;
}

@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;

- (IBAction)collectionTapGesture:(id)sender;
- (IBAction)sendMessageTouch:(id)sender;

@end

@implementation CBAMessageDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
        mss = [[CBAMessageSentCell alloc] init];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messageNotificationReceived:)
                                                 name:@"message"
                                               object:nil];
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

- (void)dealloc {
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

//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    CBAMessage *msg = _messages[indexPath.row];
//    NSString *type = ([msg.receiver.objectId isEqualToString:[PFUser currentUser].objectId] ? MESSAGE_RECEIVED_CELL : MESSAGE_SENT_CELL);
//    CBAMessageSentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:type forIndexPath:indexPath];
//    
//    cell.messageLabel.text = msg.text;
//    
//    return cell;
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CBAMessage *msg = _messages[indexPath.row];

    CGSize size = [msg.text boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:12.0f],NSFontAttributeName, nil] context:nil].size;
    
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
        [_messageCollectionView scrollToBottom];
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
//    [CBAMessage allMessagesBetweenUser:_otherUser
//                     withCompletion:^(NSArray *messages, NSError *error) {
//                         _messages = messages;
//                         [self.messageCollectionView reloadData];
//                         [self.messageCollectionView scrollToBottom];
//    }];
}

- (IBAction)sendMessageTouch:(id)sender {
    CBAMessage *messageNew = [[CBAMessage alloc] initWithText:_messageTextField.text andReceiver:_otherUser];
    
//    [[messageNew toPFObject] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (error) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error sending message" message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        
//            [alert show];
//        }
//        else {
//            [self updateMessages];
//        }
//    }];
    
    [_messageTextField resignFirstResponder];
    _messageTextField.text = @"";
}

- (void) messageNotificationReceived:(NSNotification *) notification
{
    NSString *senderId = notification.userInfo[@"senderId"];
    if ([senderId isEqualToString:self.otherUser.objectId]) {
        [self updateMessages];
    }
    
}
@end
