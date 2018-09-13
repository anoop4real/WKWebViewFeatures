//
//  WKWebScriptHandler.swift
//  WKWebVIewSample
//
//  Created by "".
//  Copyright © 2017. All rights reserved.
//

import UIKit
import WebKit

class WKWebScriptHandler: NSObject, WKScriptMessageHandler {
    
    var wkWebView:WKWebView!
    // Events to listen
    let events = ["postascript","sizeNotification"]
    init(handlerforWebView webView : WKWebView){
        wkWebView = webView
        super.init()
    }
    // MARK: Set up script handlers
    func registerScriptsAndEvents() {
        
        let controller = self.wkWebView.configuration.userContentController
        for event in events {
            controller.add(self, name: event)
        }
        // Load the entire script to the document
        controller.addUserScript(fetchScript())
    }
    // Script call back. The call backs for the vevents that ypu listen to , here I listen to "postascript","sizeNotification"
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage){
        
        if let messageInfo = message.body as? Dictionary<String, Any>{
            print(messageInfo["height"] ?? "")
        }
        print("Received script message \(message.body)")
        
    }
    
    private func fetchScript() -> WKUserScript!{
        
        var jsScript = ""
        if let jsPath = Bundle.main.path(forResource: "hello", ofType: "js", inDirectory: "scripts"){
            do
            {
                jsScript = try String(contentsOfFile: jsPath, encoding: String.Encoding.utf8)
            }catch{
                
                print("Error")
            }
        }
        
        let wkAlertScript = WKUserScript(source: jsScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        return wkAlertScript
    }
    
    private func sizeChangeScript() -> WKUserScript!{
        
        let jsScript = "window.onload=function () { window.webkit.messageHandlers.sizeNotification.postMessage({width: document.width, height: document.body.scrollHeight});};"
        let wkSizeChangeScript = WKUserScript(source: jsScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        return wkSizeChangeScript
    }

}
