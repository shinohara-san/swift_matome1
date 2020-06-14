//
//  Company.swift
//  TenshokuApp
//
//  Created by Yuki Shinohara on 2020/06/11.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import Foundation
import RealmSwift

class Company : Object{
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var detail: String = ""
    @objc dynamic var urlString: String = ""
    
    
    override static func primaryKey() -> String? {
      return "id"
    }
    
}
