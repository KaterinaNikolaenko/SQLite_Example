//
//  ContactsDB.swift
//  SQLite_Example
//
//  Created by Katerina on 13.02.18.
//  Copyright © 2018 Katerina. All rights reserved.
//

import Foundation
import SQLite

class ContactsDB {
    
    static let instance = ContactsDB()
    
    private let db: Connection?
    private let contacts = Table("contacts")
    private let id = Expression<Int>("id")
    private let name = Expression<String?>("name")
    private let phone = Expression<String>("phone")
    private let address = Expression<String>("address")
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            db = try Connection("\(path)/Contacts.sqlite3")
        } catch {
            db = nil
            print ("Unable to open database")
        }
        
        createTable()
    }
    
    func createTable() {
        do {
            try db!.run(contacts.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(phone, unique: true)
                table.column(address)
            })
        } catch {
            print("Unable to create table")
        }
    }
    
    func addContact(cname: String, cphone: String, caddress: String) -> Int64? {
        do {
            let insert = contacts.insert(name <- cname, phone <- cphone, address <- caddress)
            let id = try db!.run(insert)
            
            return id
        } catch {
            print("Insert failed")
            return -1
        }
    }
    
    func getContacts() -> [Contact] {
        var contacts = [Contact]()
        
        do {
            for contact in try db!.prepare(self.contacts) {
                contacts.append(Contact(
                    id: contact[id],
                    name: contact[name]!,
                    phone: contact[phone],
                    address: contact[address]))
            }
        } catch {
            print("Select failed")
        }
        
        return contacts
    }
    
    func deleteContact(cid: Int) -> Bool {
        do {
            let contact = contacts.filter(id == cid)
            try db!.run(contact.delete())
            return true
        } catch {
            print("Delete failed")
        }
        return false
    }
    
    func updateContact(cid:Int, newContact: Contact) -> Bool {
        let contact = contacts.filter(id == cid)
        do {
            let update = contact.update([
                name <- newContact.name,
                phone <- newContact.phone,
                address <- newContact.address
                ])
            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }
}
