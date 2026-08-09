# Ma trận kiểm thử Roblox Studio — Giai đoạn 5

Tệp để dán Output nguyên văn: [PHASE5_STUDIO_TEST_OUTPUT_TEMPLATE.md](PHASE5_STUDIO_TEST_OUTPUT_TEMPLATE.md).

## Cách ghi bằng chứng

Với mọi trường hợp, ghi phiên bản Roblox Studio, thời điểm theo `Asia/Bangkok`, chế độ/số người chơi,
kết quả thực tế, Output máy chủ, Output từng người chơi và kết luận `ĐẠT/KHÔNG ĐẠT`. Không lấy kết quả
build/lint để thay cho trường hợp `CHƯA CHẠY`.

## P5-A — Kiểm thử Luau tự động trong Studio

- Lệnh chuẩn bị (sao chép/dán):

```powershell
Set-Location 'D:\Project\MythicCubes'
rojo build artifacts/json/phase5-tests.project.json -o artifacts/rbxlx/phase5-tests.rbxlx
Invoke-Item .\artifacts\rbxlx\phase5-tests.rbxlx
```

- Điều kiện trước khi chạy: mở `artifacts/rbxlx/phase5-tests.rbxlx` vừa được build từ project chuẩn.
- Chế độ và số người chơi: `Play Solo`, 1 người chơi.
- Các bước thực hiện:
  1. Bấm Play và chờ toàn bộ script dưới `ServerScriptService` chạy.
  2. Tìm dòng `[Phase5OnboardingTests] ... tests passed` cùng các dòng xác nhận Giai đoạn 2–4.
  3. Kiểm tra không có assert, lỗi hoặc cảnh báo chờ vô hạn.
- Kết quả mong đợi: mọi dòng xác nhận xuất hiện; Giai đoạn 5 xác nhận trạng thái, cấu trúc dữ liệu chính
  xác, Tumblet, việc không cấp thưởng lặp, dữ liệu tách biệt giữa người chơi và logic thuần của cổng.
  Dòng xác nhận mới phải là `[Phase5OnboardingTests] 38 tests passed`.
- Kết quả thực tế: `ĐẠT` theo xác nhận người dùng sau Story 05-04.
- Output máy chủ cần quan sát: dòng xác nhận 38 kiểm thử và hồi quy Giai đoạn 2–4. Người dùng đã xác nhận
  đạt nhưng chưa cung cấp Output nguyên văn để lưu trong kho mã.
- Output người chơi cần quan sát: không có lỗi dự án được người dùng báo cáo.
- Kết luận và thời điểm: `ĐẠT`, xác nhận ngày 2026-08-09; chưa có phiên bản Studio và thời điểm chính xác.

## P5-B — Kiểm tra toàn bộ hành trình bằng Play Solo

- Lệnh chuẩn bị (sao chép/dán):

```powershell
Set-Location 'D:\Project\MythicCubes'
rojo build default.project.json -o default-current.rbxlx
Invoke-Item .\default-current.rbxlx
```

- Điều kiện trước khi chạy: mở `default-current.rbxlx`; dùng phiên thử mới.
- Chế độ và số người chơi: `Play Solo`, 1 người chơi.
- Các bước thực hiện:
  1. Xác nhận spawn tại Làng Mạch Nguồn, thấy landmark/năm cổng/năm starter display; xoay và zoom camera.
  2. Chọn một starter và xác nhận bộ sưu tập/companion chỉ được cấp một lần.
  3. Xác nhận nhân vật di chuyển bằng `WASD`/cần điều khiển trái; chạm cổng Thường và xác nhận tự dịch
     chuyển mà không bấm nút tương tác.
  4. Tại tuyến Bình Nguyên, tiếp tục xoay/thu phóng camera bình thường; đi đến Tumblet và thu phục.
  5. Xác nhận một `trail_capsule` bị tiêu hao, bộ sưu tập có starter và Tumblet.
  6. Chạm cổng cuối tutorial để trở lại Làng; chạm một trong bốn cổng nguyên tố để chọn world đầu tiên.
  7. Chạm cổng về Làng; thử chạm cổng Thường, world đã chọn và một world vẫn khóa.
