//
//  User.swift
//  BlogConnect
//
// Gal

import Foundation

class User {
    var uid: String
    var username: String
    var postsIDs: [String]

    init(uid: String, username: String, postsIDs: [String] = []) {
        self.uid = uid
        self.username = username
        self.postsIDs = postsIDs
    }
    // Convert User object to dictionary
       func toDictionary() -> [String: Any] {
           return [
               "uid": uid,
               "username": username,
               "postIDs": postsIDs
           ]
       }

    func addPostID(_ eventID: String) {
        postsIDs.append(eventID)
    }

    func removePostID(_ eventID: String) {
        if let index = postsIDs.firstIndex(of: eventID) {
            postsIDs.remove(at: index)
        }
    }

    func description() -> String {
        return "User(uid: \(uid), username: \(username), eventIDs: \(postsIDs))"
    }
}
