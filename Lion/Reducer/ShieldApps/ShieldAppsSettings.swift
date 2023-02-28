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
        @NotCoded var selectedItem: ShieldAppsItem.State?
    }

    enum ItemAction {
        case add
        case update
        case delete
    }

    enum Action: Equatable {
        case toggleIsPresented(Bool)

        case willAddItem(ShieldAppsItem.State)
        case addItem(ShieldAppsItem.State)
        case willUpdateItem(ShieldAppsItem.State)
        case updateItem(ShieldAppsItem.State)
        case willDeleteItem(ShieldAppsItem.State)
        case deleteItem(ShieldAppsItem.State)

        case selectNewItem
        case selectItem(UUID)
        case deselectItem

        case items(id: ShieldAppsItem.State.ID, action: ShieldAppsItem.Action)
        case selectedItem(ShieldAppsItem.Action)
    }

    @Dependency(\.uuid) var uuid

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .toggleIsPresented(isPresented):
                state.isPresented = isPresented
                return .none

            case let .addItem(item):
                var copiedItem = item
                copiedItem.isNew = false
                state.items[id: copiedItem.id] = copiedItem
                return .task { .deselectItem }

            case let .updateItem(item):
                state.items[id: item.id] = item
                return .task { .deselectItem }

            case let .deleteItem(item):
                state.items[id: item.id] = nil
                return .task { .deselectItem }

            case .selectNewItem:
                state.selectedItem = .new
                return .none

            case let .selectItem(id):
                guard let item = state.items[id: id] else { return .none }
                state.selectedItem = item
                return .run { send in
                    await send(.selectedItem(.updateIsUpdating(false)))
                    await send(.selectedItem(.updateIsDeleting(false)))
                }

            case .deselectItem:
                state.selectedItem = nil
                return .none

            default:
                return .none
            }
        }
        .forEach(\.items, action: /Action.items) {
            ShieldAppsItem()
        }
        .ifLet(\.selectedItem, action: /Action.selectedItem) {
            ShieldAppsItem()
        }
    }
}
