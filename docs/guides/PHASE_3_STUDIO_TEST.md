# Kiểm tra Phase 3 trong Roblox Studio

Phase 3 chỉ được chuyển `DONE` sau khi cả suite và runtime matrix dưới đây có kết quả thực tế. Không publish test place, không merge vào `master` trước xác nhận này.

## Baseline hiện tại và target design

Suite hiện tại kiểm tra implementation bốn hệ `verdant`, `ember`, `tide`, `gale`, effect `Damage`, một sinh vật mỗi phía và client test UI. Repository chưa có năm element target, XP/evolution/status/skill roll, combat arena vật lý hoàn chỉnh hoặc enemy model được spawn để quan sát trực tiếp. Không dùng guide này làm bằng chứng rằng các phần đó đã được triển khai.

Trước lần Studio acceptance tiếp theo, review [Hệ thống sinh vật, nguyên tố và kỹ năng](../design/CREATURE_ELEMENT_SKILL_SYSTEM.md) và hoàn tất task code migration riêng cho năm element/ba skill slot cùng các test liên quan. Sau migration, cập nhật ID/case trong guide và suite trước khi ghi actual result.

## Build và serve test project

Tại project root:

```powershell
rojo build phase3-tests.project.json -o phase3-tests.rbxlx
rojo serve phase3-tests.project.json --port 34875
```

Mở `phase3-tests.rbxlx`, hoặc kết nối Rojo plugin tới port `34875`, rồi Play với một server. Output mong đợi:

```text
[Phase2DataValidationTests] 11 tests passed
[Phase3CombatTests] 17 tests passed
```

Không được có assertion, parse error hoặc warning registry. Ghi Output thực tế vào mục “Kết quả thực tế”.

## Chuẩn bị default project

1. Chạy `rojo serve` từ project root và kết nối Studio với `default.project.json`.
2. Chạy Play một client, chọn một starter và xác nhận.
3. Trước khi xác nhận starter, kiểm tra chỉ có `StarterSelectionGui`; không có `CombatGui` hoặc thông báo rate-limit combat.
4. Xác nhận starter, kiểm tra UI chọn thú ẩn rồi `CombatGui` mới xuất hiện, không có thời điểm hai panel chồng nhau.
5. Xác nhận Output có `[VoxelCreatures] Phase 3 server started` và `[VoxelCreatures] Phase 3 client started`.
6. Xác nhận `CombatGui` hiển thị `Trạng thái: chưa có trận đấu`; bấm **Bắt đầu trận đấu**.

Kết quả mong đợi: server tạo một combat `Active`, mỗi phía có một creature, health ban đầu đến từ registry và client không tự tạo damage/state.

## Basic attack và snapshot

1. Không bấm skill trong ít nhất 8 giây.
2. Quan sát health hai phía chỉ thay đổi sau snapshot server, theo nhịp basic attack khoảng 2,5 giây.
3. Theo dõi Output và Developer Console.

Kết quả mong đợi: cả hai phía tự đánh target sống deterministic; không cần client spam attack; health không âm và basic attack dừng khi combat `Finished`.

## Presentation tối thiểu

Current implementation chỉ có snapshot test UI. Nếu task Phase 3 tiếp theo bổ sung arena nhỏ, vị trí hai phe và model blocky placeholder để quan sát combat, kiểm tra:

1. Hai phía xuất hiện đúng vị trí và model phản ánh creature server đã chọn.
2. Health/action presentation chỉ theo state hoặc event server xác nhận.
3. Model không quyết định target, damage, cooldown hoặc winner.
4. Reset/respawn không tạo model hoặc controller trùng.

Không đánh dấu mục này đạt cho tới khi presentation thực sự tồn tại và được quan sát trong Studio. Camera production, animation, VFX/SFX và mobile polish thuộc Phase 7.

## Active skill hợp lệ và cooldown

1. Bắt đầu encounter mới nếu trận trước đã kết thúc.
2. Bấm nút skill một lần.
3. Xác nhận health enemy chỉ giảm sau server response/snapshot và nút hiển thị cooldown server gửi.
4. Sau hơn 0,2 giây nhưng trước khi cooldown hết, dùng Client Command Bar với snapshot hiện tại:

