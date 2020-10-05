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
  
  // 5
  init() {}
  
  // 6
  init(id: UUID? = nil, short: String, long: String) {
    self.id = id
    self.short = short
    self.long = long
  }
}

extension Acronym: Content {}
