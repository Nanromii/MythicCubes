# Kiểm tra Phase 4 trong Roblox Studio

Phase 4 phải giữ `IN_PROGRESS` cho tới khi người dùng chạy và xác nhận toàn bộ suite/runtime matrix dưới đây. Terminal build không thay thế Play Test. Không publish, không merge vào `master`, không chạy DataStore và không bật PvP.

## Giá trị placeholder cần biết

Vertical slice chỉ có region `verdant_meadow` với hai zone. `meadow_single` tạo một cá thể; `meadow_cluster` tạo cụm hai cá thể. Aggro range là `16/18`, engagement `20/22`, owner-disengage `28/30`, wild leash `42/46`, attack range `6`, respawn `8/10` giây. Capture range là `28/32`; inventory đầu phiên là 5 Nang Dấu Đường và 2 Bẫy Lăng Kính. Đây là placeholder tập trung trong `WorldDefinitions.lua`, không phải balance production.

## Build và chạy suite

Tại project root:

```powershell
rojo build phase4-tests.project.json -o phase4-tests.rbxlx
rojo serve phase4-tests.project.json --port 34876
```

Mở `phase4-tests.rbxlx` hoặc kết nối Rojo plugin tới port `34876`, rồi Play một server. Output mong đợi:

```text
[Phase2DataValidationTests] 16 tests passed
[Phase3CombatTests] 17 tests passed
[Phase4WorldCaptureTests] 28 tests passed
```

Không được có assertion, parse error, infinite yield hay warning unexpected.

## 1. Default project với một client

1. Serve `default.project.json`, kết nối Studio và Play một client.
2. Xác nhận Output có `[VoxelCreatures] Phase 4 server started` và `[VoxelCreatures] Phase 4 client started`.
3. Chọn một starter; UI chọn starter phải ẩn rồi `Phase4WorldGui` mới xuất hiện.
4. Xác nhận Home và platform vùng phía trước cùng hai zone marker xuất hiện.

Kết quả mong đợi: UI tiếng Việt, starter được thêm vào collection session và không có `CombatGui` harness Phase 3.

## 2. Server & Clients với hai client

Chạy **Server & Clients** với hai client, chọn starter khác nhau và đưa cả hai tới vùng.

Kết quả mong đợi: mỗi người có companion, encounter/health/inventory/collection riêng; một wild chỉ bị khóa bởi một encounter tại một thời điểm.

## 3. Companion follow và respawn không duplicate

1. Đi/chạy vòng quanh Home và region; quan sát companion bám theo nhưng không đẩy/chặn nhân vật.
2. Reset Character ba lần.
3. Trong Explorer kiểm tra `Workspace.Companions/<UserId>`.

Kết quả mong đợi: mỗi player chỉ có đúng một model companion 6 block, không collision/physics instability; sau mỗi respawn companion xuất hiện lại và tiếp tục follow.

## 4. Spawn cá thể và cụm đúng vùng

Kiểm tra `Workspace.WildCreatures` và hai marker zone:

- `meadow_single`: một wild trong zone xanh.
- `meadow_cluster`: hai wild gần nhau trong zone xanh dương.
- Sau defeat/capture, wild biến mất và một cá thể thay thế spawn tại đúng zone sau respawn time.

Kết quả mong đợi: identity/position/state/health do server tạo; client không tạo wild hợp lệ.

## 5. Companion chủ động tiếp cận wild

Đưa người chơi tới gần một wild nhưng chưa sát nó. Không bấm nút combat.

Kết quả mong đợi: companion tự rời follow offset, tiến tới mục tiêu và basic attack khi vào attack range; UI chuyển `đang giao chiến`.

## 6. Wild chủ động aggro companion

Đứng để companion đi vào aggro range của wild.

Kết quả mong đợi: wild chuyển `Idle → Engaging`, tiến tới companion và đánh. Không có client remote chọn target.

## 7. Health chỉ đổi theo server

1. Quan sát health trên Billboard và UI qua vài nhịp attack.
2. Trong Client Command Bar thử sửa text UI hoặc CFrame model cục bộ.

Kết quả mong đợi: lần replicate tiếp theo vẫn theo server; damage/cooldown/target không thể được client quyết định.

