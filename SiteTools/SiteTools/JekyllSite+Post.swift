import Foundation

struct JekyllSite {
}

// MARK: - Post
extension JekyllSite {
    struct Post {
        private let item: ResourceItem
        private let itemFullPath: String
        
        init(resourceItem: ResourceItem,
             resourceItemFullPath: String) {
            self.item = resourceItem
            self.itemFullPath = resourceItemFullPath
        }
        
        func name() -> String {
            let datePart = (item.date.split(separator: " ").first ?? "")
            let titlePart = item.title.lowercased().replacingOccurrences(of: " ", with: "-")
            return datePart + "-" + titlePart + ".md"
        }
        
        private func category() -> String {
            Array(
                itemFullPath
                    .components(separatedBy: "/")
                    .suffix(2)
            )
                .first ?? ""
        }
        
        func content() -> String {
            "---\n" +
            "layout: post\n" +
            "title: \"\(item.title)\"\n" +
            "date: \(item.date)\n" +
            "category: \(category())\n" +
            "tags: \(item.tags)\n" +
            "---\n" +
            "[LINK](\(item.link))"
        }
    }
}
