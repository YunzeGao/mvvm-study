//
//  AppDelegate.m
//  ios_mvvm
//
//  Created by Gao on 2022/7/11.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UIViewController *rootVC = [[ViewController alloc] init];
    UINavigationController *rootNC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    [self.window setRootViewController:rootNC];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
