//
//  UIImageView+ImageDownload.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/21/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ImageDownload)

@property (nonatomic,strong) NSURLSessionDataTask *fm_imageDownloadTask;

- (void)fm_setImageWithURL:(NSURL *)imageURL
               placeholder:(UIImage *)placeholder;
@end
