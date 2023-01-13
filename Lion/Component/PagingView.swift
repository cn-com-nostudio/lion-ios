// PagingView.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2022/12/28.

import SwiftUI

public struct PagingView<Views: View>: View {
    public typealias Config = _PagingViewConfig
    public typealias PageIndex = _VariadicView.Children.Index

    private let tree: _VariadicView.Tree<Root, Views>

    public init(
        config: Config = Config(),
        page: Binding<PageIndex>? = nil,
        @ViewBuilder _ content: () -> Views
    ) {
        tree = _VariadicView.Tree(
            Root(config: config, page: page),
            content: content
        )
    }

    public init(
        direction: _PagingViewConfig.Direction,
        page: Binding<PageIndex>? = nil,
        @ViewBuilder _ content: () -> Views
    ) {
        tree = _VariadicView.Tree(
            Root(config: .init(direction: direction), page: page),
            content: content
        )
    }

    public var body: some View { tree }

    struct Root: _VariadicView.UnaryViewRoot {
        let config: Config
        let page: Binding<PageIndex>?

        func body(children: _VariadicView.Children) -> some View {
            _PagingView(
                config: config,
                page: page,
                views: children
            )
        }
    }
}

struct PagingView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            Color.red
            Color.blue
            Color.green
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .previewDisplayName("TabView")

        PagingView {
            Color.red
            Color.blue
            Color.green
        }
        .previewDisplayName("PagingView Without Config")

        PagingView(config: .init(margin: 20, spacing: 10)) {
            Group {
                Color.red
                Color.green
                Color.blue
            }
            .mask(RoundedRectangle(cornerRadius: 10))
            .aspectRatio(2, contentMode: .fit)
        }
        .previewDisplayName("PagingView With Config")
    }
}
