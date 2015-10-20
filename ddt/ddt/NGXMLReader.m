//
//  NGXMLReader.m
//  ddt
//
//  Created by wyg on 15/10/17.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGXMLReader.h"
#import "NGXMLDataModel.h"

#define PARSER_END_ONTIME @"PARSER_END_ONTIME"
#define PARSER_ALL_OK @"PARSER_ALL_OK"

@implementation NGXMLReader
{
    NSArray *_fileArr;//xml文件名
    NSArray *_basedataTag;
    NSInteger _currentIndex;//当前文件索引
    
    NSXMLParser *_xmlParser;
    LKDBHelper *_helper;
}

-(instancetype)init
{
    if (self == [super init]) {
        _fileArr = @[@"base_data",@"cities",@"districts"];
        _basedataTag = @[@"one",@"two",@"three"];
        _currentIndex = 0;
        _helper = [LKDBHelper getUsingLKDBHelper];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(parserEndAction) name:PARSER_END_ONTIME object:nil];
//            [_helper dropAllTable];
    }
    return self;
}


+(instancetype)share
{
    static dispatch_once_t once;
    static NGXMLReader *_reader = nil;
    dispatch_once(&once, ^{
        _reader = [[NGXMLReader alloc]init];
    });
    
    return _reader;
}


-(void)parserEndAction
{
    if (_currentIndex >= 2) {
        NGXMLDataModel *_m = [[NGXMLDataModel alloc]init];
        _m.key = @"PARSER_ALL_OK";
        _m.name =@"PARSER_ALL_OK";
        _m.level = @"PARSER_ALL_OK";
        [_helper insertToDB:_m];
        
        NSLog(@"－－－－－－%ld －－－－xml parser ok! －－－－\n",_currentIndex);
        return;
    }
    dispatch_async(dispatch_queue_create("parserxmlqueue", DISPATCH_QUEUE_SERIAL), ^{
        _currentIndex++;
        [self startParser];
    });
    
 }


//开始解析
-(void)startParser
{
    _xmlParser = nil;
    NSString *strPath = [[NSBundle mainBundle]pathForResource:[_fileArr objectAtIndex:_currentIndex] ofType:@"xml"];
    NSData *data = [[NSData alloc]initWithContentsOfFile:strPath];
    _xmlParser = [[NSXMLParser alloc]initWithData:data];
    _xmlParser.delegate  =self;
    [_xmlParser parse];
}


#pragma mark--NSXMLParser delegate
-(void)parserDidStartDocument:(NSXMLParser *)parser
{

}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:PARSER_END_ONTIME object:nil];
        NSLog(@"parserDidEndDocument");
    });

}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    switch (_currentIndex) {
        case 0:
        {
            if ([_basedataTag containsObject:elementName]) {
                NGXMLDataModel *_m = [[NGXMLDataModel alloc]init];
                _m.name = [attributeDict objectForKey:@"name"];
                _m.key = [attributeDict objectForKey:@"key"];
                _m.level = elementName;
                
                if (![_helper searchSingle:[NGXMLDataModel class] where:[NSString stringWithFormat:@"key = '%@'",_m.key] orderBy:nil]) {
                    [_helper insertToDB:_m];
                }
            }
        } break;
        case 1://  <City ID="124" CityName="南昌市" PID="14" ZipCode="330000">南昌市</City>
        {
            if ([elementName isEqualToString:@"City"]) {
                NGXMLCityModel *_m = [[NGXMLCityModel alloc]init];
                [_m setValuesForKeysWithDictionary:attributeDict];
                if (![_helper searchSingle:[NGXMLCityModel class] where:[NSString stringWithFormat:@"ID = '%@' or CityName = '%@'",_m.ID,_m.CityName] orderBy:nil]) {
                    [_helper insertToDB:_m];
                }
            }
            
        } break;
        case 2:
        {
            if ([elementName isEqualToString:@"District"]) {
                NGXMLAreaModel *_m = [[NGXMLAreaModel alloc]init];
                [_m setValuesForKeysWithDictionary:attributeDict];
                if (![_helper searchSingle:[NGXMLAreaModel class] where:[NSString stringWithFormat:@"ID = '%@'",_m.ID] orderBy:nil]) {
                    [_helper insertToDB:_m];
                }
            }
        } break;
            
        default:
            break;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{

}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{

}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _currentIndex = 0;
        [[NSNotificationCenter defaultCenter]postNotificationName:PARSER_END_ONTIME object:nil];
        NSLog(@"parserDidEndDocument");
    });
}


#pragma mark--other method

+(void)parser
{
    [[self share]startParser];
}

/**
 *  应用程序每次启动时判断
 *
 *  @return bool
 */
+(BOOL)hasAlreadyParserSuccess
{
   return  [[self share]hasAlreadyParserSuccess];
}


