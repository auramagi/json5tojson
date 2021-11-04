import ArgumentParser
import Foundation

struct JSON5toJSON: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "json5tojson",
        abstract: "Convert JSON5 to JSON"
    )
    
    @Flag(name: .shortAndLong, help: "Allow fragments")
    var allowFragments = false
    
    @Flag(name: .shortAndLong, help: "Pretty print output")
    var prettyPrint = false
    
    @Flag(name: .shortAndLong, help: "Sort object keys in output")
    var sortKeys = false
    
    @Argument(
        help: "Input JSON5 file",
        completion: .file()
    )
    var input: String
    
    @Argument(
        help: ArgumentHelp("Output file", discussion: "Write conversion output to this file. If not specified, output is sent to stdout."),
        completion: .file()
    )
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
        var options: JSONSerialization.ReadingOptions = .json5Allowed
        if allowFragments { options.insert(.fragmentsAllowed) }
        return options
    }
    
    var writingOptions: JSONSerialization.WritingOptions {
        var options: JSONSerialization.WritingOptions = []
        if allowFragments { options.insert(.fragmentsAllowed) }
        if prettyPrint { options.insert(.prettyPrinted) }
        if sortKeys { options.insert(.sortedKeys) }
        return options
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
        stream.write([10], maxLength: 1) // Write newline at the end ([10] is "\n")
    }
}

JSON5toJSON.main()