```lua
local remotes = game.ReplicatedStorage.Remotes
local snapshot = remotes.GetCombat:InvokeServer().snapshot
local playerCombatant = snapshot.combatants[1]
local enemyCombatant = snapshot.combatants[2]
print(remotes.UseCombatSkill:InvokeServer({
    combatId = snapshot.id,
    requestId = "manual-cooldown-1",
    combatantId = playerCombatant.id,
    skillId = playerCombatant.equippedSkillIds[1],
    targetId = enemyCombatant.id,
}))
```

Kết quả mong đợi: request hợp lệ đầu tiên được server tính; request trong cooldown trả `SKILL_ON_COOLDOWN` và không đổi health.

## Target sai, skill sai và payload sai

Dùng cùng cách lấy `snapshot`, chờ ít nhất 0,2 giây giữa từng case và dùng `requestId` mới:

| Case | Thay đổi request | Code mong đợi |
| --- | --- | --- |
| Target không tồn tại | `targetId = "missing"` | `TARGET_NOT_FOUND` |
| Target cùng phía | `targetId = playerCombatant.id` | `INVALID_TARGET` |
| Skill không tồn tại | `skillId = "missing"` | `SKILL_NOT_FOUND` |
| Skill có thật nhưng không equip | `skillId` của creature khác | `SKILL_NOT_EQUIPPED` |
| Payload sai kiểu | gửi chuỗi thay table | `INVALID_REQUEST` |
| Field thừa | thêm `damage = 999` | `INVALID_REQUEST` |
| Request ID lặp | gửi lại request đã xử lý | `DUPLICATE_REQUEST` |

Kết quả mong đợi: mọi case bị từ chối, UI/health/cooldown không được client tự sửa và Output không log toàn payload.

## Spam remote

Gửi hai request shape hợp lệ với `requestId` khác nhau liên tiếp dưới 0,2 giây. Có thể chuẩn bị hai table từ snapshot rồi gọi `InvokeServer` liền nhau.

Kết quả mong đợi: request thứ hai trả `RATE_LIMITED`; không có double execution. Range/distance không áp dụng ở Phase 3 vì vertical slice không dùng vị trí Workspace để chọn target.

## Kết thúc và encounter mới

1. Để basic attack và skill đưa một phía về 0 HP.
2. Xác nhận state chuyển `Finished` đúng một lần và UI hiển thị `Victory` hoặc `Defeat`.
3. Chờ thêm ít nhất 5 giây, xác nhận không còn health change.
4. Bấm **Start encounter** để tạo combat mới.

Kết quả mong đợi: winner nhất quán với phía còn sống; combat cũ không chạy tiếp; combat mới có ID/state/health riêng.

## Reset và respawn giữa combat

1. Khi combat `Active`, Reset Character.
2. Xác nhận nhân vật về Home và `CombatGui` vẫn render snapshot server.
3. Dùng skill sau respawn.

Kết quả mong đợi: encounter tiếp tục vì Phase 3 không gắn combat với vị trí character; quyền điều khiển vẫn thuộc đúng player, không có duplicate controller hoặc infinite yield.

## Multi-client isolation

1. Chạy **Server & Clients** với hai client.
2. Mỗi client chọn starter khác nhau và bắt đầu encounter.
3. Dùng skill trên client A, quan sát cả hai client.
4. Kết thúc hoặc reset combat A trong khi combat B còn chạy.

Kết quả mong đợi: combat ID, health, cooldown, winner và event của A không xuất hiện hoặc thay đổi state B. Mỗi event chỉ gửi tới owner tương ứng.

## Output audit

Trong toàn bộ matrix, xác nhận Output không có error, assertion, infinite yield, secret, profile data hoặc warning unexpected. Ghi Studio version, số client, ngày, từng actual result và log lỗi nếu có.

## Kết quả thực tế

- Báo cáo trước fix ngày 2026-08-03: UI starter và combat xuất hiện cùng lúc, text gameplay là tiếng Anh, cỏ 3D che phần lớn camera; đã sửa source nhưng chưa có kết quả Studio sau fix.
- Ngày: Chưa chạy.
- Roblox Studio version: Chưa ghi nhận.
- Test clients: Chưa ghi nhận.
- Suite output: Chưa xác minh.
- Default-project runtime: Chưa xác minh.
- Invalid request/rate/cooldown matrix: Chưa xác minh.
- Reset/multi-client isolation: Chưa xác minh.
- Output audit: Chưa xác minh.
- Kết luận: Phase 3 giữ `IN_PROGRESS` cho tới khi người dùng cung cấp log đạt.
