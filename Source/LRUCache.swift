//
//  LRUCache.swift
//  LRUCache
//
//  Created by Thomas Fulton on 2017-10-10.
//

import Foundation

/// Represents an item in the cache. The double linked list plus dictionary approach is required for O(1) get and set operations.
fileprivate class LRUCacheItem<T>: Equatable {

    var key: String
    var object: T

    var next: LRUCacheItem?
    var prev: LRUCacheItem?

    init(key: String, object: T) {
        self.key = key
        self.object = object
    }

    static func == (lhs: LRUCacheItem, rhs: LRUCacheItem) -> Bool {
        return lhs.key == rhs.key
    }
}

/// A least-recently-used cache. When the number of cached items exceeds the maximum size, it removes the least recently used item. This class is not thread-safe, so concurrent get and set operations must happen in a serial `DispatchQueue` or using a semaphore. This class has O(1) get and set operations.
public class LRUCache<T> {

    /// The max allowed cache size.
    private let maxSize: Int

    /// The most recently accessed or set cache item.
    private var newest: LRUCacheItem<T>?

    /// The least recently accessed or set cache item.
    private var oldest: LRUCacheItem<T>?

    /// The dictionary to store the cached item in.
    private var cacheDict: [String: LRUCacheItem<T>] = [:]

    /// Creates a new `LRUCache` with the given maximum size.
    ///
    /// - Parameter maxSize: The max allowed cache size. If the cache attempts to grow larger than this it will delete the least recently used item.
    init(maxSize: Int) {
        self.maxSize = maxSize
    }

    /// The number of items currently stored in the cache.
    public var count: Int {
        return cacheDict.count
    }

    /// Adds the given object to the cache with the given `String` as key.
    ///
    /// - Parameters:
    ///   - object: The object to add to the cache.
    ///   - key: The key to cache it with.
    public func set(_ object: T, forKey key: String) {
        var cacheItem = cacheDict[key]
        if let cacheItem = cacheItem {
            cacheItem.object = object
        } else {
            cacheItem = LRUCacheItem(key: key, object: object)
            cacheDict[key] = cacheItem
        }
        makeNewest(cacheItem: cacheItem!)
        if cacheDict.count > maxSize {
            removeOldest()
        }
    }

    /// Gets an object from the cache by key.
    ///
    /// - Parameter key: The key to look for the cached object with.
    /// - Returns: The cached object if it is in the cache, else `nil`.
    public func get(forKey key: String) -> T? {
        if let cacheItem = cacheDict[key] {
            makeNewest(cacheItem: cacheItem)
            return cacheItem.object
        } else {
            return nil
        }
    }

    /// Makes the given cacheItem the "newest", i.e., most recently used.
    ///
    /// - Parameter cacheItem: The cache item to make newest.
    private func makeNewest(cacheItem: LRUCacheItem<T>) {
        // If this is our very firt cache item, need to set it as the oldest and the newest.
        guard let newest = newest, let oldest = oldest else {
            self.newest = cacheItem
            self.oldest = cacheItem
            return
        }

        // Don't do anything if the item is already the newest or we will end up with `next` pointing to `self`.
        if newest == cacheItem {
            return
        }

        // Remove the `LRUCacheItem` from its previous position in the linked list.

        if cacheItem == oldest {
            // If it was the oldest, then set the new oldest.
            self.oldest = oldest.prev
            self.oldest?.next = nil
        } else {
            cacheItem.prev?.next = cacheItem.next
            cacheItem.next?.prev = cacheItem.prev
        }

        // Put it at the head of the list.

        cacheItem.next = newest
        self.newest?.prev = cacheItem
        self.newest = cacheItem
    }

    /// Removes the least recently used item from the cache.
    private func removeOldest() {
        if let oldest = oldest {
            cacheDict.removeValue(forKey: oldest.key)
            oldest.prev?.next = nil
            self.oldest = oldest.prev
        }
    }
}
