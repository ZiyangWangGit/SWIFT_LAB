//
//  UserSession.swift
//  PersonalityQuiz
//
//  Created by Ziyang Wang on 2024-11-17.
//


import Foundation

class UserSession {
    
    // Static constant for accessing the singleton instance
    static let shared = UserSession()
    
    // The username property to be shared across view controllers
    var username: String?
    
    // Private init to prevent instantiation from outside the class
    private init() {}
}
