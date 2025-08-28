//
//  AppWriteConfiguration.swift
//  Boilerplate
//
//  Created by Julien TARET on 27/08/2025.
//

import Foundation

struct AppWriteConfiguration {
    static let endpoint = "https://<REGION>.cloud.appwrite.io/v1"
    static let projectId = "<PROJECT_ID>"
    static let databaseId = "<DATABASE_ID>"
    
    static let urlScheme = "boilerplate"
    
    struct Collections {
        static let users = "<USERS_COLLECTION_ID>"
    }
    
    struct Attributes {
        static let userId = "userId"
        static let email = "email"
        static let name = "name"
        static let avatar = "avatar"
        static let createdAt = "createdAt"
        static let updatedAt = "updatedAt"
    }
}