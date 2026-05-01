import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
	app.http.server.configuration.hostname = "0.0.0.0"
	app.http.server.configuration.port = 8080
		
	let port = app.environment == .testing ? 5433 : (Environment.get("DATABASE_PORT").flatMap(Int.init) ?? 5432)
	let database = app.environment == .testing ? "vapor_database_test" : (Environment.get("DATABASE_NAME") ?? "vapor_database")
	
    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: port,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: database,
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

	app.migrations.add(CreateUser())
	app.migrations.add(CreateToken())
	app.migrations.add(CreateList())
	app.migrations.add(CreateListItem())
	app.migrations.add(CreateListEditor())

    try routes(app)
}
