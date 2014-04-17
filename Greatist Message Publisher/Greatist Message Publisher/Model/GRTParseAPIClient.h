//
//  GRTParseAPIClient.h
//  Greatist Message Publisher
//
//  Created by Ezekiel Abuhoff on 4/9/14.
//  Copyright (c) 2014 Ezekiel Abuhoff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"

@interface GRTParseAPIClient : NSObject

+ (instancetype)sharedClient;

- (void) getRelevantPostsWithCompletion:(void (^)(NSArray *))completion;
- (void) getValidResponsesWithCompletion:(void (^)(NSArray *))completion;

- (void) postPostWithContent: (NSString *)content
                     section: (NSString *)section
                    latitude: (CGFloat)latitude
                   longitude: (CGFloat)longitude
                      userID: (NSString *)userID
              withCompletion: (void (^)(NSDictionary *))completion;

- (void) postResponseWithContent: (NSString *)content
                       timeStamp: (NSDate *)timeStamp
                          userID: (NSString *)userID
                            post: (NSString *)post;

// GRTPosts
- (void) getPostsWithFriendIDs:(NSArray *)friendsArray
                WithCompletion:(void (^)(NSArray *posts))completionBlock;

// GRTUser
- (void)getUsersWithCompletion:(void (^)(NSArray *users))completionBlock;

- (void) postUserWithFacebookID:(NSString *)fbookID
                     Completion:(void (^)(NSDictionary *))completion;
- (void) postUserWithName:(NSString *)name
               FacebookID:(NSString *)fbookID
               Completion:(void (^)(NSDictionary *))completion;

                   
@end
