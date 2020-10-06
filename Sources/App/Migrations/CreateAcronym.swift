import Fluent
import Vapor
// 1
struct CreateAcronym: Migration {
    // 2
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        // 3
        database.schema("acronyms")
            // 4
            .id()
            // 5
            .field("short", .string, .required)
            .field("long", .string, .required)
            .field("userID", .uuid, .required, .references("users", "id"))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("acronyms").delete()
    }
}

struct CreateAcronymData: Content {
  let short: String
  let long: String
  let userID: UUID
}

