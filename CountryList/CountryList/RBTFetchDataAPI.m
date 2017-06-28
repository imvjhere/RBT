#import "RBTFetchDataAPI.h"
#import "RBTCountry.h"

NSString *const RBTFetchDataErrorDomain = @"RBTFetchDataErrorDomain";

@implementation RBTFetchDataAPI

- (void)fetchCountriesWithCompletion:(RBTDataCompletion)completion
{
    NSData *cachedData = [[self class] cachedJSONData];
    if (cachedData)
    {
        [self parseJSONData:cachedData completion:completion];
    }
    
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[[self class] serverURL]
                                                             completionHandler:^(NSData *data,
                                                                                 NSURLResponse *response,
                                                                                 NSError *error)
                                  {
                                      if (data) {
                                          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                              if (![data isEqual:cachedData])
                                              {
                                                  [weakSelf parseJSONData:data completion:completion];
                                                  [[weakSelf class] cacheJSONData:data];
                                              }
                                          });
                                      } else {
                                          NSDictionary *userInfo = error ? @{NSUnderlyingErrorKey: error} : nil;
                                          completion(nil, [NSError errorWithDomain:RBTFetchDataErrorDomain
                                                                              code:RBTFetchDataErrorCodeServerError
                                                                          userInfo:userInfo]);
                                      }
                                  }];
    [task resume];
}

-(void)parseJSONData:(NSData*)data completion:(RBTDataCompletion)completion
{
    NSError *error;
    NSArray<NSDictionary *> *countryDictionaries = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (countryDictionaries)
    {
        NSMutableArray *countries = [[NSMutableArray alloc] init];
        
        for (NSDictionary *countryDictionary in countryDictionaries)
        {
            RBTCountry *country = [[RBTCountry alloc] initWithDictionary:countryDictionary];
            if (country)
            {
                [countries addObject:country];
            }
        }
        
        completion([NSArray arrayWithArray:countries], nil);
    }
    else
    {
        NSDictionary *userInfo = error ? @{NSUnderlyingErrorKey: error} : nil;
        completion(nil, [NSError errorWithDomain:RBTFetchDataErrorDomain
                                            code:RBTFetchDataErrorCodeJSONDataError
                                        userInfo:userInfo]);
    }
}

+ (NSData *)cachedJSONData
{
    return [NSData dataWithContentsOfURL:[self cachedDataURL]];
}

+ (void)cacheJSONData:(NSData *)data
{
    [data writeToURL:[self cachedDataURL] atomically:YES];
}

#pragma mark -

+ (NSURL *)serverURL
{
    return [NSURL URLWithString:@"https://restcountries.eu/rest/v2/all"];
}

+ (NSURL *)cachedDataURL
{
    NSURL *baseURL = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask].firstObject;
    return [baseURL URLByAppendingPathComponent:@"Countries.json"];
}

@end
