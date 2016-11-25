//
//  UserData.swift
//  OneDayIchizen
//
//  Created by 長徳　将希 on 2016/06/20.
//  Copyright © 2016年 K10. All rights reserved.
//

import UIKit
import CoreData

@objc(UserData)
class UserData: NSManagedObject {
    
    @NSManaged var ninpuFlag :Bool
    @NSManaged var myName :String
    @NSManaged var myBirthday :NSDate
    @NSManaged var myBloodType :String
    @NSManaged var myAddress :String
    @NSManaged var myPhoneNumber :String
    @NSManaged var mailAddress1 :String
    @NSManaged var mailAddress2 :String
    @NSManaged var gestationalDay :NSDate
    @NSManaged var hospitalPhoneNumber :String
    
    @NSManaged var helperFlag :Bool
    
}
