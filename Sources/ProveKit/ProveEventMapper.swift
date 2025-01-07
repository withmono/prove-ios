//
//  ProveEventMapper.swift
//  ProveKit
//
//  Created by Victor Olusoji on 06/01/2025.
//

import Foundation

class ProveEventMapper {
    public static let eventNames = [
        "mono.prove.widget_opened": "OPENED",
        "mono.prove.error_occurred": "ERROR",
        "mono.prove.identity_verified": "IDENTITY_VERIFIED",
    ]

    static func map(_ dictionary: [String: Any]) -> ProveEvent? {
        // get event type
        var type = dictionary["type"] as? String
        if type == nil {
            type = "UNKNOWN"
        }

        let name = eventNames[type ?? "UNKNOWN", default: "UNKNOWN"]

        // get data variables
        if let data = dictionary["data"] as? [String: Any] {
            let reference =
                extractProperty(name: "reference", data: data) as? String
            let pageName =
                extractProperty(name: "pageName", data: data) as? String
            let errorType =
                extractProperty(name: "errorType", data: data) as? String
            let errorMessage =
                extractProperty(name: "errorMessage", data: data) as? String
            let reason =
                extractProperty(name: "reason", data: data) as? String

            var unixTimestamp =
                extractProperty(name: "timestamp", data: data) as? Int
            if unixTimestamp != nil {
                unixTimestamp = unixTimestamp! / 1000
            } else {
                unixTimestamp = Int(Date().timeIntervalSince1970)
            }

            let timestamp = Date(
                timeIntervalSince1970: TimeInterval(unixTimestamp!))

            return ProveEvent(
                eventName: name,
                type: type ?? "UNKNOWN",
                reference: reference,
                pageName: pageName,
                errorType: errorType,
                errorMessage: errorMessage,
                reason: reason,
                timestamp: timestamp)
        } else {
            return ProveEvent(
                eventName: name, type: type ?? "UNKNOWN", timestamp: Date())
        }

    }

    static func extractProperty(name: String, data: [String: Any]) -> Any {
        let reference = data[name]
        return reference as Any
    }
}
