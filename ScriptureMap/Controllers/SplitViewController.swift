//
//  SplitViewController.swift
//  ScriptureMap
//
//  Created by Cole Fox on 11/20/17.
//  Copyright © 2017 Cole Fox. All rights reserved.
//

import Foundation
import UIKit

class SplitViewController : UISplitViewController, UISplitViewControllerDelegate {
    
    func primaryViewController(forExpanding splitViewController: UISplitViewController) -> UIViewController? {
        return splitViewController.viewControllers.first
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        return splitViewController.viewControllers.last
    }
}
