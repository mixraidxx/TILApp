import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    app.post("api", "acronyms"){ req -> EventLoopFuture<Acronym> in
    let acronym = try req.content.decode(Acronym.self)

    return acronym.save(on: req.db).map {
        acronym
    } 
    }

    app.get("api", "acronyms"){ req -> EventLoopFuture<[Acronym]> in
        Acronym.query(on: req.db).all()
    }

    app.get("api", "acronyms", ":acronymID"){ req -> EventLoopFuture<Acronym> in
    Acronym.find(req.parameters.get("acronymID"), on: req.db)
    .unwrap(or: Abort(.notFound))
    }

    // 1
app.put("api", "acronyms", ":acronymID") { 
  req -> EventLoopFuture<Acronym> in
  // 2
  let updatedAcronym = try req.content.decode(Acronym.self)
  return Acronym.find(
  	req.parameters.get("acronymID"),
  	on: req.db)
    .unwrap(or: Abort(.notFound)).flatMap { acronym in
      acronym.short = updatedAcronym.short
      acronym.long = updatedAcronym.long
      return acronym.save(on: req.db).map {
        acronym
      }
  }
}

  app.delete("api","acronyms",":Id"){
    req -> EventLoopFuture<HTTPStatus> in
    Acronym.find(req.parameters.get("Id"), on: req.db)
    .unwrap(or: Abort(.notFound))
    .flatMap{
      acronym in
      acronym.delete(on: req.db)
      .transform(to: .noContent)
    }
  }

  // 1
app.get("api", "acronyms", "search") { 
  req -> EventLoopFuture<[Acronym]> in
  // 2
  guard let searchTerm = 
    req.query[String.self, at: "term"] else {
    throw Abort(.badRequest)
  }
  // 3
  // 1
return Acronym.query(on: req.db).group(.or) { or in
  // 2
  or.filter(\.$short == searchTerm)
  // 3
  or.filter(\.$long == searchTerm)
// 4
}.all()

}

  
// 1
app.get("api", "acronyms", "first") { 
  req -> EventLoopFuture<Acronym> in
  // 2
  Acronym.query(on: req.db)
    .first()
    .unwrap(or: Abort(.notFound))
}

// 1
app.get("api", "acronyms", "sorted") { 
  req -> EventLoopFuture<[Acronym]> in
  // 2
  Acronym.query(on: req.db)
    .sort(\.$short, .ascending)
    .all()
}




}
