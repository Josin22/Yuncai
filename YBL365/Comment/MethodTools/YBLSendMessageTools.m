//
//  YBLSendMessageTools.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSendMessageTools.h"
// iOS 9.0 以下
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

// iOS 9.0 及以上
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

#import <MessageUI/MessageUI.h>


@implementation YBLContactModel

- (instancetype)initWithName:(NSString *)name phoneNumber:(NSString *)phoneNumber
{
    self = [super init];
    if (self) {
        self.name = name;
        self.phoneNumber = phoneNumber;
    }
    return self;
}

@end

#define kRootViewController [UIApplication sharedApplication].keyWindow.rootViewController

@interface YBLSendMessageTools ()<UINavigationControllerDelegate, ABPeoplePickerNavigationControllerDelegate, CNContactPickerDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, copy) YBLContactsBlock contactBlock;
@property (nonatomic, copy) YBLMessageBlock messageBlock;

@end


@implementation YBLSendMessageTools

#pragma mark - 调用系统通讯录 选择并获取联系人信息
- (void)callContactsHandler:(YBLContactsBlock)handler {
    
    self.contactBlock = handler;
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 9.0) {
        
        ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
        peoplePicker.peoplePickerDelegate = self;
        [kRootViewController presentViewController:peoplePicker animated:YES completion:nil];
        
    }else{  // iOS 9.0 以后，使用新的系统通讯录框架
        
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        //    [CNContactStore authorizationStatusForEntityType:(CNEntityTypeContacts)];
        
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            if (granted) {
                CNContactPickerViewController *picker = [[CNContactPickerViewController alloc] init];
                picker.delegate = self;
                [kRootViewController presentViewController:picker animated:YES completion:^{}];
            }
            
        }];
        
    }
}

#pragma mark - ABPeoplePickerNavigationController delegate
// 在联系人详情页可直接发信息/打电话
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    
    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);
    CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef,index);
    
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if (!firstName) {
        firstName = @""; //!!!: 注意这里firstName/lastName是 给@"" 还是 @" ", 如果姓名要求无空格, 则必须为@""
    }
    
    NSString *lastName=(__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (!lastName) {
        lastName = @"";
    }
    
    NSString *personName = [NSString stringWithFormat:@"%@%@", lastName,firstName];
    NSString *phoneNumber = (__bridge NSString*)value;
    phoneNumber =  [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""]; // 不然是3-4-4
    
    
    YBLContactModel *model = [[YBLContactModel alloc] initWithName:personName phoneNumber:phoneNumber];
    if (self.contactBlock) {
        self.contactBlock(model);
    }
    
    [kRootViewController dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - CNContactPickerViewController delegate
// 通讯录列表 - 点击某个联系人 - 详情页 - 点击一个号码, 返回
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    
    NSString *personName = [NSString stringWithFormat:@"%@%@", contactProperty.contact.familyName, contactProperty.contact.givenName];
    NSString *phoneNumber = [contactProperty.value stringValue];
    phoneNumber =  [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    YBLContactModel *model = [[YBLContactModel alloc] initWithName:personName phoneNumber:phoneNumber];
    if (self.contactBlock) {
        self.contactBlock(model);
    }
    
}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
    
}

#pragma mark - 群发/单发 指定信息 #####
- (void)sendContacts:(NSArray<NSString *> *)phoneNumbers message:(NSString *)message completion:(YBLMessageBlock)completion{
    
    self.messageBlock = completion;
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if(messageClass != nil){
        MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc]init];
        messageVC.messageComposeDelegate = self;
        messageVC.body = message;
        messageVC.recipients = phoneNumbers;
        if (messageVC) {
            [kRootViewController presentViewController:messageVC animated:YES completion:nil];
        }
    }else {
        //        Have error here ...
    }
    
}

/** 发送信息后的回调  **/
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    [kRootViewController dismissViewControllerAnimated:YES completion:^{}];
    
    if (self.messageBlock) {
        NSInteger num = result;
        self.messageBlock(num);
    }
    
    //    switch (result) {
    //        case MessageComposeResultCancelled:
    //
    //            break;
    //        case MessageComposeResultSent:
    //
    //            break;
    //        case MessageComposeResultFailed:
    //
    //            break;
    //
    //        default:
    //            break;
    //    }
}

//创建新的联系人
+ (void)ios8_creatContactName:(NSString *)name phone:(NSString *)phone address:(NSString *)address
{
    CFErrorRef error = NULL;
    
    //创建一个通讯录操作对象
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    //创建一条新的联系人纪录
    ABRecordRef newRecord = ABPersonCreate();
    
    ABPersonSetImageData(newRecord, (__bridge CFDataRef)(UIImageJPEGRepresentation([UIImage imageNamed:smallImagePlaceholder],.8)), nil);
    
    //为新联系人记录添加属性值
    ABRecordSetValue(newRecord, kABPersonFirstNameProperty, (__bridge CFTypeRef)name, &error);
    
    //创建一个多值属性(电话)
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)phone, kABPersonPhoneMobileLabel, NULL);
    ABRecordSetValue(newRecord, kABPersonPhoneProperty, multi, &error);
    
    //address
    if (address) {
        ABMutableMultiValueRef multi1 = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)address, kABPersonAddressStreetKey, NULL);
        ABRecordSetValue(newRecord, kABPersonAddressProperty, multi1, &error);
    }
    
    //添加记录到通讯录操作对象
    ABAddressBookAddRecord(addressBook, newRecord, &error);
    
    //保存通讯录操作对象
    ABAddressBookSave(addressBook, &error);
    
    //通过此接口访问系统通讯录
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (granted) {
            //显示提示
            [SVProgressHUD showSuccessWithStatus:@"添加成功~"];
        }
    });
    
    CFRelease(multi);
    CFRelease(newRecord);
    CFRelease(addressBook);
}

