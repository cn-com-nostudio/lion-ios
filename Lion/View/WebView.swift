// WebView.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/1.

import SwiftUI
import UIKit
import WebKit

struct WebView: UIViewRepresentable {
    @State var url: String

    func makeUIView(context _: Context) -> some UIView {
        let webView = WKWebView(frame: .zero)

        webView.scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        webView.scrollView.contentInset = .zero
        webView.scrollView.contentInsetAdjustmentBehavior = .never
//        webView.scrollView.showsVerticalScrollIndicator = false

        webView.load(URLRequest(url: URL(string: url)!))
        return webView
    }

    func updateUIView(_: UIViewType, context _: Context) {}
}
