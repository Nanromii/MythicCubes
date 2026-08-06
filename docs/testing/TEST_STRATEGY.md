# Test strategy cho Roblox

## Static validation

Chỉ ghi command pass sau khi chạy mới:

```powershell
stylua --check src tests
selene src
rojo build -o build.rbxlx
```

Nếu command không có trong PATH hoặc project có lỗi sẵn, ghi rõ exit code và không che lỗi.

## Automated tests

Ưu tiên pure/shared logic: damage, state transition, cooldown, permission/target validation, data
schema và progression rule khi source đã có seam. Không thêm framework test lớn trong task docs này.

## Roblox Studio

Functional behavior phải kiểm tra trong Studio; build/lint không chứng minh runtime. Multiplayer feature
phải dùng Server & Clients với số client phù hợp. Test matrix cần ghi Studio version, client count, steps,
expected/actual result, Output và pass/fail.

## Exploit-oriented minimum

Khi remote liên quan: ID không tồn tại, object/player khác, spam remote, sai state, request sau respawn
và dữ liệu vượt range. Server phải fail closed.

## Playtest

Tách functional correctness khỏi game feel. Ví dụ damage đúng là functional; nhịp combat dễ hiểu là
playtest. Không dùng cảm nhận playtest để thay acceptance kỹ thuật.
