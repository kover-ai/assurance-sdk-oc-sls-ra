// UIButton+SKNetworking.m
// Copyright (c) 2011–2016 Alamofire Software Foundation ( http://alamofire.org/ )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "UIButton+SKNetworking.h"

#import <objc/runtime.h>

#if TARGET_OS_IOS || TARGET_OS_TV

#import "UIImageView+SKNetworking.h"
#import "SKImageDownloader.h"

@interface UIButton (_SKNetworking)
@end

@implementation UIButton (_SKNetworking)

#pragma mark -

static char SKImageDownloadReceiptNormal;
static char SKImageDownloadReceiptHighlighted;
static char SKImageDownloadReceiptSelected;
static char SKImageDownloadReceiptDisabled;

static const char * SK_imageDownloadReceiptKeyForState(UIControlState state) {
    switch (state) {
        case UIControlStateHighlighted:
            return &SKImageDownloadReceiptHighlighted;
        case UIControlStateSelected:
            return &SKImageDownloadReceiptSelected;
        case UIControlStateDisabled:
            return &SKImageDownloadReceiptDisabled;
        case UIControlStateNormal:
        default:
            return &SKImageDownloadReceiptNormal;
    }
}

- (SKImageDownloadReceipt *)SK_imageDownloadReceiptForState:(UIControlState)state {
    return (SKImageDownloadReceipt *)objc_getAssociatedObject(self, SK_imageDownloadReceiptKeyForState(state));
}

- (void)SK_setImageDownloadReceipt:(SKImageDownloadReceipt *)imageDownloadReceipt
                           forState:(UIControlState)state
{
    objc_setAssociatedObject(self, SK_imageDownloadReceiptKeyForState(state), imageDownloadReceipt, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -

static char SKBackgroundImageDownloadReceiptNormal;
static char SKBackgroundImageDownloadReceiptHighlighted;
static char SKBackgroundImageDownloadReceiptSelected;
static char SKBackgroundImageDownloadReceiptDisabled;

static const char * SK_backgroundImageDownloadReceiptKeyForState(UIControlState state) {
    switch (state) {
        case UIControlStateHighlighted:
            return &SKBackgroundImageDownloadReceiptHighlighted;
        case UIControlStateSelected:
            return &SKBackgroundImageDownloadReceiptSelected;
        case UIControlStateDisabled:
            return &SKBackgroundImageDownloadReceiptDisabled;
        case UIControlStateNormal:
        default:
            return &SKBackgroundImageDownloadReceiptNormal;
    }
}

- (SKImageDownloadReceipt *)SK_backgroundImageDownloadReceiptForState:(UIControlState)state {
    return (SKImageDownloadReceipt *)objc_getAssociatedObject(self, SK_backgroundImageDownloadReceiptKeyForState(state));
}

- (void)SK_setBackgroundImageDownloadReceipt:(SKImageDownloadReceipt *)imageDownloadReceipt
                                     forState:(UIControlState)state
{
    objc_setAssociatedObject(self, SK_backgroundImageDownloadReceiptKeyForState(state), imageDownloadReceipt, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#pragma mark -

@implementation UIButton (SKNetworking)

+ (SKImageDownloader *)sharedImageDownloader {

    return objc_getAssociatedObject([UIButton class], @selector(sharedImageDownloader)) ?: [SKImageDownloader defaultInstance];
}

+ (void)setSharedImageDownloader:(SKImageDownloader *)imageDownloader {
    objc_setAssociatedObject([UIButton class], @selector(sharedImageDownloader), imageDownloader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -

- (void)setImageForState:(UIControlState)state
                 withURL:(NSURL *)url
{
    [self setImageForState:state withURL:url placeholderImage:nil];
}

- (void)setImageForState:(UIControlState)state
                 withURL:(NSURL *)url
        placeholderImage:(UIImage *)placeholderImage
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];

    [self setImageForState:state withURLRequest:request placeholderImage:placeholderImage success:nil failure:nil];
}

- (void)setImageForState:(UIControlState)state
          withURLRequest:(NSURLRequest *)urlRequest
        placeholderImage:(nullable UIImage *)placeholderImage
                 success:(nullable void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, UIImage *image))success
                 failure:(nullable void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error))failure
{
    if ([self isActiveTaskURLEqualToURLRequest:urlRequest forState:state]) {
        return;
    }

    [self cancelImageDownloadTaskForState:state];

    SKImageDownloader *downloader = [[self class] sharedImageDownloader];
    id <SKImageRequestCache> imageCache = downloader.imageCache;

    //Use the image from the image cache if it exists
    UIImage *cachedImage = [imageCache imageforRequest:urlRequest withAdditionalIdentifier:nil];
    if (cachedImage) {
        if (success) {
            success(urlRequest, nil, cachedImage);
        } else {
            [self setImage:cachedImage forState:state];
        }
        [self SK_setImageDownloadReceipt:nil forState:state];
    } else {
        if (placeholderImage) {
            [self setImage:placeholderImage forState:state];
        }

        __weak __typeof(self)weakSelf = self;
        NSUUID *downloadID = [NSUUID UUID];
        SKImageDownloadReceipt *receipt;
        receipt = [downloader
                   downloadImageForURLRequest:urlRequest
                   withReceiptID:downloadID
                   success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
                       __strong __typeof(weakSelf)strongSelf = weakSelf;
                       if ([[strongSelf SK_imageDownloadReceiptForState:state].receiptID isEqual:downloadID]) {
                           if (success) {
                               success(request, response, responseObject);
                           } else if (responseObject) {
                               [strongSelf setImage:responseObject forState:state];
                           }
                           [strongSelf SK_setImageDownloadReceipt:nil forState:state];
                       }

                   }
                   failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                       __strong __typeof(weakSelf)strongSelf = weakSelf;
                       if ([[strongSelf SK_imageDownloadReceiptForState:state].receiptID isEqual:downloadID]) {
                           if (failure) {
                               failure(request, response, error);
                           }
                           [strongSelf  SK_setImageDownloadReceipt:nil forState:state];
                       }
                   }];

        [self SK_setImageDownloadReceipt:receipt forState:state];
    }
}

