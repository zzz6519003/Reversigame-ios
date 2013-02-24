//
//  SHCBoardSquare.h
//  SHCReversiGame
//
//  Created by Zhengzhong Zhao on 2/21/13.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHCReversiBoard.h"
#import "SHCBoardDelegate.h"


@interface SHCBoardSquare : UIView <SHCBoardDelegate>
- (id)initWithFrame:(CGRect)frame column:(NSInteger)column row:(NSInteger)row board:(SHCReversiBoard*)board;

@end
