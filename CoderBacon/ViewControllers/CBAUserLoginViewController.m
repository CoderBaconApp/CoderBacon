//
//  CBAUserLoginViewController.m
//  CoderBacon
//
//  Created by Justin Steffen on 2/25/14.
//
//

#import "CBAUserLoginViewController.h"
#import <AFNetworking.h>

@interface CBAUserLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation CBAUserLoginViewController
- (IBAction)loginUser {
    NSString *email = self.emailField.text;
    NSString *password = self.passwordField.text;
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:email
                                                             password:password
                                                          persistence:NSURLCredentialPersistencePermanent];
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:3000"];
    
    NSString *host = url.host;
    NSNumber *port = url.port;
    NSString *protocol = NSURLProtectionSpaceHTTP;
    NSString *realm = @"Application";
    NSString *authenticationMethod = NSURLAuthenticationMethodHTTPBasic;
    
    NSURLProtectionSpace *protectionSpace = [[NSURLProtectionSpace alloc]
                                             initWithHost:host
                                                     port:[port integerValue]
                                                 protocol:protocol
                                                    realm:realm
                                             authenticationMethod:authenticationMethod];
    
    
    [[NSURLCredentialStorage sharedCredentialStorage] setCredential:credential
                                                 forProtectionSpace:protectionSpace];
    
    [self test];
    
}

- (void)test {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //NSString *url = @"https://coderbacon.herokuapp.com/messages.json";
    NSString *url = @"http://localhost:3000/messages.json";
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:url parameters:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setResponseSerializer:[AFJSONResponseSerializer alloc]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
    }];
    [manager.operationQueue addOperation:operation];
}

@end
