//
//  QMDownloadContentOperation.h
//  Qmunicate
//
//  Created by Andrey Ivanov on 28.07.14.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QMContentOperation.h"

@interface QMDownloadContentOperation : QMContentOperation

- (instancetype)initWithBlobID:(NSUInteger)blobID;

@end
