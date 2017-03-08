#import <Foundation/Foundation.h>
//#import <dispatch/dispatch.h>
#import "APIInterface.h"
#import "ExchangeCalculator.h"

int main(int argc, const char* argv[]) {
    
    if(argc < 4) {
        NSLog(@"Invalid Arguments!\nSample arguments: \"./currency 5 usd cad\"");
        return -1;
    }
    
    
    int amount = atoi(argv[1]);
    NSString* fromCurrency = [NSString  stringWithUTF8String:argv[2]];
    NSString* toCurrency = [NSString  stringWithUTF8String:argv[3]];
    
    NSLog(@"Arguments successfully read: %d, %@, %@",\
                     amount, fromCurrency, toCurrency);
                     
    [[ExchangeCalculator new] convertCurrency:fromCurrency to:toCurrency amount:amount success:^(float convertedAmount) {
            NSLog(@"\n%d %@ = %f of %@", amount, fromCurrency, convertedAmount, toCurrency);
               
        } failure:^(NSString* reason) {
            NSLog(@"The request failed with reason -> %@", reason);
            
        }];

    return 0;
}
