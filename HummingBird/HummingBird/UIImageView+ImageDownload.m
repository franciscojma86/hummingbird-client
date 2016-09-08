//
//  UIImageView+ImageDownload.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/21/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "UIImageView+ImageDownload.h"
#import "NetworkingCallsHelper.h"
#import <objc/runtime.h>
#import "FMLogger.h"

@implementation UIImageView (ImageDownload)

- (NSURLSessionDataTask *)fm_imageDownloadTask {
    return objc_getAssociatedObject(self, @selector(fm_imageDownloadTask));
}

- (void)setFm_imageDownloadTask:(NSURLSessionDataTask *)newImageDownloadTask {
    objc_setAssociatedObject(self,
                             @selector(fm_imageDownloadTask),
                             newImageDownloadTask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)fm_setImageWithURL:(NSURL *)imageURL
                                 placeholder:(UIImage *)placeholder {
    if (!self.image) [self setImage:placeholder];
    
    if (self.fm_imageDownloadTask) [self.fm_imageDownloadTask cancel];
    self.fm_imageDownloadTask = [NetworkingCallsHelper downloadImageWithURL:imageURL
                                 success:^(UIImage *image) {
                                     [self setImage:image];
                                 } failure:^(NSString *errorMessage, BOOL cancelled, NSError *error) {
                                     if (!cancelled) {
                                         DLog(@"ERROR DOWNLOADING IMAGE %@\n%@",imageURL,errorMessage);
                                     }
                                 }];
}

@end
