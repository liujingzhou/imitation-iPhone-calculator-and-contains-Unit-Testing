//
//  UILabel+MyAccessibility.m
//  MYCalculator
//
//  Created by 刘景州 on 2018/8/26.
//  Copyright © 2018年 刘景州. All rights reserved.
//

#import "UILabel+MyAccessibility.h"

@implementation UILabel (MyAccessibility)
@dynamic accessibilityValue;
-(NSString *)accessibilityValue {
    // Here we force UIKit to return Label value, not the accessibility label
    return self.text;
}
@end
