//
//  YBLFoundationMethod.m
//  YC168
//
//  Created by 乔同新 on 2017/4/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFoundationMethod.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface YBLFoundationMethod ()<ABPeoplePickerNavigationControllerDelegate>{
    ABPeoplePickerNavigationController*_peopleVC;
    FoundationMethodAddressBookBlock _addressBookBlock;
}
@end

static YBLFoundationMethod *foundationMethod = nil;

@implementation YBLFoundationMethod

+ (instancetype)shareInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        foundationMethod = [[YBLFoundationMethod alloc] init];
    });
    return foundationMethod;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _peopleVC = [[ABPeoplePickerNavigationController alloc] init];
        _peopleVC.peoplePickerDelegate = self;
    }
    return self;
}

- (void)showAddressBookWithVc:(UIViewController *)Vc handleSelectBlock:(FoundationMethodAddressBookBlock)block{
    _addressBookBlock = block;
    _peopleVC.modalPresentationStyle = UIModalPresentationCustom;
    _peopleVC.modalInPopover = YES;
    _peopleVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [Vc presentViewController:_peopleVC animated:YES completion:nil];
    [_peopleVC addressBook];
    
}


#pragma mark ---- ABPeoplePickerNavigationController

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    ABMultiValueRef multiValue = ABRecordCopyValue(person, property);
    CFIndex index = ABMultiValueGetIndexForIdentifier(multiValue,identifier);
    CFStringRef value = ABMultiValueCopyValueAtIndex(multiValue, index);
    NSString* strmob = (__bridge NSString*)value;
    NSString* mobile = [strmob stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    NSString*firstName=(__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    NSString*lastName=(__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
    if (lastName ==nil) {
        lastName = @"";
    }
    if (firstName ==nil) {
        firstName = @"";
    }
    NSString *name = [NSString stringWithFormat:@"%@%@",lastName,firstName];
    BLOCK_EXEC(_addressBookBlock,name,mobile);
}

@end
