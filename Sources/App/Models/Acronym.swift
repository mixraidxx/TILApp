import Vapor
import Fluent

final class Acronym: Model {
    // nombre de la tabla
    static let schema = "acronyms"
    
    // 3
    @ID
    var id: UUID?
    
    // key es el nombre de la columna de la tabla
    @Field(key: "short")
    var short: String
    
    @Field(key: "long")
    var long: String
    
    @Parent(key: "userID")
    var user: User
    
    @Siblings(
      through: AcronymCategoryPivot.self,
      from: \.$acronym,
      to: \.$category)
    var categories: [Category]

    
    init() {}
    
    init(
        id: UUID? = nil,
        short: String,
        long: String,
        userID: User.IDValue
    ) {
        self.id = id
        self.short = short
        self.long = long
        // 2
        self.$user.id = userID
    }
}

extension Acronym: Content {}
