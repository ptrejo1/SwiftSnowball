# SwiftSnowball

![Swift 5.0](https://img.shields.io/badge/Swift-5.0-blue.svg?style=flat)
[![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/ptrejo1/SwiftSnowball/blob/master/LICENSE) 

A Swift implementation of the Snowball stemmer

For more info on algorithm:
- http://snowball.tartarus.org/
- http://snowball.tartarus.org/algorithms/english/stemmer.html

Currently English is the only supported language, there are plans for more. Help is always appreciated!

## Installation

### Swift Package Manager

```swift
.package(url: "https://github.com/ptrejo1/SwiftSnowball.git", .exact("1.0.0"))
```

## Usage

Stem a word with the `SnowballStemmer` class and its `stem` method

```swift
import SwiftSnowball

let stemmer = SnowballStemmer(language: .english)
let stemmed = stemmer.stem("swiftly")
print(stemmed)      // prints swift
```
