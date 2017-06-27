#import "RBTFetchDataAPI.h"
#import "RBTCountry.h"

NSString *const RBTFetchDataErrorDomain = @"RBTFetchDataErrorDomain";

@interface RBTFetchDataAPI ()
@property (strong, nonatomic) NSArray *fetchedCountries;
@end

@implementation RBTFetchDataAPI

- (NSURL *)serverUrl
{
    NSString *urlString = @"https://restcountries.eu/rest/v2/all";
    NSURL *dataUrl = [NSURL URLWithString:urlString];
    return dataUrl;
}

- (void)fetchCountryJson:(RBTDataCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[self serverUrl]
                                                             completionHandler:^(NSData *data,
                                                                                 NSURLResponse *response,
                                                                                 NSError *error)
                                  {
                                      NSLog(@"URL response: %@",response);
                                      NSLog(@"response data: %@",data);
                                      NSDictionary *errorInfo = nil;
                                      if (!error) {
                                          // Success
                                          if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                              dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                  [weakSelf parseJsonResponse:data completion:completion];
                                              });
                                              
                                          }  else {
                                              // Server error
                                              NSLog(@"error : %@", error.description);
                                              errorInfo = error ? @{NSUnderlyingErrorKey: error} : nil;
                                              completion(NO, [NSError errorWithDomain:RBTFetchDataErrorDomain
                                                                                 code:RBTFetchDataErrorCodeServerError
                                                                             userInfo:errorInfo]);
                                          }
                                      } else {
                                          // Response failed
                                          NSLog(@"error : %@", error.description);
                                          errorInfo = error ? @{NSUnderlyingErrorKey: error} : nil;
                                          completion(NO, [NSError errorWithDomain:RBTFetchDataErrorDomain
                                                                             code:RBTFetchDataErrorCodeNetworkError
                                                                         userInfo:errorInfo]);
                                      }
                                  }];
    [task resume];
}

-(void)parseJsonResponse:(NSData*)data completion:(RBTDataCompletion)completion
{
    NSError *error;
    NSArray<NSDictionary *> *countries = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:0
                                                                              error:&error];
    NSMutableArray *countriesArray = [NSMutableArray array];
    
    if (!error)
    {
        NSLog(@"%@",countries);

        for (NSDictionary *countryDictionary in countries)
        {
            RBTCountry *country = [[RBTCountry alloc] init];
            if ([country didUpdateSucceedForCountryDictionary:countryDictionary])
            {
                [countriesArray addObject:country];
            }
        }
        
        self.fetchedCountries = [countriesArray copy];
        completion(YES, nil);
    }
    else
    {
        // Error Parsing JSON
        NSDictionary *errorInfo = error ? @{NSUnderlyingErrorKey: error} : nil;
        completion(NO, [NSError errorWithDomain:RBTFetchDataErrorDomain
                                           code:RBTFetchDataErrorCodeJSONDataError
                                       userInfo:errorInfo]);
    }
}

@end
