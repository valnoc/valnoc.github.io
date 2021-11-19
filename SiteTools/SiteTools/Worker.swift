import Foundation
import ShellOut

class Worker {
    func start(projectRepoAbsolutePath: String,
               resourcesFolderPath: String,
               sitePostsFolderPath: String) throws {
        let fileManager = FileManager.default

        let resourcesFolderAbsolutePath = projectRepoAbsolutePath + resourcesFolderPath
        guard let resourcesPathEnumerator = fileManager.enumerator(atPath: resourcesFolderAbsolutePath) else {
            print("failed to create enumerator for resources folder")
            throw NSError()
        }

        var resourcesPaths = [String]()
        while let path = resourcesPathEnumerator.nextObject() as? String {
            guard path.hasSuffix(".json") else { continue }
            resourcesPaths.append(resourcesFolderAbsolutePath.appending("/\(path)"))
        }
        
        let sitePostsFolderAbsolutePath = projectRepoAbsolutePath + sitePostsFolderPath
        
        for path in resourcesPaths {
            let item: ResourceItem = try decodeJsonObject(path)
            
            let postNameDatePart = (item.date.split(separator: " ").first ?? "")
            let postNameTitlePart = item.title.lowercased().replacingOccurrences(of: " ", with: "-")
            let postName =  postNameDatePart + "-" + postNameTitlePart + ".md"
            
            let category = Array(
                path
                    .components(separatedBy: "/")
                    .suffix(2)
            )
                .first ?? ""
            
            let contentSTR = "---\n" +
            "layout: post\n" +
            "title: \"\(item.title)\"\n" +
            "date: \(item.date)\n" +
            "category: \(category)\n" +
            "tags: \(item.tags)\n" +
            "---\n"
            
            fileManager.createFile(atPath: sitePostsFolderAbsolutePath.appending("/\(postName)"),
                                   contents: contentSTR.data(using: .utf8),
                                   attributes: [:])
        }
        
        try shellOut(to: "bundle exec jekyll serve", at: projectRepoAbsolutePath)
    }
}

// MARK: - private
extension Worker {
    private func decodeJsonObject<T: Decodable>(_ path: String) throws -> T {
        try JSONDecoder().decode(T.self,
                                 from: try String(contentsOfFile: path).data(using: .utf8) ?? Data())
    }
}
