//
//  AppDelegate.m
//  JSONAndXMLDemo
//
//  Created by Gabriel Theodoropoulos on 24/7/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "AppDelegate.h"

NSString *const kUsername = @"saucedoa7";

@implementation AppDelegate

+(void)downloadDataFromURL:(NSURL *)url withCompletionHandeler:(void (^)(NSData *))completionHandeler{
    //Instantiate a session configuation session
    NSURLSessionConfiguration *urlSessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //instantiate a session object
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:urlSessionConfig];
    
    //Create a data task object to perform the data downloading
    NSURLSessionDataTask *task = [urlSession dataTaskWithURL:url
                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                               if (error != nil) {
                                                   NSLog(@"%@", [error localizedDescription]); //Log error description
                                               } else {
                                                   NSInteger httpStatusCode = [(NSHTTPURLResponse *)response statusCode]; // Check Error code
                                                   
                                                   if (httpStatusCode != 200) {
                                                       NSLog(@"Http Status Code %ld", (long)httpStatusCode); //Display Code
                                                   }
                                                   // Call the comp handler w/ the returned data in the main thread
                                                   [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                       completionHandeler(data);
                                                   }];
                                               }
                                           }];
    //Resume task
    [task resume];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
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
