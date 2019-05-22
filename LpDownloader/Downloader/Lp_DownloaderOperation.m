//
//  DownLoaderOperation.m
//  FMDBTest
//
//  Created by 沈立平 on 2019/5/20.
//  Copyright © 2019 沈立平. All rights reserved.
//

#import "Lp_DownloaderOperation.h"
#import <AFNetworking.h>
#import "Lp_FileManager.h"

@interface Lp_DownloaderOperation ()

@property (strong, nonatomic) NSString *downloadUrl;

@property (strong, nonatomic) NSURLSessionDownloadTask *ownedTask;

@property (assign, nonatomic, getter = isExcuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;

@end

@implementation Lp_DownloaderOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

- (instancetype)initWithUrl:(NSString *)url {
    if (self = [super init]) {
        self.downloadUrl = url;
        self.finished = NO;
        self.executing = NO;
    }
    return self;
}

#pragma mark - public
- (void)addHandlersForProgress:(nullable DownloadProgressBlock)progress completed:(nullable CompletionHandler)completionHandler {
    self.progress = progress;
    self.completionHandler = completionHandler;
}

#pragma mark - reset
- (void)start {
    @synchronized (self) {
        if (self.isCancelled) {
            self.finished = YES;
            return;
        }
    }
    
    if ([Lp_FileManager fileIsDeskExistWithUrl:self.downloadUrl]) {
        self.completionHandler([NSURL fileURLWithPath:[Lp_FileManager downloadFilePathWithUrl:self.downloadUrl]], nil);
        self.finished = YES;
        return;
    }
    self.executing = YES;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.downloadUrl]];
    NSURLSessionDownloadTask *task = [[AFHTTPSessionManager manager] downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
        CGFloat p = (1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        if (self.progress) {
            self.progress(p);
        }
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [NSURL fileURLWithPath:[Lp_FileManager downloadFilePathWithUrl:self.downloadUrl]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        self.finished = YES;
        if (self.completionHandler) {
            self.completionHandler(filePath, error);
        }
    }];
    self.ownedTask = task;
    [task resume];
}

- (void)cancel {
    @synchronized (self) {
        if (self.isFinished) {
            return;
        }
        if (self.ownedTask) {
            [self.ownedTask cancel];
        }
        self.finished = YES;
        self.executing = NO;
    }
}


- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isConcurrent {
    return YES;
}

@end
