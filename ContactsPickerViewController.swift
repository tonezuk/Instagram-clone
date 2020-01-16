//
//  ContactsPickerViewController.swift
//  Instagram
//
//  Created by Antony Paul on 01/10/2019.
//  Copyright © 2019 Instagram. All rights reserved.
//

import UIKit
import Firebase
import VENTokenField

class ContactsPickerViewController: UITableViewController {
    
    struct Storyboard {
        static let contactCell = "ContactCell"
        
    }
   
    //Check if the chat exists
    var chats: [Chat]!
    
    var accounts = [User]()
    var currentUser: User!
    
    var selectedAccounts = [User]()
    
    @IBOutlet weak var nextBarButtoneItem: UIBarButtonItem!
    @IBOutlet weak var contactsPickerField: VENTokenField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //Setup Tableview
        title = "New Message"
        navigationItem.rightBarButtonItem = nextBarButtoneItem
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    

    // Current User - > Accessing the User that is already logged in
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let tabBarController = appDelegate.window!.rootViewController as! UITabBarController
    let firstNavVC = tabBarController.viewControllers!.first as! UINavigationController
    let newsfeedTVC = firstNavVC.topViewController as! NewsFeedTableViewController
        currentUser = newsfeedTVC.currentUser
   
    // Contacts Picker fiELD
    contactsPickerField.placeholderText = "Search.."
    contactsPickerField.setColorScheme(UIColor.red)
    contactsPickerField.delimiters = [".", ";", "--"]
    contactsPickerField.toLabelTextColor = UIColor.black
    contactsPickerField.dataSource = self
    contactsPickerField.delegate = self
        
    self.fetchUsers()
    }
    
    func fetchUsers()
    {
        let accountRef = WADatabaseReference.users(uid: currentUser.uid).reference().child("follows")
        accountRef.observe(.childAdded, with: { snapshot in
            let user = User(dictionary: snapshot.value as!
                [String : Any])
            self.accounts.insert(user, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .fade)
            
        })
    }
    
    // MARK: - UITableVieWDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accounts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.contactCell, for: indexPath) as! ContactTableViewCell
        let user = accounts[indexPath.row]
        
         cell.user = user
         cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    // MARK: UITablevViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as!
        ContactTableViewCell
        cell.added = !cell.added
        
        if cell.added == true {
            self.addRecipient(account: cell.user)
        } else {
            let index = selectedAccounts.index(of: cell.user)!
            self.deleteRecipient(account: cell.user, index: index)
        }
    }
    
    // MARK: - Helper Methods
    
    func addRecipient(account: User)
    {
        selectedAccounts.append(account)
        self.contactsPickerField.reloadData()
    }
    func deleteRecipient(account: User, index: Int)
    {
        
    }
}

// MARK: - VENTokenFieldDataSource

extension ContactsPickerViewController : VENTokenFieldDataSource
{
    func tokenField(_ tokenField: VENTokenField, titleForTokenAt index: UInt) -> String {
        return selectedAccounts[Int(index)].fullName
    }
    
    func numberOfTokens(in tokenField: VENTokenField) -> UInt {
        return UInt(selectedAccounts.count)
    }
    
}
// MARK: - VENTokenFieldDelgate
extension ContactsPickerViewController : VENTokenFieldDelegate
{
//    func tokenField(_ tokenField: VENTokenField, didEnterText text: String) {
//        <#code#>
//    }
    func tokenField(_ tokenField: VENTokenField, didDeleteTokenAt index: UInt) {
        let indexPath = IndexPath(row: Int(index), section: 0)
        let cell = tableView.cellForRow(at: indexPath)  as!
        ContactTableViewCell
        cell.added = !cell.added
        self.deleteRecipient(account: cell.user, index: Int(index))
    }
}


























