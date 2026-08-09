# Phase 5 Studio test matrix

## Cách ghi evidence

Với mọi case, ghi Roblox Studio version, timestamp `Asia/Bangkok`, mode/client count, actual result,
Server Output, từng Client Output và `PASS/FAIL`. Không thay `UNTESTED` bằng build/lint result.

## P5-A — Automated Luau tests trong Studio

- Lệnh chuẩn bị (copy/paste):

```powershell
Set-Location 'D:\Project\MythicCubes'
rojo build artifacts/json/phase5-tests.project.json -o artifacts/rbxlx/phase5-tests.rbxlx
Invoke-Item .\artifacts\rbxlx\phase5-tests.rbxlx
```

- Preconditions: mở `artifacts/rbxlx/phase5-tests.rbxlx` được build từ project canonical.
- Mode: Play Solo, 1 client.
- Steps:
  1. Play và chờ toàn bộ script dưới `ServerScriptService` chạy.
  2. Tìm dòng `[Phase5OnboardingTests] ... tests passed` cùng receipt Phase 2–4.
  3. Kiểm tra không có assert/error/infinite yield.
- Expected: mọi receipt xuất hiện; Phase 5 xác nhận state, exact payload, Tumblet, idempotency,
  isolation và gate-action pure seam. Receipt mới phải là `[Phase5OnboardingTests] 38 tests passed`.
- Actual result: `PASS` theo xác nhận người dùng sau Story 05-04.
- Server Output: receipt 38 tests và regression Phase 2–4 được người dùng xác nhận pass; raw Output không
  được cung cấp để lưu trong repository.
- Client Output: không có project error được người dùng báo cáo.
- Verdict/timestamp: `PASS`, xác nhận ngày 2026-08-09; Studio version/thời điểm chính xác chưa được cung cấp.

## P5-B — Play Solo end-to-end

- Lệnh chuẩn bị (copy/paste):

```powershell
Set-Location 'D:\Project\MythicCubes'
rojo build default.project.json -o default-current.rbxlx
Invoke-Item .\default-current.rbxlx
```

- Preconditions: mở `default-current.rbxlx`; test profile/session mới.
- Mode: Play Solo, 1 client.
- Steps:
  1. Xác nhận spawn tại Làng Mạch Nguồn, thấy landmark/năm cổng/năm starter display; xoay và zoom camera.
  2. Chọn một starter và xác nhận collection/companion chỉ được grant một lần.
  3. Xác nhận character di chuyển bằng `WASD`/left stick; chạm cổng Thường và xác nhận tự teleport mà
     không bấm action button.
  4. Tại tuyến Bình Nguyên, tiếp tục xoay/zoom camera bình thường; đi đến Tumblet và capture.
  5. Xác nhận một `trail_capsule` bị tiêu, collection có starter + Tumblet.
  6. Chạm cổng cuối tutorial để trở lại Làng; chạm một trong bốn cổng nguyên tố để chọn world đầu tiên.
  7. Chạm cổng về Làng; thử chạm cổng Thường, world đã chọn và một world vẫn khóa.
- Expected: camera không bị Scriptable/khóa; touch tự travel đúng state; outcome cuối đúng hai creature và
  chỉ Normal + chosen elemental world accessible; ba gate khác fail closed không teleport/side effect.
- Actual result: `PASS` theo xác nhận người dùng cho camera Custom và touch-gate flow hiện hành.
- Server Output: touch/debounce/permission pass theo xác nhận; raw Output không được cung cấp.
- Client Output: camera/movement pass theo xác nhận; raw Output không được cung cấp.
- Verdict/timestamp: `PASS`, xác nhận ngày 2026-08-09; Studio version/thời điểm chính xác chưa được cung cấp.

## P5-C — Five-starter parity

- Lệnh chuẩn bị (copy/paste):

```powershell
Set-Location 'D:\Project\MythicCubes'
rojo build default.project.json -o default-current.rbxlx
Invoke-Item .\default-current.rbxlx
```

- Preconditions: session mới cho mỗi run.
- Mode: Play Solo; lặp 5 lần.
- Steps: lần lượt chọn Pebblit, Pyrel, Tiderook, Bramblet và Zephlet; hoàn tất selection rồi reset.
- Expected: đúng năm option không duplicate/missing; mỗi option commit cùng rule; Tumblet không xuất hiện
  trong starter list; starter không giới hạn bốn lựa chọn elemental world.
