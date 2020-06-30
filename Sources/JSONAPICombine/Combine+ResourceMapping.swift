//
//  Combine+ResourceMapping.swift
//  APITest
//
//  Created by Mathew Polzin on 6/29/20.
//  Copyright © 2020 Mathew Polzin. All rights reserved.
//

import Foundation
import Combine
import JSONAPI
import JSONAPIResourceCache

public struct SingleEntityResultPair<Primary: CacheableResource> {
    public let primaryResource: Primary
    public let allEntities: Primary.Cache
}

public struct ManyEntityResultPair<Primary: CacheableResource> {
    public let primaryResources: [Primary]
    public let allEntities: Primary.Cache
}

extension Publisher {
    public func mapEntities<Cache: ResourceCache>(_ entities: @escaping (Output) throws -> Cache) -> Publishers.TryMap<Self, Cache> {
        self.tryMap(entities)
    }
}

// Single, no includes
extension Publisher where
    Output: EncodableJSONAPIDocument,
    Output.BodyData.PrimaryResourceBody: SingleResourceBodyProtocol,
    Output.BodyData.PrimaryResourceBody.PrimaryResource: CacheableResource,
    Output.BodyData.IncludeType == NoIncludes {

    public var entities: Publishers.TryMap<Self, Output.BodyData.PrimaryResourceBody.PrimaryResource.Cache> {
        self.tryMap(Self.extractEntities)
    }

    public var primaryAndEntities: Publishers.TryMap<Self, SingleEntityResultPair<Output.BodyData.PrimaryResourceBody.PrimaryResource>> {
        self.tryMap(Self.extractPrimaryAndEntities)
    }

    static func extractEntities(from document: Output) throws -> Output.BodyData.PrimaryResourceBody.PrimaryResource.Cache {

        if let errors = document.body.errors {
            throw ResponseFailure.errorResponse(errors)
        }
        guard let entities = document.resourceCache() else {
            throw ResponseFailure.unknown("Somehow found a document that is not an error document but also failed to create entities.")
        }
        return entities
    }

    static func extractPrimaryAndEntities(from document: Output) throws -> SingleEntityResultPair<Output.BodyData.PrimaryResourceBody.PrimaryResource> {

        if let errors = document.body.errors {
            throw ResponseFailure.errorResponse(errors)
        }
        guard let primary = document.body.primaryResource?.value, let entities = document.resourceCache() else {
            throw ResponseFailure.missingPrimaryResource(String(describing: Output.PrimaryResourceBody.PrimaryResource.self))
        }
        return .init(primaryResource: primary, allEntities: entities)
    }
}

// Single, some includes
extension Publisher where
    Output: EncodableJSONAPIDocument,
    Output.BodyData.PrimaryResourceBody: SingleResourceBodyProtocol,
    Output.BodyData.PrimaryResourceBody.PrimaryResource: CacheableResource,
    Output.BodyData.IncludeType: CacheableResource,
    Output.BodyData.PrimaryResourceBody.PrimaryResource.Cache == Output.BodyData.IncludeType.Cache {

    public var entities: Publishers.TryMap<Self, Output.BodyData.PrimaryResourceBody.PrimaryResource.Cache> {
        self.tryMap(Self.extractEntities)
    }

    public var primaryAndEntities: Publishers.TryMap<Self, SingleEntityResultPair<Output.BodyData.PrimaryResourceBody.PrimaryResource>> {
        self.tryMap(Self.extractPrimaryAndEntities)
    }

    static func extractEntities(from document: Output) throws -> Output.BodyData.PrimaryResourceBody.PrimaryResource.Cache {

        if let errors = document.body.errors {
            throw ResponseFailure.errorResponse(errors)
        }
        guard let entities = document.resourceCache() else {
            throw ResponseFailure.unknown("Somehow found a document that is not an error document but also failed to create entities.")
        }
        return entities
    }

    static func extractPrimaryAndEntities(from document: Output) throws -> SingleEntityResultPair<Output.BodyData.PrimaryResourceBody.PrimaryResource> {

        if let errors = document.body.errors {
            throw ResponseFailure.errorResponse(errors)
        }
        guard let primary = document.body.primaryResource?.value, let entities = document.resourceCache() else {
            throw ResponseFailure.missingPrimaryResource(String(describing: Output.PrimaryResourceBody.PrimaryResource.self))
        }
        return .init(primaryResource: primary, allEntities: entities)
    }
}

