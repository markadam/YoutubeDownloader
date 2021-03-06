#import "_DownloadTask.h"
#import "CoreData+MagicalRecord.h"

typedef enum
{
    DownloadTaskSTATUSNone,
    DownloadTaskWaiting,
    DownloadTaskDownloading,
    DownloadTaskFailed,
    DownloadTaskFinished,
    DownloadTaskPaused
}DownloadTaskStatus;

#define DOWNLOAD_TASK_DEFAULT_PRIORITY @(100)

@interface DownloadTask : _DownloadTask {}
// Custom logic goes here.

+ (DownloadTask *)createDownloadTaskInContext:(NSManagedObjectContext *)context;
+ (DownloadTask*)findByDownloadID:(NSNumber*)downloadID inContext:(NSManagedObjectContext *)context;
+ (DownloadTask*)findVideoInfoNotDownloadTaskWithContext:(NSManagedObjectContext *)context;
+ (DownloadTask*)findByDownloadPageUrl:(NSString*)downloadPageUrl qualityType:(NSString*)qualityType  inContext:(NSManagedObjectContext *)context;
+ (DownloadTask*)getDownloadingTaskInContext:(NSManagedObjectContext *)context;
- (void)updateWithContext:(NSManagedObjectContext *)context completion:(MRSaveCompletionHandler)completion;
+ (DownloadTask*)getWaitingDownloadTaskInContext:(NSManagedObjectContext *)context;
+ (NSArray*)getRemovedTasksWithContext:(NSManagedObjectContext *)context;
+ (NSNumber*)getTotalVideoSizeWithContext:(NSManagedObjectContext *)context;
+ (DownloadTask*)getDownloadingTaskWithDownloadUrl:(NSString*)downloadUrl inContext:(NSManagedObjectContext *)context;
+ (NSArray*)getAllWaitingOrDownloadingTasksInContext:(NSManagedObjectContext *)context;
- (void)updateWithContext:(NSManagedObjectContext *)context;
+ (NSArray*)getAllWaitingTasksInContext:(NSManagedObjectContext *)context;
+ (NSString*)getDestinationPathWithDownloadUrl:(NSString*)downloadUrl;
@end
