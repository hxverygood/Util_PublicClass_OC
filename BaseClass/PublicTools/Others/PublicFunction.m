//
//  PublicFunction.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/9.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "PublicFunction.h"

@interface PublicFunction ()

@end



@implementation PublicFunction

#pragma mark - Getter

// 获得应用自定义名称
+ (NSString *)appDisplayName {
    NSString *displayName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    return displayName;
}

+ (NSString *)bundleName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

+ (NSString *)bundleID {
    return [[NSBundle mainBundle] bundleIdentifier];
}

// 获取App的版本号
+ (NSString *)appVersion {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    return [infoDic objectForKey:@"CFBundleShortVersionString"];
}





#pragma mark - 计算缓存
/**
 *  计算整个Cache目录大小
 */
+ (float)cacheFolderSize {
    NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];

    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) {
        return 0 ;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }

    return folderSize/( 1024.0 * 1024.0 );
}

/**
 *  计算单个文件大小
 */
+ (long long)fileSizeAtPath:(NSString *)filePath {

    NSFileManager *manager = [NSFileManager defaultManager];

    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0 ;

}


/// 清理Cache目录缓存
+ (void)clearCacheFolderWithCompletion:(void (^)(BOOL finished))completion {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask, YES) firstObject];
    NSArray *files = [[NSFileManager defaultManager ] subpathsAtPath:cachePath];
    //NSLog ( @"cachpath = %@" , cachePath);
    for (NSString *p in files) {

        NSError *error = nil;
        //获取文件全路径
        NSString *fileAbsolutePath = [cachePath stringByAppendingPathComponent:p];

        if ([[NSFileManager defaultManager] fileExistsAtPath:fileAbsolutePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:fileAbsolutePath error:&error];
        }
    }

    if (completion) {
        completion(YES);
    }
}


@end
