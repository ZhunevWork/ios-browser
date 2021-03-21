//
//  ViewController.swift
//  browser
//
//  Created by Дмитрий Жунёв on 21.03.2021.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate {


    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var progressBar: UIProgressView!
    
    func searchRequest(text: String) -> URLRequest? {
        var urlText = ""
        
        if (text.contains("http://") || text.contains("https://")) {
            urlText = text
        } else {
            let search = "https://www.google.com/search?q="
            urlText = search + text
        }
        
        if let url = URL(string: urlText) {
            let request = URLRequest(url: url)
            return request
        } else {
            return nil
        }
    }
    
    @IBAction func search(_ sender: UIButton) {
        guard let searchText = searchTextField.text else { return }
        guard let request = searchRequest(text: searchText) else { return }
        webView.load(request)
    }
    
    @IBAction func refresh(_ sender: UIButton) {
        webView.reload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let site = "https://apple.com"
        searchTextField.text = site
        let url = URL(string: site)
        let request = URLRequest(url: url!)
        webView.load(request)
        webView.allowsBackForwardNavigationGestures = true
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
        webView.addSubview(progressBar)
        view.addSubview(webView)
        webView.uiDelegate = self
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.progressBar.alpha = 1.0
            progressBar.setProgress(Float(webView.estimatedProgress), animated: true)
            if self.webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in self.progressBar.alpha = 0.0 }, completion: { (finised:Bool) -> Void in self.progressBar.progress = 0})
            }
        }
    }
}

