extension Dictionary {
    /// Returns a Boolean value indicating whether the dictionary contains the given key.
    ///
    /// Since `contains(key:)` checks the key by lookup, its time complexity is
    /// typically O(1).
    ///
    /// - Parameters:
    ///   - key: the key to check
    func contains(key: Key) -> Bool {
        self[key] != nil
    }

    /// Creates a key-value pair if the key has not yet been created.
    /// - Parameters:
    ///   - key: the new key to create
    ///   - value: the new value to add
    mutating func create(key: Key, value: Value) {
        if !contains(key: key) {
            self[key] = value
        }
    }
}
