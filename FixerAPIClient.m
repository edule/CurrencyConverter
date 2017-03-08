
#import "FixerAPIClient.h"

@interface FixerAPIClient()
@property (atomic, assign) BOOL runLoopThreadDidFinishFlag;
@end

@implementation FixerAPIClient

    static const NSString* kUrl = @"http://api.fixer.io/latest";

    NSMutableData* responseData; 
    
-(id) init {
    self = [super init];
    NSLog(@"FixerAPIClient init");
    if(self) {
        responseData = nil;
        self.runLoopThreadDidFinishFlag = NO;
    }
    
    return self;
}
    
- (void)exchangeRateFrom:(NSString*)from to:(NSString*)to 
                         success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField: @"Accept"];
    
    NSString* fullURL = [NSString stringWithFormat:@"%@?base=%@", kUrl, from];
    [request setURL:[NSURL URLWithString:fullURL]];
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    NSLog(@"Connection Created %@", request);
    
    while (!self.runLoopThreadDidFinishFlag) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    if ([responseData length] == 0) {
        NSLog(@"Response is empty"); 
        failure(@"Response is empty"); 
    }
    else {
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                             options: NSJSONReadingMutableContainers error: &error];
        float rate = [self getRateFromJSON:json to:to];
        NSLog(@"Rate = %f", rate);
        if(rate == -1) {
            failure(@"Exchange rates do not exist in JSON."); 
        }
        else if (rate == 0.f) {
            NSString* errorDescription = [NSString stringWithFormat:@"Exchange currency \"%@\" does not exist in JSON.", to];
            failure(errorDescription);
        }
        else{        
            success(rate);
        }                                
    }
    responseData = nil;
    //A new operation queue
    /*NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // Async connection and response handling method
    [NSURLConnection sendAsynchronousRequest:request
         queue:queue
         completionHandler:^(NSURLResponse *response, NSData *data,  NSError *error) {
             if([data length] > 0 && error == nil) {
                // parse json response 
                // and retrieve related exchange rate
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &error];
                float rate = [self getRateFromJSON:json to:to]; 
                if(rate == -1) {
                    failure(@"Exchange rate does not exist in JSON.");
                }
                else {
                    success(rate);
                }
                
             }
             else if ([data length] == 0 && error == nil){
                 NSLog(@"Response is empty"); 
                 failure(@"Response is empty"); 
             }
             else if (error) {
                 NSLog(@"Not again, what is the error = %@", error);
                 failure([error localizedDescription]);
             }
         }];
    */
    
    /*NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData* data, NSURLResponse *response, NSError* error) {
        if(error) {
            NSLog(@"Not again, what is the error = %@", error);
            failure([error localizedDescription]);
        }
        else {
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &error];
            float rate = [self getRateFromJSON:json to:to];
            if(rate == -1) {
                failure(@"Exchange rate does not exist in JSON.");
            }
            else {
                success(rate);
            }
        }
        
    }] resume];
    */
    
}

- (float)getRateFromJSON:(NSDictionary*)json to:(NSString*)to {
    if (!json) {
        return -1.f;
    }
    
    NSDictionary* rates = json[@"rates"];
    if(rates != nil) 
    {
        NSString* uppercaseTo = [to uppercaseString];
        if(rates[uppercaseTo]) {
            return [rates[uppercaseTo] floatValue];
        }
        return 0.f;
           
    }  
    return -1.f;
}

#pragma mark - NSURLConnectionDelegate methods
- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)redirectResponse {
    NSLog(@"willSendRequest");
    return request;
}

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"Connection Received response ");
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data {
    NSLog(@"Connection Received Data ");
    [responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Finished Loading!"); 
    
    self.runLoopThreadDidFinishFlag = YES;
            
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed: %@", [error description]);
    
    self.runLoopThreadDidFinishFlag = YES;
}



/*
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received
     NSLog(@"Connection Received response ");
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"Connection Received Data ");
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
        //Getting your response string
    NSLog(@"Finished Loading!");
    responseData = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ExchangeRateResponseNotification"
                                                    object:self
                                                  userInfo:nil];
    }
    */
@end