-(BOOL)hasAlreadyParserSuccess
{
    return  [_helper searchSingle:[NGXMLDataModel class] where:@"key = 'PARSER_ALL_OK'" orderBy:nil] ? YES:NO;
}

/**
 *   获取全部城市数据，每个元素为字典类型－key：为城市ID obj ： 城市名称
 *
 *  @return arr
 */
+(NSArray*)getAllCities
{
   return [[self share]getAllCities];
}

-(NSArray*)getAllCities
{
    NSMutableArray *_arr = [[NSMutableArray alloc]init];
    NSArray *_cities = [_helper search:[NGXMLCityModel class] where:nil orderBy:nil offset:0 count:INT16_MAX];
    
    [_cities enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *_id = ((NGXMLCityModel*)obj).ID ? ((NGXMLCityModel*)obj).ID : @"";
        NSString *_name =((NGXMLCityModel*)obj).CityName?((NGXMLCityModel*)obj).CityName:@"";
        if (_id && _name) {
            NSDictionary *_d = [NSDictionary dictionaryWithObjectsAndKeys:_id,@"ID",_name,@"NAME", nil];
            [_arr addObject:_d];
        }
    }];
    
    return _arr;
}

//根据城市名称获取城市编码
+(NSString*)getIDWithCityName:(NSString*)name
{
   return  [[self share]getIDWithCityName:name];
}

-(NSString*)getIDWithCityName:(NSString*)name
{
   NGXMLCityModel*_m = [_helper searchSingle:[NGXMLCityModel class] where:[NSString stringWithFormat:@"CityName like '%%%@%%'",name] orderBy:nil];
    return _m.ID;
}

//获取当前定位城市下所有区域
+(NSArray*)getCurrentLocationAreas
{
    NSString*name = [[NSUserDefaults standardUserDefaults]objectForKey:CURRENT_LOCATION_CITY];
    NSString*cityid = [[self share]getIDWithCityName:name];
    return [[self share]getAllAreaWithCityID:cityid];
}


//根据城市ID获取，当前城市下区域
+(NSArray*)getAllAreaWithCityID:(NSString*)strid
{
    return [[self share]getAllAreaWithCityID:strid];
}

-(NSArray*)getAllAreaWithCityID:(NSString*)strid
{
    NSMutableArray *_arr = [[NSMutableArray alloc]init];
    NSArray *_cities = [_helper search:[NGXMLAreaModel class] where:[NSString stringWithFormat:@"CID = '%@'",strid] orderBy:@"ID asc" offset:0 count:INT16_MAX];
    
    [_cities enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *_id = ((NGXMLAreaModel*)obj).ID ? ((NGXMLAreaModel*)obj).ID : @"";
        NSString *_name =((NGXMLAreaModel*)obj).DistrictName?((NGXMLAreaModel*)obj).DistrictName:@"";
        if (_id && _name) {
            NSDictionary *_d = [NSDictionary dictionaryWithObjectsAndKeys:_id,@"ID",_name,@"NAME", nil];
            [_arr addObject:_d];
        }
    }];
    
    return _arr;
}

#pragma mark --获取基础类型数据

-(NSArray*)getBaseTypeDataWithKey:(NSString*)key andLevel:(NSString*)level
{
    NSMutableArray *_arr = [[NSMutableArray alloc]init];
    NSString*searchStr =key?[NSString stringWithFormat:@"level = '%@' and key like '%@%%'",level,key]: [NSString stringWithFormat:@"level = '%@'",level];
    
    NSArray *_tmp = [_helper search:[NGXMLDataModel class] where:searchStr orderBy:@"rowid asc" offset:0 count:INT16_MAX];
    
//    [_tmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSString *_id = ((NGXMLDataModel*)obj).key ? ((NGXMLDataModel*)obj).key : @"";
//        NSString *_name =((NGXMLDataModel*)obj).name?((NGXMLDataModel*)obj).name:@"";
//        if (_id && _name) {
//            NSDictionary *_d = [NSDictionary dictionaryWithObjectsAndKeys:_id,@"ID",_name,@"NAME", nil];
//            [_arr addObject:_d];
//        }
//    }];
    
    for (int i =0; i < _tmp.count; i++) {
        NGXMLDataModel *_m = [_tmp objectAtIndex:i];
        NSString *_id = _m.key ? _m.key : @"";
        NSString *_name =_m.name?_m.name:@"";
        if (_id && _name) {
            NSDictionary *_d = [NSDictionary dictionaryWithObjectsAndKeys:_id,@"ID",_name,@"NAME", nil];
            [_arr addObject:_d];
        }
    }
    return _arr;
}

+(NSArray*)getBaseTypeDataWithKey:(NSString*)key //andLevel:(NSString*)level
{
    return [[self share]getBaseTypeDataWithKey:key andLevel:@"two"];
}

+(NSArray*)getBaseTypeData
{
    return [[self share]getBaseTypeDataWithKey:nil andLevel:@"one"];
}


@end







