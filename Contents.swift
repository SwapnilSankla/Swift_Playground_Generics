import UIKit

// Generic method

func swap<T>(inout value1: T, inout value2: T) {
    let temp = value1
    value1 = value2
    value2 = temp
}

var firstInt = 10; var secondInt = 20
swap(&firstInt, &secondInt)
firstInt; secondInt

var firstString = "first"; var secondString = "second"
swap(&firstString, &secondString)
firstString; secondString

// Generic structure
struct Stack<Element> {
    var arr: Array<Element> = []
    var stackTop = -1
    mutating func push(e: Element) {
        stackTop += 1
        arr.insert(e, atIndex: stackTop)
    }

    mutating func pop() -> Element {
        let e = arr[stackTop]
        stackTop -= 1
        return e
    }
}

// In extension ne need to write as generic
extension Stack {
    func top() -> Element {
        return arr[arr.count - 1]
    }
}

var stackOfInt = Stack<Int>()
stackOfInt.push(1); stackOfInt.push(2); stackOfInt.push(3)
stackOfInt.pop(); stackOfInt.pop(); stackOfInt.pop()

var stackOfString = Stack<String>()
stackOfString.push("first"); stackOfString.push("second"); stackOfString.push("third")
stackOfString.pop(); stackOfString.pop(); stackOfString.pop()

// Type Constraint in generics
protocol AreaCalculator {
    func getArea() -> Double
}

struct Circle: AreaCalculator {
    private let radius: Double
    init(radius: Double) {
        self.radius = radius
    }

    func getArea() -> Double {
        return 3.14 * radius * radius
    }
}

struct Triangle: AreaCalculator {
    private let height: Double, base: Double

    init(height: Double, base: Double) {
        self.height = height
        self.base = base
    }

    func getArea() -> Double {
        return 0.5 * base * height
    }
}

struct Calculator<T: AreaCalculator> {
    func getArea(t:T) -> Double {
        return t.getArea()
    }
}

struct Room {
    let length: Double, width: Double, height: Double

    func getArea() -> Double {
        return 0.0
    }
}

let circle = Circle(radius: 5); let calculator1 = Calculator<Circle>(); calculator1.getArea(circle)
let triangle = Triangle(height: 5, base: 2); let calculator2 = Calculator<Triangle>(); calculator2.getArea(triangle)
//let calculator3 = Calculator<Room>() // error: Type 'Room' does not conform to protocol AreaCalculator

protocol ViewModel {
    associatedtype ItemType
    func getAreaDisplayString() -> String
}

struct CircleViewModel: ViewModel {
    typealias ItemType = Circle
    func getAreaDisplayString() -> String {
        return ItemType(radius: 5).getArea().description
    }
}

struct TriangleViewModel: ViewModel {
    typealias ItemType = Triangle
    func getAreaDisplayString() -> String {
        return ItemType(height: 2, base: 5).getArea().description
    }
}

struct Presenter {
    func getArea<T: ViewModel where T.ItemType: AreaCalculator>(t:T) -> String {
        return t.getAreaDisplayString()
    }
}

struct Controller<T: ViewModel> {
    private let presenter = Presenter()
    private let viewModel: T

    func getAreaText() -> String {
        return ""
        //return presenter.getArea(viewModel)
    }
}

let circleController = Controller<CircleViewModel>(viewModel: CircleViewModel())
circleController.getAreaText()
let triangleController = Controller<TriangleViewModel>(viewModel: TriangleViewModel())
triangleController.getAreaText()