- Kết quả mong đợi: camera không bị đặt thành `Scriptable` hoặc bị khóa; chạm cổng tự di chuyển đúng trạng
  thái; kết quả cuối có đúng hai creature và chỉ world Thường cùng world nguyên tố đã chọn có thể vào;
  ba cổng còn lại từ chối an toàn, không dịch chuyển và không gây tác dụng phụ.
- Kết quả thực tế: `ĐẠT` theo xác nhận người dùng cho camera `Custom` và luồng chạm cổng hiện hành.
- Output máy chủ cần quan sát: chạm cổng, chống gọi lặp và kiểm tra quyền đạt theo xác nhận; chưa có Output
  nguyên văn.
- Output người chơi cần quan sát: camera và di chuyển đạt theo xác nhận; chưa có Output nguyên văn.
- Kết luận và thời điểm: `ĐẠT`, xác nhận ngày 2026-08-09; chưa có phiên bản Studio và thời điểm chính xác.

## P5-C — Kiểm tra đồng đều năm starter

- Lệnh chuẩn bị (sao chép/dán):

```powershell
Set-Location 'D:\Project\MythicCubes'
rojo build default.project.json -o default-current.rbxlx
Invoke-Item .\default-current.rbxlx
```

- Điều kiện trước khi chạy: tạo phiên mới cho mỗi lượt.
- Chế độ và số người chơi: `Play Solo`, 1 người chơi; lặp 5 lần.
- Các bước thực hiện: lần lượt chọn Pebblit, Pyrel, Tiderook, Bramblet và Zephlet; hoàn tất lựa chọn rồi
  đặt lại phiên.
- Kết quả mong đợi: có đúng năm lựa chọn, không trùng hoặc thiếu; mọi lựa chọn áp dụng cùng quy tắc;
  Tumblet không có trong danh sách starter; starter không giới hạn bốn lựa chọn world nguyên tố.
- Kết quả thực tế/Output/kết luận/thời điểm: `ĐẠT`; chưa có Output nguyên văn, phiên bản Studio và thời
  điểm chính xác.

## P5-D — Vòng đời đặt lại và hồi sinh

- Lệnh chuẩn bị (sao chép/dán):

```powershell
Set-Location 'D:\Project\MythicCubes'
rojo build default.project.json -o default-current.rbxlx
Invoke-Item .\default-current.rbxlx
```

- Điều kiện trước khi chạy: bản build mặc định.
- Chế độ và số người chơi: `Play Solo`, 1 người chơi.
- Các bước thực hiện: đặt lại nhân vật ở từng trạng thái `AWAITING_STARTER`, `NORMAL_WORLD_READY`, `NORMAL_TUTORIAL`,
  `TUMBLET_CAPTURED`, `WORLD_CHOICE_READY`, `COMPLETE`.
- Kết quả mong đợi: hồi sinh giữ đúng trạng thái/vị trí chuẩn của phiên; không tạo trùng `OnboardingGui`,
  `StarterSelectionGui`, bộ điều khiển/kết nối chạm, companion, phần cấp Tumblet hoặc mô hình trưng bày;
  tham gia lại sẽ tạo phiên mới.
- Kết quả thực tế/Output/kết luận/thời điểm: `ĐẠT` theo xác nhận người dùng ngày 2026-08-09; chưa có Output
  nguyên văn và phiên bản Studio.

## P5-E — Chuột, cảm ứng, tay cầm và khả năng tiếp cận

- Lệnh chuẩn bị (sao chép/dán):

```powershell
Set-Location 'D:\Project\MythicCubes'
rojo build default.project.json -o default-current.rbxlx
Invoke-Item .\default-current.rbxlx
```

- Điều kiện trước khi chạy: bản build mặc định; `Device Emulator` và tay cầm sẵn sàng.
- Chế độ và số người chơi: `Play Solo`, lần lượt dùng máy tính, giả lập cảm ứng và tay cầm.
- Các bước thực hiện: hoàn tất toàn bộ luồng bằng từng kiểu điều khiển; xác nhận xoay/thu phóng camera tại
  Làng/khu hướng dẫn; thử khung nhìn hẹp, vùng an toàn, cỡ chữ lớn và kiểm tra trạng thái cổng không chỉ dựa vào màu.
