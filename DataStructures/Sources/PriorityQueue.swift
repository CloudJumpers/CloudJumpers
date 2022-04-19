//
//  PriorityQueue.swift
//  Written for the Swift Algorithm Club by Kevin Randrup and Matthijs Hollemans
//  Imported from https://github.com/raywenderlich/swift-algorithm-club/blob/master/Priority%20Queue/PriorityQueue.swift
//  Updated for Swift 5
//

/// Priority Queue, a queue where the most "important" items are at the front of
/// the queue. All operations are O(log n).
public struct PriorityQueue<T> {
    private var heap: Heap<T>

    public init(sort: @escaping (T, T) -> Bool) {
        heap = Heap(sort: sort)
    }

    public var isEmpty: Bool {
        heap.isEmpty
    }

    public var count: Int {
        heap.count
    }

    public func peek() -> T? {
        heap.peek()
    }

    public mutating func enqueue(_ element: T) {
        heap.insert(element)
    }

    public mutating func dequeue() -> T? {
        heap.remove()
    }

    public mutating func removeAll() {
        heap.removeAll()
    }

    /// Allows you to change the priority of an element. In a max-priority queue,
    /// the new priority should be larger than the old one; in a min-priority queue
    /// it should be smaller.
    mutating func changePriority(index i: Int, value: T) {
        heap.replace(index: i, value: value)
    }
}

extension PriorityQueue where T: Equatable {
    public func index(of element: T) -> Int? {
        heap.index(of: element)
    }
}
