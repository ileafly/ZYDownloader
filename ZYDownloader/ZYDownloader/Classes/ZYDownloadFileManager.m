//
//  ZYDownloadFileManager.m
//  AFNetworking
//
//  Created by luzhiyong on 2018/9/17.
//

#import "ZYDownloadFileManager.h"

@implementation ZYDownloadFileManager

#pragma mark - Public Methods

/**
 创建默认下载路径 Documents/downloader
 
 @return 下载路径
 */
+ (NSString *)createDefaultPath {
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *downloadFolder = [documents stringByAppendingPathComponent:@"downloader"];
    [self handleDownloadFolder:downloadFolder];
    return downloadFolder;
}


/**
 处理下载文件夹
 - 确保文件夹存在
 - 为此文件夹设置备份属性，避免占用用户iCloud容量，不然会被拒的
 @param folder 文件路径
 */
+ (void)handleDownloadFolder:(NSString *)folder {
    BOOL isDir = NO;
    BOOL folderExist = [[NSFileManager defaultManager] fileExistsAtPath:folder isDirectory:&isDir];
    if (!folderExist || !isDir ) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
        NSURL *fileURL = [NSURL fileURLWithPath:folder];
        [fileURL setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:nil];
    }
}

@end