- Kết quả mong đợi: `Activated`, điều hướng tiêu điểm và cuộn hoạt động; có thể tới đủ bốn lựa chọn world;
  vùng chạm, xuống dòng, độ tương phản, tiêu điểm và nội dung không phụ thuộc màu đều dễ đọc; camera
  `Custom` xoay/thu phóng được và chạm trực tiếp cổng hoạt động.
- Kết quả thực tế/Output/kết luận/thời điểm: `ĐẠT` theo xác nhận người dùng ngày 2026-08-09; chưa có Output
  nguyên văn và phiên bản Studio.

## P5-F — Dữ liệu tách biệt trong Server & Clients

- Lệnh chuẩn bị (sao chép/dán):

```powershell
Set-Location 'D:\Project\MythicCubes'
rojo build default.project.json -o default-current.rbxlx
Invoke-Item .\default-current.rbxlx
```

- Điều kiện trước khi chạy: bản build mặc định.
- Chế độ và số người chơi: `Server & Clients`, 2 người chơi.
- Các bước thực hiện:
  1. Người chơi A chọn Pyrel, người chơi B chọn Tiderook.
  2. A tiến đến bước thu phục trong khi B còn ở Làng.
  3. A chạm cổng Hải Vực Lam Triều; B chạm cổng Quần Đảo Hỏa Mạch gần như đồng thời.
  4. Đặt lại từng người chơi và quan sát phần hiển thị, ảnh chụp trạng thái và bộ sưu tập của cả hai.
- Kết quả mong đợi: trạng thái, starter, bộ sưu tập, bộ nhớ đệm yêu cầu, companion và world đã chọn tách
  biệt; sự kiện của A không đổi giao diện, phần thưởng hoặc vị trí của B; cả hai có thể dùng chung mục tiêu
  greybox nhưng kết quả vẫn được ghi riêng.
- Kết quả thực tế: `ĐẠT` theo xác nhận người dùng sau thay đổi chạm cổng.
- Output máy chủ cần quan sát: chống gọi lặp và dữ liệu tách biệt đạt theo xác nhận; chưa có Output nguyên văn.
- Output người chơi A/B cần quan sát: đạt theo xác nhận; chưa có Output nguyên văn.
- Kết luận và thời điểm: `ĐẠT`, xác nhận ngày 2026-08-09; chưa có phiên bản Studio và thời điểm chính xác.

## P5-G — Dữ liệu gửi lên không hợp lệ và ID không tồn tại

- Lệnh chuẩn bị (sao chép/dán):

```powershell
Set-Location 'D:\Project\MythicCubes'
rojo build default.project.json -o default-current.rbxlx
Invoke-Item .\default-current.rbxlx
```

- Điều kiện trước khi chạy: dùng `Start Server/Start Player`; chạy bằng `Client Command Bar` hoặc script
  kiểm thử cục bộ tạm thời và không lưu script này vào Git.
- Chế độ và số người chơi: `Start Server` cùng 1 `Player`.
- Client Command Bar — chạy trên phiên mới trước khi chọn starter:

```lua
local remotes = game.ReplicatedStorage.Remotes
local function check(label, remote, payload)
    local response = remote:InvokeServer(payload)
    print(label, response and response.ok, response and response.code)
    task.wait(0.6)
end

check("onboarding/non-table", remotes.RequestOnboardingAction, "invalid")
check("onboarding/missing-field", remotes.RequestOnboardingAction, { requestId = "p5g-missing" })
check("onboarding/extra-field", remotes.RequestOnboardingAction, {
    requestId = "p5g-extra",
    action = "enter_normal_world",
    completed = true,
})
check("onboarding/user-id", remotes.RequestOnboardingAction, {
    requestId = "p5g-user",
    action = "enter_normal_world",
    userId = 123,
})
check("onboarding/unknown-action", remotes.RequestOnboardingAction, {
    requestId = "p5g-action",
    action = "unknown_action",
})
check("onboarding/unknown-world", remotes.RequestOnboardingAction, {
    requestId = "p5g-world",
    action = "select_elemental_world",
    worldId = "missing_world",
})
check("onboarding/normal-not-selectable", remotes.RequestOnboardingAction, {
    requestId = "p5g-normal",
    action = "select_elemental_world",
    worldId = "origin_plains",
})
check("onboarding/empty-request-id", remotes.RequestOnboardingAction, {
    requestId = "",
    action = "enter_normal_world",
})
check("onboarding/long-request-id", remotes.RequestOnboardingAction, {
    requestId = string.rep("x", 65),
    action = "enter_normal_world",
})
check("starter/unknown-id", remotes.SelectStarter, { starterId = "missing_starter" })
check("starter/extra-field", remotes.SelectStarter, { starterId = "pyrel", userId = 123 })
```

