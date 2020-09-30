//
//  BinaryTree.swift
//  MyLeetCode
//
//  Created by build on 2020/9/27.
//

import Foundation

protocol Limitable {
    static var max: Self { get }
    static var min: Self { get }
}

typealias BSTValue = Comparable & Limitable

public class TreeNode<Element> {
    public var value: Element
    public var left: TreeNode?
    public var right: TreeNode?
    
    public init(_ value: Element) {
        self.value = value
        self.left = nil
        self.right = nil
    }
    
    //按层序初始化二叉树
    public init?(_ elements: [Element?]) {
        var elements = elements
        guard let rootValue = elements.removeFirst() else {
            return nil
        }
        value = rootValue
        var queue: [TreeNode<Element>?] = []
        queue.append(self)
        while elements.count > 0 {
            let node = queue.removeFirst()
            if let value = elements.removeFirst() {
                queue.append(TreeNode<Element>(value))
            } else {
                queue.append(nil)
            }
            node?.left = queue.last ?? nil
            
            if elements.count > 0, let value = elements.removeFirst() {
                queue.append(TreeNode<Element>(value))
            } else {
                queue.append(nil)
            }
            node?.right = queue.last ?? nil
        }
    }
    
    //按层序将二叉树输出为数组
    public func bfs() -> [Element] {
        var result: [Element] = []
        var queue: [TreeNode<Element>?] = []
        queue.append(self)
        while queue.count > 0 {
            if let node = queue.removeFirst() {
                result.append(node.value)
                if let left = node.left {
                    queue.append(left)
                }
                if let right = node.right {
                    queue.append(right)
                }
            }
        }
        return result
    }
}

extension TreeNode where Element: BSTValue {

    //验证是否为二叉搜索树
    func isBST() -> Bool {
        return between(lower: Element.min, upper: Element.max)
    }
    
    func between(lower: Element, upper: Element) -> Bool {
        if value <= lower || value >= upper {
            return false
        }
        let leftResult = left?.between(lower: lower, upper: value) ?? true
        let rightResult = right?.between(lower: value, upper: upper) ?? true
        
        return leftResult && rightResult
    }
    
    func insert(_ element: Element) {
        if element < value {
            if let left = left {
                left.insert(element)
            } else {
                left = TreeNode(element)
            }
        } else if element > value {
            if let right = right {
                right.insert(element)
            } else {
                right = TreeNode(element)
            }
        }
    }
}

extension Int: Limitable {}

func createArray(length: Int) -> [Int] {
    let valueRange = 1..<100
    var array: [Int] = []
    for _ in 0..<length {
        let value = Int.random(in: valueRange)
        array.append(value)
    }
    return array
}

func testBfs() {
    let date = Date()
    for _ in 0..<50000 {
        let randomArray = createArray(length: 10)
        if let rootNode = TreeNode<Int>(randomArray) {
            let bfsArray = rootNode.bfs()
            assert(randomArray == bfsArray, "randomArray = \(randomArray)\nbfsArray = \(bfsArray)")
        }
    }
    let endDate = Date()
    let time = endDate.timeIntervalSince(date)
    print("耗时: \(time)秒")
}

func testBST() {
    var array = createArray(length: 10)
    print("Array = \(array)")
    let value = array.removeFirst()
    let rootNode = TreeNode<Int>(value)
    for value in array {
        rootNode.insert(value)
    }
    
    let iterator = BSTIterator(rootNode)
}


class BSTIterator {

    var elements: [TreeNode<Int>] = []

    init(_ root: TreeNode<Int>?) {
        findMin(node: root)
        for element in elements {
            print("\(element.value)")
        }
    }
    
    func findMin(node: TreeNode<Int>?) {
        guard let node = node else {
            return
        }
        findMin(node: node.left)
        elements.append(node)
        findMin(node: node.right)
    }
    
    /** @return the next smallest number */
    func next() -> Int {
        return elements.removeFirst().value
    }
    
    /** @return whether we have a next smallest number */
    func hasNext() -> Bool {
        return elements.count > 0
    }
}


