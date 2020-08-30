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
        
        return englishWord.description
    }
    
    func preprocess(_ word: EnglishWord) {
        word.normalizeApostrophes()
        word.trimLeadingApostrophes()
        word.capitalizeYs()
        word.findR1R2()
    }
    
    func step0(_ word: EnglishWord) {
        let str = word.description
        let suffixes = ["'s'", "'s", "'"]
        let suffix = suffixes.first { str.hasSuffix($0) }
        
        guard let count = suffix?.count else { return }
        word.dropLast(count)
    }
}
