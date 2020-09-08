//
//  EnglishWord.swift
//  
//
//  Created by Phoenix Trejo on 8/25/20.
//

import Foundation

internal class EnglishWord: StandardWord {
    
    func normalizeApostrophes() {
        for i in 0..<count {
            guard
                characters[i] == "\u{2019}" ||
                characters[i] == "\u{2018}" ||
                characters[i] == "\u{201B}"
            else { continue }
            
            characters[i] = "'"
        }
    }
    
    func trimLeadingApostrophes() {
        if let i = characters.firstIndex(where: { $0 != "'" }) {
            characters = Array(characters[i...])
        } else {
            characters = []
        }
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
        let word = description
        let specialPrefixes = ["gener", "commun", "arsen"]
        let prefix = specialPrefixes.first { word.hasPrefix($0) }

        if let prefixIdx = prefix?.count {
            r1 = prefixIdx
        } else {
            r1 = standardR(start: 0, vowels: EnglishUtils.vowels)
        }
        
        guard let start = r1 else { return }
        r2 = standardR(start: start, vowels: EnglishUtils.vowels)
    }
    
    private func resetR1R2() {
        if let r = r1, r >= count {
            r1 = nil
        }
        if let r = r2, r >= count {
            r2 = nil
        }
        if let r = rv, r >= count {
            rv = nil
        }
    }
    
    func dropLast(_ n: Int) {
        characters = characters.dropLast(n)
        resetR1R2()
    }
    
    func firstSuffix(in suffixes: [String]) -> String? {
        let word = description
        return suffixes.first { word.hasSuffix($0) }
    }
    
    func replaceSuffix(_ suffix: String, with newSuffix: String) {
        guard description.hasSuffix(suffix) else { return }
        
        characters = characters.dropLast(suffix.count)
        characters += Array(newSuffix)
        resetR1R2()
    }
    
    func isShortWord() -> Bool {
        guard r1 == nil else { return false }
        return endsInShortSyllable(at: count)
    }
    
    /// - Parameter ending: Index to cutoff at
    func endsInShortSyllable(at ending: Int) -> Bool {
        if ending == 2 {
            return
                EnglishUtils.isVowel(characters[0]) &&
                    !EnglishUtils.isVowel(characters[1])
                ? true : false
        } else if ending > 2 {
            let e1 = characters[ending - 1]
            let e2 = characters[ending - 2]
            let e3 = characters[ending - 3]
            let specialNonVowels: [Character] = ["w", "x", "Y"]
            
            let isShort = !EnglishUtils.isVowel(e1) &&
                !specialNonVowels.contains(e1) &&
                EnglishUtils.isVowel(e2) &&
                !EnglishUtils.isVowel(e3)
            
            return isShort ? true : false
        }
        
        return false
    }
    
    func uncapitalizeYs() {
        for i in 0..<count {
            guard characters[i] == "Y" else { continue }
            characters[i] = "y"
        }
    }
}
