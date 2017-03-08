#import <Foundation/Foundation.h>

enum {
    FixerAPI = 1,
    GoogleAPI,
    YahooAPI, 
    CurrencyLayerAPI,
};

typedef void(^SuccessBlock)(float);
typedef void (^FailureBlock)(NSString*);

@protocol APIInterface
- (void)exchangeRateFrom:(NSString*)from to:(NSString*)to success:(SuccessBlock)success failure:(FailureBlock)failure;
@end
