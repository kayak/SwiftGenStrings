import Foundation

class CharacterIterator {

    private let characters: [Character]

    private var index = -1

    init(string: String) {
        self.characters = string.map { $0 }
    }

    var current: Character? {
        guard index >= 0 && index < characters.count else {
            return nil
        }
        return characters[index]
    }

    var next: Character? {
        guard index + 1 < characters.count else {
            return nil
        }
        index += 1
        return characters[index]
    }

    var peekNext: Character? {
        guard index + 1 < characters.count else {
            return nil
        }
        return characters[index + 1]
    }

    var previous: Character? {
        guard index - 1 >= 0 else {
            return nil
        }
        index -= 1
        return characters[index]
    }

    var peekPrevious: Character? {
        guard index - 1 >= 0 else {
            return nil
        }
        return characters[index - 1]
    }

    func advance(_ count: Int) {
        if index + count < characters.count {
            index += count
        } else {
            index = characters.count - 1
        }
    }
    
    func charactersMatch(_ string: String) -> Bool {
        let match = string.map { $0 }
        guard index + match.count - 1 < characters.count else {
            return false
        }
        let sub = Array(characters[index..<index + match.count])
        return sub == match
    }
    
}
