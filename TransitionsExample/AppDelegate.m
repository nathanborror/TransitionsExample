//
//  AppDelegate.m
//  TransitionsExample
//
//  Created by Nathan Borror on 4/27/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  MasterViewController *viewController = [[MasterViewController alloc] init];
  [_window setRootViewController:viewController];

  [_window setBackgroundColor:[UIColor whiteColor]];
  [_window makeKeyAndVisible];
  return YES;
}

@end
