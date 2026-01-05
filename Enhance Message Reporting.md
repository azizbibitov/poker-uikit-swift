# Cascade Chat Conversation

  Note: _This is purely the output of the chat conversation and does not contain any raw data, codebase snippets, etc. used to generate the output._

### User Input

analyse get10Messages function in @[Signal/src/ViewControllers/ConversationView/ConversationViewController+MessageRequest.swift] . currently it is sending 10 messages whether it is outgoing or incoming message

### Planner Response

I'll open `Signal/src/ViewControllers/ConversationView/ConversationViewController+MessageRequest.swift` to find and review the `get10Messages` function and see how it's selecting messages (direction, filtering, order).

*Viewed [ConversationViewController+MessageRequest.swift](file:///Users/azizbibitov/Desktop/Link-Messenger-iOS/Signal/src/ViewControllers/ConversationView/ConversationViewController+MessageRequest.swift) *

### Planner Response

# Findings

- **Where**: `get10Messages()` in [Signal/src/ViewControllers/ConversationView/ConversationViewController+MessageRequest.swift](cci:7://file:///Users/azizbibitov/Desktop/Link-Messenger-iOS/Signal/src/ViewControllers/ConversationView/ConversationViewController+MessageRequest.swift:0:0-0:0) lines 203–237.
- **What it does**:
  - Iterates recent interactions via `InteractionFinder.enumerateRecentInteractions(...)`.
  - Appends the `body` for both `TSIncomingMessage` and `TSOutgoingMessage`.
  - Stops after collecting 10 bodies.
  - Returns the list (most recent-first, given the enumeration order).

```swift
func get10Messages() -> [String] {
    let messagesToReport: [String] = databaseStorage.read { transaction in
        var messagesToReport = [String]()
        do {
            try InteractionFinder(
                threadUniqueId: self.thread.uniqueId
            ).enumerateRecentInteractions(
                transaction: transaction
            ) { interaction, stop in
                if let incomingMessage = interaction as? TSIncomingMessage {
                    if let message = incomingMessage.body {
                        messagesToReport.append(message)
                        guard messagesToReport.count < 10 else {
                            stop.pointee = true
                            return
                        }
                    }
                }else if let outgoingMessage = interaction as? TSOutgoingMessage {
                    if let message = outgoingMessage.body {
                        messagesToReport.append(message)
                        guard messagesToReport.count < 10 else {
                            stop.pointee = true
                            return
                        }
                    }
                }
            }
        } catch {
            owsFailDebug("Failed to lookup guids to report \(error)")
        }
        return messagesToReport
    }
    
    return messagesToReport
}
```

- **Consequence**:
  - It mixes your own messages with the other party’s messages.
  - For spam reporting/evidence, this likely isn’t intended. Note that `reportSpam()` above only collects incoming messages’ server GUIDs, aligning with reporting the sender’s content, not yours.
  - It only includes text bodies; attachments (no `body`) aren’t captured.

# Recommendation

- **If the intent is to send only the other user’s content** (typical for spam evidence):
  - Filter to `TSIncomingMessage` only.
  - Keep the limit (10). Return fewer if there aren’t enough incoming texts.

Minimal change:

```swift
func get10Messages() -> [String] {
    databaseStorage.read { transaction in
        var messages = [String]()
        do {
            try InteractionFinder(threadUniqueId: self.thread.uniqueId)
                .enumerateRecentInteractions(transaction: transaction) { interaction, stop in
                    guard let incoming = interaction as? TSIncomingMessage,
                          let body = incoming.body, !body.isEmpty else { return }
                    messages.append(body)
                    if messages.count >= 10 { stop.pointee = true }
                }
        } catch {
            owsFailDebug("Failed to lookup messages to report \(error)")
        }
        return messages
    }
}
```

- Optional enhancements:
  - Add parameters to control direction and limit:
    - `getMessages(limit: Int = 10, includeOutgoing: Bool = false)`
  - Reverse to chronological order if the consumer expects oldest→newest.
  - Consider including a placeholder for attachments if needed.

# Summary

`get10Messages()` currently collects both incoming and outgoing text bodies, which is why you’re seeing 10 messages regardless of direction. To align with spam reporting behavior (and avoid sending your own messages), restrict it to `TSIncomingMessage` only. Want me to apply this change now?

### User Input

no. i need to send to server not just text messages but all kind of last 10 messages like texts, images, videos, audios and etc because our product manager changed requirement for reporting for this: 

"Increase the number of messages sent when blocking or reporting to 10. Messages must be from both the recipient and the sender.

These messages must include video, audio, and photos. These materials should be displayed on the admin panel along with other messages in the order they were received (oldest to newest).

• 3. Send the time messages were received and the message type (video, audio, photo)."

how can we do that in this iOS app?

### Planner Response

I'll search the codebase for the request/response models used to send block/report payloads (`BlockUserReqModel`, `BlockUser`) and for message models to understand how to extract type, timestamps, and media URLs/identifiers from `TSIncomingMessage`/`TSOutgoingMessage`. This will let me propose precise code changes and data structures.

*Grep searched codebase*

### Planner Response

To design the correct payload and extraction logic, I'll inspect the data models and repository methods used for block/report: `BlockUserReqModel`, `BlockUser`, and the API call in `ProfileRepository`. I'll open the relevant files to see the current request schema and how messages are sent.

*Viewed [SocialResponse.swift](file:///Users/azizbibitov/Desktop/Link-Messenger-iOS/Signal/src/Data/Request/models/SocialResponse.swift) *

*Viewed [ProfileRepository.swift](file:///Users/azizbibitov/Desktop/Link-Messenger-iOS/Signal/src/Data/Repositories/ProfileRepository.swift) *

*Viewed [ReportBottomSheetVC.swift](file:///Users/azizbibitov/Desktop/Link-Messenger-iOS/Signal/src/ViewControllers/ReportBottomSheet/ReportBottomSheetVC.swift) *

*Grep searched codebase*

### Planner Response

I will search the codebase for attachment handling in TS messages to determine how to extract media (images, videos, audio) and their metadata (type, timestamp, direction). This will inform how we build the payload.

*Grep searched codebase*

### Planner Response

I'll open the TSIncomingMessage/TSOutgoingMessage/TSMessage classes to confirm how to read timestamps, directions, and attachments so I can propose exact code for extracting message type, timestamp, and media data.

*Grep searched codebase*

### Planner Response

To implement the new requirement, I need to inspect the message models to understand how to extract timestamps, direction, and attachments. I'll open the relevant TS message and attachment classes.

*Viewed [TSMessage.h](file:///Users/azizbibitov/Desktop/Link-Messenger-iOS/SignalServiceKit/src/Messages/Interactions/TSMessage.h) *

*Grep searched codebase*

*Viewed [TSAttachment.h](file:///Users/azizbibitov/Desktop/Link-Messenger-iOS/SignalServiceKit/src/Messages/Attachments/TSAttachment.h) *

### Planner Response

I'll search the codebase for any newer request models or fields that support sending rich message evidence (type, timestamp, media) beyond the current `[String]` messages array. This helps ensure we align with the server contract before implementing extraction.

*Grep searched codebase*

*Viewed [TSInteraction.h](file:///Users/azizbibitov/Desktop/Link-Messenger-iOS/SignalServiceKit/src/Messages/Interactions/TSInteraction.h) *

*Grep searched codebase*

*Viewed [TSAttachmentStream.m](file:///Users/azizbibitov/Desktop/Link-Messenger-iOS/SignalServiceKit/src/Messages/Attachments/TSAttachmentStream.m) *

*Grep searched codebase*

*Grep searched codebase*

*Viewed [TSAttachmentPointer.h](file:///Users/azizbibitov/Desktop/Link-Messenger-iOS/SignalServiceKit/src/Messages/Attachments/TSAttachmentPointer.h) *

*Grep searched codebase*

*Updated todo list*

*Grep searched codebase*

*Grep searched codebase*

*Viewed [OWSAttachmentDownloads.swift](file:///Users/azizbibitov/Desktop/Link-Messenger-iOS/SignalServiceKit/src/Messages/Attachments/OWSAttachmentDownloads.swift) *

### User Input

Continue

### User Input

no, it seems to me that there is no rich text sending to server  yet. just tell me how can i do that and show me code

*Grep searched codebase*

*Grep searched codebase*

*Viewed [SocialRequest.swift](file:///Users/azizbibitov/Desktop/Link-Messenger-iOS/Signal/src/Data/Request/SocialRequest.swift) *

*Grep searched codebase*

*Grep searched codebase*

### Planner Response

Below is a concrete, minimal design and code you can drop in to send the last 10 messages (incoming and outgoing), including text and media (images, video, audio, files), with message direction, type, and received time in oldest→newest order.

High level:
- Collect last 10 `TSMessage` interactions in [ConversationViewController+MessageRequest.swift](cci:7://file:///Users/azizbibitov/Desktop/Link-Messenger-iOS/Signal/src/ViewControllers/ConversationView/ConversationViewController+MessageRequest.swift:0:0-0:0).
- For each message, collect text and attachments (download missing ones).
- Build a JSON “payload” describing the evidence, plus multipart file parts for the binaries.
- Add a multipart uploader in `ProfileRepository` and call it from the report/block UI.
- Keep the old JSON-only path for backward compatibility.

# Data model additions
Edit [Signal/src/Data/Request/models/SocialResponse.swift](cci:7://file:///Users/azizbibitov/Desktop/Link-Messenger-iOS/Signal/src/Data/Request/models/SocialResponse.swift:0:0-0:0):
- Add new models for evidence + upload parts.
- Extend `BlockUser` with optional `evidence`.

```swift
// MARK: - Report Evidence Models

struct ReportEvidenceAttachment: Codable {
    // Field name used in multipart for the file part (e.g., "file_0")
    let field: String
    // image | video | audio | file
    let type: String
    let fileName: String?
    let contentType: String
    let size: Int
}

struct ReportEvidenceItem: Codable {
    // incoming | outgoing
    let direction: String
    // ISO8601 time message was received (or sent for outgoing)
    let receivedAt: String
    // Text body if present
    let body: String?
    // Metadata for attachments included in this message
    let attachments: [ReportEvidenceAttachment]?
}

// Public helper to pass files for upload along with evidence
struct AttachmentUploadPart {
    let field: String
    let url: URL
    let mimeType: String
    let fileName: String?
}

// Backward compatible: add evidence to BlockUser payload.
// Server must accept this optional key; old clients won’t send it.
extension BlockUser {
    // Add this new optional property
    var evidence: [ReportEvidenceItem]? { return nil }
}
```

Note: Because `BlockUser` is declared as a struct elsewhere, you need to add a real property (not only extension). Replace the original declaration with this:

```swift
struct BlockUser: Codable, Model{
    var uuid: String?
    var userId: Int?
    let categoryId: Int
    let extra_comment: String
    let messages: [String]?       // legacy
    var blockUser: Bool?

    // NEW
    let evidence: [ReportEvidenceItem]?
}
```

Backwards compatibility: server can keep accepting `messages` while you roll out `evidence`.

# Multipart upload in the repository
Add new uploaders in [Signal/src/Data/Repositories/ProfileRepository.swift](cci:7://file:///Users/azizbibitov/Desktop/Link-Messenger-iOS/Signal/src/Data/Repositories/ProfileRepository.swift:0:0-0:0):
- `reportUserWithEvidence` for report-only.
- `blockAndReportUserWithEvidence` for report+block.
- Both send `payload` JSON + files via multipart.

```swift
import Alamofire

extension ProfileRepository {

    func reportUserWithEvidence(
        model: BlockUser,
        files: [AttachmentUploadPart],
        completion: @escaping (Result<MsgResponse, ErrorDataNew>) -> ()
    ) {
        let url = Config.socialUrl + "/api/v1/report/report"
        uploadEvidenceMultipart(url: url, payload: model, files: files, completion: completion)
    }

    func blockAndReportUserWithEvidence(
        req: BlockUserReqModel,
        files: [AttachmentUploadPart],
        completion: @escaping (Result<MsgResponse, ErrorDataNew>) -> ()
    ) {
        let url = Config.socialUrl + "/api/v1/profile/block"
        uploadEvidenceMultipart(url: url, payload: req, files: files, completion: completion)
    }

    // Generic multipart uploader for evidence payloads.
    private func uploadEvidenceMultipart<T: Codable, R: Decodable>(
        url: String,
        payload: T,
        files: [AttachmentUploadPart],
        completion: @escaping (Result<R, ErrorDataNew>) -> ()
    ) {
        // Authorization
        guard let token = SocialRequest.shared.keychain.get("social_token"), !token.isEmpty else {
            completion(.failure(ErrorDataNew(code: 401, message: "Auth error", cause: "")))
            return
        }
        var headers = HTTPHeaders()
        headers.add(HTTPHeader.authorization(bearerToken: token))

        // Encode payload JSON once
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let payloadData = try? encoder.encode(payload) else {
            completion(.failure(ErrorDataNew(code: 0, message: "Encoding payload failed", cause: "")))
            return
        }

        NetworkManager.shared.customAF.upload(multipartFormData: { form in
            // JSON payload as 'payload'
            form.append(payloadData, withName: "payload", mimeType: "application/json")

            // Files
            for file in files {
                form.append(file.url, withName: file.field, fileName: file.fileName ?? "file", mimeType: file.mimeType)
            }
        }, to: url, method: .post, headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: SocialResponse<R>.self) { response in
            switch response.result {
            case .success(let wrapped):
                if let data = wrapped.data, wrapped.success {
                    completion(.success(data))
                } else {
                    completion(.failure(ErrorDataNew(code: wrapped.error?.code ?? 0,
                                                     message: wrapped.error?.message ?? "Server error",
                                                     cause: "")))
                }
            case .failure:
                completion(.failure(ErrorDataNew(code: response.response?.statusCode ?? 0,
                                                 message: "Network error",
                                                 cause: "")))
            }
        }
    }
}
```

# Collector: last 10 messages, oldest→newest, with media
Add this to [Signal/src/ViewControllers/ConversationView/ConversationViewController+MessageRequest.swift](cci:7://file:///Users/azizbibitov/Desktop/Link-Messenger-iOS/Signal/src/ViewControllers/ConversationView/ConversationViewController+MessageRequest.swift:0:0-0:0):
- A collector that builds evidence + files and downloads missing attachments before upload.

```swift
import SignalServiceKit

private struct EvidenceBuildResult {
    let items: [ReportEvidenceItem]
    let files: [AttachmentUploadPart]
}

// Builds last 10 messages evidence (incoming & outgoing), oldest->newest.
// Includes text body and attachments (images/videos/audios/files).
private func collectLastMessagesEvidence(limit: Int = 10,
                                         completion: @escaping (EvidenceBuildResult) -> Void) {

    // 1) Read interactions newest->oldest, prepare basic metadata & attachment pointers.
    struct PendingPointer {
        let attachmentId: String
        let field: String
        let pointer: TSAttachmentPointer
        let mime: String
        let fileName: String?
        let size: Int
    }

    var evidenceItemsNewestFirst: [ReportEvidenceItem] = []
    var uploadParts: [AttachmentUploadPart] = []
    var pendingPointers: [PendingPointer] = []
    var fileCounter = 0

    // Date formatter for ISO8601
    let iso = ISO8601DateFormatter()

    databaseStorage.read { tx in
        do {
            try InteractionFinder(threadUniqueId: self.thread.uniqueId)
                .enumerateRecentInteractions(transaction: tx) { interaction, stop in

                    guard evidenceItemsNewestFirst.count < limit else {
                        stop.pointee = true; return
                    }

                    guard let message = interaction as? TSMessage else { return }

                    // Direction + timestamp
                    let direction: String = (message is TSIncomingMessage) ? "incoming" : "outgoing"
                    // Prefer receivedAt for incoming; fall back to timestamp if needed
                    let receivedDate = message.receivedAtDate
                    let receivedAt = iso.string(from: receivedDate)

                    // Body
                    var bodyText: String?
                    if let plaintext = message.plaintextBody(with: tx.unwrapGrdbRead) {
                        bodyText = plaintext.isEmpty ? nil : plaintext
                    } else if let raw = message.rawBody(with: tx.unwrapGrdbRead) {
                        bodyText = raw.isEmpty ? nil : raw
                    }

                    // Attachments
                    var attachmentsMeta: [ReportEvidenceAttachment] = []
                    let attachments = message.mediaAttachments(with: tx.unwrapGrdbRead)

                    for att in attachments {
                        // Skip view-once media for safety
                        if message.isViewOnceMessage { continue }

                        let contentType = att.contentType
                        let fileName = att.sourceFilename
                        let size = Int(att.byteCount)
                        let field = "file_\(fileCounter)"; defer { fileCounter += 1 }

                        // Map content type -> type
                        let type: String = {
                            if att.isImage { return "image" }
                            if att.isVideo { return "video" }
                            if att.isAudio || att.isVoiceMessage { return "audio" }
                            return "file"
                        }()

                        attachmentsMeta.append(ReportEvidenceAttachment(
                            field: field,
                            type: type,
                            fileName: fileName,
                            contentType: contentType,
                            size: size
                        ))

                        if let stream = att as? TSAttachmentStream,
                           let url = stream.originalMediaURL {
                            // Already downloaded: add file part
                            uploadParts.append(AttachmentUploadPart(
                                field: field,
                                url: url,
                                mimeType: contentType,
                                fileName: fileName
                            ))
                        } else if let pointer = att as? TSAttachmentPointer {
                            // Download later
                            pendingPointers.append(PendingPointer(
                                attachmentId: pointer.uniqueId,
                                field: field,
                                pointer: pointer,
                                mime: contentType,
                                fileName: fileName,
                                size: size
                            ))
                        }
                    }

                    // Build item
                    evidenceItemsNewestFirst.append(ReportEvidenceItem(
                        direction: direction,
                        receivedAt: receivedAt,
                        body: bodyText,
                        attachments: attachmentsMeta.isEmpty ? nil : attachmentsMeta
                    ))
                }
        } catch {
            owsFailDebug("Failed to build evidence: \(error)")
        }
    }

    // 2) Download missing attachments (if any), then finish.
    guard !pendingPointers.isEmpty else {
        // Oldest -> newest
        completion(EvidenceBuildResult(items: evidenceItemsNewestFirst.reversed(), files: uploadParts))
        return
    }

    let downloader = OWSAttachmentDownloads()
    var promises = [Promise<TSAttachmentStream>]()
    var fieldMap = [String: String]() // attachmentId -> field

    for p in pendingPointers {
        promises.append(downloader.enqueueHeadlessDownloadPromise(attachmentPointer: p.pointer))
        fieldMap[p.attachmentId] = p.field
    }

    Promise.when(fulfilled: promises).done { streams in
        for s in streams {
            guard let url = s.originalMediaURL else { continue }
            let field = fieldMap[s.uniqueId] ?? "file_\(UUID().uuidString)"
            uploadParts.append(AttachmentUploadPart(
                field: field,
                url: url,
                mimeType: s.contentType,
                fileName: s.sourceFilename
            ))
        }
        completion(EvidenceBuildResult(items: evidenceItemsNewestFirst.reversed(), files: uploadParts))
    }.catch { error in
        // Even if some downloads fail, send what we have
        completion(EvidenceBuildResult(items: evidenceItemsNewestFirst.reversed(), files: uploadParts))
    }
}
```

# Wire it into the UI flow
Update `blockThreadAndReportSpam()` in [ConversationViewController+MessageRequest.swift](cci:7://file:///Users/azizbibitov/Desktop/Link-Messenger-iOS/Signal/src/ViewControllers/ConversationView/ConversationViewController+MessageRequest.swift:0:0-0:0):
- Build evidence first.
- Pass evidence + files into the bottom sheet (or send directly if you prefer).

```swift
func blockThreadAndReportSpam() {
    guard let contactThread = thread as? TSContactThread else { return }
    let contactUuid = contactThread.contactUUID ?? contactThread.contactAddress.uuid?.uuidString
    let shortName = databaseStorage.read { contactsManager.shortDisplayName(for: contactThread.contactAddress, transaction: $0) }

    collectLastMessagesEvidence(limit: 10) { [weak self] result in
        guard let self = self else { return }

        let vc = ReportBottomSheetVC()
        vc.isFromBlocking = true
        vc.isBlocked = false
        vc.isBlockingFromChat = true
        vc.username = shortName ?? ""
        vc.uuid = contactUuid
        vc.id = 0
        // NEW: pass evidence + files
        vc.evidenceItems = result.items
        vc.evidenceFiles = result.files

        vc.completion = { [weak self] isBlocked in
            guard let self = self else { return }
            if isBlocked {
                self.syncManager.sendMessageRequestResponseSyncMessage(thread: self.thread, responseType: .block)
                self.reportSpam()
                NotificationCenter.default.post(name: ChatListViewController.clearSearch, object: nil)
            }
        }
        self.present(vc, animated: true)
    }
}
```

Update [Signal/src/ViewControllers/ReportBottomSheet/ReportBottomSheetVC.swift](cci:7://file:///Users/azizbibitov/Desktop/Link-Messenger-iOS/Signal/src/ViewControllers/ReportBottomSheet/ReportBottomSheetVC.swift:0:0-0:0):
- Replace `messages: [String]` with `

### Planner Response

Below is a minimal, end-to-end implementation to send the last 10 messages (incoming and outgoing) with text + media (images, videos, audio, files), including direction, received time (ISO-8601), oldest→newest. It uses multipart: JSON payload + binary files.

# 1) Add evidence models
File: [Signal/src/Data/Request/models/SocialResponse.swift](cci:7://file:///Users/azizbibitov/Desktop/Link-Messenger-iOS/Signal/src/Data/Request/models/SocialResponse.swift:0:0-0:0)

```swift
// MARK: - Report Evidence (NEW)
struct ReportEvidenceAttachment: Codable {
    let field: String            // multipart field name e.g. "file_0"
    let type: String             // "image" | "video" | "audio" | "file"
    let fileName: String?
    let contentType: String
    let size: Int
}

struct ReportEvidenceItem: Codable {
    let direction: String        // "incoming" | "outgoing"
    let receivedAt: String       // ISO8601
    let body: String?
    let attachments: [ReportEvidenceAttachment]?
}

// Helper for upload
struct AttachmentUploadPart {
    let field: String
    let url: URL
    let mimeType: String
    let fileName: String?
}
```

Extend request model to carry evidence (backward compatible):

```swift
// Replace BlockUser with this version (add evidence)
struct BlockUser: Codable, Model{
    var uuid: String?
    var userId: Int?
    let categoryId: Int
    let extra_comment: String
    let messages: [String]?              // legacy
    var blockUser: Bool?                 // optional flag; used by report-only flow
    let evidence: [ReportEvidenceItem]?  // NEW
}
```

# 2) Multipart uploader (ProfileRepository)
File: [Signal/src/Data/Repositories/ProfileRepository.swift](cci:7://file:///Users/azizbibitov/Desktop/Link-Messenger-iOS/Signal/src/Data/Repositories/ProfileRepository.swift:0:0-0:0)

```swift
import Alamofire

extension ProfileRepository {

    func reportUserWithEvidence(
        model: BlockUser,
        files: [AttachmentUploadPart],
        completion: @escaping (Result<MsgResponse, ErrorDataNew>) -> ()
    ) {
        let url = Config.socialUrl + "/api/v1/report/report"
        uploadEvidenceMultipart(url: url, payload: model, files: files, completion: completion)
    }

    func blockAndReportUserWithEvidence(
        req: BlockUserReqModel,
        files: [AttachmentUploadPart],
        completion: @escaping (Result<MsgResponse, ErrorDataNew>) -> ()
    ) {
        let url = Config.socialUrl + "/api/v1/profile/block"
        uploadEvidenceMultipart(url: url, payload: req, files: files, completion: completion)
    }

    private func uploadEvidenceMultipart<T: Codable, R: Decodable>(
        url: String,
        payload: T,
        files: [AttachmentUploadPart],
        completion: @escaping (Result<R, ErrorDataNew>) -> ()
    ) {
        guard let token = SocialRequest.shared.keychain.get("social_token"), !token.isEmpty else {
            completion(.failure(ErrorDataNew(code: 401, message: "Auth error", cause: ""))); return
        }
        var headers = HTTPHeaders()
        headers.add(HTTPHeader.authorization(bearerToken: token))

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let payloadData = try? encoder.encode(payload) else {
            completion(.failure(ErrorDataNew(code: 0, message: "Encoding payload failed", cause: ""))); return
        }

        NetworkManager.shared.customAF.upload(multipartFormData: { form in
            form.append(payloadData, withName: "payload", mimeType: "application/json")
            files.forEach {
                form.append($0.url, withName: $0.field, fileName: $0.fileName ?? "file", mimeType: $0.mimeType)
            }
        }, to: url, method: .post, headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: SocialResponse<R>.self) { response in
            switch response.result {
            case .success(let wrapped):
                if let data = wrapped.data, wrapped.success { completion(.success(data)) }
                else {
                    completion(.failure(ErrorDataNew(code: wrapped.error?.code ?? 0,
                                                     message: wrapped.error?.message ?? "Server error",
                                                     cause: "")))
                }
            case .failure:
                completion(.failure(ErrorDataNew(code: response.response?.statusCode ?? 0,
                                                 message: "Network error",
                                                 cause: "")))
            }
        }
    }
}
```

# 3) Collect last 10 messages + media
File: [Signal/src/ViewControllers/ConversationView/ConversationViewController+MessageRequest.swift](cci:7://file:///Users/azizbibitov/Desktop/Link-Messenger-iOS/Signal/src/ViewControllers/ConversationView/ConversationViewController+MessageRequest.swift:0:0-0:0)

```swift
import SignalServiceKit

private struct EvidenceBuildResult {
    let items: [ReportEvidenceItem]
    let files: [AttachmentUploadPart]
}

// Build last 10 (incoming+outgoing), oldest→newest
private func collectLastMessagesEvidence(limit: Int = 10,
                                         completion: @escaping (EvidenceBuildResult) -> Void) {

    let iso = ISO8601DateFormatter()
    var newestFirst: [ReportEvidenceItem] = []
    var uploadParts: [AttachmentUploadPart] = []
    var toDownload: [(field: String, pointer: TSAttachmentPointer)] = []
    var fieldIndex = 0

    databaseStorage.read { tx in
        do {
            try InteractionFinder(threadUniqueId: self.thread.uniqueId)
                .enumerateRecentInteractions(transaction: tx) { interaction, stop in
                    guard newestFirst.count < limit else { stop.pointee = true; return }
                    guard let msg = interaction as? TSMessage else { return }

                    let direction = (msg is TSIncomingMessage) ? "incoming" : "outgoing"
                    let receivedAt = iso.string(from: msg.receivedAtDate)

                    var body: String?
                    if let p = msg.plaintextBody(with: tx.unwrapGrdbRead), !p.isEmpty { body = p }
                    else if let r = msg.rawBody(with: tx.unwrapGrdbRead), !r.isEmpty { body = r }

                    var atts: [ReportEvidenceAttachment] = []
                    for a in msg.mediaAttachments(with: tx.unwrapGrdbRead) {
                        if msg.isViewOnceMessage { continue }
                        let type: String = a.isImage ? "image" : a.isVideo ? "video" : (a.isAudio || a.isVoiceMessage) ? "audio" : "file"
                        let field = "file_\(fieldIndex)"; fieldIndex += 1
                        atts.append(.init(field: field,
                                          type: type,
                                          fileName: a.sourceFilename,
                                          contentType: a.contentType,
                                          size: Int(a.byteCount)))
                        if let s = a as? TSAttachmentStream, let url = s.originalMediaURL {
                            uploadParts.append(.init(field: field, url: url, mimeType: s.contentType, fileName: s.sourceFilename))
                        } else if let p = a as? TSAttachmentPointer {
                            toDownload.append((field: field, pointer: p))
                        }
                    }

                    newestFirst.append(.init(direction: direction, receivedAt: receivedAt, body: body, attachments: atts.isEmpty ? nil : atts))
                }
        } catch { }
    }

    guard !toDownload.isEmpty else {
        completion(.init(items: newestFirst.reversed(), files: uploadParts)); return
    }

    let loader = OWSAttachmentDownloads()
    let promises = toDownload.map { loader.enqueueHeadlessDownloadPromise(attachmentPointer: $0.pointer) }

    Promise.when(fulfilled: promises).done { streams in
        for s in streams where s.originalMediaURL != nil {
            let field = toDownload.first { $0.pointer.uniqueId == s.uniqueId }?.field ?? "file_\(UUID().uuidString)"
            uploadParts.append(.init(field: field, url: s.originalMediaURL!, mimeType: s.contentType, fileName: s.sourceFilename))
        }
        completion(.init(items: newestFirst.reversed(), files: uploadParts))
    }.catch { _ in
        completion(.init(items: newestFirst.reversed(), files: uploadParts))
    }
}
```

# 4) Use it when blocking/reporting
Option A — call directly in `blockThreadAndReportSpam()` (same file):

```swift
func blockThreadAndReportSpam() {
    guard let contactThread = thread as? TSContactThread else { return }
    let contactUuid = contactThread.contactUUID ?? contactThread.contactAddress.uuid?.uuidString

    collectLastMessagesEvidence(limit: 10) { [weak self] result in
        guard let self = self else { return }

        let payload = BlockUserReqModel(
            uuid: contactUuid,
            blockUser: BlockUser(
                uuid: nil, userId: nil,
                categoryId: 1,
                extra_comment: "",
                messages: nil,
                blockUser: nil,
                evidence: result.items
            )
        )

        ProfileRepository.shared.blockAndReportUserWithEvidence(req: payload, files: result.files) { res in
            // handle success/failure; keep existing sync + notifications
        }
    }
}
```

Option B — if you want the sheet to submit: pass `evidenceItems` and `evidenceFiles` to `ReportBottomSheetVC` and call `reportUserWithEvidence` or `blockAndReportUserWithEvidence` inside its action.

# Notes
- Direction: uses `TSIncomingMessage` vs `TSOutgoingMessage`.
- Time: `TSInteraction.receivedAtDate` → ISO-8601.
- Types: derived from `TSAttachment` flags (`isImage`, `isVideo`, `isAudio`, `isVoiceMessage`).
- Oldest→newest: we collect newest-first then `reversed()`.
- View-once: attachments skipped for safety.
- Backward compatibility: `messages` remains; server should start reading `payload.evidence` when present.

# Summary
- Added evidence models, multipart upload, a collector for the last 10 messages with media, and integrated call sites.
- This fulfills: 10 messages, both directions, includes media, includes type + received time, oldest→newest.