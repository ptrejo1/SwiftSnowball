//
//  EnglishUtils.swift
//  
//
//  Created by Phoenix Trejo on 8/23/20.
//

import Foundation

internal class EnglishUtils {
    
    class var vowels: Set<Character> {
        return ["a", "e", "i", "o", "u", "y"]
    }
    
    class var stopWords: Set<String> {
        return [
            "a", "about", "above", "after", "again", "against", "all", "am", "an",
            "and", "any", "are", "as", "at", "be", "because", "been", "before",
            "being", "below", "between", "both", "but", "by", "can", "did", "do",
            "does", "doing", "don", "down", "during", "each", "few", "for", "from",
            "further", "had", "has", "have", "having", "he", "her", "here", "hers",
            "herself", "him", "himself", "his", "how", "i", "if", "in", "into", "is",
            "it", "its", "itself", "just", "me", "more", "most", "my", "myself",
            "no", "nor", "not", "now", "of", "off", "on", "once", "only", "or",
            "other", "our", "ours", "ourselves", "out", "over", "own", "s", "same",
            "she", "should", "so", "some", "such", "t", "than", "that", "the", "their",
            "theirs", "them", "themselves", "then", "there", "these", "they",
            "this", "those", "through", "to", "too", "under", "until", "up",
            "very", "was", "we", "were", "what", "when", "where", "which", "while",
            "who", "whom", "why", "will", "with", "you", "your", "yours", "yourself",
            "yourselves"
        ]
    }
    
    class var specialWords: [String: String] {
        return [
            "skis": "ski",
            "skies": "sky",
            "dying": "die",
            "lying": "lie",
            "tying": "tie",
            "idly": "idl",
            "gently": "gentl",
            "ugly": "ugli",
            "early": "earli",
            "only": "onli",
            "singly": "singl",
            "sky": "sky",
            "news": "news",
            "howe": "howe",
            "atlas": "atlas",
            "cosmos": "cosmos",
            "bias": "bias",
            "andes": "andes",
            "inning": "inning",
            "innings": "inning",
            "outing": "outing",
            "outings": "outing",
            "canning": "canning",
            "cannings": "canning",
            "herring": "herring",
            "herrings": "herring",
            "earring": "earring",
            "earrings": "earring",
            "proceed": "proceed",
            "proceeds": "proceed",
            "proceeded": "proceed",
            "proceeding": "proceed",
            "exceed": "exceed",
            "exceeds": "exceed",
            "exceeded": "exceed",
            "exceeding": "exceed",
            "succeed": "succeed",
            "succeeds": "succeed",
            "succeeded": "succeed",
            "succeeding": "succeed",
        ]
    }
    
    class func isStopWord(_ word: String) -> Bool {
        return stopWords.contains(word)
    }
    
    class func isVowel(_ char: Character) -> Bool {
        return vowels.contains(char)
    }
}
