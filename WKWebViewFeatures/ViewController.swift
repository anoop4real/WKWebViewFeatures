//
//  ViewController.swift
//  WKWebViewFeatures
//
//  Created by anoopm on 01/07/18.
//  Copyright © 2018 anoopm. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var webViewHolder:UIView!
    var wkWebView:WKWebView!
    var wkWebScriptHandler:WKWebScriptHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeWKWebView()
        //loadSimpleUrlRequest()
        //loadString()
        //loadUrl()
        loadContentFromResources()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // Set up the wkwebview and register delegates
    private func initializeWKWebView(){
        
        wkWebView = WKWebView(frame: webViewHolder.bounds)
        wkWebView.navigationDelegate = self
        wkWebView.uiDelegate = self
        webViewHolder.addSubview(wkWebView)
        
        // Move out all script handling logic from view controller
        wkWebScriptHandler = WKWebScriptHandler(handlerforWebView: wkWebView)
        wkWebScriptHandler.registerScriptsAndEvents()
        
        
    }
    // Function to load a simple URL directly
    private func loadSimpleUrlRequest(){
        let url = "http://www.google.com"
        let urlRequest = url.asURLRequest()
        wkWebView.load(urlRequest!)
    }
    
    // Load the html from local resource folder
    // MARK: Method to load html from resources
    private func loadUrl(){
        if let resourceUrl = Bundle.main.url(forResource: "start", withExtension: "html") {
            let urlRequest = URLRequest.init(url: resourceUrl)
            wkWebView.load(urlRequest)
        }
    }
    
    private func loadString(){
        let stri = "<head><head><html><body><h1>Hello!</h1></body></html>"
        wkWebView.loadHTMLString(stri, baseURL: nil)
    }
    
    private func loadContentFromResources(){
        
        if let htmlPath = Bundle.main.path(forResource: "start", ofType: "html"){
            
            do{
                let contents =  try String(contentsOfFile: htmlPath, encoding: .utf8)
                let baseUrl = URL(fileURLWithPath: htmlPath)
                wkWebView.loadHTMLString(contents, baseURL: baseUrl)
            }catch{
                print("Error")
            }
            
        }
    }

    // MARK: JS CALLS
    @IBAction func executeJS(){
        // "http://www.freeiconspng.com/uploads/smiley-icon-1.png"
        let path = "http://www.freeiconspng.com/uploads/smiley-icon-1.png"
        let formattedPath = "\"\(path)\""
        evaluateWithJavaScriptExpression(jsExpression: "changeImagePathWith(\(formattedPath));")
    }

    // Call js functions from native controls
    @IBAction func rightTapped(){
        
        evaluateWithJavaScriptExpression(jsExpression: "rightTapped();")
    }
    
    // Call js functions from native controls
    @IBAction func leftTapped(){
        evaluateWithJavaScriptExpression(jsExpression: "leftTapped();")
    }

    fileprivate func evaluateWithJavaScriptExpression(jsExpression: String) {
        
        wkWebView.evaluateJavaScript(jsExpression, completionHandler: {(_, error) in
            if((error) != nil) {
                print(error?.localizedDescription ?? "")
            } else {
                
            }
        })
    }

}

extension ViewController:WKNavigationDelegate, WKUIDelegate {
    
    // MARK: Webview Navigation Delegates
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        
        switch navigationAction.navigationType {
        case .linkActivated:
            // Navigate to any internal links clicked
            wkWebView.load(navigationAction.request)
        case .reload:
            print("reloaded")
        default:
            break
        }
        decisionHandler(.allow)
    }
    // Handle alert
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void){
        
        let alertController = UIAlertController(title: message, message: nil,
                                                preferredStyle: .alert);
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel) {
            _ in completionHandler()}
        );
        
        self.present(alertController, animated: true, completion: {});
    }
    
    
    
}
extension String{
    
    func asURLRequest()->URLRequest?{
        var urlRequest:URLRequest?
        if self.isValidForUrl(){
            if let url = URL(string: self){
                urlRequest = URLRequest(url: url)
            }
        }else{
            urlRequest = nil
        }
        return urlRequest
    }
    func isValidForUrl() -> Bool {
        
        if(self.hasPrefix("http") || self.hasPrefix("https")) {
            return true
        }
        return false
    }
}

