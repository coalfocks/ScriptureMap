//
//  VolumeNavigatorViewController.swift
//  ScriptureMap
//
//  Created by Cole Fox on 11/16/17.
//  Copyright © 2017 Cole Fox. All rights reserved.
//

import Foundation
import UIKit

class VolumeNavigatorViewController : UITableViewController {
    //MARK: Properties
    var volumes: [(Int, String)]?
    var selectedVolume: Int?
    
    //MARK: Storyboard
    struct storyboard {
        static let navCellId = "VolumeNavCell"
    }
    
    //MARK: VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        volumes = GeoDatabase.sharedGeoDatabase.volumes()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? BookNavigatorViewController {
            destinationViewController.volumeId = (tableView.indexPathForSelectedRow?.row)! + 1
        }
    }
    
    //MARK: Config
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return volumes!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: storyboard.navCellId)!
        
        cell.textLabel?.text = volumes![indexPath.row].1.capitalized
        return cell
    }
}
