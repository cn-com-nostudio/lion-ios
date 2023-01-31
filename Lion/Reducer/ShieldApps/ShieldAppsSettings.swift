// ShieldAppsSettings.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/29.

import ComposableArchitecture
import Foundation

extension ShieldAppsSettings.State {
    static let `default`: Self = .init(isPresented: false, items: [])
}

struct ShieldAppsSettings: ReducerProtocol {
    struct State: Equatable, Codable {
        @NotCoded var isPresented: Bool
        var items: IdentifiedArrayOf<ShieldAppsItem.State>
        @NotCoded var selectedItem: ShieldAppsItem.State?
    }

    enum Action: Equatable {
        case toggleIsPresented(Bool)

        case addItem
        case updateItem(ShieldAppsItem.State)
        case deleteItem(ShieldAppsItem.State)

        case items(id: ShieldAppsItem.State.ID, action: ShieldAppsItem.Action)

        case selectedItem(UUID)
        case deselectedItem
        case item(ShieldAppsItem.Action)
    }

    @Dependency(\.uuid) var uuid

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .toggleIsPresented(isPresented):
                state.isPresented = isPresented
                return .none

            case .addItem:
                let item: ShieldAppsItem.State = .init(id: uuid())
                state.items.insert(item, at: 0)
                return .none

            case let .updateItem(item):
                if state.items.contains(item) {
                    state.items[id: item.id] = item
                }
                return .none

            case let .deleteItem(item):
                state.items[id: item.id] = nil
                return .none

            case let .selectedItem(id):
                guard let item = state.items[id: id] else { return .none }
                state.selectedItem = item
                return .none

            case .deselectedItem:
                state.selectedItem = nil
                return .none

            default:
                return .none
            }
        }
        .forEach(\.items, action: /Action.items) {
            ShieldAppsItem()
        }
        .ifLet(\.selectedItem, action: /Action.item) {
            ShieldAppsItem()
        }
    }
}
