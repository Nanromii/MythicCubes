# Kiến trúc dự án

Tài liệu này mô tả kiến trúc dự kiến và phần hiện có. Phase 1 triển khai Home placeholder cùng starter selection theo session; các hệ thống combat, capture, progression và persistence vẫn chỉ là định hướng.

## Nguyên tắc

- **Server-authoritative:** server quyết định dữ liệu thật, chiến đấu, phần thưởng và tiến trình.
- **Data-driven:** definition tách khỏi service xử lý; nội dung mới chủ yếu được thêm bằng dữ liệu đã validation.
- **Module hóa theo trách nhiệm:** tránh service khổng lồ, coupling và circular dependency; không tạo service chỉ để bọc một function đơn giản.
- **Shared thuần:** shared definitions chứa type, cấu hình và logic thuần; không quản lý trạng thái người chơi.
- **Client trình bày:** client phụ trách input, UI, camera và hiển thị kết quả do server xác nhận.
- Không tạo framework nội bộ hoặc abstraction phức tạp trước khi có nhu cầu thực tế.

## Các tầng chính

### Shared

Phase 2 triển khai type, definition, validator và registry thuần cho sinh vật, owned creature, element, role và skill. Registry validate shape, ID duy nhất và cross-reference ngay khi load; service/controller chỉ đọc dữ liệu qua registry hoặc starter view.

Shared không truy cập DataStore trực tiếp, tự đổi trạng thái người chơi, phụ thuộc UI hoặc tin dữ liệu client.

### Server

Các service hiện có trong Phase 1:

- `HomeService`: tạo platform và spawn placeholder ở server khi runtime bắt đầu.
- `StarterSelectionService`: sở hữu một lựa chọn starter theo session, validate remote và khôi phục presentation sau respawn.
- `StarterDisplayService`: tạo một block placeholder đã được server xác nhận cạnh nhân vật.

Các service dự kiến cho phase sau:

- `PlayerDataService`: vòng đời và quyền truy cập profile.
- `CreatureService`: sở hữu, đội hình và trạng thái sinh vật.
- `CombatService`: trạng thái trận đấu và kết quả chiến đấu.
- `SkillService`: validation, cooldown và thực thi kỹ năng.
- `CaptureService`: kiểm tra thiết bị và quyết định bắt.
- `RegionService`: quyền truy cập và mở khóa vùng.
- `ProgressionService`: kinh nghiệm, cấp và phần thưởng.
- `EncounterService`: vòng đời encounter và mục tiêu hợp lệ.

Danh sách dự kiến này chỉ mô tả trách nhiệm; Phase 1 chưa tạo các module trên.

### Client

`StarterSelectionController` hiện tạo UI starter tối thiểu, gửi intent và chỉ khóa lựa chọn theo response server. Các controller dự kiến khác gồm `InputController`, `UIController`, `CameraController`, `CreatureController`, `CombatController` và `RegionController`. Chúng thu nhận input và trình bày state đã được xác nhận, không sở hữu gameplay truth.

## Ranh giới client-server

Luồng sử dụng kỹ năng dự kiến:

```text
Client gửi ý định sử dụng kỹ năng
→ Server xác thực người chơi và sinh vật
→ Server kiểm tra cooldown, trạng thái và mục tiêu
→ Server tính kết quả
→ Server cập nhật trạng thái
→ Server gửi kết quả hiển thị về client
```

Luồng bắt sinh vật dự kiến:

```text
Client yêu cầu sử dụng thiết bị bắt
→ Server kiểm tra inventory
→ Server kiểm tra encounter và khoảng cách
→ Server tính tỷ lệ
→ Server quyết định kết quả
→ Server cập nhật collection
→ Server gửi kết quả cho client
```

## Data flow dự kiến

Ngoài luồng Home/starter theo session của Phase 1, các luồng sau **chưa được triển khai**:

- **Khởi động server:** bootstrap nạp cấu hình đã validation, khởi tạo service theo dependency order, rồi cho phép gameplay request.
- **Khởi động client:** bootstrap nạp controller, nhận snapshot được server cấp và bật input/UI khi sẵn sàng.
- **Tải PlayerProfile:** server tải và validate profile, áp dụng migration, giữ session rồi gửi snapshot an toàn cho client.
- **Chọn sinh vật khởi đầu:** client gửi lựa chọn; server kiểm tra trạng thái chưa chọn, definition hợp lệ, ghi ownership và trả kết quả.
- **Bắt đầu encounter:** server xác định người chơi, vùng, spawn và đối thủ hợp lệ rồi tạo encounter state.
- **Sử dụng kỹ năng:** server validation chủ thể, kỹ năng, cooldown, target và range trước khi tính kết quả.
- **Bắt sinh vật:** server validation encounter, inventory và khoảng cách, tiêu thụ thiết bị rồi quyết định kết quả.
- **Đánh boss:** server tạo encounter boss, theo dõi trạng thái và cấp phần thưởng một lần khi điều kiện đạt.
- **Mở khóa vùng:** server kiểm tra boss/progression prerequisite, cập nhật profile và phát snapshot mới.
- **Lưu dữ liệu:** server đánh dấu dirty, lưu có retry phù hợp, xử lý đóng session và ghi lỗi có context.

## Quy tắc dependency

- Client không import server module; server không import UI module.
- Shared không import implementation của client hoặc server.
- Service không phụ thuộc ngược vào controller; definition không gọi service.
- Utility không chứa mutable global state.
- Remote name được quản lý tập trung; không tạo `RemoteEvent` tùy tiện trong từng feature.
- Dependency đi từ bootstrap đến service/controller, rồi đến shared definition và utility; không đi ngược tầng.

## Rojo mapping

| Filesystem | Roblox DataModel |
| --- | --- |
| `src/ReplicatedStorage` | `ReplicatedStorage` |
| `src/ServerScriptService` | `ServerScriptService` |
| `src/ServerStorage` | `ServerStorage` |
| `src/StarterPlayer/StarterPlayerScripts` | `StarterPlayer.StarterPlayerScripts` |
| `src/StarterGui` | `StarterGui` |

`src/StarterPlayer` có thêm một cấp filesystem để phản ánh rõ service đích, nhưng `default.project.json` ánh xạ trực tiếp thư mục con `StarterPlayerScripts`. `assets`, `tests`, `scripts` và `docs` không được đồng bộ vào DataModel.

## Bảo mật

- Validate kiểu, giới hạn, ownership và state cho mọi remote request.
- Áp dụng rate limit gameplay khi abuse có thể gây tải hoặc lợi thế.
- Kiểm tra khoảng cách, cooldown, encounter state và inventory ở server.
- Không tin timestamp, damage hoặc kết quả random do client gửi.
- Không tin ID sinh vật sở hữu trước khi đối chiếu profile server.
- Chỉ replicate dữ liệu client thực sự cần; không ghi secret vào log hoặc remote payload.
