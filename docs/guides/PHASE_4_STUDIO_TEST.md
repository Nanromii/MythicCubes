# Kiểm tra Phase 4 trong Roblox Studio

Phase 4 đã được xác nhận hoàn tất trong Studio. Tài liệu này giữ lại suite/runtime matrix dưới đây như hồ sơ lịch sử và regression. Terminal build không thay thế Play Test. Không publish, không merge vào `master`, không chạy DataStore và không bật PvP.

## Giá trị placeholder cần biết

Vertical slice chỉ có region `verdant_meadow` với hai zone. `meadow_single` tạo một cá thể; `meadow_cluster` tạo cụm hai cá thể. Aggro range là `16/18`, engagement `20/22`, owner-disengage `28/30`, wild leash `42/46`, attack range `6`, respawn `8/10` giây. Capture range theo thứ tự bóng là `28/32/36/40`; inventory đầu phiên là 5 Bóng xanh lá, 2 Bóng xanh dương, 1 Bóng tím và 1 Bóng đỏ. Đây là placeholder tập trung trong `WorldDefinitions.lua`, không phải balance production.

## Build và chạy suite

Tại project root:

```powershell
rojo build artifacts/json/phase4-tests.project.json -o artifacts/rbxlx/phase4-tests.rbxlx
rojo serve artifacts/json/phase4-tests.project.json --port 34876
```

Mở `artifacts/rbxlx/phase4-tests.rbxlx` hoặc kết nối Rojo plugin tới port `34876`, rồi Play một server. Output mong đợi:

```text
[Phase2DataValidationTests] 16 tests passed
[Phase3CombatTests] 17 tests passed
[Phase4WorldCaptureTests] 49 tests passed
```

Không được có assertion, parse error, infinite yield hay warning unexpected.

## 1. Default project với một client

1. Serve `default.project.json`, kết nối Studio và Play một client.
2. Xác nhận Output có `[VoxelCreatures] Phase 4 server started` và `[VoxelCreatures] Phase 4 client started`.
3. Chọn một starter; UI phải hiển thị đúng năm lựa chọn hệ Lửa, Nước, Gió, Tự nhiên và Thường, sau đó ẩn rồi `Phase4WorldGui` mới xuất hiện.
4. Xác nhận Home và platform vùng phía trước cùng hai zone marker xuất hiện.

Kết quả mong đợi: UI tiếng Việt, starter được thêm vào collection session và không có `CombatGui` harness Phase 3.

## 2. Server & Clients với hai client

Chạy **Server & Clients** với hai client, chọn starter khác nhau và đưa cả hai tới vùng.

Kết quả mong đợi: mỗi người có companion, health/inventory/collection riêng; nếu cả hai cùng tới một wild đang `Engaging`, cả hai có thể cùng tham gia encounter đó nhưng collection/inventory vẫn tách riêng.

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

## 4a. Encounter cụm không còn 1v1 cứng

1. Đưa player tới `meadow_cluster`.
2. Quan sát UI `Sinh vật tự nhiên` khi cụm hai wild cùng vào encounter.
3. Đợi vài nhịp attack.

Kết quả mong đợi: UI liệt kê nhiều wild trong encounter; companion chọn một target server-side, và nhiều wild có thể cùng gây damage lên companion. Combat không bị khóa thành đúng một player pet với đúng một wild nếu cụm còn nhiều target hợp lệ.

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

## 7a. Companion không tự hồi sau combat

1. Để companion mất HP trong combat.
2. Chạy ra khỏi owner-disengage range để encounter kết thúc.
3. Đứng ngoài vùng đủ lâu để UI quay về `đang khám phá`.
4. Đi vào encounter mới mà không qua cơ chế hồi máu safe zone.

Kết quả mong đợi: HP companion giữ giá trị đã mất, không tự reset về max chỉ vì combat cũ kết thúc. Wild return vẫn được hồi đầy HP khi về spawn theo lifecycle của wild.

## 8. Disengage và return

