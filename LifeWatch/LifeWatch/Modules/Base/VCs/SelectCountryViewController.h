//
//  SelectCountryViewController.h
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/21.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "BaseViewController.h"

@protocol selectCountryDelegate <NSObject>

- (void)selectedCountry:(NSDictionary *)dict;

@end


@interface SelectCountryViewController : BaseViewController

@property (nonatomic, strong) NSMutableDictionary * resultDict;

@property (nonatomic, assign) id<selectCountryDelegate> delegate;


@end
