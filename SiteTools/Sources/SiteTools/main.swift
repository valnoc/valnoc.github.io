import Foundation

// absoulute for projects/valnoc.github.io
let repoLocalAbsolutePath = CommandLine.arguments[1]
    .replacingOccurrences(of: "~", with: NSHomeDirectory())

let fileManager = FileManager.default

guard let resourcesURLsEnumerator = fileManager.enumerator(atPath: repoLocalAbsolutePath + "/resources") else {
    print("failed to create enumerator for resources folder")
    throw NSError()
}

var resourcesURLs = [URL]()
print(resourcesURLs)