Khi đang giao chiến, chạy thẳng ra xa hai sinh vật hơn owner-disengage range `28/30` stud. Sau đó test thêm trường hợp kéo wild khỏi điểm spawn gần wild leash `42/46` stud.

Kết quả mong đợi: khi một participant tách khỏi companion/wild quá owner-disengage range, participant đó
  được gỡ khỏi encounter và companion lập tức trở lại follow. Với test hai client, encounter vẫn tiếp tục
  cho participant hợp lệ còn lại; chỉ khi không còn participant hợp lệ, wild mới chuyển `Returning`, đi về
  spawn, hồi đầy HP khi tới nơi rồi về `Idle`. Trong lúc participant còn xa, companion không được re-aggro
  wild khác. Không cấp reward/capture credit.

## 9. Capture thành công và thất bại

1. Thử bắt một wild còn full HP, sau đó thử một wild đã mất HP; full HP vẫn hợp lệ nhưng chance thấp hơn.
2. Dùng Bóng xanh lá, Bóng xanh dương, Bóng tím và Bóng đỏ qua các encounter để quan sát ít nhất một failure và một success.
3. Ghi lại inventory trước/sau.

Kết quả mong đợi: mỗi transaction hợp lệ tiêu đúng một thiết bị; failure không thêm collection, unlock target và encounter tiếp tục; success thêm đúng một owned record, despawn đúng target và chỉ kết thúc encounter nếu không còn wild hợp lệ. UI hiển thị kết quả/tỷ lệ server bằng tiếng Việt.

## 9a. Chọn đúng target khi có nhiều wild

1. Vào encounter ở `meadow_cluster`.
2. Dùng nút đổi mục tiêu bắt để chuyển highlight `▶` giữa các wild trong UI.
3. Làm yếu một wild cụ thể rồi ném một loại bóng vào target đang chọn.

Kết quả mong đợi: client gửi đúng `wildId` đang chọn; server chỉ xử lý target đó. Nếu target không thuộc encounter,
locked, out-of-range hoặc không còn `Engaging`, request bị từ chối không tiêu bóng. Target full HP vẫn được
server cho phép attempt theo rule capture mới.

## 10. Ngoài khoảng cách, payload sai, request lặp và spam

Lấy `world` từ server rồi dùng Client Command Bar với target còn sống (full HP cũng hợp lệ theo rule mới):

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
- dùng lại `requestId` cũ với `wildId` hoặc `deviceId` khác → `REQUEST_ID_CONFLICT`.

Không case bị từ chối nào được tiêu inventory hoặc tạo ownership. Output không log toàn payload.

## 10a. Hai client cùng đánh và tranh capture cùng target

1. Chạy **Server & Clients** với hai client và đưa cả hai tới cùng một wild.
2. Xác nhận cả hai UI cùng thấy encounter và HP wild giảm theo server.
3. Khi wild đã yếu, cho Client A và Client B cùng ném bóng vào cùng `wildId` gần như đồng thời.
4. Nếu request đầu thất bại, gửi tiếp request hợp lệ từ client còn lại.

Kết quả mong đợi: request hợp lệ đến trước khóa target. Request còn lại trong lúc target locked trả `TARGET_CAPTURE_LOCKED`, không roll, không tiêu bóng và không thêm collection. Nếu request đầu thất bại, target unlock ngay và request sau có thể thử lại. Nếu request đầu thành công, chỉ player thắng nhận owned creature và target despawn đúng một lần.

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

- Ngày: 2026-08-08.
- Roblox Studio version: Đã ghi nhận trong lần xác nhận gần nhất.
- Suite output: `PASS`.
- Default one-client runtime: `PASS`.
- Two-client isolation: `PASS`.
- Invalid/range/idempotency/spam matrix: `PASS`.
- Respawn/disengage/capture matrix: `PASS`.
- Output audit: `PASS`.
- Kết luận: Phase 4 `DONE (historical)`; Studio acceptance đã hoàn tất và tài liệu này chỉ còn là hồ sơ/regression.
