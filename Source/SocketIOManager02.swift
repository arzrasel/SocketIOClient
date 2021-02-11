//
//  SocketIOManager.swift
//  SwiftSocketIO
//
//  Created by Rz Rasel on 2/7/21.
//

import Foundation
import SocketIO

var onEventSocketIO: ((String, Any, SocketAckEmitter) -> Void)!
class SocketIOManager {
    private var socketManager: SocketManager!
    public var socket: SocketIOClient!
    public var resetAckEmitter: SocketAckEmitter?
    private var httpURL = ""
    private var isLog = false
    private var connectParams: [String: Any] = [String: Any]()
//    static let sharedInstance = SocketIOManager()
    public var isConnected = false
    //
    public init(isLog argIsLog: Bool) {
        isConnected = false
        isLog = argIsLog
        connectParams.removeAll()
    }
    public func params(key argKey: String, value argValue: Any) -> SocketIOManager {
        connectParams[argKey] = argValue
        return self
    }
    public func with(url argURL: String) -> SocketIOManager {
        httpURL = argURL
        return self
    }
    public func prepareConnection() {
        guard let url = URL(string: httpURL) else {
            debugLog(message: "Error: url can't parse \(httpURL)")
            return
        }
//        debugLog(message: "Socket manager url: \(httpURL)")
        print("DEBUG_SOCKET_IO_MANAGER: connection URL" + " \(self.httpURL) File: \(#file) Line: \(#line)")
        print("DEBUG_SOCKET_IO_MANAGER: connection params" + " File: \(#file) Line: \(#line)")
        print(connectParams)
//        print("DEBUG_SOCKET_IO_MANAGER: " + " \(self.httpURL) File: \(#file) Line: \(#line)")
        socketManager = SocketManager(socketURL:  url, config: [.log(isLog), .reconnectWait(6000), .connectParams(connectParams), .forceWebsockets(true), .compress])
        socket = socketManager.defaultSocket
//        self.debugLog(message: "DEBUG_SOCKET_IO_MANAGER: SOCKET_ID or sid: \(self.socket.sid)")
    }
    public func connectOld(handler: @escaping (Any, SocketAckEmitter?) -> Void) {
        guard let url = URL(string: httpURL) else {
            handler("Error: url can't parse \(httpURL)", nil)
            return
        }
        disconnect()
        socketManager = SocketManager(socketURL:  url, config: [.log(isLog), .reconnectWait(6000), .connectParams(connectParams), .forceWebsockets(true), .compress])
        socket = socketManager.defaultSocket
//        socketManager.connect()
        socket.on(clientEvent: SocketClientEvent.connect) {data, ack in
            self.isConnected = true
            self.debugLog(message: "DEBUG_SOCKET_IO_MANAGER: SocketIO connected");
        }
//        socket.on(clientEvent: SocketClientEvent.connect) {data, ack in
//            self.isConnected = true
//            self.debugLog(message: "SocketIO connected");
//            self.socket.emit("message", "data")
//        }
//        socket.on("message") {data, ack in
//            print("message data received \(data) \(#file):\(#line)")
//            handler(data, ack)
//        }
        if (self.socket?.status == .disconnected || self.socket?.status == .notConnected ) {
            socketManager.connect()
            socket.connect()
            self.debugLog(message: "DEBUG_SOCKET_IO_MANAGER: SOCKET_ID or sid: \(self.socket.sid)")
        }
    }
    //
    public func connect(handler: @escaping (Any, SocketAckEmitter?) -> Void) {
        socket.on(clientEvent: .connect) {data, ack in
            print("DEBUG_SOCKET_IO_MANAGER: SOCKET_ID or sid: \(self.socket.sid) File: \(#file) Line: \(#line)")
            print("DEBUG_SOCKET_IO_MANAGER: socket name: \(SocketClientEvent.connect) \(self.httpURL) File: \(#file) Line: \(#line)")
//            handler(data, ack)
//            onEventSocketIO!(data, ack)
        }
    }
    //
//    @available(*, deprecated, message: "Try to don't use it")
//    public func socketOn(name: String, params: SocketData!, handler: @escaping (Any, SocketAckEmitter) -> Void) {
    public func socketOn(name: String, handler: @escaping (String, Any, SocketAckEmitter) -> Void) {
//        debugLog(message: "SOCKET_NAME: \(name)")
//        prepareConnection()
        socket.on(clientEvent: .connect) {data, ack in
//            self.debugLog(message: "DEBUG_SOCKET_IO_MANAGER: SOCKET_ID or sid: \(self.socket.sid)")
            print("DEBUG_SOCKET_IO_MANAGER: SOCKET_ID or sid: \(self.socket.sid) File: \(#file) Line: \(#line)")
            print("DEBUG_SOCKET_IO_MANAGER: socket name: \(SocketClientEvent.connect) \(self.httpURL) File: \(#file) Line: \(#line)")
//            self.socket.emit(name, emitParam!)
        }
//        self.socket.emit(name, params)
        socket.on(name) {data, ack in
//            self.debugLog(message: "DEBUG_SOCKET_IO_MANAGER: Socket on \(name) \(data) : \(self.httpURL)")
            print("DEBUG_SOCKET_IO_MANAGER: socket name: \(name) File: \(#file) Line: \(#line)")
            handler(name, data, ack)
            onEventSocketIO(name, data, ack)
        }
//        socket.on("message") {data, ack in
//            self.debugLog(message: "DEBUG_SOCKET_IO_MANAGER: Socket on \(name) \(data) : \(self.httpURL)")
//            handler(data, ack)
//        }
//        socketManager.connect()
//        socket.connect()
//        socket.on(clientEvent: .connect) {data, ack in
        //            print("socket connected \(self.httpURL)")
        //            handler(data, ack)
        //        }
//        socket.on(clientEvent: SocketClientEvent.connect) { _, _ in
//            print("socket connected \(#file):\(#line)")
//            self.socket.emit("message", "data")
//        }
//        //
//        socket.on("message") {data, _ in
//            print("message data received \(data) \(#file):\(#line)")
//        }
        if (self.socket?.status == .disconnected || self.socket?.status == .notConnected ) {
            socketManager.connect()
            socket.connect()
        }
    }
    //
//    public func socketOn(name: String, handler: @escaping (Any, SocketAckEmitter) -> Void) {
//        socket.on(name) {data, ack in
//            print("DEBUG_SOCKET_IO_MANAGER: socket name: \(name) File: \(#file) Line: \(#line)")
////            handler(data, ack)
////            onEventSocketIO!(data, ack)
//        }
//    }
    public func socketOn(name: String) {
        socket.on(name) {data, ack in
            print("Socket on \(name) \(data) : \(self.httpURL) \(#file):\(#line)")
            onEventSocketIO!(name, data, ack)
        }
    }
    public func emit(name: String, params: SocketData) {
//        self.socket.emit(name, params)
//        socket.on(clientEvent: .connect) {data, ack in
////            self.socket.emit(name, params)
//            print("\(name) \(params)")
//            self.socket.emit("CALL_REJECTED", params)
//        }
        self.socket.emit(name, params)
        print("\(name) \(params)")
//        self.socket.emit("CALL_REJECTED", params)
//        socket.on("CALL_REJECTED") {data, ack in
//            print("Socket on \(name) \(data) : \(self.httpURL) \(#file):\(#line)")
//        }
    }
    public func disconnect() {
        close()
        
    }
    public func close() {
        if socket == nil {
            return
        }
        isConnected = false
        socket.disconnect()
        socket = nil
        debugLog(message: "close")
    }
    public func getSocket() -> SocketIOClient {
        return socket
    }
    public func getStatus() -> SocketIOStatus? {
        guard let status = self.socket?.status else{ return nil }
        return status
    }
    public func debugLog(message: String) {
        print("DEBUG_SOCKET_IO_MANAGER: \(message) \(self.httpURL) File: \(#file) Line: \(#line)")
    }
}
typealias EventSocketIO = (String, Any, SocketAckEmitter) -> Void
//var onEventSocketIO: (EventSocketIO)?
class SocketIOManagerOld02 {
    private var socketManager: SocketManager!
    var socket: SocketIOClient!
    var resetAckEmitter: SocketAckEmitter?
    private var httpURL = ""
//    static let sharedInstance = SocketIOManager()
    //
    
