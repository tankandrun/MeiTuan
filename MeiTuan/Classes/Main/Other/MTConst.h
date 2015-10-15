
#import <Foundation/Foundation.h>

#ifdef DEBUG
#define MTLog(...) NSLog(__VA_ARGS__)
#else
#define MTLog(...)
#endif

#define MTColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define MTGlobalBg MTColor(230, 230, 230)

extern NSString *const MTCityDidChangedNotification;
extern NSString *const MTSelectedCityName;

extern NSString *const MTSortDidChangedNotification;
extern NSString *const MTSelectedSort;

extern NSString *const MTCategoryDidChangedNotification;
extern NSString *const MTSelectedCategory;
extern NSString *const MTSelectedSubCategoryName;

extern NSString *const MTRegionDidChangedNotification;
extern NSString *const MTSelectedRegion;
extern NSString *const MTSelectedSubRegionName;

extern NSString *const MTCollectStateDidChangedNotification;
extern NSString *const MTIsCollectKey;
extern NSString *const MTCollectDealKey;