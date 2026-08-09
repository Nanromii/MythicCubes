# Chiến lược kiểm thử Roblox

## Kiểm tra tĩnh

Chỉ ghi câu lệnh đạt sau khi vừa chạy lại:

```powershell
stylua --check src tests
selene src
rojo build default.project.json -o default-current.rbxlx
```

Nếu câu lệnh không có trong `PATH` hoặc dự án có lỗi sẵn, ghi rõ mã thoát và không che lỗi.

## Kiểm thử tự động

Ưu tiên logic thuần/dùng chung: sát thương, chuyển trạng thái, thời gian hồi, kiểm tra quyền/mục tiêu, cấu
trúc dữ liệu và quy tắc tiến trình khi mã nguồn đã có điểm tách phù hợp. Không thêm bộ khung kiểm thử lớn
chỉ để hoàn thành tài liệu.

## Roblox Studio

Hành vi chức năng phải được kiểm tra trong Studio; build/lint không chứng minh hành vi khi chạy. Tính năng
nhiều người chơi phải dùng `Server & Clients` với số người chơi phù hợp. Ma trận kiểm thử phải tuân theo
[hướng dẫn kiểm thử Studio](STUDIO_TEST_GUIDE.md), viết bằng tiếng Việt nhất quán và luôn đi kèm file mẫu
Output nguyên văn có đủ mục tương ứng với từng mã trường hợp kiểm thử.

## Kiểm tra khai thác lỗi tối thiểu

Khi có remote: thử ID không tồn tại, đối tượng/người chơi khác, gửi dồn dập, sai trạng thái, yêu cầu sau
khi hồi sinh và dữ liệu ngoài khoảng cho phép. Máy chủ phải từ chối an toàn.

## Chơi thử

Tách tính đúng của chức năng khỏi cảm giác chơi. Ví dụ sát thương đúng là kiểm thử chức năng; nhịp chiến
đấu dễ hiểu là chơi thử. Không dùng cảm nhận khi chơi thử để thay tiêu chí kỹ thuật.
