//
//  LCWordCodeViewController.m
//  LCSelectCountryCode_Example
//
//  Created by lu on 2020/3/13.
//  Copyright © 2020 Swift. All rights reserved.
//

#import "LCWordCodeViewController.h"
#import "LCWordCodeModel.h"
#import "BAKit_LocalizedIndexedCollation.h"
//#import "ContactsIndexView.h"

static NSString * const cellID = @"LCWordCodeViewCell";

#define Color_Clear_pod          [UIColor clearColor]
#define Color_Black_pod          [UIColor blackColor]
#define Color_Red_pod            [UIColor redColor]

/*!
 *  获取屏幕宽度和高度
 */
#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)

#define cellHeight        50

//#define tableViewEdgeInsets UIEdgeInsetsMake(0, 15, 0, 0)

@interface LCWordCodeViewController ()
<UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate>

@property(nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <LCWordCodeModel *>*dataArray;
@property (nonatomic, strong) NSMutableArray <LCWordCodeModel *>*searchResultsKeywordsArray;
@property (nonatomic, strong) NSMutableArray <NSString *>*searchResultIndexArray;

/*! 索引 */
@property (nonatomic, strong) NSMutableArray <NSString *>*indexArray;
@property (nonatomic, strong) NSMutableArray *sectionArray;

@property (nonatomic, strong) UISearchController *searchController;

//@property(nonatomic, strong) ContactsIndexView *indexView;

@property(nonatomic, strong) UIView *emptyView;

@end

@implementation LCWordCodeViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self removeSearch];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [self removeSearch];
}

- (void)removeSearch
{
    if (self.searchController.active)
    {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI
{
    self.navigationItem.title = @"选择国家或者地区";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.hidden = NO;
    self.emptyView.hidden = YES;
    
    [self getSectionData];
    [self setupNavi];
}

- (void)setupNavi {
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(handleLeftNaviButtonAction)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)handleLeftNaviButtonAction {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)getSectionData
{
    NSDictionary *dict = [BAKit_LocalizedIndexedCollation ba_localizedWithDataArray:self.dataArray localizedNameSEL:@selector(user_Name)];
    self.indexArray   = dict[kBALocalizedIndexArrayKey];
    self.sectionArray = dict[kBALocalizedGroupArrayKey];
    
//    NSMutableArray *tempModel = [[NSMutableArray alloc] init];
//    NSArray *dicts = @[@{@"user_Name" : @"新的朋友",
//                         @"user_Image_url" : @"plugins_FriendNotify"},
//                       @{@"user_Name" : @"群聊",
//                         @"user_Image_url" : @"add_friend_icon_addgroup"},
//                       @{@"user_Name" : @"标签",
//                         @"user_Image_url" : @"Contact_icon_ContactTag"},
//                       @{@"user_Name" : @"公众号",
//                         @"user_Image_url" : @"add_friend_icon_offical"}];
//    for (NSDictionary *dict in dicts)
//    {
//        LCWordCodeModel *model = [LCWordCodeModel new];
//        model.user_Name = dict[@"user_Name"];
//        model.user_Image_url = dict[@"user_Image_url"];
//        [tempModel addObject:model];
//    }
//
//    [self.sectionArray insertObject:tempModel atIndex:0];
//    [self.indexArray insertObject:@"🔍" atIndex:0];
    
    [self.tableView reloadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!self.searchController.active)
    {
        return self.indexArray.count;
    }
    else
    {
//        return self.searchResultIndexArray.count;
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.searchController.active)
    {
        return [self.sectionArray[section] count];
    }
    return self.searchResultsKeywordsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID ];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    LCWordCodeModel *model = nil;
    
    if (!self.searchController.active)
    {
        model = self.sectionArray[section][row];
        cell.textLabel.text = model.user_Name;
    }
    else
    {
        model = self.searchResultsKeywordsArray[row];

        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.user_Name attributes:@{NSForegroundColorAttributeName:Color_Black_pod}];
        
        NSRange range = [model.user_Name rangeOfString:self.searchController.searchBar.text];
        if (range.location != NSNotFound)
        {
            [attributedString addAttributes:@{NSForegroundColorAttributeName:Color_Red_pod} range:range];
        }
        cell.textLabel.attributedText = attributedString;
    }
    
    if (model.user_PhoneNumber)
    {
        cell.detailTextLabel.text = model.user_PhoneNumber;
//        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        //        cell.detailTextLabelEdgeInsets = UIEdgeInsetsMake(2, -3, 0, 0);
    }
    else
    {
        cell.detailTextLabel.text = nil;
    }
    
    //    cell.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    //    cell.textLabelEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    cell.backgroundColor = Color_Clear_pod;
    //    [cell updateCellAppearanceWithIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LCWordCodeModel *model = nil;
        if (!self.searchController.active) {
            model = self.sectionArray[indexPath.section][indexPath.row];
            //model.user_PhoneNumber;
        }
        else{
            model = self.searchResultsKeywordsArray[indexPath.row];
        }
//    NSLog(@"Name = %@",model.user_Name);
//    NSLog(@"PhoneNumber = %@",model.user_PhoneNumber);
    //
    if (self.successBlock != nil) {
        self.successBlock(model.user_Name,model.user_PhoneNumber);
    }

    if (self.searchController.active) {
        [self handleLeftNaviButtonAction];
        [self handleLeftNaviButtonAction];
    }else{
        [self handleLeftNaviButtonAction];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (!self.searchController.active)
    {
        return self.indexArray[section];
    }
    else
    {
        if (self.searchResultsKeywordsArray.count > 0)
        {
             return @"最佳匹配";
//            return self.searchResultIndexArray[section];
        }
    }
    return nil;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (!self.searchController.active)
    {
        return self.indexArray;
    }
    return nil;
}

#pragma mark - UISearchControllerDelegate
// 谓词搜索过滤
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = [self.searchController.searchBar text];
    [self.searchResultsKeywordsArray removeAllObjects];
    
    for (LCWordCodeModel *model in self.dataArray)
    {
        if ([model.user_Name containsString:searchString])
        {
            [self.searchResultsKeywordsArray addObject:model];
        }
        if (self.searchResultsKeywordsArray.count)
        {
            NSDictionary *dict = [BAKit_LocalizedIndexedCollation ba_localizedWithDataArray:self.searchResultsKeywordsArray localizedNameSEL:@selector(user_Name)];
            self.searchResultIndexArray = dict[kBALocalizedIndexArrayKey];
        }
    }
    
    if (self.searchResultsKeywordsArray.count == 0 && [self.searchController.searchBar isFirstResponder])
    {
        self.emptyView.hidden = NO;
    }
    else
    {
        self.emptyView.hidden = YES;
    }
    [self.tableView reloadData];
}

