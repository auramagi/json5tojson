import ArgumentParser
import Foundation

struct JSON5toJSON: ParsableCommand {
    @Argument(help: "Input JSON5 file", completion: .file())
    var input: String
    
    @Argument(help: "Input JSON5 file", completion: .file())
    var output: String?
    
    func run() throws {
        let json = try read()
        try write(json)
    }
}

extension JSON5toJSON {
    func makeInputStream() throws -> InputStream {
        guard FileManager.default.fileExists(atPath: input) else {
            throw "Not file at path \(input)"
        }
        return try InputStream(fileAtPath: input)
            .unwrapOrThrow("Can't open file at path \(input)")
    }
    
    func makeOutputStream() throws -> OutputStream {
        if let output = output {
            return try OutputStream(toFileAtPath: output, append: false)
                .unwrapOrThrow("Can't open file at path \(output)")
        } else {
            return try OutputStream(toFileAtPath: "/dev/stdout", append: false)
                .unwrapOrThrow("Can't open stdout")
        }
    }
    
    var readingOptions: JSONSerialization.ReadingOptions {
        [.json5Allowed]
    }
    
    var writingOptions: JSONSerialization.WritingOptions {
        [.prettyPrinted]
    }
    
    func read() throws -> Any {
        let stream = try makeInputStream()
        stream.open()
        defer { stream.close() }
        
        do {
            return try JSONSerialization.jsonObject(with: stream, options: readingOptions)
        } catch {
            throw "Error decoding JSON5 file: \(error)"
        }
    }
    
    func write(_ json: Any) throws {
        let stream = try makeOutputStream()
        stream.open()
        defer { stream.close() }
        
        var error: NSError?
        JSONSerialization.writeJSONObject(json, to: stream, options: writingOptions, error: &error)
        if let error = error {
            throw "Error while writing conversion output: \(error)"
        }
    }
}

JSON5toJSON.main()
