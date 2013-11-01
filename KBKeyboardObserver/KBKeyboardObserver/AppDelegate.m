//
//  AppDelegate.m
//  KBKeyboardObserver
//
//  Created by Kamil Borzym on 15.10.2013.
//  Copyright (c) 2013 Killer Ball. All rights reserved.
//

#import "AppDelegate.h"
#import "ExampleViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[ExampleViewController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
