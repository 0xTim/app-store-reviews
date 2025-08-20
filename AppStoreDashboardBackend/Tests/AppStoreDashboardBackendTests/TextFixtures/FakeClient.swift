import NIOCore
import NIOPosix
import Vapor

final class FakeClient: Client, @unchecked Sendable {
    let contentType = "text/javascript; charset=UTF-8"
    let eventLoop: any EventLoop = MultiThreadedEventLoopGroup.singleton.any()
    let byteBufferAllocator: ByteBufferAllocator = .init()


    var requests: [ClientRequest] = []
    var queuedResponses: [String] = []
    func send(_ request: ClientRequest) -> EventLoopFuture<ClientResponse> {
        self.requests.append(request)
        if queuedResponses.count > 0 {
            let responseBody = queuedResponses.removeFirst()
            var response = ClientResponse()
            response.body = .init(string: responseBody)
            response.headers.add(name: "Content-Type", value: contentType)
            response.headers.add(name: "Content-Length", value: "\(responseBody.utf8.count)")
            return self.eventLoop.makeSucceededFuture(response)
        } else {
            return self.eventLoop.makeFailedFuture(Abort(.notFound))
        }
    }

    func delegating(to eventLoop: any EventLoop) -> any Client {
        self
    }

    func logging(to logger: Logger) -> any Client {
        self
    }

    func allocating(to byteBufferAllocator: ByteBufferAllocator) -> any Client {
        self
    }
}
