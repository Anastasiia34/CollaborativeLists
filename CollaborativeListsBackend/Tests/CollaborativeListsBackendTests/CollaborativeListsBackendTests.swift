@testable import CollaborativeListsBackend
import VaporTesting
import Testing
import Fluent

@Suite("App Tests with DB", .serialized)
struct CollaborativeListsBackendTests {
	private func withApp(_ test: (Application) async throws -> ()) async throws {
		let app = try await Application.make(.testing)
		do {
			try await configure(app)
			try await app.autoMigrate()
			try await test(app)
			try await app.autoRevert()
		} catch {
			try? await app.autoRevert()
			try await app.asyncShutdown()
			throw error
		}
		try await app.asyncShutdown()
	}
	
	@Test("Register creates user")
	func registerCreatesUser() async throws {
		try await withApp { app in
			try await app.testing().test(.POST, "/api/v1/auth/register") { req in
				try req.content.encode(RegisterRequest(email: "test@example.com", password: "password123"))
			} afterResponse: { res in
				#expect(res.status == .ok)
			}
			
			let user = try await User.query(on: app.db)
				.filter(\.$email == "test@example.com")
				.first()
			
			#expect(user != nil)
			#expect(user?.passwordHash != "password123")
			
			let count = try await User.query(on: app.db).count()
			#expect(count == 1)
		}
	}
	
	@Test("Create list without token returns 401")
	func createListWithoutTokenReturnsUnauthorized() async throws {
		try await withApp { app in
			try await app.testing().test(.POST, "/api/v1/lists") { req in
				try req.content.encode(CreateListRequest(title: "Title"))
			} afterResponse: { res in
				#expect(res.status == .unauthorized)
			}
		}
	}
	
	@Test("Authorized user can create list")
	func authorizedUserCanCreateList() async throws {
		try await withApp { app in
			let token = try await registerAndGetToken(app: app)
			var listId: UUID?
			
			try await app.testing().test(.POST, "/api/v1/lists") { req in
				req.headers.bearerAuthorization = BearerAuthorization(token: token)
				try req.content.encode(CreateListRequest(title: "Title"))
			} afterResponse: { res in
				#expect(res.status == .ok)
				listId = try res.content.decode(CreateListResponse.self).id
			}
			
			let id = try #require(listId)
			let list = try await List.find(id, on: app.db)
			#expect(list != nil)
			#expect(list?.title == "Title")
		}
	}
	
	@Test("Non-owner cannot edit another user's list")
	func nonOwnerCannotEditAnotherUsersList() async throws {
		try await withApp { app in
			let token1 = try await registerAndGetToken(app: app, email: "user1@example.com")
			var listId: UUID?
			
			try await app.testing().test(.POST, "/api/v1/lists") { req in
				req.headers.bearerAuthorization = BearerAuthorization(token: token1)
				try req.content.encode(CreateListRequest(title: "Title"))
			} afterResponse: { res in
				#expect(res.status == .ok)
				listId = try res.content.decode(CreateListResponse.self).id
			}
			
			let id = try #require(listId)
			let token2 = try await registerAndGetToken(app: app, email: "user2@example.com")
			
			try await app.testing().test(.PATCH, "/api/v1/lists/\(id)") { req in
				req.headers.bearerAuthorization = BearerAuthorization(token: token2)
				try req.content.encode(UpdateTitleRequest(title: "Another Title"))
			} afterResponse: { res in
				#expect(res.status == .forbidden)
			}
			
			let list = try await List.find(id, on: app.db)
			#expect(list?.title == "Title")
		}
	}
	
	private func registerAndGetToken(
		app: Application,
		email: String = "test@example.com"
	) async throws -> String {
		var token: String?
		
		try await app.testing().test(.POST, "/api/v1/auth/register") { req in
			try req.content.encode(RegisterRequest(email: email, password: "password123"))
		} afterResponse: { res async throws in
			#expect(res.status == .ok)
			let body = try res.content.decode(AuthResponse.self)
			token = body.token
		}
		
		return try #require(token)
	}
}
