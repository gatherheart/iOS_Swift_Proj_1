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

