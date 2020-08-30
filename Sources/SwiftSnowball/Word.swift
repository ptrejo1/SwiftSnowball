//
//  Word.swift
//  
//
//  Created by Phoenix Trejo on 8/25/20.
//

import Foundation

internal protocol Word {
    var characters: [Character] { get set }
    var r1: Int? { get set }
    var r2: Int? { get set }
    var rv: Int? { get set }
    
    init(_ word: String)
}

internal class StandardWord: Word {
    
    var characters: [Character]
    var r1: Int?
    var r2: Int?
    var rv: Int?
    
    var count: Int {
        return characters.count
    }
    
    required init(_ word: String) {
        characters = Array(word)
    }
    
    /// Finds the region after the first non-vowel following
    /// a vowel, returns nil if there is no such non-vowel.
    func standardR(start: Int, vowels: Set<Character>) -> Int? {
        let end = characters[start...].count - 1
        for i in stride(from: 1, to: end, by: 1) {
            let j = start + i
            guard
                vowels.contains(characters[j - 1]),
                !vowels.contains(characters[j])
            else { continue }
            return j + 1
        }
        
        return nil
    }
}

extension StandardWord: CustomStringConvertible {
    
    var description: String {
        return String(characters)
    }
}
