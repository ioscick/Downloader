//
//  FileManager.m
//  FMDBTest
//
//  Created by 沈立平 on 2019/5/20.
//  Copyright © 2019 沈立平. All rights reserved.
//

#import "Lp_FileManager.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Lp_FileManager

#pragma mark - public
+ (NSString *)downloadFilePathWithUrl:(NSString *)url {
    NSString *fileName = [self md5:url];
    NSString *path = [NSString stringWithFormat:@"%@/downloadFile", [self getDocumentPath]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [path stringByAppendingPathComponent:fileName];
}

+ (BOOL)fileIsDeskExistWithUrl:(NSString *)url {
    NSString *path = [self downloadFilePathWithUrl:url];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

#pragma mark - private
+ (NSString *)getDocumentPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    NSString *documents = [paths objectAtIndex:0];
    return documents;
}


+ (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
