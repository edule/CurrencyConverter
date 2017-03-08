#import "APIInterface.h"

@interface ExchangeCalculator: NSObject 

-(void)convertCurrency:(NSString*)from to:(NSString*)to amount:(float)amount success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
