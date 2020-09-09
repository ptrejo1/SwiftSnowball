internal protocol Stemmer {
    func stem(_ word: String, stemStopWords: Bool) -> String
}

/// Language used to stem
public enum Language {
    
    case english
    
    internal var stemmer: Stemmer {
        switch self {
        case .english:
            return EnglishStemmer()
        }
    }
}

/// Used to stem word in specified language
public class SnowballStemmer {
    
    public let language: Language
    private let stemmer: Stemmer
    
    public init(language: Language) {
        self.language = language
        stemmer = language.stemmer
    }
    
    /// Stems a word
    ///
    /// - Parameters:
    ///   - word: word to stem
    ///   - stemStopWords: whether to stem stop words or ignore them
    ///
    /// - Returns: stemmed word
    public func stem(_ word: String, stemStopWords: Bool = false) -> String {
        guard !word.isEmpty else { return "" }
        return stemmer.stem(word, stemStopWords: stemStopWords)
    }
}
