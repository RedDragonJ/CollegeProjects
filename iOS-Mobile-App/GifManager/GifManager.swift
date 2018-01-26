//
//  GifManager.swift
//  GifTest
//
//  Created by James on 1/3/18.
//  Copyright © 2018 James. All rights reserved.
//

import Foundation
import UIKit

class GifManager: NSObject
{
    /** Source must be HTML format **/
    func loadGif(view: UIWebView, source: String)
    {
        var gifData = Data()
        let gifUrl = URL.init(fileURLWithPath: Bundle.main.path(forResource: source, ofType: "html")!)
        
        guard let gifHTMLData = self.getURLData(url: gifUrl) else {
            return
        }
        
        gifData = gifHTMLData
        view.alpha = 0.0
        
        self.loadFile(webView: view, data: gifData, url: gifUrl.deletingLastPathComponent())
    }
    
    func loadFile(webView: UIWebView, data: Data, url: URL)
    {
        webView.load(data, mimeType:"text/html", textEncodingName: "UTF-8", baseURL: url)
        UIView.animate(withDuration: 2.0, animations: {
            webView.alpha = 1.0
        })
    }
    
    func getURLData(url: URL) -> Data?
    {
        var urlData: Data?
        do
        {
            urlData = try Data.init(contentsOf: url)
            return urlData!
        }
        catch
        {
            print("ERROR: Failed get data from URL")
            return nil
        }
    }
}
