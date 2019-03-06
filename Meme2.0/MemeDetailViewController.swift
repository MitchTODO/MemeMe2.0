 //
//  MemeDetailViewController.swift
//   MemeMe2.0
//
//  Created by mitch on 3/1/19.
//  Copyright © 2019 mitch. All rights reserved.
//

import UIKit



class MemeDetailViewController: UIViewController {
    
    // share meme struct array
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // shared variable
    var memeIndex : Int?
    
    @IBOutlet weak var myImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // use shared variable to index meme array for UIimage
        myImage.image = self.appDelegate.memes[memeIndex!].memedImage
    }
    
    // MARK: -Edit Meme Segue
    // Edit button executes segue
    // pass index integer allows meme reconstuction
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "toCreate") {
            let destinationVC = segue.destination as! MemeEditorViewController
            destinationVC.index = memeIndex
        }
    }
}
