// TransactionObserver.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/5.

import StoreKit

// Refer to: https://developer.apple.com/documentation/storekit/transaction/3851206-updates

final class TransactionObserver {
    var updates: Task<Void, Never>?

    init() {
        updates = newTransactionListenerTask()
    }

    deinit {
        // Cancel the update handling task when you deinitialize the class.
        updates?.cancel()
    }

    private func newTransactionListenerTask() -> Task<Void, Never> {
        Task(priority: .background) {
            for await verificationResult in Transaction.updates {
                self.handle(updatedTransaction: verificationResult)
            }
        }
    }

    private func handle(updatedTransaction verificationResult: VerificationResult<Transaction>) {
        guard case let .verified(transaction) = verificationResult else {
            // Ignore unverified transactions.
            return
        }

        if let revocationDate = transaction.revocationDate {
            // Remove access to the product identified by transaction.productID.
            // Transaction.revocationReason provides details about
            // the revoked transaction.
            // ...
        } else if let expirationDate = transaction.expirationDate,
                  expirationDate < Date()
        {
            // Do nothing, this subscription is expired.
            return
        } else if transaction.isUpgraded {
            // Do nothing, there is an active transaction
            // for a higher level of service.
            return
        } else {
            // Provide access to the product identified by
            // transaction.productID.
            // ...
        }
    }
}
