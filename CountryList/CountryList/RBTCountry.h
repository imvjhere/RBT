#import <Foundation/Foundation.h>

@interface RBTCountry : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@property (nonatomic, readonly) NSDictionary *dictionaryRepresentation;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *alphaCode;
@property (nonatomic, readonly) NSString *nativeName;
@property (nonatomic, readonly) NSString *capital;
@property (nonatomic, readonly) NSString *region;
@property (nonatomic, readonly) NSString *subregion;

@end

