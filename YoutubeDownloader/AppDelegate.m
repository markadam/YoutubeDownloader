//
//  AppDelegate.m
//  YoutubeDownloader
//
//  Created by HAO WANG on 10/31/13.
//  Copyright (c) 2013 HAO WANG. All rights reserved.
//

#import "AppDelegate.h"
#import "YDViewController.h"
#import "YDBaseNavigationViewController.h"
#import "YDSearchViewController.h"
#import "CoreData+MagicalRecord.h"
#import "Video.h"
#import "YDConstants.h"
#import "YDAnalyticManager.h"
#import "YDDownloadManager.h"
#import "YDIntroAnimationView.h"
#import "YDBaseViewController.h"
#import <AVFoundation/AVFoundation.h>

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupCoreDataStack];
    
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    application.applicationIconBadgeNumber = 0;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.internetConnectionReachability = [Reachability reachabilityForInternetConnection];
    [self.internetConnectionReachability startNotifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    YDSearchViewController *searchViewController = [[YDSearchViewController alloc] initWithNibName:@"YDSearchViewController" bundle:nil];
    YDBaseNavigationViewController *navigationController = [[YDBaseNavigationViewController alloc] initWithRootViewController:searchViewController];
    self.window.rootViewController = navigationController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    /*google analytics*/
    [self recordNewOrReturningUser];
    [[YDAnalyticManager sharedInstance]setUserType];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YDDownloadManager sharedInstance] initializeProcess];
        
        
        NSError *error = nil;
        BOOL success = [[AVAudioSession sharedInstance]
                        setCategory:AVAudioSessionCategoryPlayback
                        error:&error];
        if (!success) {
            // Handle error here, as appropriate
        }
    });
    
    // do an animation
    YDIntroAnimationView *introAnimationView = [[YDIntroAnimationView alloc]initWithFrame:searchViewController.view.frame];
    [introAnimationView presentOnView:searchViewController withCompletion:^{
        searchViewController.navigationController.navigationBarHidden = NO;
        searchViewController.webView.hidden = NO;
        [introAnimationView removeFromSuperview];
    }];
    searchViewController.navigationController.navigationBarHidden = YES;
    searchViewController.webView.hidden = YES;
    
    return YES;
}

//- (void)registerVideoDownloadNotification
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(receivedDownloadStatusNotification:)
//                                                 name:kDownloadTaskStatusChangeNotification
//                                               object:nil];
//}
//
//- (void)receivedDownloadStatusNotification: (NSNotification *)notification
//{
//    NSNumber *videoID = [notification.userInfo objectForKey:@"videoID"];
//    Video *video = [Video findByVideoID:videoID inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
//    DownloadTask *downloadTask = video.downloadTask;
//    BOOL downloadFinished = [downloadTask.downloadTaskStatus isEqualToNumber: @(DownloadTaskFinished)];
//    if (downloadFinished) {
//        
//    }
//}

- (void)recordNewOrReturningUser
{
    BOOL isReturningUser = [[NSUserDefaults standardUserDefaults]boolForKey:IS_RETURNING_USER_KEY];
    if (isReturningUser) {
        
    }else{
        // new user
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:IS_RETURNING_USER_KEY];
    }
}

- (void)generateDebugData
{
    NSManagedObjectContext *context  = [NSManagedObjectContext MR_contextForCurrentThread];
    Video *video1 = [Video createVideoWithContext:context];
    video1.videoTitle = @"iG vs Zenith - Game 3 (G1 League - Phase 3) [LOLDAGONS]";
    video1.videoImagePath = @"http://i1.ytimg.com/vi/d105E2sijd4/mqdefault.jpg";
    video1.duration = @(812);
    [video1 setIsRemovedValue:NO];
    video1.createDate = [NSDate date];
    
    Video *video2 = [Video createVideoWithContext:context];
    video2.videoTitle = @"Official LORD OF DARKNESS Trailer -- 2013";
    video2.videoImagePath = @"http://i1.ytimg.com/vi/HnemfnZc3sI/mqdefault.jpg";
    video2.duration = @(1231);
    [video2 setIsNewValue:YES];
    [video2 setIsRemovedValue:NO];
    video2.createDate = [NSDate date];
    
    Video *video3 = [Video createVideoWithContext:context];
    video3.videoTitle = @"How to Train Your Dragon 2 Trailer 2014 Movie Teaser - Official [HD]";
    video3.videoImagePath = @"http://i1.ytimg.com/vi/O_4IxOMfOds/mqdefault.jpg";
    video3.duration = @(522);
    [video3 setIsRemovedValue:NO];
    video3.createDate = [NSDate date];
    
    Video *video4 = [Video createVideoWithContext:context];
    video4.videoTitle = @"Kung Fu Panda - The Secret Museum of Kung Fu - Full HD";
    video4.videoImagePath = @"http://i1.ytimg.com/vi/sfdoLedAWWg/mqdefault.jpg";
    video4.duration = @(998);
    [video4 setIsRemovedValue:NO];
    video4.createDate = [NSDate date];
    
    Video *video5 = [Video createVideoWithContext:context];
    video5.videoTitle = @"Dragons: Gift of the Night fury";
    video5.videoImagePath = @"http://i1.ytimg.com/vi/A5y_jx3Gzoo/mqdefault.jpg";
    video5.duration = @(998);
    [video5 setIsRemovedValue:NO];
    video5.createDate = [NSDate date];
    
    [context MR_saveToPersistentStoreWithCompletion:nil];
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

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    [MagicalRecord cleanUp];
}

- (void)reachabilityChanged:(NSNotification *)note
{
    self.networkAvailable = [self.internetConnectionReachability currentReachabilityStatus] != NotReachable;
    
    if (self.networkAvailable)
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    else
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"YoutubeDownloader" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"YoutubeDownloader.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
    self.backgroundURLSessionCompletionHandler = completionHandler;
}

@end
