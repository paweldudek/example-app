//
//  main.m
//  ExampleApp
//
//  Created by Paweł Dudek on 07/01/16.
//  Copyright © 2016 Paweł Dudek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char *argv[]) {
    int returnValue;

    @autoreleasepool {
        BOOL inTests = (NSClassFromString(@"SenTestCase") != nil || NSClassFromString(@"XCTest") != nil);

        if (inTests) {
            //use a special empty delegate when we are inside the tests
            returnValue = UIApplicationMain(argc, argv, nil, @"TestAppDelegate");
        }
        else {
            //use the normal delegate
            returnValue = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
    }

    return returnValue;
}