#pragma mark - UISearchControllerDelegate代理,可以省略,主要是为了验证打印的顺序
- (void)willPresentSearchController:(UISearchController *)searchController
{
//    self.indexView.hidden = YES;
//    [UIApplication.sharedApplication setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    // 如果进入预编辑状态,searchBar消失(UISearchController套到TabBarController可能会出现这个情况),请添加下边这句话
    //    [self.view addSubview:self.searchController.searchBar];
    //    if (![searchController.searchBar.text ba_stringIsBlank])
    //    {
    //        self.searchController.dimsBackgroundDuringPresentation = NO;
    //    }
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    //    [self lc_removeEmptyView];
//    self.indexView.hidden = NO;
//    [UIApplication.sharedApplication setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    //    [self lc_removeEmptyView];
}

- (void)presentSearchController:(UISearchController *)searchController
{
    
}

#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.emptyView.hidden = YES;
    //    [self lc_removeEmptyView];
}


- (void)lc_removeEmptyView
{
    [self.emptyView removeFromSuperview];
    self.emptyView = nil;
}

#pragma mark - setter / getter
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        self.tableView.backgroundColor = Color_Clear_pod;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.tableView.estimatedRowHeight = 44;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.tableFooterView = [UIView new];
        // 更改索引的背景颜色
        self.tableView.sectionIndexBackgroundColor = Color_Clear_pod;
        // 更改索引的文字颜色
        //        self.tableView.sectionIndexColor = Color_Orange;
//        self.tableView.sectionIndexTrackingBackgroundColor = Color_Red_pod;
        
        [self.view addSubview:self.tableView];
    }
    return _tableView;
}

- (UISearchController *)searchController
{
    if (!_searchController)
    {
        // 创建UISearchController
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        //设置代理
        self.searchController.delegate = self;
        self.searchController.searchResultsUpdater = self;
        self.searchController.searchBar.delegate = self;

        //包着搜索框外层的颜色
        // self.searchController.searchBar.barTintColor = [UIColor yellowColor];

        // placeholder
        self.searchController.searchBar.placeholder = @"搜索";
        self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        // 顶部提示文本,相当于控件的Title
//        self.searchController.searchBar.prompt = @"Prompt";
        // 搜索框样式
//        self.searchController.searchBar.barStyle = UIBarMetricsDefault;
        // 位置
        self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, SCREEN_WIDTH, 44.0);
//         [self.searchController.searchBar setSearchTextPositionAdjustment:UIOffsetMake(30, 0)];
        
        // 改变系统自带的“cancel”为“取消”
        ///(3).获取SearchBar的cancleButton,由于searcBar的层级发生变化以及对象的局部变量,因为无法通过kvc的方式来获取
//        [self.searchController.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
        
        
        self.searchController.searchBar.tintColor = Color_Red_pod;
        //        self.searchController.searchBar.backgroundColor = Color_Green_pod;

        // 是否提供自动修正功能（这个方法一般都不用的）
        // 设置自动检查的类型
        [self.searchController.searchBar setSpellCheckingType:UITextSpellCheckingTypeYes];
        [self.searchController.searchBar setAutocorrectionType:UITextAutocorrectionTypeDefault];// 是否提供自动修正功能，一般设置为UITextAutocorrectionTypeDefault
        [self.searchController.searchBar sizeToFit];


        //  是否显示灰色透明的蒙版，默认 YES，点击事件无效
        self.searchController.dimsBackgroundDuringPresentation = NO;
        // 是否隐藏导航条，这个一般不需要管，都是隐藏的
        //        self.searchController.hidesNavigationBarDuringPresentation = YES;
        // 搜索时，背景变模糊
        //        self.searchController.obscuresBackgroundDuringPresentation = NO;

        //点击搜索的时候,是否隐藏导航栏
        //    self.searchController.hidesNavigationBarDuringPresentation = NO;

        // 如果进入预编辑状态,searchBar消失(UISearchController套到TabBarController可能会出现这个情况),请添加下边这句话
        self.definesPresentationContext = YES;
        // 添加 searchbar 到 headerview
        self.tableView.tableHeaderView = self.searchController.searchBar;
    }
    return _searchController;
}

