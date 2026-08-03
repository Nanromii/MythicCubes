# Quy tắc dành cho AI agent

Tài liệu này áp dụng cho mọi AI agent làm việc trong repository. Agent phải giữ phạm vi theo phase hiện tại, ưu tiên an toàn, khả năng kiểm tra và tính nguyên bản của IP.

## Năng lực và vai trò cần có

Agent phải có khả năng:

- Phân tích kiến trúc Roblox client-server và viết typed Luau.
- Hiểu Rojo mapping và ranh giới giữa filesystem với Roblox DataModel.
- Thiết kế hệ thống data-driven, module có trách nhiệm rõ ràng và gameplay có thể test.
- Thiết kế `RemoteEvent` an toàn, kiểm tra mọi dữ liệu đến từ client.
- Viết tài liệu kỹ thuật, phân tích log Roblox Studio và refactor không làm đổi hành vi ngoài ý muốn.
- Xây dựng nền tảng có thể mở rộng kho sinh vật và kỹ năng mà không tạo abstraction sớm.
- Nhận biết và ngăn nội dung hoặc asset IP bên thứ ba không có giấy phép, đặc biệt nội dung Pokémon.

## Thứ tự đọc tài liệu

Trước khi thực hiện nhiệm vụ, đọc theo thứ tự:

1. `docs/project/AGENTS.md`.
2. `docs/project/CODEX.md`.
3. `docs/project/GAME_DESIGN.md`.
4. `docs/project/ARCHITECTURE.md`.
5. `docs/project/CODING_STANDARDS.md`.
6. `docs/project/PROJECT_PROCESS.md`.
7. Tài liệu liên quan trực tiếp tới feature đang làm.

## Quy tắc triển khai

- Chỉ làm phase hiện tại; không tự chuyển phase, mở rộng scope hoặc tạo thứ chỉ vì có thể cần sau này.
- Không hardcode dữ liệu sinh vật trong service hoặc bảng khắc hệ trong logic chiến đấu.
- Server là nguồn sự thật. Client không được tự quyết định sát thương, kết quả bắt sinh vật, tiền, vật phẩm, mở khóa vùng hoặc dữ liệu sở hữu.
- Mọi request từ client phải được server xác thực về kiểu dữ liệu, quyền sở hữu, trạng thái, khoảng cách, cooldown và tần suất khi phù hợp.
- Không ghi log secret hoặc dữ liệu nhạy cảm.
- Không sử dụng asset không rõ giấy phép, nội dung Pokémon hoặc nội dung thuộc IP bên thứ ba chưa được cho phép.
- Không tạo code giả để che giấu tính năng chưa tồn tại.
- Giữ typed Luau với `--!strict`, dependency một chiều và module có một trách nhiệm chính.

## Quy tắc hoàn thành nhiệm vụ

Sau mỗi nhiệm vụ, agent phải:

- Liệt kê file đã tạo và file đã sửa.
- Liệt kê lệnh đã chạy, exit status và kết quả kiểm tra.
- Nêu rõ phần chưa kiểm tra được và nguyên nhân.
- Cập nhật `docs/project/PROJECT_PROCESS.md`; cập nhật `docs/project/CHANGELOG.md` khi có thay đổi đáng kể.
- Đưa ra bước kiểm tra thủ công trong Roblox Studio.
- Kiểm tra diff, secret, binary build và nội dung ngoài scope.
- Không tuyên bố hoàn thành nếu acceptance criteria chưa đạt.
