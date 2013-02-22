//
//  SHCBoardSquare.h
//  SHCReversiGame
//
//  Created by Zhengzhong Zhao on 2/21/13.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHCReversiBoard.h"

@interface SHCBoardSquare : UIView
- (id)initWithFrame:(CGRect)frame column:(NSInteger)column row:(NSInteger)row board:(SHCReversiBoard*)board;

@end
