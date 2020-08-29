//
//  EnglishWord.swift
//  
//
//  Created by Phoenix Trejo on 8/25/20.
//

import Foundation

internal class EnglishWord: StandardWord {
    
    func normalizeApostrophes() {
        for i in 0..<characters.count {
            guard
                characters[i] == "\u{2019}" ||
                characters[i] == "\u{2018}" ||
                characters[i] == "\u{201B}"
            else { continue }
            
            characters[i] = "'"
        }
    }
    
    func trimLeadingApostrophes() {
        var idx = 0
        for i in 0..<characters.count {
            guard characters[i] == "'" else { break }
            idx += 1
        }
        
        characters = Array(characters[idx...])
    }
    
    /// Capitalize all 'Y's preceded by vowels or starting a word
    func capitalizeYs() {
        for (i, char) in characters.enumerated() {
            guard char == "y" && (i == 0 ||
                EnglishUtils.isVowel(characters[i - 1]))
            else { continue }
            
            characters[i] = "Y"
        }
    }
    
    /// Find the starting point of the two regions R1 & R2
    /// See http://snowball.tartarus.org/texts/r1r2.html
    func findR1R2() {
        let word = String(characters)
        let specialPrefixes = ["gener", "commun", "arsen"]
        var prefixIdx = -1
        for prefix in specialPrefixes {
            guard word.hasPrefix(prefix) else { continue }
            prefixIdx = prefix.count
        }
        
        if prefixIdx != -1 {
            r1 = prefixIdx
        } else {
            r1 = standardR(start: 0, vowels: EnglishUtils.vowels)
        }
        
        guard let start = r1 else { return }
        r2 = standardR(start: start, vowels: EnglishUtils.vowels)
    }
}