- Actual/output/verdict/timestamp: `PASS`.

## P5-D — Reset/respawn lifecycle

- Lệnh chuẩn bị (copy/paste):

```powershell
Set-Location 'D:\Project\MythicCubes'
rojo build default.project.json -o default-current.rbxlx
Invoke-Item .\default-current.rbxlx
```

- Preconditions: default build.
- Mode: Play Solo.
- Steps: reset ở từng state `AWAITING_STARTER`, `NORMAL_WORLD_READY`, `NORMAL_TUTORIAL`,
  `TUMBLET_CAPTURED`, `WORLD_CHOICE_READY`, `COMPLETE`.
- Expected: respawn giữ state/location session canonical; không duplicate `OnboardingGui`,
  `StarterSelectionGui`, controller/touch connection, companion, Tumblet grant hoặc display; rejoin tạo session mới.
- Actual/output/verdict/timestamp: `PASS` theo xác nhận người dùng ngày 2026-08-09; raw Output và Studio
  version chưa được cung cấp.

## P5-E — Mouse/touch/gamepad và accessibility

- Lệnh chuẩn bị (copy/paste):

```powershell
Set-Location 'D:\Project\MythicCubes'
rojo build default.project.json -o default-current.rbxlx
Invoke-Item .\default-current.rbxlx
```

- Preconditions: default build; Device Emulator và gamepad sẵn sàng.
- Mode: Play Solo; desktop, touch emulator và gamepad lần lượt.
- Steps: hoàn tất toàn flow bằng từng input family; xác nhận xoay/zoom camera tại Village/tutorial; thử
  viewport hẹp, safe area, text scaling lớn và kiểm tra gate state không chỉ dựa vào màu.
- Expected: `Activated`/focus/scroll hoạt động; bốn world option reachable; touch target, text wrapping,
  contrast, focus và non-color copy đọc được; camera Custom xoay/zoom và physical gate touch hoạt động.
- Actual/output/verdict/timestamp: `PASS` theo xác nhận người dùng ngày 2026-08-09; raw Output và Studio
  version chưa được cung cấp.

## P5-F — Server & Clients isolation

- Lệnh chuẩn bị (copy/paste):

```powershell
Set-Location 'D:\Project\MythicCubes'
rojo build default.project.json -o default-current.rbxlx
Invoke-Item .\default-current.rbxlx
```

- Preconditions: default build.
- Mode: Server & Clients, 2 clients.
- Steps:
  1. Client A chọn Pyrel, Client B chọn Tiderook.
  2. A tiến đến capture trong khi B còn ở Village.
  3. A chạm cổng Hải Vực Lam Triều; B chạm cổng Quần Đảo Hỏa Mạch gần như đồng thời.
  4. Reset từng client và quan sát presentation/snapshot/collection của cả hai.
- Expected: state, starter, collection, request cache, companion và selected world tách biệt; không event
  nào của A đổi UI/grant/location của B; cả hai có thể dùng shared greybox target mà vẫn commit riêng.
- Actual result: `PASS` theo xác nhận người dùng sau touch-gate change.
- Server Output: debounce/isolation pass theo xác nhận; raw Output không được cung cấp.
- Client A/B Output: pass theo xác nhận; raw Output không được cung cấp.
- Verdict/timestamp: `PASS`, xác nhận ngày 2026-08-09; Studio version/thời điểm chính xác chưa được cung cấp.

## P5-G — Invalid payload và unknown ID

- Lệnh chuẩn bị (copy/paste):

```powershell
Set-Location 'D:\Project\MythicCubes'
rojo build default.project.json -o default-current.rbxlx
Invoke-Item .\default-current.rbxlx
```

- Preconditions: Start Server/Player; dùng Client Command Bar hoặc temporary local test script, không commit.
- Mode: Start Server + 1 Player.
- Client Command Bar — chạy trên session mới trước khi chọn starter:

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

- Steps: chạy toàn bộ snippet và đối chiếu từng label trong Client Output; xác nhận Server Output không error.
- Expected: `INVALID_REQUEST`, `OUT_OF_RANGE`, `WORLD_NOT_SELECTABLE`, `INVALID_SELECTION` hoặc fail-closed
  tương ứng; không state/collection/location side effect; server không error.
- Actual/output/verdict/timestamp: `PASS`.

