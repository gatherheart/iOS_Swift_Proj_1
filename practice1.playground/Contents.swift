import UIKit

"""

written by bean.milky
2021-01-05

"""

enum FrameColor {
    case white, black, yellow, red, blue, green, brown, cyan, purple, pink, orange, gray
}

class Utils {
    public static func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyz0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

protocol FrameProtocol {
    var origin: CGPoint { get set }
    var size: CGSize { get set }
    var center : CGPoint { get }
    var superFrame : Frame? { get set }
    var subFrames : [Frame] { get }
    var color : FrameColor { get set }
    var description: String { get }
    func add(frame: Frame)
    func insert(frame: Frame, at index:Int)
    func removeFromSuper()
    func recursiveDescription() -> String
    func remove(frame: Frame)
    func hitTest(point: CGPoint) -> Frame?
    func isPoint(inside: CGPoint) -> Bool
    func convert(point: CGPoint, from: Frame?) -> CGPoint
    func convert(point: CGPoint, to: Frame?) -> CGPoint
}

class Frame: FrameProtocol {
    public let fid: String
    public var origin: CGPoint
    public var size: CGSize
    private(set) public var center: CGPoint
    public var superFrame : Frame?
    public var subFrames : [Frame]
    private var zIndex : Int = 0
    private var absoluteOrigin: CGPoint // position relative to the topmost frame
    static public var topFrame: Frame?
    public var color : FrameColor = FrameColor.white
    public var description: String {
        return """
            Frame:(\(fid)) \(self.color) \
            origin(\(String(format: "x: %.0f", self.origin.x)), \(String(format: "y: %.0f", self.origin.y))) \
            size(\(String(format: "width: %.0f", self.size.width)), \(String(format: "height: %.0f", self.size.height)))
            """
    }
    public var shortDescription: String {
        return "Frame:(\(fid)) \(self.color)"
    }
    
    private class func idGenerator() -> String {
        return "\(Utils.randomString(length: 3))-\(Utils.randomString(length: 3))-\(Utils.randomString(length: 3))"
    }
    
    public init(origin: CGPoint, size: CGSize){
        self.fid = Frame.idGenerator()
        self.origin = origin
        self.absoluteOrigin = CGPoint(x: origin.x, y: origin.y)
        self.size = size
        self.center = CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height / 2)
        self.subFrames = [Frame]()
        if Frame.topFrame == nil {
            Frame.topFrame = self
        }
    }
    
    public init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat){
        self.fid = Frame.idGenerator()
        self.origin = CGPoint(x: x, y: y)
        self.absoluteOrigin = CGPoint(x: x, y: y)
        self.size = CGSize(width: width, height: height)
        self.center = CGPoint(x: self.origin.x + size.width / 2, y: self.origin.y + size.height / 2)
        self.subFrames = [Frame]()
        if Frame.topFrame == nil {
            Frame.topFrame = self
        }
    }
    
    private func adjustPosition(origin: CGPoint){
        self.origin = origin
        self.center = CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height / 2)
    }
    
    public func add(frame: Frame) {
        // 하위 frame origin 좌표는 상위 frame origin을 기준으로 상대적으로 떨어짐
        let newOrigin = CGPoint(x: frame.origin.x - self.absoluteOrigin.x, y: frame.origin.y - self.absoluteOrigin.y)
        frame.absoluteOrigin = CGPoint(x: frame.origin.x, y: frame.origin.y)
        frame.origin = newOrigin
        frame.adjustPosition(origin: newOrigin)
        frame.superFrame = self
        frame.zIndex = self.zIndex + 1
        self.subFrames.append(frame)
    }
    
    // 하위에 frame을 특정한 위치(index > 0)에 삽입
    public func insert(frame: Frame, at index:Int){
        if index <= 0 {
            return
        }
        let newOrigin = CGPoint(x: frame.origin.x - self.absoluteOrigin.x, y: frame.origin.y - self.absoluteOrigin.y)
        frame.absoluteOrigin = CGPoint(x: frame.origin.x, y: frame.origin.y)
        frame.origin = newOrigin
        frame.adjustPosition(origin: newOrigin)
        frame.superFrame = self
        frame.zIndex = self.zIndex + 1
        self.subFrames.insert(frame, at: index)
    }
    
    // 자신을 포함하는 상위 frame에서 제거
    public func removeFromSuper() {
        if let index = self.superFrame?.subFrames.firstIndex(where: { $0.fid == self.fid }) {
            self.superFrame?.subFrames.remove(at: index)
        }
    }
    // 하위 특정 frame을 찾아서 제거
    public func remove(frame: Frame) {
        if let index = self.subFrames.firstIndex(where: { $0.fid == frame.fid }) {
            self.subFrames.remove(at: index)
        }
    }
    // 해당 좌표를 기준으로 가장 위에 있는 하위 frame을 찾아서 리턴
    public func hitTest(point: CGPoint) -> Frame? {
        // point, which is relative to current frame
        let _point = CGPoint(x: point.x - self.origin.x, y: point.y - self.origin.y)
        if self.subFrames.isEmpty && self.isPoint(inside: _point){
            return self
        }
        for sub in self.subFrames.reversed() {
            if let ret = sub.hitTest(point: CGPoint(x: _point.x, y: _point.y)) {
                return ret
            }
        }
        return self.isPoint(inside: _point) ? self : nil
    }
    
    public func isPoint(inside: CGPoint) -> Bool {
        if inside.x > self.size.width || inside.x < 0 || inside.y > self.size.height || inside.y < 0{
            return false
        }
        return true
    }

    public func recursiveDescription() -> String {
        let header = "\(String(repeating: "  ", count: self.zIndex))\(self.zIndex != 0 ? "ㄴ " : "")"
        var ret: String = "\(header)\(self.description)\n"

        for sub in self.subFrames {
            ret += "\(sub.recursiveDescription())"
        }
        
        return ret
    }
        
    public func convert(point: CGPoint, from: Frame?) -> CGPoint {
        let to: CGPoint = self.absoluteOrigin
        if let _from = from {
            return CGPoint(x: _from.absoluteOrigin.x + point.x - to.x, y: _from.absoluteOrigin.y + point.y - to.y)
        }
        else {
            // if there is no top level frame, return error (or throw error)
            guard let _from = Frame.topFrame else { return CGPoint(x: -0xFFFF, y: -0xFFFF) }
            return CGPoint(x: _from.absoluteOrigin.x + point.x - to.x, y: _from.absoluteOrigin.y + point.y - to.y)
        }
    }
    
    public func convert(point: CGPoint, to: Frame?) -> CGPoint {
        if let _to = to {
            return _to.convert(point: point, from: self)
        }
        else {
            guard let _to = Frame.topFrame else { return CGPoint(x: -0xFFFF, y: -0xFFFF) }
            return _to.convert(point: point, from: self)
        }
    }
    
    public func printHitTestResult(point: CGPoint) {
        if let result = self.hitTest(point: point) {
            print("point\((Int(point.x), Int(point.y))) --> \(result.shortDescription)")
        }
    }
}