- (NSMutableArray <LCWordCodeModel *> *)searchResultsKeywordsArray
{
    if(_searchResultsKeywordsArray == nil)
    {
        _searchResultsKeywordsArray = [[NSMutableArray <LCWordCodeModel *> alloc] init];
    }
    return _searchResultsKeywordsArray;
}

- (NSMutableArray <LCWordCodeModel *> *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [[NSMutableArray <LCWordCodeModel *> alloc] init];
//        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"WordCode" ofType:@"plist"];
//        _dataArray = [NSMutableArray arrayWithContentsOfFile:plistPath];

        NSArray *iconImageNamesArray = @[@"61",
                                         @"55",
                                         @"49",
                                         @"07",
                                         @"33",
                                         @"63",
                                         @"82",
                                         @"01",
                                         @"855",
                                         @"856",
                                         @"60",
                                         @"01",
                                         @"95",
                                         @"81",
                                         @"66",
                                         @"673",
                                         @"34",
                                         @"65",
                                         @"39",
                                         @"91",
                                         @"62",
                                         @"44",
                                         @"84",
                                         @"86",
                                         @"853",
                                         @"886",
                                         @"852",

                                         ];
        NSArray *namesArray = @[
                                @"澳大利亚",
                                @"巴西",
                                @"德国",
                                @"俄罗斯",
                                @"法国",
                                @"菲律宾",
                                @"韩国",
                                @"加拿大",
                                @"柬埔寨",
                                @"老挝",
                                @"马来西亚",
                                @"美国",
                                @"缅甸",
                                @"日本",
                                @"泰国",
                                @"文莱",
                                @"西班牙",
                                @"新加坡",
                                @"意大利",
                                @"印度",
                                @"印尼",
                                @"英国",
                                @"越南",
                                @"中国",
                                @"中国澳门",
                                @"中国台湾",
                                @"中国香港"];
        
        NSInteger count = iconImageNamesArray.count > namesArray.count ? iconImageNamesArray.count: namesArray.count;
        
        for (NSInteger i = 0; i < count; i ++)
        {
            LCWordCodeModel *model = [[LCWordCodeModel alloc] init];
            @try {
                model.user_PhoneNumber = [NSString stringWithFormat:@"+%@",iconImageNamesArray[i]];
            } @catch (NSException *exception) {
                model.user_PhoneNumber = [NSString stringWithFormat:@"+%@",@""];
            }
            model.user_Name = namesArray[i];
            
            [self.dataArray addObject:model];
        }
    }
    return _dataArray;
}

- (NSMutableArray <NSString *> *)indexArray
{
    if(_indexArray == nil)
    {
        _indexArray = [[NSMutableArray <NSString *> alloc] init];
    }
    return _indexArray;
}

- (NSMutableArray *)sectionArray
{
    if(_sectionArray == nil)
    {
        _sectionArray = [[NSMutableArray alloc] init];
    }
    return _sectionArray;
}

//- (NSMutableArray <NSString *> *)searchResultIndexArray
//{
//    if(_searchResultIndexArray == nil)
//    {
//        _searchResultIndexArray = [[NSMutableArray <NSString *> alloc] init];
//    }
//    return _searchResultIndexArray;
//}

- (UIView *)emptyView
{
    if (!_emptyView)
    {
        _emptyView = [UIView new];
        _emptyView.backgroundColor = Color_Clear_pod;
        self.emptyView.frame = CGRectMake(100, 100, 150, 150);
        
        UILabel *label = [UILabel new];
        label.frame = _emptyView.bounds;
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"没有搜索到相关数据！";
        
        [_emptyView addSubview:label];
        [self.view addSubview:_emptyView];
    }
    return _emptyView;
}

- (void)dealloc {
//    NSLog(@"__func__dealloc = %s", __func__);
}



@end
