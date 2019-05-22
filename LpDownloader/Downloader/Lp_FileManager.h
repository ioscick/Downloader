//
//  FileManager.h
//  FMDBTest
//
//  Created by 沈立平 on 2019/5/20.
//  Copyright © 2019 沈立平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Lp_FileManager : NSObject

+ (NSString *)downloadFilePathWithUrl:(NSString *)url;

+ (BOOL)fileIsDeskExistWithUrl:(NSString *)url;

@end