    func connect(url: String, isLog: Bool, handler: @escaping (Any, SocketAckEmitter) -> Void) {
        let query = [
            "auth": "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYwMTI3NTlkNWEyOWFhM2U1MDJjMDIxMyIsImlhdCI6MTYxMjc1ODg1NSwiZXhwIjoxNjEzMzYzNjU1fQ.qzRY4DndUvgo_oT7s8vgihiVpDB3rg1BzDC7OKWsG4pZqUqzgvUYR2NSklxAWI9WJoE0NOAsTLe3lBSzNHg96IeXi5AUB05N9R6gTUCDMnyOnOTnwv_jJYAtdLNPlHST2f543HdA4ArtMK_hgY2VZgd50_6j8r1CuoiJrAL8U2eAH4wcXFgSonO1_VPdKK2gJxiVL_aFR0bft32wDI4ZVLIpZ9u3lC3JyIWxPTgWPIIbXsgNASP5BiElYc4xzAlUtvgxnaCuCzaXyUMUzElCzvt1Vw5MTMpivqaer5kz5y-wBkekgHBCQipeYVsm25qBtT01f2I1EKH2zLUBYwXFmg"
        ]
        httpURL = url
        //        socketManager = SocketManager(socketURL: URL(string: url)!, config: [.log(isLog), .compress])
        socketManager  = SocketManager(socketURL:  URL(string: url)!, config: [.log(true), .reconnectWait(6000), .connectParams(["auth": "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYwMTI3NTlkNWEyOWFhM2U1MDJjMDIxMyIsImlhdCI6MTYxMjc1ODg1NSwiZXhwIjoxNjEzMzYzNjU1fQ.qzRY4DndUvgo_oT7s8vgihiVpDB3rg1BzDC7OKWsG4pZqUqzgvUYR2NSklxAWI9WJoE0NOAsTLe3lBSzNHg96IeXi5AUB05N9R6gTUCDMnyOnOTnwv_jJYAtdLNPlHST2f543HdA4ArtMK_hgY2VZgd50_6j8r1CuoiJrAL8U2eAH4wcXFgSonO1_VPdKK2gJxiVL_aFR0bft32wDI4ZVLIpZ9u3lC3JyIWxPTgWPIIbXsgNASP5BiElYc4xzAlUtvgxnaCuCzaXyUMUzElCzvt1Vw5MTMpivqaer5kz5y-wBkekgHBCQipeYVsm25qBtT01f2I1EKH2zLUBYwXFmg"]), .forceWebsockets(true), .compress])
        socket = socketManager.defaultSocket
        //        socket.on(clientEvent: .connect) {data, ack in
        //            print("socket connected \(self.httpURL)")
        //            handler(data, ack)
        //        }
        socket.on("connect") { _, _ in
            print("socket connected \(#file):\(#line)")
            self.socket.emit("message", "data")
        }
        //
        socket.on("message") {data, _ in
            print("message data received \(data) \(#file):\(#line)")
        }
        socketManager.connect()
        //        socket.connect()
    }
    //
    func socketOn(name: String, handler: @escaping (Any, SocketAckEmitter) -> Void) {
        socket.on(name) {data, ack in
            print("socket on \(name) : \(self.httpURL)")
            handler(data, ack)
        }
    }
    func disconnect() {
        socket.disconnect()
    }
    func close() {
        socket.disconnect()
    }
}
class SocketIOManagerOld01: NSObject {
    //    let socketManager = SocketManager(socketURL: URL(string: AppConstant.HTTP.API.INDEX)!)
    //    static let sharedInstance = SocketIOManager()
    ////    var socket = SocketIOClient(socketURL: URL(string: AppConstant.HTTP.API.INDEX)!, config: [.log(false), .forcePolling(true)])
    ////    var socket = SocketIOClient(socketURL: URL(string: AppConstant.HTTP.API.INDEX)!, config: [.log(false), .forcePolling(true)])
    //    var socket = SocketIOClient(manager: <#T##SocketManagerSpec#>, nsp: <#T##String#>)
    ////    let socket = SocketIOClient(socketURL: URL(string: AppConstant.HTTP.API.INDEX)!)
    //    var socketManager = SocketManager(socketURL: URL(string: AppConstant.HTTP.API.REALTIME)!, config: [.log(true), .compress])
    private var socketManager: SocketManager!
    var socket: SocketIOClient!
    var resetAckEmitter: SocketAckEmitter?
    private var httpURL = ""
    
