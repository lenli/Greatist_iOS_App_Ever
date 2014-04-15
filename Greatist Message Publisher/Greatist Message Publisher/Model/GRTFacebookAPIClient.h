//
//  GRTFacebookAPI.h
//  Greatist Message Publisher
//
//  Created by Leonard Li on 4/9/14.
//  Copyright (c) 2014 Ezekiel Abuhoff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface GRTFacebookAPIClient : NSObject

+ (instancetype)sharedClient;
- (BOOL)isUserFacebookCached;
- (void)verifyUserFacebookCachedInViewController:(UIViewController *)parentVC;
- (void)getFriendIDsWithCompletion:(void(^)(NSArray *facebookFriendIDs))completion;
- (void)facebookLoginWithCompletion:(void (^)(NSArray *facebookFriends))completion;

@end
