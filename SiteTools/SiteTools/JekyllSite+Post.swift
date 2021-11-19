import Foundation

struct JekyllSite {
}

// MARK: - Post
extension JekyllSite {
    struct Post {
        let name: String
        let content: String
        
        init(item: ResourceItem,
             itemFullPath: String) {
            let datePart = (item.date.split(separator: " ").first ?? "")
            let titlePart = item.title.lowercased().replacingOccurrences(of: " ", with: "-")
            self.name = datePart + "-" + titlePart + ".md"
            
            let category = Array(
                itemFullPath
                    .components(separatedBy: "/")
                    .suffix(2)
            )
                .first ?? ""
            
            self.content = "---\n" +
            "layout: post\n" +
            "title: \"\(item.title)\"\n" +
            "date: \(item.date)\n" +
            "category: \(category)\n" +
            "tags: \(item.tags)\n" +
            "---\n" +
            "[LINK](\(item.link))"
        }
    }
}
