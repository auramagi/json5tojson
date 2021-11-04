import ArgumentParser
import Foundation


struct JSON5toJSON: ParsableCommand {
    @Argument(help: "Input JSON5 file", completion: .file())
    var input: String
    
    @Argument(help: "Input JSON5 file", completion: .file())
    var output: String?
    
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
    
    func run() throws {
        let inputStream = try makeInputStream()
        inputStream.open()
        defer { inputStream.close() }
        
        let json = try JSONSerialization.jsonObject(with: inputStream, options: readingOptions)
        
        let outputStream = try makeOutputStream()
        outputStream.open()
        defer { outputStream.close() }
        
        var error: NSError?
        JSONSerialization.writeJSONObject(json, to: outputStream, options: writingOptions, error: &error)
        if let error = error { throw error }
    }
}

JSON5toJSON.main()
