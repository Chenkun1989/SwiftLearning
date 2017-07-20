//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, HashTable"

let max_load_factor = 0.75

//NSHashTable
public struct HashTable<Key: Hashable, Value>: CustomStringConvertible {
    private typealias Element = (key: Key, value: Value)
    private typealias Bucket = [Element]
    private var buckets: [Bucket]
    
    private(set) public var count = 0
    
    public var isEmpty: Bool { return count == 0 }
    
    init(capacity: Int) {
        assert(capacity > 0)
        buckets = Array<Bucket>.init(repeatElement([], count: capacity))
    }
    
    public subscript(key: Key) -> Value? {
        get {
            return value(forKey: key)
        }
        set {
            if let value = newValue {
                updateValue(value: value, forKey: key)
            } else {
                removeValue(forKey: key)
            }
        }
    }
    
    private func index(forKey key: Key) -> Int {
        return abs(key.hashValue) % buckets.count
    }
    
    private func value(forKey key: Key) -> Value? {
        let index = self.index(forKey: key)
        for element in buckets[index] {
            if key == element.key {
                return element.value
            }
        }
        return nil
    }
    
    // return old value.
    @discardableResult public mutating func updateValue(value: Value, forKey key: Key) -> Value? {
        let index = self.index(forKey: key)
        for (i, element) in buckets[index].enumerated() {
            if key == element.key {
                let oldValue = element.value
                buckets[index][i].value = value
                return oldValue
            }
        }
        // the key not exsited.
        buckets[index].append(key: key, value: value)
        count += 1
        
        // resize if load factor is larger
        if Double(count) / Double(buckets.count) > max_load_factor {
            print("-----max load factor-------")
            var newBuckets: [Bucket] = .init(repeatElement([], count: buckets.count * 2))
            for index in 0..<buckets.count {
                for element in buckets[index] {
                    let newIndex = self.index(forKey: element.key)
                    newBuckets[newIndex].append(element)
                }
            }
            buckets = newBuckets
        }
        return nil
    }
    
    @discardableResult public mutating func removeValue(forKey key: Key) -> Value? {
        let index = self.index(forKey: key)
        for (i, element) in buckets[index].enumerated() {
            if key == element.key {
                buckets[index].remove(at: i)
                count -= 1
                return element.value
            }
        }
        return nil
    }
    
    public var description: String {
        let pairs = buckets.flatMap { b in
            b.map { e in
                "\(e.key) = \(e.value)"
            }
        }
        return pairs.joined(separator: ", ")
    }
    
    public var debugDescription: String {
        var str = ""
        for (i, bucket) in buckets.enumerated() {
            let pairs = bucket.map { b in
                "\(b.key) = \(b.value)"
            }
            str += "bucket[\(i)] " + pairs.joined(separator: ", ") + "\n"
        }
        return str
    }
}

var hashtables = HashTable<String, String>.init(capacity: 5)

hashtables["Jobs"] = "Apple"
hashtables["Steves"] = "Google"
hashtables["mao"] = "China"
hashtables["hu"] = "China"
hashtables["jobs"] = "jd"
hashtables["setve"] = "jd"

print(hashtables)
print(hashtables.debugDescription)







