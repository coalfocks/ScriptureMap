//
//  BookNavigationViewController.swift
//  ScriptureMap
//
//  Created by Cole Fox on 11/16/17.
//  Copyright © 2017 Cole Fox. All rights reserved.
//

import Foundation
import UIKit

class BookNavigatorViewController : UITableViewController {
    //MARK: Properties
    var books: [Book]?
    var volumeId: Int?
    //offsets for different books
    var volumeToBook = [
        1 : 100,
        2 : 139,
        3 : 200,
        4 : 300,
        5 : 400
    ]
    
    //I could query the db for this info, but since it's not likely that Obadiah writes another chapter, this can safely speed up the process
    var singleChapterBooks = [
        165 : 1,
        201 : 0,
        202 : 0,
        203 : 0,
        204 : 0,
        208 : 1,
        209 : 1,
        210 : 1,
        211 : 1,
        216 : 1,
        301 : 0,
        404 : 1,
        405 : 1,
        406 : 1
    ]
    
    //TODO: make nav header show name of volume
    //TODO: if only one chapter, go to scripture
    
    //MARK: Storyboard
    struct storyboard {
        static let navCellId = "BookNavCell"
        static let chapterSegue = "WithChapters"
        static let verseSegue = "SingleChapter"
    }
    
    //MARK: VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if (volumeId != nil) {
            books = GeoDatabase.sharedGeoDatabase.booksForParentId(volumeId!)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let bookId = (tableView.indexPathForSelectedRow?.row)! +
            (volumeToBook[volumeId!]!) + 1
        if segue.identifier == storyboard.verseSegue {
            if let destinationViewController = segue.destination as? ScriptureNavigationViewController {
                destinationViewController.book = bookId
                destinationViewController.chapter = singleChapterBooks[bookId]
            }
        } else {
            if let destinationViewController = segue.destination as? ChapterNavigatorViewController {
                destinationViewController.bookId = bookId
            }
        }
    }
    //MARK: Config
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: storyboard.navCellId)!
        
        cell.textLabel?.text = books![indexPath.row].fullName.capitalized
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = singleChapterBooks[indexPath.row + (volumeToBook[volumeId!]!) + 1] {
            performSegue(withIdentifier: storyboard.verseSegue, sender: self)
        } else {
            performSegue(withIdentifier: storyboard.chapterSegue, sender: self)
        }

    }
}

