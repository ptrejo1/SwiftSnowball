//
//  EnglishStemmer.swift
//  SwiftSnowball
//
//  Created by Phoenix Trejo on 8/23/20.
//

import Foundation

internal class EnglishStemmer: Stemmer {
    
    func stem(_ word: String, ignoreStopWords: Bool) -> String {
        let lower = word.lowercased().trimmingCharacters(
            in: .whitespacesAndNewlines)
        
        if lower.count <= 2 || (!ignoreStopWords &&
            EnglishUtils.isStopWord(lower)) {
            return lower
        }
        
        if let specialWord = EnglishUtils.specialWords[lower] {
            return specialWord
        }
        
        let englishWord = EnglishWord(lower)
        
        preprocess(englishWord)
        step0(englishWord)
        step1a(englishWord)
        step1b(englishWord)
        
        return englishWord.description
    }
    
    func preprocess(_ word: EnglishWord) {
        word.normalizeApostrophes()
        word.trimLeadingApostrophes()
        word.capitalizeYs()
        word.findR1R2()
    }
    
    func step0(_ word: EnglishWord) {
        let suffixes = ["'s'", "'s", "'"]
        let suffix = word.firstSuffix(in: suffixes)
        
        guard let count = suffix?.count else { return }
        word.dropLast(count)
    }
    
    func step1a(_ word: EnglishWord) {
        let suffixes = ["sses", "ied", "ies", "us", "ss", "s"]
        let suffix = word.firstSuffix(in: suffixes)
        
        switch suffix {
        case "sses":
            word.dropLast(2)
        case "ies", "ied":
            // replace by i if preceded by more than one letter,
            // otherwise by ie
            word.count > 4 ? word.dropLast(2) : word.dropLast(1)
        case "us", "ss":
            break
        case "s":
            // delete if the preceding word part contains a vowel
            // not immediately before the s
            let idx = word.characters.firstIndex {
                EnglishUtils.isVowel($0)
            }
            guard let i = idx, i < word.count - 2 else { break }
            word.dropLast(1)
        default:
            break
        }
    }
    
    func step1b(_ word: EnglishWord) {
        let suffixes = ["eedly", "ingly", "edly", "eed", "ing", "ed"]
        let suffix = word.firstSuffix(in: suffixes)
        
        switch suffix {
        case "eed", "eedly":
            guard
                let r1 = word.r1,
                suffix!.count <= word.count - r1
            else { break }
            
            word.replaceSuffix(suffix!, with: "ee")
        case "ed", "edly", "ing", "ingly":
            var isVowelPresent = false
            let n = word.count - suffix!.count
            loop: for char in word.characters[..<n] {
                guard EnglishUtils.isVowel(char) else {
                    continue
                }
                isVowelPresent = true
                break loop
            }
            
            guard isVowelPresent else { break }
            
            let r1 = word.r1
            let r2 = word.r2
            word.dropLast(suffix!.count)
            
            let newSuffixes = ["at", "bl", "iz"] + EnglishUtils.doubles
            let newSuffix = word.firstSuffix(in: newSuffixes)
            
            switch newSuffix {
            case "at", "bl", "iz":
                word.replaceSuffix(newSuffix!, with: newSuffix! + "e")
            case "bb", "dd", "ff", "gg", "mm", "nn", "pp", "rr", "tt":
                word.dropLast(1)
            default:
                guard word.isShortWord() else { break }
                word.characters.append("e")
                word.r1 = nil
                word.r2 = nil
                return
            }
            
            if let r = r1, r < word.count {
                word.r1 = r
            }
            if let r = r2, r < word.count {
                word.r2 = r
            }
        default:
            break
        }
    }
}
