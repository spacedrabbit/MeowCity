//
//  AppDelegate.m
//  BarkCity
//
//  Created by Rosa McGee on 11/24/14.
//  Copyright (c) 2014 com.rosamcgee. All rights reserved.
//

#import "AppDelegate.h"
#import "BRKHomeViewController.h"
#import "BRKUIManager.h"

@interface AppDelegate () <PKRevealing>

#pragma mark - Properties
@property (nonatomic, strong, readwrite) PKRevealController *revealController;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [Parse setApplicationId:@"ectwGYNTEmjRYLV28j81qdTElHyt98jiq3WWjWRO"
                  clientKey:@"hGtJ9IBGaI7auYteKjm6lynoLoB4KUhFmbwAOzTo"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    BRKHomeViewController * rootViewController = [[BRKHomeViewController alloc] init];
    UINavigationController * navControl = [[UINavigationController alloc] initWithRootViewController:rootViewController ];
    
    UIViewController *leftViewController = [[UIViewController alloc] init];
    leftViewController.view.backgroundColor = [UIColor blueColor];
    
    self.revealController = [PKRevealController revealControllerWithFrontViewController:navControl leftViewController:leftViewController];
    self.revealController.delegate = self;
    self.revealController.animationDuration = 0.25;
    
    self.window.rootViewController = self.revealController;
    
    
//    navControl.navigationBar.topItem.title = @"Bark City";
//    [navControl.navigationBar setTitleTextAttributes:[BRKUIManager navBarAttributes]];
//    self.window.rootViewController = navControl;

    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
