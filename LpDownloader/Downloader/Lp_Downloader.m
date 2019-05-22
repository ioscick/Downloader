//
//  Downloader.m
//  FMDBTest
//
//  Created by 沈立平 on 2019/5/21.
//  Copyright © 2019 沈立平. All rights reserved.
//

#import "Lp_Downloader.h"
#import "Lp_DownloaderOperation.h"

@interface Lp_Downloader ()

@property (strong, nonatomic) NSOperationQueue *downloadQueue;

@property (strong, nonatomic) NSMutableArray *downloadArray;

@end

@implementation Lp_Downloader

+ (instancetype)shareInstance {
    static Lp_Downloader *downloader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloader = [[Lp_Downloader alloc] init];
    });
    return downloader;
}

- (instancetype)init {
    if (self = [super init]) {
        self.downloadQueue = [NSOperationQueue new];
        self.downloadQueue.maxConcurrentOperationCount = 5;
        self.downloadQueue.name = @"com.ggj.downloader";
        self.downloadArray = [NSMutableArray arrayWithCapacity:3];
    }
    return self;
}

- (void)downloadUrls:(NSArray *)urls {
    @synchronized (self) {
        [self.downloadArray removeAllObjects];
    }
    dispatch_group_t group = dispatch_group_create();
    for (NSString *url in urls) {
        dispatch_group_enter(group);
        Lp_DownloaderOperation *operation = [[Lp_DownloaderOperation alloc] initWithUrl:url];
        [operation addHandlersForProgress:^(CGFloat progress) {
            
        } completed:^(NSURL * _Nonnull filePath, NSError * _Nonnull error) {
            if (!error) {
                @synchronized (self) {
                    NSLog(@"the downloadUrl is %@", filePath.path);
                    [self.downloadArray addObject:filePath.path];
                }
            }
            dispatch_group_leave(group);
        }];
        [self.downloadQueue addOperation:operation];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"the downloadArray is %@", self.downloadArray);
    });
}

- (void)cancelAllDownloads {
    [self.downloadQueue cancelAllOperations];
}


@end
