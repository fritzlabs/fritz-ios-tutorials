//
//  Models+Fritz.swift
//  FritzStyleTransferDemo
//
//  Created by Jameson Toole on 12/28/18.
//  Copyright © 2018 Fritz. All rights reserved.
//

import Fritz

@available(iOS 11.0, *)
public enum FritzVisionStyleTypes: CaseIterable {
    case style_1
    case style_2
    
    public func getModel() -> FritzVisionFlexibleStyleModel {
        switch (self) {
        case .style_1: return FritzVisionFlexibleStyleModel(model: styleOne())
        case .style_2: return FritzVisionFlexibleStyleModel(model: styleTwo())
        }
    }
}

extension styleOne: SwiftIdentifiedModel {
    
    static let modelIdentifier = "abc-123"
    static let packagedModelVersion = 1
    static let session = Session(apiKey: "abc-123")
}

extension styleTwo: SwiftIdentifiedModel {
    
    static let modelIdentifier = "abc-123"
    static let packagedModelVersion = 1
    static let session = Session(apiKey: "abc-123")
}
