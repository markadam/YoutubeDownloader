#import "DownloadTask.h"


@interface DownloadTask ()

// Private interface goes here.

@end


@implementation DownloadTask

+ (NSInteger)maxDownloadID:(NSManagedObjectContext*)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DownloadTask"];
    fetchRequest.fetchLimit = 1;
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"downloadID" ascending:NO]];
    NSError *error = nil;
    DownloadTask *downloadTask = [context executeFetchRequest:fetchRequest error:&error].lastObject;
    if (downloadTask != nil)
    {
        return [downloadTask.downloadID integerValue];
    }
    return 0;
}

// Custom logic goes here.
+ (DownloadTask *)createDownloadTaskInContext:(NSManagedObjectContext *)context
{
    // Get the local context
    @synchronized(self)
    {
        NSInteger downloadID = [DownloadTask maxDownloadID:context];
        downloadID++;
        DownloadTask *downloadTask = [DownloadTask MR_createInContext:context];
        downloadTask.downloadID = @(downloadID);
        downloadTask.createDate = [NSDate date];
        downloadTask.downloadTaskStatus = @(DownloadTaskSTATUSNone);
        // Save the modification in the local context
        [context MR_saveToPersistentStoreAndWait];
        return downloadTask;
    }
}

+ (DownloadTask*)findByDownloadID:(NSNumber*)downloadID inContext:(NSManagedObjectContext *)context
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloadID == %@",downloadID];
    return  [DownloadTask MR_findFirstWithPredicate:predicate inContext:context];
}

+ (DownloadTask*)getDownloadingTaskInContext:(NSManagedObjectContext *)context
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloadTaskStatus = %d and video.isRemoved == 0",DownloadTaskDownloading];
    
    return  [DownloadTask MR_findFirstWithPredicate:predicate sortedBy:@"downloadPriority,createDate" ascending:YES inContext:context];
}

+ (DownloadTask*)getWaitingDownloadTaskInContext:(NSManagedObjectContext *)context
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloadTaskStatus = %d and  video.isRemoved == 0 and videoFileSize > 0",DownloadTaskWaiting];
    
    return  [DownloadTask MR_findFirstWithPredicate:predicate sortedBy:@"downloadPriority,createDate" ascending:YES inContext:context];
}

+ (NSArray*)getAllWaitingOrDownloadingTasksInContext:(NSManagedObjectContext *)context
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloadTaskStatus in %@ and video.isRemoved == 0 and videoFileSize > 0",@[@(DownloadTaskWaiting),@(DownloadTaskDownloading)]];
    return  [DownloadTask MR_findAllWithPredicate:predicate inContext:context];
}

+ (NSArray*)getAllWaitingTasksInContext:(NSManagedObjectContext *)context
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloadTaskStatus = %d and video.isRemoved == 0 and videoFileSize > 0",DownloadTaskWaiting];
    return  [DownloadTask MR_findAllWithPredicate:predicate inContext:context];
}


+ (DownloadTask*)findByDownloadPageUrl:(NSString*)downloadPageUrl qualityType:(NSString*)qualityType  inContext:(NSManagedObjectContext *)context
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloadPageUrl = %@ and qualityType = %@",downloadPageUrl,qualityType];
    
    return  [DownloadTask MR_findFirstWithPredicate:predicate inContext:context];
}

+ (DownloadTask*)findVideoInfoNotDownloadTaskWithContext:(NSManagedObjectContext *)context
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(videoFileSize = 0 or videoFileSize = NULL or videoImagePath == NULL) and video.isRemoved == 0 and downloadTaskStatus != %d",DownloadTaskFailed];
    
    return  [DownloadTask MR_findFirstWithPredicate:predicate inContext:context];
}

- (void)updateWithContext:(NSManagedObjectContext *)context completion:(MRSaveCompletionHandler)completion
{
    [context MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (completion)
        {
            completion(success, error);
        }
    }];
}

- (void)updateWithContext:(NSManagedObjectContext *)context
{
    [context MR_saveToPersistentStoreAndWait];
}

+ (NSArray*)getRemovedTasksWithContext:(NSManagedObjectContext *)context
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"video.isRemoved == 1",DownloadTaskWaiting];
    
    return  [DownloadTask MR_findAllWithPredicate:predicate inContext:context];
}

+ (NSNumber*)getTotalVideoSizeWithContext:(NSManagedObjectContext *)context
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"downloadTaskStatus = %d",DownloadTaskFinished];
    
    return  [DownloadTask MR_aggregateOperation:@"sum:" onAttribute:@"videoFileSize" withPredicate:predicate];
}

+ (DownloadTask*)getDownloadingTaskWithDownloadUrl:(NSString*)downloadUrl inContext:(NSManagedObjectContext *)context
{
    if (!downloadUrl) {
        return nil;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"videoDownloadUrl = %@",downloadUrl];
    
    return  [DownloadTask MR_findFirstWithPredicate:predicate inContext:context];
}


+ (NSString*)getDestinationPathWithDownloadUrl:(NSString*)downloadUrl
{
    if (!downloadUrl) {
        return nil;
    }
    NSManagedObjectContext *privateQueueContext = [NSManagedObjectContext MR_contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"videoDownloadUrl = %@",downloadUrl];
    DownloadTask *downloadTask = [DownloadTask MR_findFirstWithPredicate:predicate inContext:privateQueueContext];
    if (!downloadTask) {
        return nil;
    }
    return downloadTask.videoFilePath;
}


@end
