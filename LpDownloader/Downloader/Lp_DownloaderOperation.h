//
//  DownLoaderOperation.h
//  FMDBTest
//
//  Created by 沈立平 on 2019/5/20.
//  Copyright © 2019 沈立平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DownloadProgressBlock)(CGFloat progress);
typedef void(^CompletionHandler)(NSURL *filePath, NSError * _Nullable error);

@interface Lp_DownloaderOperation : NSOperation

@property (copy, nonatomic) DownloadProgressBlock progress;
@property (copy, nonatomic) CompletionHandler completionHandler;

- (instancetype)initWithUrl:(NSString *)url;

- (void)addHandlersForProgress:(nullable DownloadProgressBlock)progress completed:(nullable CompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
