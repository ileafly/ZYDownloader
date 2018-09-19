//
//  ZYViewController.m
//  ZYDownloader
//
//  Created by luzhiyongGit on 09/13/2018.
//  Copyright (c) 2018 luzhiyongGit. All rights reserved.
//

#import "ZYViewController.h"
#import <ZYDownloader/ZYDownloader.h>

@interface ZYViewController ()<ZYDownloaderDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *processView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property(nonatomic, strong) ZYDownloadTask *task;

@end

@implementation ZYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[ZYDownloader sharedInstance] registerDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)startTask:(id)sender {
    // 创建task并添加到Downloader中 
    ZYDownloadTask *task = [ZYDownloadTask downloadTask:[NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"]];
    [[ZYDownloader sharedInstance] addTask:task];
    _task = task;
}

- (IBAction)pauseTask:(id)sender {
    [[ZYDownloader sharedInstance] pauseTask:_task];
}

- (IBAction)resumeTask:(id)sender {
    [[ZYDownloader sharedInstance] resumeTask:_task];
}

- (IBAction)cancelTask:(id)sender {
}

#pragma mark - ZYDownloaderDelegate

- (void)downloadTaskProgressDidChangeWithTask:(ZYDownloadTask *)task {
    _processView.progress = task.downloadProgress.fractionCompleted;
    _stateLabel.text = [NSString stringWithFormat:@"下载中: %f", task.downloadProgress.fractionCompleted];
}

- (void)downloadTaskDidPauseWithTask:(ZYDownloadTask *)task {
    
}


@end
