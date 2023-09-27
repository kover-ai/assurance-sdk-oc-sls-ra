//
//  SKAuthManager.m
//  SeelKit
//
//  Created by CP on 2022/11/1.
//

#import "SKAuthManager.h"
#import "SKIPAgent.h"

@implementation SKAuthManager
+(instancetype)shared
{
       static SKAuthManager * manager = nil;
       static dispatch_once_t onceToken;
       dispatch_once(&onceToken, ^{
           manager = [SKAuthManager new];
        });
       return manager;
}
- (void)setKey:(NSString *)key
{
    _key = key;
    if ([_key containsString:@"sk_dev"]) {
        [SKIPAgent shareInstance].IPType = SKIPServerTypeTest;
    } else if ([_key containsString:@"sk_prod"]) {
        [SKIPAgent shareInstance].IPType = SKIPServerTypeOfficialDistribution;
    }
}
- (void)setQuotePrice:(NSString *)quotePrice
{
    _quotePrice = quotePrice;
    if (self.delegate && [self.delegate respondsToSelector:@selector(returnQuotePrice:)]) {
        [self.delegate returnQuotePrice:_quotePrice];
    }
}
+ (NSString *)toJsonStrWithDictionary:(NSDictionary *)dict {
    if ([dict isKindOfClass:[NSString class]]) {
        return (NSString *)dict;
    }
    NSError *parseError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *jsonSrt = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (parseError) {
        jsonSrt = @"";
    }
    return jsonSrt;
}



@end