#pragma mark -

- (void)setBackgroundImageForState:(UIControlState)state
                           withURL:(NSURL *)url
{
    [self setBackgroundImageForState:state withURL:url placeholderImage:nil];
}

- (void)setBackgroundImageForState:(UIControlState)state
                           withURL:(NSURL *)url
                  placeholderImage:(nullable UIImage *)placeholderImage
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];

    [self setBackgroundImageForState:state withURLRequest:request placeholderImage:placeholderImage success:nil failure:nil];
}

- (void)setBackgroundImageForState:(UIControlState)state
                    withURLRequest:(NSURLRequest *)urlRequest
                  placeholderImage:(nullable UIImage *)placeholderImage
                           success:(nullable void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, UIImage *image))success
                           failure:(nullable void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error))failure
{
    if ([self isActiveBackgroundTaskURLEqualToURLRequest:urlRequest forState:state]) {
        return;
    }

    [self cancelBackgroundImageDownloadTaskForState:state];

    SKImageDownloader *downloader = [[self class] sharedImageDownloader];
    id <SKImageRequestCache> imageCache = downloader.imageCache;

    //Use the image from the image cache if it exists
    UIImage *cachedImage = [imageCache imageforRequest:urlRequest withAdditionalIdentifier:nil];
    if (cachedImage) {
        if (success) {
            success(urlRequest, nil, cachedImage);
        } else {
            [self setBackgroundImage:cachedImage forState:state];
        }
        [self SK_setBackgroundImageDownloadReceipt:nil forState:state];
    } else {
        if (placeholderImage) {
            [self setBackgroundImage:placeholderImage forState:state];
        }

        __weak __typeof(self)weakSelf = self;
        NSUUID *downloadID = [NSUUID UUID];
        SKImageDownloadReceipt *receipt;
        receipt = [downloader
                   downloadImageForURLRequest:urlRequest
                   withReceiptID:downloadID
                   success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
                       __strong __typeof(weakSelf)strongSelf = weakSelf;
                       if ([[strongSelf SK_backgroundImageDownloadReceiptForState:state].receiptID isEqual:downloadID]) {
                           if (success) {
                               success(request, response, responseObject);
                           } else if (responseObject) {
                               [strongSelf setBackgroundImage:responseObject forState:state];
                           }
                           [strongSelf SK_setBackgroundImageDownloadReceipt:nil forState:state];
                       }

                   }
                   failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                       __strong __typeof(weakSelf)strongSelf = weakSelf;
                       if ([[strongSelf SK_backgroundImageDownloadReceiptForState:state].receiptID isEqual:downloadID]) {
                           if (failure) {
                               failure(request, response, error);
                           }
                           [strongSelf  SK_setBackgroundImageDownloadReceipt:nil forState:state];
                       }
                   }];

        [self SK_setBackgroundImageDownloadReceipt:receipt forState:state];
    }
}

#pragma mark -

- (void)cancelImageDownloadTaskForState:(UIControlState)state {
    SKImageDownloadReceipt *receipt = [self SK_imageDownloadReceiptForState:state];
    if (receipt != nil) {
        [[self.class sharedImageDownloader] cancelTaskForImageDownloadReceipt:receipt];
        [self SK_setImageDownloadReceipt:nil forState:state];
    }
}

- (void)cancelBackgroundImageDownloadTaskForState:(UIControlState)state {
    SKImageDownloadReceipt *receipt = [self SK_backgroundImageDownloadReceiptForState:state];
    if (receipt != nil) {
        [[self.class sharedImageDownloader] cancelTaskForImageDownloadReceipt:receipt];
        [self SK_setBackgroundImageDownloadReceipt:nil forState:state];
    }
}

- (BOOL)isActiveTaskURLEqualToURLRequest:(NSURLRequest *)urlRequest forState:(UIControlState)state {
    SKImageDownloadReceipt *receipt = [self SK_imageDownloadReceiptForState:state];
    return [receipt.task.originalRequest.URL.absoluteString isEqualToString:urlRequest.URL.absoluteString];
}

- (BOOL)isActiveBackgroundTaskURLEqualToURLRequest:(NSURLRequest *)urlRequest forState:(UIControlState)state {
    SKImageDownloadReceipt *receipt = [self SK_backgroundImageDownloadReceiptForState:state];
    return [receipt.task.originalRequest.URL.absoluteString isEqualToString:urlRequest.URL.absoluteString];
}


@end

#endif
