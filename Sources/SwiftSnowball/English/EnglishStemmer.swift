//
//  EnglishStemmer.swift
//  SwiftSnowball
//
//  Created by Phoenix Trejo on 8/23/20.
//

import Foundation

class EnglishStemmer: Stemmer {
    
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
        
        return ""
    }
    
    func preprocess(_ word: EnglishWord) {
        word.normalizeApostrophes()
        word.trimLeadingApostrophes()
        word.capitalizeYs()
        word.findR1R2()
    }
}
