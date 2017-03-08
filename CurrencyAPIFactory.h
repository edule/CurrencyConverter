#import "APIInterface.h"
@interface CurrencyAPIFactory : NSObject
- (id<APIInterface>)generateCurrencyAPI:(int)apiType;
@end
