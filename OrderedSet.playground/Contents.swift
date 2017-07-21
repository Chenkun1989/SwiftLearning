//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, Ordered Set"

public struct OrderedSet<T: Hashable> {
    private var internalSet = [T]()
    private var indexOfKey: [T: Int] = [:]
    
    public init() {}
    
    public var count: Int {
        return internalSet.count
    }
    
    public mutating func add(_ object: T) {
        guard indexOfKey[object] == nil else {
            return
        }
        // if not exist, append to the last
        internalSet.append(object)
        indexOfKey[object] = internalSet.count - 1
    }
    
    public mutating func insert(_ object: T, at index: Int) {
        assert(index < internalSet.count, "Index out of range.")
        assert(index >= 0, "Index should greater than 0")
        
        guard indexOfKey[object] == nil else {
            return
        }
        
        internalSet.insert(object, at: index)
        indexOfKey[object] = index
        
        for i in (index + 1)..<internalSet.count {
            indexOfKey[internalSet[i]] = i
        }
    }
    
    public func object(at index: Int) -> T {
        assert(index < internalSet.count, "Index out of range.")
        assert(index >= 0, "Index should greater than 0")
        
        return internalSet[index]
    }
    
    public mutating func set(_ object: T, at index: Int) {
        assert(index < internalSet.count, "Index out of range.")
        assert(index >= 0, "Index should greater than 0")

        guard indexOfKey[object] == nil else {
            return
        }
        
        indexOfKey.removeValue(forKey: internalSet[index])
        indexOfKey[object] = index
        internalSet[index] = object
    }
    
    public mutating func remove(_ object: T) {
        guard let index = indexOfKey[object] else {
            return
        }
        internalSet.remove(at: index)
        indexOfKey.removeValue(forKey: object)
        
        for i in (index + 1)..<internalSet.count {
            indexOfKey[internalSet[i]] = i
        }
    }
}


















