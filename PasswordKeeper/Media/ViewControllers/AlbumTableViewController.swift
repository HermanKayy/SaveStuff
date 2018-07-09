//
//  SavedPhotosTableViewController.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/10/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import UIKit

class AlbumTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredAlbums: [Album]?
    var tableViewIsEditing = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !AlbumController.shared.albums.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        filteredAlbums = AlbumController.shared.albums
        tabBarController?.tabBar.isHidden = false
        self.definesPresentationContext = true
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true 
        navigationController?.navigationBar.barTintColor = UIColor.ColorPalette.themeColor
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationItem.title = "Album"
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
        guard let filteredAlbums = filteredAlbums else { return AlbumController.shared.albums.count }
        return filteredAlbums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "photosCell", for: indexPath) as? AlbumListTableViewCell else { return UITableViewCell() }
        
        if let albums = filteredAlbums {
            let album = albums[indexPath.row]
            cell.album = album
        } else {
            let album = AlbumController.shared.albums[indexPath.row]
            cell.album = album
        }
        cell.selectionStyle = .none
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let album = AlbumController.shared.albums[indexPath.row]
            AlbumController.shared.deleteAlbum(album: album)
            filteredAlbums = AlbumController.shared.albums
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if AlbumController.shared.albums.isEmpty {
                tableViewIsEditing = false
                tableView.setEditing(false, animated: true)
                navigationItem.rightBarButtonItem?.isEnabled = false 
                navigationItem.rightBarButtonItem?.title = "Edit"
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
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
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Album", message: "Please add an album name", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Album Name"
            textField.becomeFirstResponder()
        }
        let done = UIAlertAction(title: "Done", style: .default) { (_) in
            guard let textFields = alert.textFields, let text = textFields[0].text, !text.isEmpty else { return }
            AlbumController.shared.addAlbum(title: text, image: #imageLiteral(resourceName: "noImage"))
            self.filteredAlbums = AlbumController.shared.albums
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(done)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMediaVC" {
            guard let destinationVC =  segue.destination as? MediaListViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            let album = AlbumController.shared.albums[indexPath.row]
            destinationVC.album = album
            destinationVC.navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
}

extension AlbumTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredAlbums = AlbumController.shared.albums.filter { (album) -> Bool in
                guard let title = album.title else { return false }
                return title.lowercased().hasPrefix(searchText.lowercased())
            }
        } else {
            filteredAlbums = AlbumController.shared.albums
        }
        tableView.reloadData()
    }
}





