//按首字母或者汉字拼音首字母分组排序索引工具类


#import <Foundation/Foundation.h>

/*! 索引 */
#define kBALocalizedIndexArrayKey @"kBALocalizedIndexArrayKey"
/*! 排序后的分组，可以为 model */
#define kBALocalizedGroupArrayKey @"kBALocalizedGroupArrayKey"

@interface BAKit_LocalizedIndexedCollation : NSObject

/*!
 对数组排序
 
 @param dataArray        需要排序的数组，可以为 model
 @param localizedNameSEL 数组中对象需要排序的属性，可以为 model.userName
 
 @return 排序后的索引及 groupArray 字典形式 kBALocalizedIndexArrayKey kBALocalizedGroupArrayKey
 */
+ (NSDictionary *)ba_localizedWithDataArray:(NSMutableArray *)dataArray
                           localizedNameSEL:(SEL)localizedNameSEL;

@end
