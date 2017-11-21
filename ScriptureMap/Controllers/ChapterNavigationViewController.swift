//
//  ChapterNavigatorViewController.swift
//  ScriptureMap
//
//  Created by Cole Fox on 11/16/17.
//  Copyright © 2017 Cole Fox. All rights reserved.
//

import Foundation
import UIKit

class ChapterNavigatorViewController : UITableViewController {
    //MARK: Properties
    var chapters: [Int]?
    var bookId: Int?
    //TODO: show title if applicable (ie introduction)
    
    //MARK: Storyboard
    struct storyboard {
        static let navCellId = "ChapterNavCell"
    }
    
    //MARK: VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let ID = bookId {
            chapters = GeoDatabase.sharedGeoDatabase.getChaptersForBook(bookId: ID)
            if chapters?.count == 1 {
                performSegue(withIdentifier: "SingleChapter", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? ScriptureNavigationViewController {
            destinationViewController.book = bookId
            if segue.identifier == "SingleChapter" {
                destinationViewController.chapter = 0
            } else {
                destinationViewController.chapter = (tableView.indexPathForSelectedRow?.row)! + 1
            }
        }
    }
    
    //MARK: Config
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chapters!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: storyboard.navCellId)!
        
        cell.textLabel?.text = "Chapter \(chapters![indexPath.row])"
        //TODO:append chapter with book name
        //TODO:use section for D&C
        return cell
    }
}