## P5-H — Spam, replay và request conflict

- Lệnh chuẩn bị (copy/paste):

```powershell
Set-Location 'D:\Project\MythicCubes'
rojo build default.project.json -o default-current.rbxlx
Invoke-Item .\default-current.rbxlx
```

- Preconditions: Start Server/Player; có local test script kiểm soát request ID.
- Mode: Start Server + 1 Player.
- Steps:
  1. Gửi nhanh nhiều request hợp lệ khác ID.
  2. Replay cùng request ID/fingerprint sau khi state đã tiến.
  3. Dùng lại request ID với action/world khác.
  4. Replay capture Tumblet và starter selection.
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

- Client Command Bar — khi đã tới bước capture và đứng cạnh Tumblet:

```lua
local remote = game.ReplicatedStorage.Remotes.RequestOnboardingAction
local request = { requestId = "p5h-capture-1", action = "capture_tumblet" }
local first = remote:InvokeServer(request)
task.wait(0.4)
local replay = remote:InvokeServer(request)
print("capture-first", first.ok, first.code)
print("capture-replay", replay.ok, replay.code)
```

- Client Command Bar — trên session mới trước khi chọn starter:

```lua
local remote = game.ReplicatedStorage.Remotes.SelectStarter
local first = remote:InvokeServer({ starterId = "pyrel" })
task.wait(0.6)
local replay = remote:InvokeServer({ starterId = "pyrel" })
print("starter-first", first.ok, first.code)
print("starter-replay", replay.ok, replay.code)
```

- Expected: spam bị `RATE_LIMITED`; replay không duplicate consume/grant/transition và trả snapshot hiện tại;
  conflict bị `REQUEST_ID_CONFLICT`; starter/Tumblet mỗi loại grant đúng một lần.
- Actual/output/verdict/timestamp: `PASS`.

## P5-I — Ownership/range/post-respawn exploit

- Lệnh chuẩn bị (copy/paste):

```powershell
Set-Location 'D:\Project\MythicCubes'
rojo build default.project.json -o default-current.rbxlx
Invoke-Item .\default-current.rbxlx
```

- Preconditions: Server & Clients, 2 clients; temporary test scripts.
- Mode: Server & Clients, 2 clients.
- Steps: A chạm normal gate trước starter, chạm elemental gate sai state, chạm gate world chỉ B đã mở,
  spam contact bằng nhiều body part và thử lại sau respawn; gọi Phase 4 capture remote trước onboarding complete.
- Client A Command Bar — đổi suffix request ID cho mỗi lần chạy lại:

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

- Expected: server dùng Player implicit, state/range/access của chính caller; không nhận userId/Player từ
  payload; capture cũ trả `ONBOARDING_INCOMPLETE`; không grant/teleport/change B.
- Actual/output/verdict/timestamp: `PASS` theo xác nhận người dùng ngày 2026-08-09; raw Output và Studio
  version chưa được cung cấp.

## P5-J — Readability, audio hooks và performance smoke

- Lệnh chuẩn bị (copy/paste):

```powershell
Set-Location 'D:\Project\MythicCubes'
rojo build default.project.json -o default-current.rbxlx
Invoke-Item .\default-current.rbxlx
```

- Preconditions: default build; MicroProfiler/Stats nếu có.
- Mode: Play Solo và Server & Clients 2.
- Steps: quan sát Village, năm display/gate, Normal route, Tumblet và bốn landing; xoay/zoom camera tại
  Village/tutorial; theo dõi FPS, instance, network/heartbeat và Output trong reset/touch-travel lặp lại.
- Expected: không duplicate model/controller, infinite yield hoặc unexpected warning; landmark/copy/camera
  đọc được. Audio asset vẫn là explicit pending hook cho tới khi có licensed source, nên audio acceptance
  không được đánh dấu pass chỉ từ source.
- Actual/output/verdict/timestamp: `PASS` cho readability/performance/camera/touch theo xác nhận người dùng
  ngày 2026-08-09. Licensed audio asset vẫn là explicit pending hook; raw Output và Studio version chưa
  được cung cấp.

## Completion boundary

Nếu bất kỳ case Required nào còn `UNTESTED`/`FAIL`, Stories giữ `Verification` và Phase 5 không `DONE`.
Đính kèm raw Output cần thiết hoặc report tóm tắt dưới `docs/testing/reports/`.
