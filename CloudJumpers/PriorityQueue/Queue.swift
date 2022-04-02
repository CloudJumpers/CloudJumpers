//
//  Queue.swift
//  Written for the Swift Algorithm Club by Kevin Randrup and Matthijs Hollemans
//  Imported from https://github.com/raywenderlich/swift-algorithm-club/blob/master/Queue/Queue-Optimized.swift
//  Updated for Swift 5
//

/// A first-in first-out data structure. Enqueuing and dequeuing are O(1) operations.
struct Queue<T> {
    private var array: [T?] = []
    private var head = 0

    var isUpdated = false
    var count: Int {
        array.count - head
    }

    // swiftlint:disable empty_count
    var isEmpty: Bool {
        count == 0
    }
    // swiftlint:enable empty_count

    mutating func enqueue(_ element: T) {
        array.append(element)
        isUpdated = true
    }

    mutating func dequeue() -> T? {
        guard let element = array[guarded: head] else {
            return nil
        }
        isUpdated = true

        array[head] = nil
        head += 1

        let percentage = Double(head) / Double(array.count)
        if array.count > 50 && percentage > 0.25 {
            array.removeFirst(head)
            head = 0
        }

        return element
    }

    var front: T? {
        if isEmpty {
            return nil
        } else {
            return array[head]
        }
    }

    var iterable: [T] {
        var array: [T] = []

        var queue = self
        while let item = queue.dequeue() {
            array.append(item)
        }

        return array
    }
}

extension Array {
    subscript(guarded idx: Int) -> Element? {
        guard (startIndex..<endIndex).contains(idx) else {
            return nil
        }
        return self[idx]
    }
}
