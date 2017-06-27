#import <Foundation/Foundation.h>

@class RBTCountry;

@interface RBTCountriesSection : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic) NSArray<RBTCountry *> *countries;

@end
