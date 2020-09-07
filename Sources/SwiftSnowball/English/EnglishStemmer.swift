//
//  EnglishStemmer.swift
//  SwiftSnowball
//
//  Created by Phoenix Trejo on 8/23/20.
//

import Foundation

internal class EnglishStemmer: Stemmer {
    
    func stem(_ word: String, stemStopWords: Bool) -> String {
        let lower = word.lowercased().trimmingCharacters(
            in: .whitespacesAndNewlines)
        
        if lower.count <= 2 || (!stemStopWords &&
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
        step1c(englishWord)
        step2(englishWord)
        step3(englishWord)
        step4(englishWord)
        step5(englishWord)
        
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
    
    func step1c(_ word: EnglishWord) {
        let n = word.count
        guard
            word.count > 2,
            (word.characters[n - 1] == "y" ||
                word.characters[n - 1] == "Y"),
            !EnglishUtils.isVowel(word.characters[n - 2])
        else { return }
        
        word.characters[n - 1] = "i"
    }
    
    func step2(_ word: EnglishWord) {
        let suffixes = [
            "ational", "fulness", "iveness", "ization", "ousness",
            "biliti", "lessli", "tional", "alism", "aliti", "ation",
            "entli", "fulli", "iviti", "ousli", "anci", "abli",
            "alli", "ator", "enci", "izer", "bli", "ogi", "li"
        ]
        
        guard
            let suffix = word.firstSuffix(in: suffixes),
            let r1 = word.r1,
            suffix.count <= word.count - r1
        else { return }
        
        switch suffix {
        case "li":
            let count = word.count
            let chars: [Character] = [
                "c", "d", "e", "g", "h",
                "k", "m", "n", "r", "t"
            ]
            guard
                count >= 3,
                chars.contains(word.characters[count - 3])
            else { break }
            
            word.dropLast(suffix.count)
        case "ogi":
            let count = word.count
            guard
                count >= 4,
                word.characters[count - 4] == "l"
            else { break }
            
            word.replaceSuffix(suffix, with: "og")
        default:
            break
        }
        
        var replace = ""
        switch suffix {
        case "tional":
            replace = "tion"
        case "enci":
            replace = "ence"
        case "anci":
            replace = "ance"
        case "abli":
            replace = "able"
        case "entli":
            replace = "ent"
        case "izer", "ization":
            replace = "ize"
        case "ational", "ation", "ator":
            replace = "ate"
        case "alism", "aliti", "alli":
            replace = "al"
        case "fulness":
            replace = "ful"
        case "ousli", "ousness":
            replace = "ous"
        case "iveness", "iviti":
            replace = "ive"
        case "biliti", "bli":
            replace = "ble"
        case "fulli":
            replace = "ful"
        case "lessli":
            replace = "less"
        default:
            return
        }
        
        word.replaceSuffix(suffix, with: replace)
    }
    
    func step3(_ word: EnglishWord) {
        let suffixes = [
            "ational", "tional", "alize", "icate", "ative",
            "iciti", "ical", "ful", "ness"
        ]
        
        guard
            let suffix = word.firstSuffix(in: suffixes),
            let r1 = word.r1,
            suffix.count <= word.count - r1
        else { return }
        
        guard
            suffix != "ative",
            let r2 = word.r2,       // check if in r2
            word.count - r2 < 5     // 5 = len of ative
        else {
            word.dropLast(suffix.count)
            return
        }
        
        if suffix == "active",
            let r2 = word.r2,
            word.count - r2 >= suffix.count {
            word.dropLast(suffix.count)
            return
        }
        
        var replace = ""
        switch suffix {
        case "ational":
            replace = "ate"
        case "tional":
            replace = "tion"
        case "alize":
            replace = "al"
        case "icate", "iciti", "ical":
            replace = "ic"
        case "ful", "ness":
            replace = ""
        default:
            return
        }
        
        word.replaceSuffix(suffix, with: replace)
    }
    
    func step4(_ word: EnglishWord) {
        let suffixes = [
            "ement", "ance", "ence", "able", "ible", "ment",
            "ent", "ant", "ism", "ate", "iti", "ous", "ive",
            "ize", "ion", "al", "er", "ic",
        ]
        
        guard
            let suffix = word.firstSuffix(in: suffixes),
            let r2 = word.r2,
            suffix.count <= word.count - r2
        else { return }
        
        if suffix == "ion",
            word.count >= 4,
            ["s", "t"].contains(word.characters[word.count - 4]) {
            word.dropLast(suffix.count)
            return
        }
        
        word.dropLast(suffix.count)
    }
    
    func step5(_ word: EnglishWord) {
        let lastCharIdx = word.count - 1
        
        guard let r1 = word.r1, r1 <= lastCharIdx else {
            return
        }
        
        if word.characters[lastCharIdx] == "e" {
            if let r2 = word.r2, r2 <= lastCharIdx {
                word.dropLast(1)
            } else if !word.endsInShortSyllable(at: lastCharIdx) {
                word.dropLast(1)
            }
        } else if word.characters[lastCharIdx] == "l",
            lastCharIdx - 1 >= 0,
            word.characters[lastCharIdx - 1] == "l",
            let r2 = word.r2,
            r2 <= lastCharIdx {
            word.dropLast(1)
        }
    }
}
