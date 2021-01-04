import UIKit

var str = "Hello, playground"

func add(number1 : Int, number2: Int) -> Int {
    let sum = number1 + number2
    return sum
}

func add(number1 : Int, number2: Int, number3: Int) -> Int {
    let sum = number1 + number2 + number3
    return sum
}

func substract(number1: Int, number2: Int) -> Int {
    return number1 - number2
}
func square(number: Int) -> Int {
    return number * number
}
func divide(number: Int, divisor: Int) -> Int {
    return number / divisor
}

add(number1: 123, number2: 234)
substract(number1: 456, number2: 123)
square(number: 8)
divide(number: 256, divisor: 8)


// Mission #1
let INCH_TO_CM: Float = 2.54
let METER_TO_CM: Float = 1000

func convertToCM(fromInches : Float) -> Float {
    return fromInches * INCH_TO_CM
}

func convertToInches(fromCM : Float) -> Float {
    return fromCM / INCH_TO_CM
}

func convertToInches(fromMeter : Float) -> Float {
    return fromMeter * METER_TO_CM / INCH_TO_CM
}

print(convertToCM(fromInches: 50))
print(convertToCM(fromInches: 15))


print(convertToInches(fromCM: 1.5))
print(convertToInches(fromCM: 0.4))

print(convertToInches(fromMeter: 1.5))
print(convertToInches(fromMeter: 0.4))


// Mission Pre
let http404Error = (404, "Not Found")
// http404Error is of type (Int, String), and equals (404, "Not Found")


let (statusCode, statusMessage) = http404Error
print("The status code is \(statusCode)")
// Prints "The status code is 404"
print("The status message is \(statusMessage)")
// Prints "The status message is Not Found"

print("The status code is \(http404Error.0)")
// Prints "The status code is 404"
print("The status message is \(http404Error.1)")
// Prints "The status message is Not Found"

let http200Status = (statusCode: 200, description: "OK")
struct Resolution {
    var width = 0
    var height = 0
}
let someResolution = Resolution()
print(someResolution.width)

let vga = Resolution(width: 640, height: 480)

// Mission #2

struct Rectangle {
    var leftTopX: Float = 0, leftTopY: Float = 0
    var rightBottomX: Float = 0, rightBottomY: Float = 0
    // coordinates of all vertex of rectangle
    func printRect() {
        print((self.leftTopX, self.leftTopY), (self.rightBottomX, self.leftTopY),
              (self.rightBottomX, self.rightBottomY),
              (self.leftTopX, rightBottomY))
    }
    // area of rectangle
    func printArea() {
        print((self.rightBottomX - self.leftTopX) * (self.leftTopY - self.rightBottomY))
    }
    // center of rectangle
    func printCenter() {
        print(((self.rightBottomX + self.leftTopX) / 2,  (self.leftTopY + self.rightBottomY) / 2))
    }
}

let rect = Rectangle(leftTopX: 5, leftTopY: 11, rightBottomX: 15, rightBottomY: 4)

rect.printRect()
rect.printArea()

let rect2 = Rectangle(leftTopX: 4.5, leftTopY: 10.5, rightBottomX: 15, rightBottomY: 3.5)

rect2.printRect()
rect2.printArea()
rect2.printCenter()
