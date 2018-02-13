//
//  Contact.swift
//  SQLite_Example
//
//  Created by Katerina on 13.02.18.
//  Copyright © 2018 Katerina. All rights reserved.
//

import Foundation

class Contact {
    let id: Int
    var name: String
    var phone: String
    var address: String
    
    init(id: Int) {
        self.id = id
        name = ""
        phone = ""
        address = ""
    }
    
    init(id: Int, name: String, phone: String, address: String) {
        self.id = id
        self.name = name
        self.phone = phone
        self.address = address
    }
}
