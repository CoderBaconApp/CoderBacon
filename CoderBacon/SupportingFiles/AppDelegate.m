//  AppDelegate.m
//
//  Copyright (C) 2013 CoderBacon
//
//  Licensed under Creative Commons BY-NC-SA
//  http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

#import "AppDelegate.h"
#import "CBAMessage.h"
#define USER @"user"
#import <AFNetworking.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"Hello world!");
    [self test];
    
    return YES;
}

- (void)test {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //NSURLCredential *credential = [NSURLCredential credentialWithUser:@"user" password:@"passwd" persistence:NSURLCredentialPersistenceNone];
    NSURLCredential *credential = [NSURLCredential credentialWithUser:@"justindsn@gmail.com" password:@"password" persistence:NSURLCredentialPersistenceNone];
    
    //NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:@"https://httpbin.org/basic-auth/user/passwd" parameters:nil];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:@"http://localhost:3000/messages.json" parameters:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCredential:credential];
    [operation setResponseSerializer:[AFJSONResponseSerializer alloc]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
    }];
    [manager.operationQueue addOperation:operation];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
