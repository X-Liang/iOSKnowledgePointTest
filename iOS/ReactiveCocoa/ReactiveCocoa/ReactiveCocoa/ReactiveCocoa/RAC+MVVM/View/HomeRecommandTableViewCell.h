//
//  HomeRecommandTableViewCell.h
//  ReactiveCocoa
//
//  Created by X-Liang on 2017/11/18.
//  Copyright © 2017年 X-Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeRecommendItem.h"

@interface HomeRecommandTableViewCell : UITableViewCell
@property (weak, nonatomic, readonly) IBOutlet UIImageView *iconView;
@property (weak, nonatomic, readonly) IBOutlet UILabel *nameView;
@property (weak, nonatomic, readonly) IBOutlet UIButton *numView;
//@property (nonatomic, strong) HomeRecommendItem *item;

@end
