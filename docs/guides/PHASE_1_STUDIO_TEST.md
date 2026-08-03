# Kiểm tra thủ công Phase 1 trong Roblox Studio

## Môi trường

- Roblox Studio đã cài Rojo plugin tương thích với Rojo CLI 7.7.0.
- Terminal mở tại project root và chạy `rojo serve`.
- Studio kết nối đúng project `VoxelCreatures` qua Rojo.
- Test bằng chế độ **Server & Clients** với ít nhất hai client khi kiểm tra isolation.

## Smoke test Home và UI

1. Stop mọi Play Test cũ, xác nhận Rojo đã đồng bộ source mới rồi bắt đầu Play Test với một client.
2. Trong Explorer, xác nhận `Services` nằm cạnh `Bootstrap` dưới `ServerScriptService.Server`; `Controllers` nằm cạnh `Bootstrap` dưới `StarterPlayerScripts.Client`.
3. Xác nhận Output có `[VoxelCreatures] Phase 1 server started` và `[VoxelCreatures] Phase 1 client started`, không còn lỗi `Services is not a valid member` hoặc infinite yield remote.
4. Xác nhận `Workspace.HomePlaceholder` có `HomePlatform`, `HomeSpawn` và `HomeSign` hiển thị chữ **HOME** về phía spawn.
5. Xác nhận `Players/<Player>.RespawnLocation` trỏ tới `Workspace.HomePlaceholder.HomeSpawn`.
6. Xác nhận nhân vật xuất hiện tại Home và UI `StarterSelectionGui` xuất hiện.
7. Xác nhận UI hiển thị bốn starter nguyên bản: Bramblet, Pyrel, Tiderook và Zephlet.
8. Chọn một starter, sau đó chọn starter khác trước khi xác nhận.
9. Xác nhận UI chỉ giữ một lựa chọn và nút **Confirm starter** bật khi có lựa chọn.

Kết quả mong đợi: Home và UI xuất hiện không lỗi; client chưa tạo companion trước khi server xác nhận.

## Lựa chọn hợp lệ

1. Chọn một starter và bấm **Confirm starter**.
2. Xác nhận UI báo thành công rồi tự ẩn.
3. Trong Explorer, kiểm tra `Workspace.StarterCompanions/<UserId>`.
4. Xác nhận folder chứa đúng một Part có ID trùng lựa chọn và nameplate đúng.
5. Reset nhân vật.
6. Xác nhận nhân vật trở lại `HomeSpawn`.
7. Xác nhận placeholder starter được tạo lại cho nhân vật mới mà không cho chọn lại.

Kết quả mong đợi: server lưu một starter trong session, tạo đúng một placeholder và khôi phục nó sau respawn.

## Request không hợp lệ và request lặp

Chạy từng request sau từ client trong khi Play Test, trước lựa chọn hợp lệ. Dùng Command Bar ở client context và thay `request` cho từng case:

```lua
local remote = game.ReplicatedStorage.Remotes.SelectStarter
local request = { starterId = "bramblet" }
print(remote:InvokeServer(request))
```

Các case cần kiểm tra:

| Case | Request | Code mong đợi |
| --- | --- | --- |
| Sai kiểu | `"bramblet"` | `INVALID_SELECTION` |
| Sai field | `{ starterIds = { "bramblet" } }` | `INVALID_SELECTION` |
| ID sai kiểu | `{ starterId = 123 }` | `INVALID_SELECTION` |
| ID không tồn tại | `{ starterId = "unknown" }` | `INVALID_SELECTION` |
| Field thừa | `{ starterId = "bramblet", damage = 999 }` | `INVALID_SELECTION` |
| Gửi quá nhanh | Hai request sai liên tiếp dưới 0,5 giây | request sau trả `RATE_LIMITED` |

Sau đó gửi một request hợp lệ, rồi gửi lại một starter khác. Request thứ hai phải trả `ALREADY_SELECTED` và trả lại starter đã được server chấp nhận lần đầu.

## Isolation và reconnect

1. Chạy Server & Clients với hai client.
2. Chọn hai team khác nhau.
3. Xác nhận mỗi client có state riêng và mỗi UserId có đúng một folder companion.
4. Ngắt một client và kết nối lại trong một Play Test mới.

Kết quả mong đợi: lựa chọn không rò giữa người chơi. Reconnect tạo session mới và hiển thị lại UI vì DataStore chưa thuộc Phase 1; persistence chỉ được thêm ở Phase 6.

## Ghi kết quả

Ghi ngày, phiên bản Studio, số client, kết quả thực tế và mọi lỗi Output vào `PROJECT_PROCESS.md` khi chạy regression sau này.

## Trạng thái acceptance

Phase 1 là `DONE` theo xác nhận rõ ràng của người dùng ngày 2026-08-03. Repository không có Roblox Studio version, số client hoặc log chi tiết cho lần xác nhận đó, vì vậy tài liệu không suy đoán các giá trị này. Matrix phía trên được giữ làm regression checklist, không phải bằng chứng mới rằng một lần test chưa được ghi nhận đã chạy.
