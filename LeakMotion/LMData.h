//
//  LMData.h
//  LeakMotion
//
//  Created by Acsa Lu on 11/2/13.
//  Copyright (c) 2013 com.penser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>

@class LMData;

@protocol LMDataDelegate <NSObject>

@optional
- (void)data:(LMData *)data finishedFacebookMeQueryWithFacebookId:(NSString *)facebookId;

@end


@interface LMData : NSObject

@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccount *facebookAccount;
@property (strong, nonatomic) UIImage *profilePic;
@property (strong, nonatomic) NSString *facebookId;
@property (weak, nonatomic) id<LMDataDelegate> delegate;

+ (LMData *)sharedData;
- (void)facebook;

@end
