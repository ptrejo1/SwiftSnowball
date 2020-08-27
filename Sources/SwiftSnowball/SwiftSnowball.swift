internal protocol Stemmer {
    func stem(_ word: String, ignoreStopWords: Bool) -> String
}

public enum Language {
    
    case English
    
    var stemmer: Stemmer {
        switch self {
        case .English:
            return EnglishStemmer()
        }
    }
}

public class SnowballStemmer {
    
    let language: Language
    private let stemmer: Stemmer
    
    public init(language: Language) {
        self.language = language
        stemmer = language.stemmer
    }
    
    func stem(_ word: String, ignoreStopWords: Bool = false) -> String {
        guard !word.isEmpty else { return "" }
        return stemmer.stem(word, ignoreStopWords: ignoreStopWords)
    }
}
