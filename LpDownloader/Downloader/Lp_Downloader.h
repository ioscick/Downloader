//
//  Downloader.h
//  FMDBTest
//
//  Created by 沈立平 on 2019/5/21.
//  Copyright © 2019 沈立平. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Lp_Downloader : NSObject

+ (instancetype)shareInstance;

- (void)downloadUrls:(NSArray *)urls;

@end

