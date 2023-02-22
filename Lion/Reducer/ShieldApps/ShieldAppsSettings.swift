// ShieldAppsSettings.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import Foundation

extension ShieldAppsSettings.State {
    static let `default`: Self = .init(items: [])
}

struct ShieldAppsSettings: ReducerProtocol {
    struct State: Equatable, Codable {
        @NotCoded var isPresented: Bool = false
        var items: IdentifiedArrayOf<ShieldAppsItem.State>
        var isSelectedItemANewItem: Bool = false
        @NotCoded var selectedItem: ShieldAppsItem.State?
    }

    enum Action: Equatable {
        case toggleIsPresented(Bool)

        case addItem(ShieldAppsItem.State)
        case updateItem(ShieldAppsItem.State)
        case deleteItem(ShieldAppsItem.State)

        case items(id: ShieldAppsItem.State.ID, action: ShieldAppsItem.Action)

        case willAddItem
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

            case let .addItem(item):
                if !state.items.contains(item) {
                    state.items.insert(item, at: 0)
                }
                return .none

            case let .updateItem(item):
                if state.items.contains(item) {
                    state.items[id: item.id] = item
                }
                return .none

            case let .deleteItem(item):
                state.items[id: item.id] = nil
                return .none

            case .willAddItem:
                state.selectedItem = .default
                state.isSelectedItemANewItem = true
                return .none

            case let .selectedItem(id):
                guard let item = state.items[id: id] else { return .none }
                state.selectedItem = item
                state.isSelectedItemANewItem = false
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
