//
//  ResponseFailure.swift
//  
//
//  Created by Mathew Polzin on 6/29/20.
//

import Foundation

public enum ResponseFailure: Swift.Error {
    case unknown(String)
    case missingPrimaryResource(String)
    case errorResponse([Swift.Error])
    case responseDecoding(String)
    case typeMismatch(contentType: HttpContentType, responseType: String)

    public var isMissingPrimaryResource: Bool {
        guard case .missingPrimaryResource = self else {
            return false
        }
        return true
    }

    public var isErrorResponse: Bool {
        guard case .errorResponse = self else {
            return false
        }
        return true
    }

    public var isResponseDecoding: Bool {
        guard case .responseDecoding = self else {
            return false
        }
        return true
    }

    public var isTypeMismatch: Bool {
        guard case .typeMismatch = self else {
            return false
        }
        return true
    }
}