- Các bước thực hiện: chạy toàn bộ đoạn lệnh và đối chiếu từng nhãn trong Output người chơi; xác nhận
  Output máy chủ không có lỗi.
- Kết quả mong đợi: trả về `INVALID_REQUEST`, `OUT_OF_RANGE`, `WORLD_NOT_SELECTABLE`, `INVALID_SELECTION`
  hoặc từ chối an toàn tương ứng; không đổi trạng thái, bộ sưu tập hoặc vị trí; máy chủ không có lỗi.
- Kết quả thực tế/Output/kết luận/thời điểm: `ĐẠT`; chưa có Output nguyên văn, phiên bản Studio và thời
  điểm chính xác.

## P5-H — Gửi dồn dập, gửi lại và xung đột mã yêu cầu

- Lệnh chuẩn bị (sao chép/dán):

```powershell
Set-Location 'D:\Project\MythicCubes'
rojo build default.project.json -o default-current.rbxlx
Invoke-Item .\default-current.rbxlx
```

- Điều kiện trước khi chạy: dùng `Start Server/Start Player`; có script kiểm thử cục bộ để kiểm soát
  `requestId`.
- Chế độ và số người chơi: `Start Server` cùng 1 `Player`.
- Các bước thực hiện:
  1. Gửi nhanh nhiều yêu cầu hợp lệ có ID khác nhau.
  2. Gửi lại cùng `requestId` và cùng nội dung sau khi trạng thái đã tiến.
  3. Dùng lại `requestId` với hành động/world khác.
  4. Gửi lại yêu cầu thu phục Tumblet và chọn starter.
- Client Command Bar — sau khi chọn starter và đứng cạnh cổng Thường:

```lua
local remote = game.ReplicatedStorage.Remotes.RequestOnboardingAction
local firstRequest = { requestId = "p5h-enter-1", action = "enter_normal_world" }
local first = remote:InvokeServer(firstRequest)
local spam = remote:InvokeServer({ requestId = "p5h-enter-2", action = "enter_normal_world" })
task.wait(0.4)
local replay = remote:InvokeServer(firstRequest)
local conflict = remote:InvokeServer({
    requestId = "p5h-enter-1",
    action = "travel_world",
    worldId = "origin_plains",
})
print("first", first.ok, first.code)
print("spam", spam.ok, spam.code)
print("replay", replay.ok, replay.code)
print("conflict", conflict.ok, conflict.code)
```

- Client Command Bar — khi đã tới bước thu phục và đứng cạnh Tumblet:

```lua
local remote = game.ReplicatedStorage.Remotes.RequestOnboardingAction
local request = { requestId = "p5h-capture-1", action = "capture_tumblet" }
local first = remote:InvokeServer(request)
task.wait(0.4)
local replay = remote:InvokeServer(request)
print("capture-first", first.ok, first.code)
print("capture-replay", replay.ok, replay.code)
```

- Client Command Bar — trên phiên mới trước khi chọn starter:

```lua
local remote = game.ReplicatedStorage.Remotes.SelectStarter
local first = remote:InvokeServer({ starterId = "pyrel" })
task.wait(0.6)
local replay = remote:InvokeServer({ starterId = "pyrel" })
print("starter-first", first.ok, first.code)
print("starter-replay", replay.ok, replay.code)
```

- Kết quả mong đợi: gửi dồn dập bị `RATE_LIMITED`; gửi lại không tiêu hao, cấp thưởng hoặc chuyển trạng
  thái lần nữa và trả về ảnh chụp trạng thái hiện tại; xung đột bị `REQUEST_ID_CONFLICT`; starter và
  Tumblet đều chỉ được cấp đúng một lần.
- Kết quả thực tế/Output/kết luận/thời điểm: `ĐẠT`; chưa có Output nguyên văn, phiên bản Studio và thời
  điểm chính xác.

## P5-I — Quyền sở hữu, khoảng cách và yêu cầu sau hồi sinh

- Lệnh chuẩn bị (sao chép/dán):

