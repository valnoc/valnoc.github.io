import Foundation

// absoulute for projects/valnoc.github.io
let projectRepoAbsolutePath = CommandLine.arguments[1]
    .replacingOccurrences(of: "~", with: NSHomeDirectory())

try Worker()
    .start(projectRepoAbsolutePath: projectRepoAbsolutePath,
           resourcesFolderPath: "/resources",
           sitePostsFolderPath: "/docs/_posts")
