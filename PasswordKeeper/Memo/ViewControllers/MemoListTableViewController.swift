//
//  MemoListTableViewController.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/29/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import UIKit

class MemoListTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredMemos: [Memo]?
    var tableViewIsEditing = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !MemoController.shared.memos.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = true 
        }
        tabBarController?.tabBar.isHidden = false
        filteredMemos = MemoController.shared.memos
        self.definesPresentationContext = true 
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Memo"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = UIColor.ColorPalette.themeColor
 navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        tableView.separatorStyle = .none
        tableView.tableHeaderView = searchController.searchBar
        
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
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let filteredMemos = filteredMemos else { return MemoController.shared.memos.count }
        return filteredMemos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath) as? MemoListTableViewCell else { return UITableViewCell() }
        
        if let memos = filteredMemos {
            let memo = memos[indexPath.row]
            cell.memo = memo
        } else {
            let memo = MemoController.shared.memos[indexPath.row]
            cell.memo = memo
        }
        cell.selectionStyle = .none
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let memo = MemoController.shared.memos[indexPath.row]
            MemoController.shared.deleteMemo(memo: memo)
            filteredMemos = MemoController.shared.memos
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if MemoController.shared.memos.isEmpty {
                tableViewIsEditing = false
                navigationItem.rightBarButtonItem?.isEnabled = false
                tableView.setEditing(false, animated: true)
                navigationItem.rightBarButtonItem?.title = "Edit"
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMemoDetailVC" {
            guard let destinationVC = segue.destination as? MemoDetailViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            let memo = MemoController.shared.memos[indexPath.row]
            destinationVC.memo = memo
        }
    }
    
    @IBAction func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        if tableViewIsEditing == false {
            tableViewIsEditing = true
            tableView.setEditing(true, animated: true)
            navigationItem.rightBarButtonItem?.title = "Cancel"

        } else {
            tableViewIsEditing = false
            tableView.setEditing(false, animated: true)
            navigationItem.rightBarButtonItem?.title = "Edit"
        }
    }
}

extension MemoListTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredMemos = MemoController.shared.memos.filter { (memo) -> Bool in
                guard let title = memo.title else { return false }
                return title.lowercased().hasPrefix(searchText.lowercased())
            }
        } else {
            filteredMemos = MemoController.shared.memos
        }
        tableView.reloadData()
    }
}



















