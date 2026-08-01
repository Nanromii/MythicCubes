# Tiêu chuẩn coding

## Luau

- Mọi source mới dùng `--!strict` và khai báo type rõ ràng ở boundary.
- Tránh `any`; nếu không thể tránh, giới hạn phạm vi và ghi lý do.
- Không dùng mutable global state hoặc lạm dụng metatable.
- Function ngắn, có một trách nhiệm chính và tên thể hiện ý định.
- Không dùng magic number; constant phải có tên rõ ràng.
- Không nuốt lỗi im lặng hoặc dùng code giả thay implementation thật.

## Naming

- Module và type: `PascalCase`.
- Function và variable: `camelCase`.
- Constant: `UPPER_SNAKE_CASE`.
- Private helper dùng tên đầy đủ, tránh viết tắt khó hiểu.
- Remote name phải được quản lý tập trung.

## Ranh giới module

- Một module có một trách nhiệm chính; không import ngược tầng hoặc tạo circular dependency.
- Shared module không chứa state người chơi.
- Client module không truy cập DataStore.
- Server module không phụ thuộc implementation UI.
- Definition là dữ liệu được validation, không gọi service.

## Xử lý lỗi

- Validate argument tại public boundary và remote boundary.
- Fail rõ ràng trong development; log có context hành động nhưng không chứa secret.
- Không dùng `pcall` để che mọi lỗi. Chỉ bắt lỗi khi có chiến lược xử lý cụ thể.
- Chỉ retry operation phù hợp, có giới hạn và backoff; không retry lỗi validation.

## Bảo mật

- Server xác thực mọi remote; client chỉ gửi intent.
- Kiểm tra ownership, distance, cooldown, state, inventory và rate khi phù hợp.
- Không nhận damage, tiền, phần thưởng hoặc kết quả random trực tiếp từ client.
- Không tin ID đối tượng sở hữu trước khi đối chiếu state server.

## Formatting và lint

- StyLua là formatter chuẩn: `stylua src tests`.
- Selene là linter chuẩn: `selene src`.
- Không bỏ qua lint tùy tiện. Mọi disable rule phải hẹp và ghi lý do tại vị trí áp dụng.
- Source phải vượt qua `stylua --check src tests` trước khi merge.

## Test

- Logic thuần cần unit test khi test framework được thêm.
- Validation có case hợp lệ, không hợp lệ và boundary.
- Công thức sát thương trong phase sau phải có deterministic test.
- Không buộc mọi logic thuần phụ thuộc Roblox Studio.
- Manual test phải ghi lại môi trường, bước thực hiện, kết quả mong đợi và kết quả thực tế.

