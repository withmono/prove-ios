//
//  ProveEvent.swift
//  ProveKit
//
//  Created by Victor Olusoji on 06/01/2025.
//

import Foundation

public struct ProveEvent {
    public let eventName: String  // name of event
    public let data: ProveData  // holds all event related data

    public init(
        eventName: String,
        type: String,
        reference: String? = nil,
        pageName: String? = nil,
        errorType: String? = nil,
        errorMessage: String? = nil,
        reason: String? = nil,
        timestamp: Date
    ) {
        self.eventName = eventName

        let data = ProveData(
            type: type,
            reference: reference,
            pageName: pageName,
            errorType: errorType,
            errorMessage: errorMessage,
            timestamp: timestamp)

        self.data = data
    }
}
