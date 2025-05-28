import Peripheral

import Foundation

public protocol StorageAPI {
    typealias ByteStream = AsyncThrowingStream<[UInt8], Swift.Error>
    typealias ByteCountStream = AsyncThrowingStream<Int, Swift.Error>

    func space(of path: Path) async throws -> StorageSpace

    func list(
        at path: Path,
        calculatingMD5: Bool,
        sizeLimit: Int
    ) async throws -> [Element]

    func size(of path: Path) async throws -> Int
    func hash(of path: Path) async throws -> Hash
    func timestamp(of path: Path) async throws -> Date

    func create(at path: Path, isDirectory: Bool) async throws
    func delete(at path: Path, force: Bool) async throws
    func read(at path: Path) async -> ByteStream
    func write(at path: Path, bytes: [UInt8]) async -> ByteCountStream
    func move(at path: Path, to: Path) async throws
}

extension StorageAPI {
    func list(
        at path: Path,
        calculatingMD5: Bool
    ) async throws -> [Element] {
        try await self.list(
            at: path,
            calculatingMD5: calculatingMD5,
            sizeLimit: 0)
    }

    func list(
        at path: Path,
        sizeLimit: Int = 0
    ) async throws -> [Element] {
        try await self.list(
            at: path,
            calculatingMD5: false,
            sizeLimit: sizeLimit)
    }

    func createDirectory(at path: Path) async throws {
        try await create(at: path, isDirectory: true)
    }

    func delete(at path: Path) async throws {
        try await delete(at: path, force: false)
    }

    func write(at path: Path, string: String) async -> ByteCountStream {
        await write(at: path, bytes: .init(string.utf8))
    }
}

extension StorageAPI {
    func fileExists(at path: Path) async throws -> Bool {
        do {
            _ = try await size(of: path)
            return true
        } catch let error as Error where error == .storage(.doesNotExist) {
            return false
        }
    }
}

extension StorageAPI.ByteStream {
    func drain() async throws -> [UInt8] {
        var result: [UInt8] = []
        for try await next in self {
            result += next
        }
        return result
    }
}

extension StorageAPI.ByteCountStream {
    @discardableResult
    func drain() async throws -> Int {
        var result: Int = 0
        for try await next in self {
            result += next
        }
        return result
    }
}

extension StorageAPI {
    func read(
        at path: Path,
        progress: (Double) -> Void
    ) async throws -> String {
        let size = try await size(of: path)
        guard size > 0 else {
            progress(1)
            return ""
        }
        var bytes: [UInt8] = []
        for try await next in await read(at: path) {
            bytes += next
            progress(Double(bytes.count) / Double(size))
        }
        return .init(decoding: bytes, as: UTF8.self)
    }

    func write(
        at path: Path,
        bytes: [UInt8],
        progress: (Double) -> Void
    ) async throws {
        guard !bytes.isEmpty else {
            progress(1)
            return
        }
        var sent = 0
        for try await next in await write(at: path, bytes: bytes) {
            sent += next
            progress(Double(sent) / Double(bytes.count))
        }
    }

    func write(
        at path: Path,
        string: String,
        progress: (Double) -> Void
    ) async throws {
        try await write(
            at: path,
            bytes: [UInt8](string.utf8),
            progress: progress)
    }
}
