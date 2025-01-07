//
//  ProveWidget.swift
//  ProveKit
//
//  Created by Victor Olusoji on 06/01/2025.
//

import Foundation
import UIKit
import WebKit

public class ProveWidget: UIViewController, WKUIDelegate {
    // required
    var sessionId: String
    let successHandler: (() -> Void?)

    // optionals
    var reference: String?

    // handlers
    let eventHandler: ((_ event: ProveEvent) -> Void?)?
    let closeHandler: (() -> Void?)?

    // loading view
    var progressView: UIProgressView

    init(configuration: ProveConfiguration) {
        // required
        self.sessionId = configuration.sessionId
        self.successHandler = configuration.onSuccess

        // optionals
        if configuration.reference != nil {
            self.reference = configuration.reference
        } else {
            self.reference = nil
        }

        // handlers
        if configuration.onEvent != nil {
            self.eventHandler = configuration.onEvent!
        } else {
            self.eventHandler = nil
        }

        if configuration.onClose != nil {
            self.closeHandler = configuration.onClose!
        } else {
            self.closeHandler = nil
        }

        self.progressView = UIProgressView(progressViewStyle: .bar)
        self.progressView.sizeToFit()
        super.init(nibName: nil, bundle: nil)

        self.progressView.frame = CGRect(
            x: 0, y: 0, width: self.view.frame.width * 2, height: 2)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        progressView.removeFromSuperview()
    }

    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.addObserver(
            self, forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new, context: nil)

        return webView
    }()

    override public func observeValue(
        forKeyPath keyPath: String?, of object: Any?,
        change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?
    ) {

        if keyPath == "estimatedProgress" {
            let progressFloat = Float(webView.estimatedProgress)
            self.progressView.setProgress(progressFloat, animated: true)
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        let contentController = self.webView.configuration.userContentController
        contentController.add(self, name: "mono")

        var components = URLComponents()
        components.scheme = "https"
        components.host = "develop.d121npziv08191.amplifyapp.com"

        // TODO: Update host
        //        components.host = "prove.mono.co"

        // add prove session id as path
        components.path = "/\(sessionId)"

        let request = URLRequest(url: components.url!)
        webView.load(request)

        if self.eventHandler != nil {
            let proveEvent = ProveEvent(
                eventName: "OPENED", type: "mono.prove.widget_opened",
                reference: self.reference, timestamp: Date())
            self.eventHandler!(proveEvent)
        }
    }

    func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(webView)
        self.view.addSubview(progressView)

        if #available(iOS 12.0, *) {
            NSLayoutConstraint.activate([
                webView.topAnchor
                    .constraint(
                        equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                webView.leftAnchor
                    .constraint(
                        equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
                webView.bottomAnchor
                    .constraint(
                        equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                webView.rightAnchor
                    .constraint(
                        equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            ])
        }
    }
}

extension ProveWidget: WKScriptMessageHandler {
    public func parseJSON(str: String?) -> [String: AnyObject]? {
        if let data = str?.data(using: .utf8) {
            do {
                let json =
                    try JSONSerialization.jsonObject(with: data, options: [])
                    as? [String: AnyObject]
                return json
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
                return nil
            }
        }

        return nil
    }

    public func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        if message.name == "mono",
            let messageBody = parseJSON(str: (message.body as! String))
        {
            let type = messageBody["type"] as! String

            // pass data on to onEvent
            if self.eventHandler != nil {
                let proveEvent = ProveEventMapper.map(messageBody)
                self.eventHandler!(proveEvent!)
            }

            switch type {
            case "mono.prove.identity_verified":
                self.successHandler()
                self.dismiss(animated: true, completion: nil)
                break
            case "mono.prove.widget.closed":
                if closeHandler != nil {
                    closeHandler!()
                }

                self.dismiss(animated: true, completion: nil)
                break
            default:
                break
            }
        }
    }
}

extension ProveWidget: WKNavigationDelegate {
    public func webView(
        _ webView: WKWebView, didFinish navigation: WKNavigation!
    ) {
        webView.evaluateJavaScript(
            "window.MonoClientInterface = window.webkit.messageHandlers.mono;")

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.5,
            execute: {
                self.progressView.isHidden = true
            })
    }

    public func webView(
        _ webView: WKWebView,
        didStartProvisionalNavigation navigation: WKNavigation!
    ) {
        progressView.isHidden = false
    }

    public func webView(
        _ webView: WKWebView, didFail navigation: WKNavigation!,
        withError error: Error
    ) {
        self.dismiss(animated: true, completion: nil)
    }

    public func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: Error
    ) {
        self.dismiss(animated: true, completion: nil)
    }
}
