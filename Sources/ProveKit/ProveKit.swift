//
//  ProveKit.swift
//  ProveKit
//
//  Created by Victor Olusoji on 06/01/2025.
//

import Foundation
import UIKit

@MainActor
public class ProveKit {
    init() {}

    public static func create(configuration: ProveConfiguration)
        -> UIViewController
    {
        let widget = ProveWidget(configuration: configuration)

        return widget
    }
}
