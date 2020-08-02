//
//  LoginWebViewController.swift
//  GitHubClient
//
//  Created by Darya on 02.08.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

import WebKit

class LoginWebViewController: UIViewController, WKNavigationDelegate {

    private let webView = WKWebView()
    private let startURL: URL

    init(url: URL) {
        startURL = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: startURL))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        guard let url = navigationAction.request.url else {
            return
        }
        if LoginService.canRequestToken(url: url) {
            LoginService.requestAuthToken(url: url)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
