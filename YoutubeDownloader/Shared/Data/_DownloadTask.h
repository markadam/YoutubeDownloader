// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DownloadTask.h instead.

#import <CoreData/CoreData.h>


extern const struct DownloadTaskAttributes {
	__unsafe_unretained NSString *createDate;
	__unsafe_unretained NSString *downloadID;
	__unsafe_unretained NSString *downloadPageUrl;
	__unsafe_unretained NSString *downloadPriority;
	__unsafe_unretained NSString *downloadTaskStatus;
	__unsafe_unretained NSString *qualityType;
	__unsafe_unretained NSString *videoDescription;
	__unsafe_unretained NSString *videoImagePath;
	__unsafe_unretained NSString *videoImageUrl;
} DownloadTaskAttributes;

extern const struct DownloadTaskRelationships {
} DownloadTaskRelationships;

extern const struct DownloadTaskFetchedProperties {
} DownloadTaskFetchedProperties;












@interface DownloadTaskID : NSManagedObjectID {}
@end

@interface _DownloadTask : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DownloadTaskID*)objectID;





@property (nonatomic, strong) NSDate* createDate;



//- (BOOL)validateCreateDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* downloadID;



@property int32_t downloadIDValue;
- (int32_t)downloadIDValue;
- (void)setDownloadIDValue:(int32_t)value_;

//- (BOOL)validateDownloadID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* downloadPageUrl;



//- (BOOL)validateDownloadPageUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* downloadPriority;



@property int16_t downloadPriorityValue;
- (int16_t)downloadPriorityValue;
- (void)setDownloadPriorityValue:(int16_t)value_;

//- (BOOL)validateDownloadPriority:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* downloadTaskStatus;



@property int16_t downloadTaskStatusValue;
- (int16_t)downloadTaskStatusValue;
- (void)setDownloadTaskStatusValue:(int16_t)value_;

//- (BOOL)validateDownloadTaskStatus:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* qualityType;



//- (BOOL)validateQualityType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* videoDescription;



//- (BOOL)validateVideoDescription:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* videoImagePath;



//- (BOOL)validateVideoImagePath:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* videoImageUrl;



//- (BOOL)validateVideoImageUrl:(id*)value_ error:(NSError**)error_;






@end

@interface _DownloadTask (CoreDataGeneratedAccessors)

@end

@interface _DownloadTask (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreateDate;
- (void)setPrimitiveCreateDate:(NSDate*)value;




- (NSNumber*)primitiveDownloadID;
- (void)setPrimitiveDownloadID:(NSNumber*)value;

- (int32_t)primitiveDownloadIDValue;
- (void)setPrimitiveDownloadIDValue:(int32_t)value_;




- (NSString*)primitiveDownloadPageUrl;
- (void)setPrimitiveDownloadPageUrl:(NSString*)value;




- (NSNumber*)primitiveDownloadPriority;
- (void)setPrimitiveDownloadPriority:(NSNumber*)value;

- (int16_t)primitiveDownloadPriorityValue;
- (void)setPrimitiveDownloadPriorityValue:(int16_t)value_;




- (NSNumber*)primitiveDownloadTaskStatus;
- (void)setPrimitiveDownloadTaskStatus:(NSNumber*)value;

- (int16_t)primitiveDownloadTaskStatusValue;
- (void)setPrimitiveDownloadTaskStatusValue:(int16_t)value_;




- (NSString*)primitiveQualityType;
- (void)setPrimitiveQualityType:(NSString*)value;




- (NSString*)primitiveVideoDescription;
- (void)setPrimitiveVideoDescription:(NSString*)value;




- (NSString*)primitiveVideoImagePath;
- (void)setPrimitiveVideoImagePath:(NSString*)value;




- (NSString*)primitiveVideoImageUrl;
- (void)setPrimitiveVideoImageUrl:(NSString*)value;




@end
