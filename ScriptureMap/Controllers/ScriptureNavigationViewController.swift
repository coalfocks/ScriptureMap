//
//  ScriptureNavigationViewController.swift
//  ScriptureMap
//
//  Created by Cole Fox on 11/17/17.
//  Copyright © 2017 Cole Fox. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import MapKit

class ScriptureNavigationViewController : UIViewController, WKNavigationDelegate {
    //MARK: Outlets
    
    //get volume,book,chapter
    //MARK: Properties
    var book: Int?
    var chapter: Int?
    var webView: WKWebView!
    private weak var map: MapViewController?
    var geoPlaces: [Int : GeoPlace]?
    var selectedPlace: GeoPlace?
    struct storyboard {
        static let mapSegueID = "Show Map"
    }
    
    //MARK: VC lifecycle
    override func loadView() {
        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.preferences.javaScriptEnabled = false
        webView = WKWebView(frame: .zero, configuration: webViewConfig)
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureDetailViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDetailViewController()
        let html = ScriptureRenderer.sharedRenderer.htmlForBookId(self.book!, chapter: self.chapter!)
        setGeoplaces(places: html.1)
        webView.loadHTMLString(html.0, baseURL: nil)
        map?.setPins(pins: Array(geoPlaces!.values))
    }
    
    //MARK: WebView Event Handling
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let path = navigationAction.request.url?.absoluteString {
            if path.hasPrefix(ScriptureRenderer.Constant.baseUrl) {
                if let mapVC = map {
                    print("The path is: \(path)")
                    mapVC.zoomOnPlace(place: (geoPlaces?[Int((navigationAction.request.url?.lastPathComponent)!)!])!)
                } else {
                    self.selectedPlace = geoPlaces?[Int((navigationAction.request.url?.lastPathComponent)!)!]
                    performSegue(withIdentifier: storyboard.mapSegueID, sender: self)
                }
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == storyboard.mapSegueID {
            if let destination = segue.destination as? MapViewController {
                destination.selectedGeoPlace = self.selectedPlace
            }
        }
    }
    
    
    //MARK: Helpers
    
    private func configureDetailViewController() {
        if let splitVC = splitViewController {
            if let mapVC = splitVC.viewControllers.last as? MapViewController {
                map = mapVC
            } else {
                map = splitVC.viewControllers.last as? MapViewController
            }
        } else {
            map = nil
        }
    }
    
    private func setGeoplaces(places: [GeoPlace]) {
        self.geoPlaces = [Int : GeoPlace]()
        for p in places {
            geoPlaces?[p.id] = p
        }
        
    }
}