//创建新的联系人
+ (void)creatContactName:(NSString *)name phone:(NSString *)phone{
    [self creatContactName:name phone:phone address:nil];
}
+ (void)creatContactName:(NSString *)name phone:(NSString *)phone address:(NSString *)address{
    
    if (iOS9) {
        [self ios9_initWithImage:@"contact_icon"
                         andName:@[name]
                       andEmails:nil
                 andPhoneNumbers:@[phone]
                    andAddresses:@[address]
                     andBirthday:nil];

    } else {
        [self ios8_creatContactName:name phone:phone address:address];
    }
}
//创建联系人
+ (void)ios9_initWithImage:(NSString *)imageName
              andName:(NSArray *)name
            andEmails:(NSArray *)email
      andPhoneNumbers:(NSArray *)phoneNumber
         andAddresses:(NSArray *)address
          andBirthday:(NSArray *)birthdayArray
{
    //=============格式化创建联系人=================
    CNMutableContact *contact = [[CNMutableContact alloc] init];
    //头像
    contact.imageData = UIImageJPEGRepresentation([UIImage imageNamed:imageName],.8);
    //姓名
    NSInteger index = 0;
    for (NSString *name_string in name) {
        if (index==0) {
            contact.familyName = name_string;
        } else if (index==1) {
            contact.givenName = name_string;
        }
        index++;
    }
    //邮箱
    //邮箱键值
    //家庭CNLabelHome   0
    //工作CNLabelWork   1
    //其他CNLabelOther  2
    NSMutableArray *email_array = @[].mutableCopy;
    for (NSString *email_string in email) {
        CNLabeledValue *homeEmail = [CNLabeledValue labeledValueWithLabel:CNLabelHome value:email_string];
        [email_array addObject:homeEmail];
    }
    contact.emailAddresses = email_array;
    //电话
    //电话键值
    //CNLabelPhoneNumberiPhone  0
    //CNLabelPhoneNumberMobile  1
    //CNLabelPhoneNumberMain    2
    //CNLabelPhoneNumberHomeFax
    //CNLabelPhoneNumberWorkFax
    //CNLabelPhoneNumberOtherFax
    //CNLabelPhoneNumberPager
    NSMutableArray *phone_array = @[].mutableCopy;
    for (NSString *phone_string in phoneNumber) {
        CNLabeledValue *iPhoneNumber = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberiPhone value:[CNPhoneNumber phoneNumberWithStringValue:phone_string]];
        [phone_array addObject:iPhoneNumber];
    }
    contact.phoneNumbers = phone_array;

    //地址 可设键值 home:[0]
    CNMutablePostalAddress * homeAdress = [[CNMutablePostalAddress alloc]init];
    if (address.count==1) {
        homeAdress.street = address[0];
    }
//    homeAdress.street = address[0][2];
//    homeAdress.city = address[0][1];
//    homeAdress.state = address[0][0]; //国家
//    homeAdress.postalCode = address[0][3];
    contact.postalAddresses = @[[CNLabeledValue labeledValueWithLabel:CNLabelHome value:homeAdress]];
    
    //生日
//    NSDateComponents * birthday = [[NSDateComponents  alloc]init];
//    birthday.day = (long int)birthdayArray[2];
//    birthday.month = (long)birthdayArray[1];
//    birthday.year = (long)birthdayArray[0];
//    contact.birthday=birthday;
    
    //=============创建联系人请求=================
    CNSaveRequest * saveRequest = [[CNSaveRequest alloc]init];
    //添加联系人
    [saveRequest addContact:contact toContainerWithIdentifier:nil];
    
    //    //更新一个联系人
    //    - (void)updateContact:(CNMutableContact *)contact;
    //    //删除一个联系人
    //    - (void)deleteContact:(CNMutableContact *)contact;
    //    //添加一组联系人
    //    - (void)addGroup:(CNMutableGroup *)group toContainerWithIdentifier:(nullable NSString *)identifier;
    //    //更新一组联系人
    //    - (void)updateGroup:(CNMutableGroup *)group;
    //    //删除一组联系人
    //    - (void)deleteGroup:(CNMutableGroup *)group;
    //    //向组中添加子组
    //    - (void)addSubgroup:(CNGroup *)subgroup toGroup:(CNGroup *)group NS_AVAILABLE(10_11, NA);
    //    //在组中删除子组
    //    - (void)removeSubgroup:(CNGroup *)subgroup fromGroup:(CNGroup *)group NS_AVAILABLE(10_11, NA);
    //    //向组中添加成员
    //    - (void)addMember:(CNContact *)contact toGroup:(CNGroup *)group;
    //    //向组中移除成员
    //    - (void)removeMember:(CNContact *)contact fromGroup:(CNGroup *)group;
    
    //=============写操作=================
    CNContactStore * store = [[CNContactStore alloc]init];
    if([store executeSaveRequest:saveRequest error:nil])
        [SVProgressHUD showSuccessWithStatus:@"添加成功~"];
    NSLog(@"创建联系人成功。");
}


@end
