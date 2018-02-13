//
//  ViewController.swift
//  SQLite_Example
//
//  Created by Katerina on 13.02.18.
//  Copyright © 2018 Katerina. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //UI
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    //Data source
    private var contacts = [Contact]()
    private var selectedContact: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contacts = ContactsDB.instance.getContacts()
        
        setTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
}

// MARK: - Actions

extension ViewController {
    
    @IBAction func addContact(_ sender: Any) {
        let name = nameTextField.text ?? ""
        let phone = phoneTextField.text ?? ""
        let address = addressTextField.text ?? ""
        
        if let id = ContactsDB.instance.addContact(cname: name, cphone: phone, caddress: address) {
            let contact = Contact(id: 0, name: name, phone: phone, address: address)
            contacts.append(contact)
            contactsTableView.insertRows(at: [IndexPath(row: contacts.count-1, section: 0)], with: .fade)
            
            nameTextField.text = ""
            phoneTextField.text = ""
            addressTextField.text = ""
        }
    }
    
    @IBAction func updateContact(_ sender: Any) {
        if selectedContact != nil {
            let id = contacts[selectedContact!].id
            let contact = Contact(
                id: id,
                name: nameTextField.text ?? "",
                phone: phoneTextField.text ?? "",
                address: addressTextField.text ?? "")
            
            if ContactsDB.instance.updateContact(cid: id, newContact: contact) {
                contacts.remove(at: selectedContact!)
                contacts.insert(contact, at: selectedContact!)
                
                contactsTableView.reloadData()
            } else {
                print("No item selected")
            }
        }
    }
    
    @IBAction func deleteContact(_ sender: Any) {
        if selectedContact != nil {
            if ContactsDB.instance.deleteContact(cid: contacts[selectedContact!].id) {
                contacts.remove(at: selectedContact!)
                
                contactsTableView.deleteRows(at: [IndexPath(row: selectedContact!, section: 0)], with: .fade)
                
                nameTextField.text = ""
                phoneTextField.text = ""
                addressTextField.text = ""
            } else {
                print("No item selected")
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    fileprivate func setTableView() {
        contactsTableView.dataSource = self
        contactsTableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell")!
        
        cell.textLabel?.text = contacts[indexPath.row].name
        cell.detailTextLabel?.text = contacts[indexPath.row].phone
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nameTextField.text = contacts[indexPath.row].name
        phoneTextField.text = contacts[indexPath.row].phone
        addressTextField.text = contacts[indexPath.row].address
        
        selectedContact = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
}
