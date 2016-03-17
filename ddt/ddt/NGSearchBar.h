//
//  NGSearchBar.h
//  ddt
//
//  Created by gener on 15/10/14.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NGSearchBar;

@protocol NGSearchBarDelegate <NSObject>

@optional
-(void)searchBarWillBeginSearch:(NGSearchBar*)searchBar;

-(BOOL)searchBarshouldChangeCharactersInRange:(NGSearchBar*)searchBar;

- (BOOL)textFieldShouldEndEditing:(NGSearchBar*)textField;

//@required
-(void)searchBarDidBeginSearch:(NGSearchBar*)searchBar withStr:(NSString *)str;

@end




@interface NGSearchBar : UIView<UITextFieldDelegate>

@property(nonatomic,copy)   NSString               *text;                 // default is nil
@property(nonatomic,copy)   NSString               *placeholder;
@property(nonatomic,assign) BOOL                    enable;
@property(nonatomic,assign)BOOL                     isFirstResponse;

@property(nonatomic,assign) id<NGSearchBarDelegate> delegate;
@end
