#import <Foundation/Foundation.h>
#import <YYCategories/NSDate+YYAdd.h>

typedef NS_ENUM(NSInteger, NSDateStringStyle) {
    NSDateStringStyleDay = 0,
    NSDateStringStyleSecond = 1,
};

@interface NSDate (Add)

+ (NSLocale *)defaultLocal;
+ (NSString *)currentDate:(NSDateStringStyle)style;
+ (NSString *)formatDate:(NSDateStringStyle)style date:(NSDate *)date;

@end