## 8. Disengage và return

Khi đang giao chiến, chạy thẳng ra xa hai sinh vật hơn owner-disengage range `28/30` stud. Sau đó test thêm trường hợp kéo wild khỏi điểm spawn gần wild leash `42/46` stud.

Kết quả mong đợi: ngay khi owner tách khỏi companion/wild quá owner-disengage range, encounter kết thúc an toàn và companion lập tức trở lại follow. Trong lúc owner còn xa, companion không được re-aggro wild khác dù vẫn đang ở trong vùng. Wild chuyển `Returning`, đi về spawn, hồi đầy HP khi tới nơi rồi về `Idle`. Không cấp reward/capture credit.

## 9. Capture thành công và thất bại

1. Đợi wild mất ít nhất một HP; trước đó các nút bắt phải bị khóa.
2. Dùng Nang Dấu Đường nhiều lần qua các encounter để quan sát ít nhất một failure và một success; có thể dùng Bẫy Lăng Kính để tăng chance.
3. Ghi lại inventory trước/sau.

Kết quả mong đợi: mỗi transaction hợp lệ tiêu đúng một thiết bị; failure không thêm collection và encounter tiếp tục; success thêm đúng một owned record, kết thúc encounter và despawn wild. UI hiển thị kết quả/tỷ lệ server bằng tiếng Việt.

## 10. Ngoài khoảng cách, payload sai, request lặp và spam

Lấy `world` từ server rồi dùng Client Command Bar. Chỉ thực hiện sau khi wild đã mất HP:

```lua
local remotes = game.ReplicatedStorage.Remotes
local world = remotes.GetWorldState:InvokeServer()
local request = {
    requestId = "manual-capture-1",
    encounterId = world.encounterId,
    wildId = world.wildId,
    deviceId = "trail_capsule",
}
print(remotes.UseCaptureDevice:InvokeServer(request))
print(remotes.UseCaptureDevice:InvokeServer(request))
```

Kết quả mong đợi: request lặp trả cached result nhưng không tiêu/add lần hai. Với request ID mới, thử:

- thêm `chance = 1` hoặc `ownership = true` → `INVALID_REQUEST`;
- `wildId`/`encounterId` giả → `ENCOUNTER_NOT_FOUND`;
- `deviceId` giả → `DEVICE_NOT_FOUND`;
- chạy ra ngoài capture range nhưng vẫn trong leash rồi gửi → `TARGET_INVALID`;
- gửi hai request ID mới liên tiếp dưới 0,25 giây → request sau `RATE_LIMITED`.

Không case bị từ chối nào được tiêu inventory hoặc tạo ownership. Output không log toàn payload.

## 11. Collection hai người chơi không lẫn nhau

1. Client A bắt thành công một wild; client B không bắt.
2. So sánh UI collection/inventory hai client.
3. Reset cả hai character.

Kết quả mong đợi: collection A tăng đúng một, B không đổi; active team vẫn starter riêng; reset không làm lẫn state. Collection chỉ tồn tại trong session, rejoin tạo session mới vì DataStore thuộc Phase 6.

## 12. Không xuất hiện PvP

Đưa hai player và companion sát nhau, thử va chạm/chạy vòng quanh nhau.

Kết quả mong đợi: không challenge, arena, player target, damage hoặc reward PvP; companion chỉ target wild hợp lệ.

## 13. Output audit

Trong toàn bộ matrix, xác nhận Output/Developer Console không có error, assertion, infinite yield, secret/profile data, duplicate controller/service hoặc warning unexpected. Ghi Studio version, ngày, số client và log lỗi nếu có.

## Kết quả thực tế

- Ngày: Chưa chạy.
- Roblox Studio version: Chưa cung cấp.
- Suite output: `PENDING`.
- Default one-client runtime: `PENDING`.
- Two-client isolation: `PENDING`.
- Invalid/range/idempotency/spam matrix: `PENDING`.
- Respawn/disengage/capture matrix: `PENDING`.
- Output audit: `PENDING`.
- Kết luận: Phase 4 `IN_PROGRESS`; chờ người dùng xác nhận đầy đủ, chưa được merge vào `master`.
