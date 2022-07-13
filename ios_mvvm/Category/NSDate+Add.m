#import "NSDate+Add.h"

@implementation NSDate (Add)

+ (NSLocale *)defaultLocal {
    return [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
}

+ (NSString *)formatDate:(NSDateStringStyle)style date:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [self defaultLocal];
    
    switch (style) {
        case NSDateStringStyleDay:
            formatter.dateFormat = @"YYYY-MM-dd";
            break;
        case NSDateStringStyleSecond:
            formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
            break;
        default:
            formatter.dateFormat = @"YYYY-MM-dd";
            break;
    }
    
    return [formatter stringFromDate:date];
}

+ (NSString *)currentDate:(NSDateStringStyle)style {
    return [self formatDate:style date:[NSDate date]];
}

@end
