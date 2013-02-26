//
//  SHCComputerOpponent.h
//  SHCReversiGame
//
//  Created by Zhengzhong Zhao on 2/26/13.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHCReversiBoardDelegate.h"
#import "SHCReversiBoard.h"


@interface SHCComputerOpponent : NSObject<SHCReversiBoardDelegate>

- (id)initWithBoard:(SHCReversiBoard *)board andColor:(BoardCellState)computerColor;

@end
