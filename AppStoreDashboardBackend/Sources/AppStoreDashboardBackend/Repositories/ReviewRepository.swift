protocol ReviewRepository {
    func save(_ review: Review) async throws
}
