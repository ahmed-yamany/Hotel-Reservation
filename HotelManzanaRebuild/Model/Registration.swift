//
//  Registration.swift
//  HotelManzanaRebuild
//
//  Created by Ahmed Yamany on 31/07/2022.
//

import Foundation



struct Registration: Equatable, Codable{
    var firstName: String
    var lastName: String
    var email: String
    
    var checkInDate: Date
    var checkOutDate: Date
    
    var numberOfAdults: Int
    var numberOfChildren: Int
    
    var wifi: Bool
    var roomType: RoomType
    
    
    
    static func ==(lhs: Registration, rhs: Registration) -> Bool{
        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.email == rhs.email
    }
    
    
    
}



struct RoomType: Equatable, Codable{
    var id: Int
    var name: String
    var shortName: String
    var price: Int
    
    static func ==(lhs: RoomType, rhs: RoomType) -> Bool{
        return lhs.id == rhs.id
    }
    
    
    static var all: [RoomType] {
        return [RoomType(id: 0, name: "Two Queens",
                   shortName: "2Q", price: 179),
                RoomType(id: 1, name: "One King",
                   shortName: "K", price: 209),
                RoomType(id: 2, name: "Penthouse Suite",
                    shortName: "PHS", price: 309)]
    }
    
}


class Registrations{
    let archiveUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("registrations").appendingPathExtension("plist")


    func saveTofile(registrations: [Registration]){
        let propertyListEncoder = PropertyListEncoder()
        if let encodedNote = try? propertyListEncoder.encode(registrations){
            try? encodedNote.write(to: archiveUrl, options: .noFileProtection)
        }

    }
    
    func loadFromFile() -> [Registration]?{
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedNoteData = try? Data(contentsOf: archiveUrl),
           let decodedNote = try? propertyListDecoder.decode(Array<Registration>.self,
               from: retrievedNoteData) {
            return decodedNote

        }
        return nil
        
    }
    
}
