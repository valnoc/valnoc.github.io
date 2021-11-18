import Foundation

// absoulute for projects/valnoc.github.io
let repoLocalAbsolutePath = CommandLine.arguments[1]
    .replacingOccurrences(of: "~", with: NSHomeDirectory())

let fileManager = FileManager.default

let resourcesFolderPath = repoLocalAbsolutePath + "/resources"
guard let resourcesPathEnumerator = fileManager.enumerator(atPath: resourcesFolderPath) else {
    print("failed to create enumerator for resources folder")
    throw NSError()
}

var resourcesPaths = [String]()
while let file = resourcesPathEnumerator.nextObject() as? String {
    guard file.hasSuffix(".md") else { continue }
    resourcesPaths.append(resourcesFolderPath.appending(file))
}

print(resourcesPaths)
