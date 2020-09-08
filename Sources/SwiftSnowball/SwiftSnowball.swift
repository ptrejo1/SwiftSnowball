internal protocol Stemmer {
    func stem(_ word: String, stemStopWords: Bool) -> String
}

public enum Language {
    
    case english
    
    internal var stemmer: Stemmer {
        switch self {
        case .english:
            return EnglishStemmer()
        }
    }
}

public class SnowballStemmer {
    
    public let language: Language
    private let stemmer: Stemmer
    
    public init(language: Language) {
        self.language = language
        stemmer = language.stemmer
    }
    
    public func stem(_ word: String, stemStopWords: Bool = false) -> String {
        guard !word.isEmpty else { return "" }
        return stemmer.stem(word, stemStopWords: stemStopWords)
    }
}