    override init() {
        super.init()
        //        socket = socketManager.defaultSocket
        //        socket.on("test") { data, ack in
        //            print(data)
        //        }
        //        self.socket.on("win") {[weak self] data, ack in
        //            if let name = data[0] as? String, let typeDict = data[1] as? NSDictionary {
        ////                self?.handleWin(name, type: typeDict)
        //                print("Value: \(name) \(typeDict)")
        //            }
        //        }
    }
    
    //    func establishConnection() {
    //        socket.connect()
    //    }
    //
    //    func closeConnection() {
    //        socket.disconnect()
    //    }
    //    func connect() {
    //        socket.connect()
    //    }
    //
    //    func disconnect() {
    //        socket.disconnect()
    //    }
    //    func start(name: String, handler: @escaping (Any) -> Void) {
    //        socket.on(name) { data, ack in
    //            print(data)
    //        }
    //    }
    func connectOld01(name: String, url: String, isLog: Bool, handler: @escaping (Any, SocketAckEmitter) -> Void) {
        httpURL = url
        socketManager = SocketManager(socketURL: URL(string: url)!, config: [.log(isLog), .compress])
        socket = socketManager.defaultSocket
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected \(self.httpURL)")
        }
        //
        socket.on(name) { data, ack in
            print("================Socket connected")
            // Sending messages
            self.socket.emit("testEcho")
            //            print(data)
            handler(data, ack)
        }
        socket.connect()
    }
    func connectOld02(url: String, isLog: Bool, handler: @escaping (Any, SocketAckEmitter) -> Void) {
        socketManager = SocketManager(socketURL: URL(string: url)!, config: [.log(isLog), .compress])
        socket = socketManager.defaultSocket
        socket.connect()
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected \(self.httpURL)")
            handler(data, ack)
        }
    }
    func socketOn(name: String, handler: @escaping (Any, SocketAckEmitter) -> Void) {
        socket.on(name) {data, ack in
            print("socket on \(name) : \(self.httpURL)")
            handler(data, ack)
        }
    }
    func disconnect() {
        socket.disconnect()
    }
    func close() {
        socket.disconnect()
    }
}
/*
 /// A typealias for an ack callback.
 public typealias AckCallback = ([Any]) -> ()
 /// A typealias for a normal callback.
 public typealias NormalCallback = ([Any], SocketAckEmitter) -> ()
 /// A typealias for a queued POST
 public typealias Post = (msg: String, completion: (() -> ())?)
 //https://www.youtube.com/watch?v=X84FRywsJB8&ab_channel=%D0%AD%D0%BB%D0%B8%D0%BD%D0%B0%D0%91%D0%B0%D1%82%D1%8B%D1%80%D0%BE%D0%B2%D0%B0
 //https://www.twilio.com/blog/2016/09/getting-started-with-socket-io-in-swift-on-ios.html
 //
 //How to build real time iOS Chat application with Swift intro
 //https://www.youtube.com/watch?v=qS-7b0EiOIg&ab_channel=DavidKababyan
 //Chat Photo Messages in App (Swift 5, Xcode 11) - iOS
 //https://www.youtube.com/watch?v=w7PkyFXqLLw&ab_channel=iOSAcademy
 //
 https://stackoverflow.com/questions/52222791/connect-socketio-with-options-in-swift
 */

/*
 @IBAction func facebookButtonClicked(_ sender: UIButton) {
 Alamofire.request("/login", method: .post, parameters: parameters, encoding: JSONEncoding.default)
 .responseJSON { response in
 if let value = response.result.value {
 let json = JSON(value)
 
 self.keychain["token"] = String(describing: json["token"])
 SocketIOManager.sharedInstance.establishConnection()
 self.segueToAnotherVC() // Segue to another screen, to simplify things i put it in a function
 }
 }
 }
 */
