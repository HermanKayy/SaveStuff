//
//  PasswordListTableViewController.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/6/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import UIKit
import CoreData

class PasswordListTableViewController: UITableViewController {

    // MARK: Propertie s
    let searchController = UISearchController(searchResultsController: nil)
    var filteredPasswords: [Password]?
    var tableViewIsEditing: Bool = false {
        didSet {
            tableView.setEditing(tableViewIsEditing, animated: true)
        }
    }
    
    // MARK: LifeCycles
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !PasswordController.shared.passwords.isEmpty {
            navigationItem.leftBarButtonItem?.isEnabled = true
        }
        tabBarController?.tabBar.isHidden = false
        filteredPasswords = PasswordController.shared.passwords
        self.definesPresentationContext = true
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // NavBar Properties
        //        navigationController?.navigationBar.barTintColor = UIColor.ColorPalette.themeColor

        navigationItem.title = "Password"
        navigationController?.navigationBar.prefersLargeTitles = true

        // Tableview Properties
        tableView.separatorStyle = .none
        tableView.tableHeaderView = searchController.searchBar

        // Search Controller Properties
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.black
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.searchBar.text = ""
        searchController.searchBar.showsCancelButton = false
        searchController.dismiss(animated: true, completion: nil)
        tableView.setEditing(false, animated: true)
    }

    // MARK: - TableView DataSource

    // Number of Rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let filteredPasswords = filteredPasswords else { return PasswordController.shared.passwords.count }
        return filteredPasswords.count
    }

    // Cell for Row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "passwordCell", for: indexPath) as? PasswordListTableViewCell else { return UITableViewCell() }
        
        if let passwords = filteredPasswords {
            let password = passwords[indexPath.row]
            cell.passwordLabel.text = password.title
            cell.passcode = password.passcode
        } else {
            let password = PasswordController.shared.passwords[indexPath.row]
            cell.passwordLabel.text = password.title
            cell.passcode = password.passcode
        }
        
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none 
        cell.lockButtonImage.image = UIImage(named: "clipboard")
        cell.delegate = self
        return cell
    }
    
    // Tableview Editing Style
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let password = PasswordController.shared.passwords[indexPath.row]
            PasswordController.shared.deletePassword(password: password)
            filteredPasswords = PasswordController.shared.passwords
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if PasswordController.shared.passwords.isEmpty {
                tableViewIsEditing = false
                navigationItem.leftBarButtonItem?.isEnabled = false
                navigationItem.leftBarButtonItem?.title = "Edit"
            }
        }
    }
    
    // TableView Disable Slide to Delete
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }
    
    // TableView Height for Row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    // MARK: Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemDetailSegue" {
            guard let destinationVC = segue.destination as? PasswordDetailViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            let password = PasswordController.shared.passwords[indexPath.row]
            destinationVC.passwword = password
        }
    }
    
    // MARK: IBActions
    @IBAction func leftBarButtonTapped(_ sender: UIBarButtonItem) {
        if tableViewIsEditing == false {
            tableViewIsEditing = true
            navigationItem.leftBarButtonItem?.title = "Cancel"
        } else {
            tableViewIsEditing = false
            navigationItem.leftBarButtonItem?.title = "Edit"
        }
    }
}

// MARK: SearchController ResultsUpdating
extension PasswordListTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredPasswords = PasswordController.shared.passwords.filter { (password) -> Bool in
                guard let title = password.title else { return false }
                return title.lowercased().hasPrefix(searchText.lowercased())
            }
        } else {
            filteredPasswords = PasswordController.shared.passwords
        }
        tableView.reloadData()
    }
}

// MARK: SavedPasswordTableViewCell Delegate
extension PasswordListTableViewController: PasswordListTableViewCellDelegate {
    
    func lockButtonPressed(_ sender: PasswordListTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        
        let password = PasswordController.shared.passwords[indexPath.row]
        sender.lockIsPressed(password: password)
        
    }
    
    func lockButtonReleased(_ sender: PasswordListTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        
        let password = PasswordController.shared.passwords[indexPath.row]
        sender.lockIsReleased(password: password)
    }

    func copyToClipboardPressed() {
        let alert = UIAlertController(title: "Passcode copied!", message: nil, preferredStyle: UIAlertController.Style.alert)
          self.present(alert, animated: true, completion: nil)
          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
              alert.dismiss(animated: true, completion: nil)
          }
    }
}









