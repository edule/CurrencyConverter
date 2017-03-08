#import <Foundation/Foundation.h>
#import "APIInterface.h"
#import "ExchangeCalculator.h"
#import "CurrencyAPIFactory.h"


@implementation ExchangeCalculator
id<APIInterface> currencyAPI;
//FixerAPIClient* currencyAPI;
    
-(id) init {
    self = [super init];
    if(self) {
        NSLog(@"ExchangeCalculator init");
        currencyAPI = [[CurrencyAPIFactory new] generateCurrencyAPI:FixerAPI];
        
    }
    
    return self;
}

-(void) dealloc {
}

- (void)convertCurrency:(NSString*)from to:(NSString*)to amount:(float)amount 
                        success:(SuccessBlock)success failure:(FailureBlock)failure {
    [currencyAPI exchangeRateFrom:from to:to success:^(float rate) {
        // convert the amount of the currency using the exchange rate
        float result = [self calculateExchangeValue:amount rate:rate];
        success(result);
    } 
    failure:^(NSString* reason) {
        failure(reason);
    }];
    
    //[currencyAPI exchangeRateFrom:from to:to];
}

- (float)calculateExchangeValue:(float)amount rate:(float)exchangeRate {
    return amount*exchangeRate;
}
@end
