//
//  SentMemesViewController.swift
//   MemeMe2.0
//
//  Created by mitch on 3/1/19.
//  Copyright © 2019 mitch. All rights reserved.
//

import UIKit


class SentMemesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // share appDelegate delegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let reuseIdentifier = "cell" // collections cell identifier
    let tableReuseIdentifier = "tcell" // table cell identifier

    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var boringLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        // collection view is default
        tableview.alpha = 0
        collectionview.alpha = 1

    }
    
    // reload meme cells
    override func viewWillAppear(_ animated: Bool) {
        // if meme array is empty write text to label
        if appDelegate.memes.count == 0{
            boringLabel.text = "Go make some memes!"
        }else{
            boringLabel.text = ""
        }
        self.collectionview!.reloadData()
        self.tableview!.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.appDelegate.memes.count
    }
    
    // make a cell for each meme struct in appDelegate array
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UIImage in the cell
        cell.myLabel.image = self.appDelegate.memes[indexPath.item].memedImage
        return cell
    }
    
    
    // MARK: - UITableViewDataSource protocol
    
    // tell the table view how many rows to make
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.appDelegate.memes.count
    }
    
    // make a row for each meme struct in appDelegate array
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // get a reference to our storyboard cell
        let cell = tableView.dequeueReusableCell(withIdentifier: tableReuseIdentifier, for: indexPath as IndexPath) as! TableViewCell
        
        // Use the outlet in our custom class to get a reference to the UIImage in the cell
        cell.tImage.image = self.appDelegate.memes[indexPath.row].memedImage
        return cell
    }
    
    // MARK: -Prepare for segue
    // sender is used to index appDelegate meme array
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "toEdit") {
            let destinationVC = segue.destination as! MemeDetailViewController
            let index = sender as? Int
            destinationVC.memeIndex = index
        }
    }
    
    // MARK: - Handle tap events
    // handle tap events for both collections and table view

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // integer representing what cell was pressed in the collections view
        let cell = indexPath.item
        performSegue(withIdentifier: "toEdit", sender: cell)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // integer representing what row was pressed in the table view
        let cell = indexPath.row
        performSegue(withIdentifier: "toEdit", sender: cell)
    }
    
    // MARK: - Jump between table and collections view
    // alpha factors used to hide and show views
    @IBAction func viewChanger(_ sender: UIButton) {
        if sender.tag == 1{
            tableview.alpha = 1
            collectionview.alpha = 0
        }else{
            tableview.alpha = 0
            collectionview.alpha = 1
        }

    }
    
}