// Many, no includes
extension Publisher where
    Output: EncodableJSONAPIDocument,
    Output.BodyData.PrimaryResourceBody: ManyResourceBodyProtocol,
    Output.BodyData.PrimaryResourceBody.PrimaryResource: CacheableResource,
    Output.BodyData.IncludeType == NoIncludes {

    public var entities: Publishers.TryMap<Self, Output.BodyData.PrimaryResourceBody.PrimaryResource.Cache> {
        self.tryMap(Self.extractEntities)
    }

    public var primaryAndEntities: Publishers.TryMap<Self, ManyEntityResultPair<Output.PrimaryResourceBody.PrimaryResource>> {
        self.tryMap(Self.extractPrimaryAndEntities)
    }

    static func extractEntities(from document: Output) throws -> Output.BodyData.PrimaryResourceBody.PrimaryResource.Cache {

        if let errors = document.body.errors {
            throw ResponseFailure.errorResponse(errors)
        }
        guard let entities = document.resourceCache() else {
            throw ResponseFailure.unknown("Somehow found a document that is not an error document but also failed to create entities.")
        }
        return entities
    }

    static func extractPrimaryAndEntities(from document: Output) throws -> ManyEntityResultPair<Output.PrimaryResourceBody.PrimaryResource> {

        if let errors = document.body.errors {
            throw ResponseFailure.errorResponse(errors)
        }
        guard let primary = document.body.primaryResource?.values, let entities = document.resourceCache() else {
            throw ResponseFailure.missingPrimaryResource(String(describing: Output.PrimaryResourceBody.PrimaryResource.self))
        }
        return .init(primaryResources: primary, allEntities: entities)
    }
}

// Many, some includes
extension Publisher where
    Output: EncodableJSONAPIDocument,
    Output.BodyData.PrimaryResourceBody: ManyResourceBodyProtocol,
    Output.BodyData.PrimaryResourceBody.PrimaryResource: CacheableResource,
    Output.BodyData.IncludeType: CacheableResource,
    Output.BodyData.PrimaryResourceBody.PrimaryResource.Cache == Output.BodyData.IncludeType.Cache {

    public var entities: Publishers.TryMap<Self, Output.BodyData.PrimaryResourceBody.PrimaryResource.Cache> {
        self.tryMap(Self.extractEntities)
    }

    public var primaryAndEntities: Publishers.TryMap<Self, ManyEntityResultPair<Output.PrimaryResourceBody.PrimaryResource>> {
        self.tryMap(Self.extractPrimaryAndEntities)
    }

    static func extractEntities(from document: Output) throws -> Output.BodyData.PrimaryResourceBody.PrimaryResource.Cache {

        if let errors = document.body.errors {
            throw ResponseFailure.errorResponse(errors)
        }
        guard let entities = document.resourceCache() else {
            throw ResponseFailure.unknown("Somehow found a document that is not an error document but also failed to create entities.")
        }
        return entities
    }

    static func extractPrimaryAndEntities(from document: Output) throws -> ManyEntityResultPair<Output.PrimaryResourceBody.PrimaryResource> {

        if let errors = document.body.errors {
            throw ResponseFailure.errorResponse(errors)
        }
        guard let primary = document.body.primaryResource?.values, let entities = document.resourceCache() else {
            throw ResponseFailure.missingPrimaryResource(String(describing: Output.PrimaryResourceBody.PrimaryResource.self))
        }
        return .init(primaryResources: primary, allEntities: entities)
    }
}
