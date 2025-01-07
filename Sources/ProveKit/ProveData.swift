//
//  ProveData.swift
//  ProveKit
//
//  Created by Victor Olusoji on 06/01/2025.
//

import Foundation

public struct ProveData {
    public let type: String  // type of event mono.connect.xxxx
    public let reference: String?  // reference passed through the prove setup
    public let pageName: String?  // name of page the widget exited on
    public let errorType: String?  // error thrown by widget
    public let errorMessage: String?  // error message describing the error
    public let reason: String?  // reason for exiting the widget
    public let timestamp: Date  // timestamp of the event converted to Date object

    public init(
        type: String,
        reference: String? = nil,
        pageName: String? = nil,
        errorType: String? = nil,
        errorMessage: String? = nil,
        reason: String? = nil,
        timestamp: Date
    ) {
        self.type = type
        self.reference = reference
        self.pageName = pageName
        self.errorType = errorType
        self.errorMessage = errorMessage
        self.reason = reason
        self.timestamp = timestamp
    }
}
