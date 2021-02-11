//
//  SocketIOManager.swift
//  Pods-SocketIOClient_Example
//
//  Created by Rz Rasel on 2021-02-10
//

import Foundation
import SocketIO

public var onEventSocketIO: ((String, Any, SocketAckEmitter) -> Void)!
public class SocketIOManager {
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
        prepare()
    }
    public func prepare() {
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
//    public func socketOn(name: String) {
//        socket.on(name) {data, ack in
//            print("Socket on \(name) \(data) : \(self.httpURL) \(#file):\(#line)")
//            onEventSocketIO!(name, data, ack)
//        }
//    }
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
//public var onEventSocketIO: ((String, Any, SocketAckEmitter) -> Void)!
//typealias EventSocketIO = (String, Any, SocketAckEmitter) -> Void
//var onEventSocketIO: (EventSocketIO)?
//var onEventSocketIO: ((String, Any, SocketAckEmitter) -> Void)
//class SocketIOManagerOld01 {
//    private var socketManager: SocketManager!
//    public var socket: SocketIOClient!
//    public var resetAckEmitter: SocketAckEmitter?
//    private var httpURL = ""
//    private var isLog = false
//    private var connParams: [String: Any] = [String: Any]()
////    static let sharedInstance = SocketIOManager()
//    public var isConnected = false
//    //
//    public init(isLog argIsLog: Bool) {
//        isConnected = false
//        isLog = argIsLog
//        connParams.removeAll()
//    }
//    public func connectParams(key argKey: String, value argValue: Any) -> SocketIOManager {
//        connParams[argKey] = argValue
//        return self
//    }
//    public func connectWith(url argURL: String) -> SocketIOManager {
//        httpURL = argURL
//        return self
//    }
//    public func prepareConnection() {
//        prepare()
//    }
//    public func prepare() {
//        guard let url = URL(string: httpURL) else {
//            debugLog(message: "Error: url can't parse \(httpURL)")
//            return
//        }
////        debugLog(message: "Socket manager url: \(httpURL)")
//        print("DEBUG_SOCKET_IO_MANAGER: connection URL" + " \(self.httpURL) File: \(#file) Line: \(#line)")
//        print("DEBUG_SOCKET_IO_MANAGER: connection params" + " File: \(#file) Line: \(#line)")
//        print(connectParams)
////        print("DEBUG_SOCKET_IO_MANAGER: " + " \(self.httpURL) File: \(#file) Line: \(#line)")
//        socketManager = SocketManager(socketURL:  url, config: [.log(isLog), .reconnectWait(6000), .connectParams(connectParams), .forceWebsockets(true), .compress])
//        socket = socketManager.defaultSocket
////        self.debugLog(message: "DEBUG_SOCKET_IO_MANAGER: SOCKET_ID or sid: \(self.socket.sid)")
//    }
//    //
//    public func connect() {
//        socket.on(clientEvent: .connect) {data, ack in
//            print("DEBUG_SOCKET_IO_MANAGER: SOCKET_ID or sid: \(self.socket.sid) File: \(#file) Line: \(#line)")
//            print("DEBUG_SOCKET_IO_MANAGER: socket name: \(SocketClientEvent.connect) \(self.httpURL) File: \(#file) Line: \(#line)")
////            handler(data, ack)
////            onEventSocketIO!(data, ack)
//        }
//    }
//    public func socketOn(name: String) {
//        socket.on(clientEvent: .connect) {data, ack in
////            self.debugLog(message: "DEBUG_SOCKET_IO_MANAGER: SOCKET_ID or sid: \(self.socket.sid)")
//            print("DEBUG_SOCKET_IO_MANAGER: SOCKET_ID or sid: \(self.socket.sid) File: \(#file) Line: \(#line)")
//            print("DEBUG_SOCKET_IO_MANAGER: socket name: \(SocketClientEvent.connect) \(self.httpURL) File: \(#file) Line: \(#line)")
////            self.socket.emit(name, emitParam!)
//        }
////        self.socket.emit(name, params)
//        socket.on(name) {data, ack in
////            self.debugLog(message: "DEBUG_SOCKET_IO_MANAGER: Socket on \(name) \(data) : \(self.httpURL)")
//            print("DEBUG_SOCKET_IO_MANAGER: socket name: \(name) File: \(#file) Line: \(#line)")
////            handler(name, data, ack)
////            onEventSocketIO?(name, data, ack)
//        }
//        if (self.socket?.status == .disconnected || self.socket?.status == .notConnected ) {
//            socketManager.connect()
//            socket.connect()
//        }
//    }
//    //
////    public func socketOn(name: String, handler: @escaping (Any, SocketAckEmitter) -> Void) {
////        socket.on(name) {data, ack in
////            self.debugLog(message: "Socket on \(name) : \(self.httpURL)")
////            handler(data, ack)
////        }
////    }
////    public func socketOn(name: String) {
////        socket.on(name) {data, ack in
////            self.debugLog(message: "Socket on \(name) \(data) : \(self.httpURL)")
////        }
////    }
//    public func emit(name: String, params: SocketData!) {
//        self.socket.emit(name, params)
//    }
//    public func disconnect() {
//        close()
//
//    }
//    public func close() {
//        if socket == nil {
//            return
//        }
//        isConnected = false
//        socket.disconnect()
//        socket = nil
//        debugLog(message: "close")
//    }
//    public func getSocket() -> SocketIOClient {
//        return socket
//    }
//    public func getStatus() -> SocketIOStatus? {
//        guard let status = self.socket?.status else{ return nil }
//        return status
//    }
//    public func debugLog(message: String) {
//        print("\(message) \(self.httpURL) File: \(#file) Line: \(#line)")
//    }
//}
////typealias EventSocketIO = (String, Any, SocketAckEmitter) -> Void
////var onEventSocketIO: (EventSocketIO)?
////var onEventSocketIO: ((String, Any, SocketAckEmitter) -> Void)?
