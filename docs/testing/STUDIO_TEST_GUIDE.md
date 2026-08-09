# Hướng dẫn kiểm thử bằng Roblox Studio

## Ngôn ngữ sử dụng

- Phần hướng dẫn dành cho người kiểm thử phải viết bằng tiếng Việt rõ ràng, câu ngắn và thống nhất.
- Chỉ giữ tiếng Anh khi đó là tên hiển thị chính xác trong Roblox Studio (`Play Solo`, `Server & Clients`,
  `Command Bar`, `Output`), câu lệnh, đường dẫn, định danh, giá trị enum, mã lỗi hoặc thuật ngữ riêng đã
  dùng trong trò chơi như `starter`, `world`.
- Không chêm từ tiếng Anh thông thường vào câu tiếng Việt nếu đã có cách diễn đạt tiếng Việt tự nhiên.
- Không dùng một nhãn tiếng Anh rồi giải thích bằng tiếng Việt. Dùng các nhãn chuẩn ở phần dưới.

## Cấu trúc một trường hợp kiểm thử

Mỗi trường hợp kiểm thử phải có đủ các mục, theo đúng thứ tự:

- **Lệnh chuẩn bị (sao chép/dán):** đặt ngay sau tiêu đề trường hợp và trước mục **Điều kiện trước khi
  chạy**. Cung cấp khối `powershell` hoàn chỉnh gồm thư mục gốc dự án, lệnh `rojo build` hoặc `rojo serve`
  đúng project Rojo, tệp đầu ra và lệnh mở/chạy cần thiết cho chính trường hợp đó. Không bắt người kiểm
  thử ghép lệnh từ phần mô tả hoặc trường hợp khác.
- **Điều kiện trước khi chạy**
- **Chế độ và số người chơi thử**
- **Các bước thực hiện:** đánh số từng bước.
- **Kết quả mong đợi**
- **Kết quả thực tế**
- **Output máy chủ cần quan sát**
- **Output từng người chơi cần quan sát**
- **Kết luận và thời điểm:** dùng `CHƯA CHẠY`, `ĐẠT` hoặc `KHÔNG ĐẠT`.
- **Phần chưa kiểm tra hoặc giới hạn**, nếu có.

Nếu trường hợp cần `Client Command Bar`, `Server Command Bar` hoặc script kiểm thử tạm thời, tài liệu phải
kèm khối `lua` hoàn chỉnh có thể sao chép và chạy trực tiếp. Không chỉ ghi “dùng Command Bar” hoặc “tạo
script tạm thời”. Nếu trường hợp thật sự không cần cửa sổ lệnh/Command Bar, vẫn ghi rõ `Không cần lệnh bổ
sung` thay vì bỏ mục này.

Lệnh phải:

- chạy được từ PowerShell với đường dẫn chính xác trong kho mã;
- tuân theo quy ước `default-current.rbxlx` cho project Rojo mặc định và
  `artifacts/json/` → `artifacts/rbxlx/` cho project Rojo của giai đoạn/kiểm thử;
- không chứa nội dung giữ chỗ chưa được giải thích;
- không xuất bản place hoặc thay đổi dữ liệu ở môi trường thật.

## Tệp ghi Output nguyên văn

Mỗi tệp ma trận kiểm thử phải có một tệp mẫu Output riêng trong cùng thư mục. Quy tắc đặt tên:

```text
<TÊN>_STUDIO_TEST_MATRIX.md
<TÊN>_STUDIO_TEST_OUTPUT_TEMPLATE.md
```

Ví dụ: `PHASE5_STUDIO_TEST_MATRIX.md` phải đi cùng
`PHASE5_STUDIO_TEST_OUTPUT_TEMPLATE.md`.

Tệp mẫu Output bắt buộc phải:

- có đúng một mục cho từng mã trường hợp kiểm thử trong ma trận và giữ nguyên thứ tự;
- có chỗ ghi phiên bản Studio, thời điểm, chế độ, số người chơi, kết quả thực tế và kết luận;
- có khối `text` riêng để dán nguyên văn Output máy chủ và Output của từng người chơi;
- hướng dẫn ghi `Không có dòng Output liên quan` khi cửa sổ Output không phát sinh dòng cần lưu;
- liên kết ngược về tệp ma trận; tệp ma trận cũng phải liên kết tới tệp mẫu Output;
- để trống dữ liệu thực tế nếu chưa được cung cấp, không tự dựng log và không tóm tắt thay cho Output nguyên văn.

Dùng [mẫu Output chung](templates/STUDIO_TEST_OUTPUT_TEMPLATE.md) khi tạo tệp mới. Khi bàn giao một ma
trận, phải sao chép mẫu thành tệp riêng của ma trận và tạo sẵn toàn bộ mục theo mã trường hợp kiểm thử để
người chạy chỉ cần dán Output vào đúng vị trí.

## Chế độ chạy

- **Play Solo:** kiểm tra nhanh với một người chơi.
- **Start Server / Start Player:** kiểm tra ranh giới giữa máy chủ và người chơi.
- **Server & Clients:** kiểm tra dữ liệu tách biệt, remote, quyền sở hữu và nhiều người chơi.
- **Kiểm thử chức năng:** hành vi có thể quan sát và đối chiếu.
- **Kiểm thử hồi quy:** chạy lại trường hợp cũ sau thay đổi.
- **Kiểm thử hướng tới khai thác lỗi:** gửi yêu cầu không đáng tin từ người chơi.
- **Chơi thử:** đánh giá cảm giác, độ dễ đọc và nhịp độ; không thay thế bằng chứng chức năng.

## Bàn giao

Codex không có môi trường chạy Studio trong tác vụ này. Người thực hiện Studio cần ghi phiên bản, số người
chơi, kết quả thực tế và Output nguyên văn vào tệp mẫu đi kèm; không chỉ ghi một chữ `ĐẠT`.
