//
//  AppDelegate.m
//  SocketIOSample
//
//  Created by hirai.yuki on 2013/01/24.
//  Copyright (c) 2013年 hirai.yuki. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationWillResignActive" object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidBecomeActive" object:nil];
}

@end
