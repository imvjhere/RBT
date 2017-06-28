#import <Foundation/Foundation.h>

@class RBTCountry;

extern NSString *const RBTFetchDataErrorDomain;

typedef NS_OPTIONS(NSUInteger, RBTFetchDataErrorCode) {
    RBTFetchDataErrorCodeServerError,
    RBTFetchDataErrorCodeJSONDataError,
    RBTFetchDataErrorCodeUnknownError
};

@interface RBTFetchDataAPI : NSObject

typedef void (^RBTDataCompletion)(NSArray<RBTCountry *> *countries, NSError* error);
- (void)fetchCountriesWithCompletion:(RBTDataCompletion)completion;

@end
