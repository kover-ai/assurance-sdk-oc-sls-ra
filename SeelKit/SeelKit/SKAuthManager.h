//
//  SKAuthManager.h
//  SeelKit
//
//  Created by CP on 2022/11/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SKAuthManagerDelegate <NSObject>

@optional
- (void)returnQuotePrice:(NSString *)price;

@end

@interface SKAuthManager : NSObject
+(instancetype)shared;

@property (nonatomic, weak) id<SKAuthManagerDelegate> delegate;

@property (nonatomic, assign) BOOL initSuc;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *quoteId;
@property (nonatomic, copy) NSString *quotePrice;

+ (NSString *)toJsonStrWithDictionary:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
