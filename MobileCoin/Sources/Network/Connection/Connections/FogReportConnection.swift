//
//  Copyright (c) 2020 MobileCoin. All rights reserved.
//

import Foundation
import GRPC
import LibMobileCoin

final class FogReportConnection: Connection, FogReportService {
    private let client: Report_ReportAPIClient

    init(
        url: FogReportUrl,
        channelManager: GrpcChannelManager,
        targetQueue: DispatchQueue?
    ) {
        let channel = channelManager.channel(for: url)
        self.client = Report_ReportAPIClient(channel: channel)
        super.init(url: url, targetQueue: targetQueue)
    }

    func getReports(
        request: Report_ReportRequest,
        completion: @escaping (Result<Report_ReportResponse, Error>) -> Void
    ) {
        performCall(GetReportsCall(client: client), request: request, completion: completion)
    }
}

extension FogReportConnection {
    private struct GetReportsCall: GrpcCallable {
        let client: Report_ReportAPIClient

        func call(
            request: Report_ReportRequest,
            callOptions: CallOptions?,
            completion: @escaping (UnaryCallResult<Report_ReportResponse>) -> Void
        ) {
            let unaryCall = client.getReports(request, callOptions: callOptions)
            unaryCall.callResult.whenSuccess(completion)
        }
    }
}