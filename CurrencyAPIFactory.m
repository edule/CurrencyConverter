#import <Foundation/Foundation.h>
#import "CurrencyAPIFactory.h"
#import "FixerAPIClient.h"

@implementation CurrencyAPIFactory

- (id<APIInterface>)generateCurrencyAPI:(int)apiType {
    switch(apiType) {
       case FixerAPI:
            NSLog(@"Creating the FixerAPIClient.");
            return [FixerAPIClient new];
       //TODO: Create a new instances when the following methods are ready
       case GoogleAPI: 
            return nil;
       case YahooAPI:
            return nil;
       case CurrencyLayerAPI:
            return nil;
    }
    
    return nil;
}
@end