let frame1 = Frame(origin: CGPoint(x: 0, y: 0), size: CGSize(width:768, height:1024)) // white
let frame2 = Frame(origin: CGPoint(x: 20, y: 20), size: CGSize(width: 728, height: 440)) // orange
let frame3 = Frame(origin: CGPoint(x: 20, y: 484), size: CGSize(width: 352, height: 520)) // red
let frame4 = Frame(origin: CGPoint(x: 396, y: 484), size: CGSize(width: 352, height: 320)) // blue
let frame5 = Frame(origin: CGPoint(x: 396, y: 828), size: CGSize(width: 3532, height: 176)) // green
let frame6 = Frame(origin: CGPoint(x: 56, y: 56), size: CGSize(width: 314, height: 372)) // purple
let frame7 = Frame(origin: CGPoint(x: 94, y: 694), size: CGSize(width: 200, height: 100)) // yellow
let frame8 = Frame(origin: CGPoint(x: 202, y: 90), size: CGSize(width: 512, height: 200)) // gray
let frame9 = Frame(origin: CGPoint(x: 316, y: 140), size: CGSize(width: 256, height: 256)) // cyan

frame2.color = FrameColor.orange
frame3.color = FrameColor.red
frame4.color = FrameColor.blue
frame5.color = FrameColor.green
frame6.color = FrameColor.purple
frame7.color = FrameColor.yellow
frame8.color = FrameColor.gray
frame9.color = FrameColor.cyan

frame1.add(frame: frame2)
frame1.add(frame: frame3)
frame1.add(frame: frame4)
frame1.add(frame: frame5)

frame2.add(frame: frame6)
frame2.add(frame: frame8)
frame2.add(frame: frame9)

frame3.add(frame: frame7)

print(">> recursiveDescription")
print(frame1.recursiveDescription())

print(">> hitTest")
frame1.printHitTestResult(point: CGPoint(x: 128, y: 200))
frame1.printHitTestResult(point: CGPoint(x: 255, y: 200))
frame1.printHitTestResult(point: CGPoint(x: 382, y: 200))
frame1.printHitTestResult(point: CGPoint(x: 196, y: 716))
frame1.printHitTestResult(point: CGPoint(x: 324, y: 716))
frame1.printHitTestResult(point: CGPoint(x: 450, y: 716))
print()

print(">> point")
print("\(frame8.shortDescription) contains")
let convert1 = frame8.convert(point: CGPoint(x: 128, y: 200), from: frame1)
let convert2 = frame8.convert(point: CGPoint(x: 255, y: 200), from: frame1)
let convert3 = frame8.convert(point: CGPoint(x: 382, y: 200), from: frame1)
print("point\((128, 200)) => \(convert1) \(frame8.isPoint(inside: convert1))")
print("point\((255, 200)) => \(convert2) \(frame8.isPoint(inside: convert2))")
print("point\((382, 200)) => \(convert3) \(frame8.isPoint(inside: convert3))")

print("\(frame7.shortDescription) contains")
let convert4 = frame7.convert(point: CGPoint(x: 196, y: 716), from: frame1)
let convert5 = frame7.convert(point: CGPoint(x: 324, y: 716), from: frame1)
let convert6 = frame7.convert(point: CGPoint(x: 450, y: 716), from: frame1)
print("point\((196, 716)) => \(convert4) \(frame7.isPoint(inside: convert4))")
print("point\((324, 716)) => \(convert5) \(frame7.isPoint(inside: convert5))")
print("point\((450, 716)) => \(convert6) \(frame7.isPoint(inside: convert6))")

