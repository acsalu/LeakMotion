//
//  LMData.m
//  LeakMotion
//
//  Created by Acsa Lu on 11/2/13.
//  Copyright (c) 2013 com.penser. All rights reserved.
//

#import "LMData.h"
#import <Social/Social.h>
#import "AFNetworking.h"

@implementation LMData

+ (LMData *)sharedData
{
    static dispatch_once_t once;
    static LMData *data;
    dispatch_once(&once, ^{
        data = [[self alloc] init];
    });
    return data;
}

- (void)facebook
{
    if (!_accountStore)
        _accountStore = [[ACAccountStore alloc] init];
    
    NSDictionary *options = @{
                              ACFacebookAppIdKey: @"232104906954589",
                              ACFacebookPermissionsKey: @[@"email", @"publish_stream", @"publish_actions"],
                              ACFacebookAudienceKey: ACFacebookAudienceFriends
                              };
    
    ACAccountType *facebookTypeAccount = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    [_accountStore requestAccessToAccountsWithType:facebookTypeAccount
        options:options
        completion:^(BOOL granted, NSError *error) {
            if(granted){
            NSArray *accounts = [_accountStore accountsWithAccountType:facebookTypeAccount];
            _facebookAccount = [accounts lastObject];
            NSLog(@"Success");
                [self me];
        } else{
            // ouch
            NSLog(@"Fail");
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)me{
    NSURL *meurl = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    
    SLRequest *merequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                              requestMethod:SLRequestMethodGET
                                                        URL:meurl
                                                 parameters:nil];
    
    merequest.account = _facebookAccount;
    
    [merequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSString *meDataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *meDict = [NSJSONSerialization JSONObjectWithData:responseData options:nil error:nil];
//        NSLog(@"%@", meDataString);
        self.facebookId = meDict[@"id"];
        self.userName = meDict[@"name"];
        [self.delegate data:self finishedFacebookMeQueryWithFacebookId:self.facebookId andName:self.userName];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", meDict[@"id"]]];
//        self.profilePic = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];

    }];
}

- (MKMapView *)mapView
{
    if (!_mapView)
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 370)];

    return _mapView;
}

@end
