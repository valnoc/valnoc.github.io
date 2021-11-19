import Foundation

class Worker {
    func start(projectRepoAbsolutePath: String,
               resourcesFolderPath: String,
               sitePostsFolderPath: String) throws {
        
        try cleanupSitePostsFolder(projectRepoAbsolutePath: projectRepoAbsolutePath,
                                   sitePostsFolderPath: sitePostsFolderPath)
        try copyResourcesToSitePostsFolder(projectRepoAbsolutePath: projectRepoAbsolutePath,
                                           resourcesFolderPath: resourcesFolderPath,
                                           sitePostsFolderPath: sitePostsFolderPath)
    }
}

// MARK: - private
extension Worker {
    private func cleanupSitePostsFolder(projectRepoAbsolutePath: String,
                                        sitePostsFolderPath: String) throws {
        let fileManager = FileManager.default
        try fileManager.removeItem(atPath: projectRepoAbsolutePath + sitePostsFolderPath)
        
        try fileManager.createDirectory(atPath: projectRepoAbsolutePath + sitePostsFolderPath,
                                        withIntermediateDirectories: true,
                                        attributes: nil)
    }
    
    private func copyResourcesToSitePostsFolder(projectRepoAbsolutePath: String,
                                                resourcesFolderPath: String,
                                                sitePostsFolderPath: String) throws {
        let fileManager = FileManager.default
        let resourcesFolderAbsolutePath = projectRepoAbsolutePath + resourcesFolderPath
        
        guard let resourcesPathEnumerator = fileManager.enumerator(atPath: resourcesFolderAbsolutePath) else {
            print("failed to create enumerator for resources folder")
            throw NSError()
        }
        
        let sitePostsFolderAbsolutePath = projectRepoAbsolutePath + sitePostsFolderPath
        while let path = resourcesPathEnumerator.nextObject() as? String {
            guard path.hasSuffix(".json") else { continue }
            let fullPath = resourcesFolderAbsolutePath.appending("/\(path)")
            
            let item: ResourceItem = try decodeJsonObject(fullPath)
            let post = JekyllSite.Post(item: item,
                                       itemFullPath: fullPath)
            
            fileManager.createFile(atPath: sitePostsFolderAbsolutePath.appending("/\(post.name)"),
                                   contents: post.content.data(using: .utf8),
                                   attributes: [:])
        }
    }
}

// MARK: - private tools
extension Worker {
    private func decodeJsonObject<T: Decodable>(_ path: String) throws -> T {
        try JSONDecoder().decode(T.self,
                                 from: try String(contentsOfFile: path).data(using: .utf8) ?? Data())
    }
}