```powershell
Set-Location 'D:\Project\MythicCubes'
rojo build default.project.json -o default-current.rbxlx
Invoke-Item .\default-current.rbxlx
```

- Điều kiện trước khi chạy: `Server & Clients`, 2 người chơi; dùng script kiểm thử tạm thời.
- Chế độ và số người chơi: `Server & Clients`, 2 người chơi.
- Các bước thực hiện: A chạm cổng Thường trước khi chọn starter, chạm cổng nguyên tố khi sai trạng thái,
  chạm cổng tới world mà chỉ B đã mở, tạo nhiều lần chạm từ nhiều bộ phận cơ thể rồi thử lại sau hồi sinh;
  gọi remote thu phục của Giai đoạn 4 trước khi hoàn tất hướng dẫn đầu game.
- Client A Command Bar — đổi phần cuối của `requestId` sau mỗi lần chạy lại:

```lua
local remotes = game.ReplicatedStorage.Remotes
local onboarding = remotes.RequestOnboardingAction:InvokeServer({
    requestId = "p5i-locked-world-1",
    action = "travel_world",
    worldId = "azure_tide",
})
print("locked-world", onboarding.ok, onboarding.code)

local capture = remotes.UseCaptureDevice:InvokeServer({
    requestId = "p5i-capture-1",
    encounterId = "missing_encounter",
    wildId = "missing_wild",
    deviceId = "trail_capsule",
})
print("pre-onboarding-capture", capture.ok, capture.code)
```

- Kết quả mong đợi: máy chủ tự xác định `Player`, dùng trạng thái/khoảng cách/quyền truy cập của chính
  người gọi và không nhận `userId`/`Player` từ dữ liệu gửi lên; yêu cầu thu phục cũ trả
  `ONBOARDING_INCOMPLETE`; không cấp thưởng, dịch chuyển hoặc thay đổi dữ liệu của B.
- Kết quả thực tế/Output/kết luận/thời điểm: `ĐẠT` theo xác nhận người dùng ngày 2026-08-09; chưa có Output
  nguyên văn và phiên bản Studio.

## P5-J — Độ dễ đọc, điểm nối âm thanh và kiểm tra nhanh hiệu năng

- Lệnh chuẩn bị (sao chép/dán):

```powershell
Set-Location 'D:\Project\MythicCubes'
rojo build default.project.json -o default-current.rbxlx
Invoke-Item .\default-current.rbxlx
```

- Điều kiện trước khi chạy: bản build mặc định; mở `MicroProfiler`/`Stats` nếu có.
- Chế độ và số người chơi: lần lượt `Play Solo` và `Server & Clients` với 2 người chơi.
- Các bước thực hiện: quan sát Làng, năm mô hình trưng bày/cổng, tuyến Thường, Tumblet và bốn điểm đến;
  xoay/thu phóng camera tại Làng/khu hướng dẫn; theo dõi FPS, số lượng `Instance`, mạng/`Heartbeat` và Output
  khi lặp lại việc đặt lại nhân vật/chạm cổng di chuyển.
- Kết quả mong đợi: không tạo trùng mô hình/bộ điều khiển, không chờ vô hạn hoặc phát sinh cảnh báo bất
  thường; landmark, nội dung chữ và camera dễ hiểu. Tài nguyên âm thanh vẫn đang chờ nguồn có giấy phép, vì
  vậy không đánh dấu phần âm thanh đạt chỉ dựa trên mã nguồn.
- Kết quả thực tế/Output/kết luận/thời điểm: `ĐẠT` cho độ dễ đọc, hiệu năng, camera và chạm cổng theo xác
  nhận người dùng ngày 2026-08-09. Tài nguyên âm thanh có giấy phép vẫn đang chờ; chưa có Output nguyên văn và
  phiên bản Studio.

## Điều kiện hoàn tất

Nếu bất kỳ trường hợp bắt buộc nào còn `CHƯA CHẠY` hoặc `KHÔNG ĐẠT`, Story giữ trạng thái `Verification`
và Giai đoạn 5 không được chuyển thành `DONE`. Dán Output nguyên văn vào
[tệp mẫu Output của Giai đoạn 5](PHASE5_STUDIO_TEST_OUTPUT_TEMPLATE.md); không thay bằng bản tóm tắt.
