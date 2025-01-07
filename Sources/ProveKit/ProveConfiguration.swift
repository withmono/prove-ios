//
//  ProveConfiguration.swift
//  ProveKit
//
//  Created by Victor Olusoji on 06/01/2025.
//

import Foundation

public class ProveConfiguration {
    // required parameters
    public var sessionId: String
    public var onSuccess: (() -> Void?)

    // optional parameters
    public var reference: String?
    public var onEvent: ((_ event: ProveEvent) -> Void?)?
    public var onClose: (() -> Void?)?

    public init(
        sessionId: String,
        onSuccess: @escaping (() -> Void?),
        reference: String? = nil,
        onEvent: ((_ event: ProveEvent) -> Void?)? = nil,
        onClose: (() -> Void?)? = nil,

        redirectUrl: String? = nil,
        scope: [String]? = nil,
        personalInfo: [String]? = nil,
        identity: [String]? = nil
    ) {
        self.sessionId = sessionId
        self.onSuccess = onSuccess

        if reference != nil {
            self.reference = reference
        } else {
            self.reference = nil
        }

        if onEvent != nil {
            self.onEvent = onEvent!
        } else {
            self.onEvent = nil
        }

        if onClose != nil {
            self.onClose = onClose!
        } else {
            self.onClose = nil
        }
    }
}
