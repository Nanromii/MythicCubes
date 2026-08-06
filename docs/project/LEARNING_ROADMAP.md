# Lộ trình học nền tảng cho MythicCubes

Tài liệu này chỉ liệt kê những thứ cần học ở mức căn bản để có thể phát triển MythicCubes tốt hơn. Không cần trở thành chuyên gia ở tất cả lĩnh vực; mục tiêu là hiểu đủ để tự làm prototype, phối hợp với người khác và đưa ra quyết định đúng.

## Nguyên tắc học

- Học theo nhu cầu của phase hiện tại, không học tất cả cùng lúc.
- Mỗi chủ đề chỉ cần đạt mức có thể làm một sản phẩm nhỏ và hiểu giới hạn của nó.
- Ưu tiên hoàn thành một vertical slice có thể chơi được hơn là học lý thuyết quá lâu.
- Công cụ chỉ là phương tiện; không nên đổi tool liên tục.

## Mức độ ưu tiên

- **P0 — cần học trước:** ảnh hưởng trực tiếp đến việc làm game.
- **P1 — nên học sớm:** giúp game dễ chơi, dễ kiểm thử và có chất lượng tốt hơn.
- **P2 — học sau:** cần khi dự án bắt đầu có người chơi hoặc nhiều nội dung.

## P0 — Những kiến thức cần học trước

### 1. Thiết kế game căn bản

Cần hiểu:

- Core loop: người chơi làm gì lặp đi lặp lại.
- Game loop của MythicCubes: khám phá → chiến đấu → bắt → nâng cấp → quay lại.
- Mục tiêu ngắn hạn, trung hạn và dài hạn của người chơi.
- Difficulty curve: độ khó tăng như thế nào.
- Progression: level, XP, skill, rarity, đội hình và mở vùng.
- Balance căn bản: damage, HP, cooldown, tỉ lệ bắt và phần thưởng.
- Viết một feature thành: mục tiêu, luật chơi, trạng thái thành công/thất bại và cách kiểm thử.

**Bài tập tối thiểu:** dùng Google Sheets để lập bảng damage, XP, rarity và phần thưởng cho một world nhỏ.

### 2. Roblox Studio căn bản

Cần biết sử dụng:

- Explorer, Properties, Workspace, ServerScriptService và ReplicatedStorage.
- Play Test, Server & Clients và Test tab.
- Output, Developer Console và Script Analysis.
- Import model, đặt collision, anchor, pivot và hierarchy.
- Lighting, camera và các thiết lập cơ bản cho mobile.
- Publish phiên bản test và kiểm tra quyền truy cập.

### 3. Workflow của repository

Cần hiểu:

- Git: branch, commit, diff, merge và cách khôi phục thay đổi an toàn.
- Rojo: mapping source vào Roblox DataModel và `rojo serve`.
- Luau Language Server: đọc type error và autocomplete.
- StyLua: format code.
- Selene: lint và phát hiện lỗi phổ biến.
- Cách đọc design document, architecture document và test guide trong repo.

**Mục tiêu:** có thể sửa một feature nhỏ, chạy format/lint, build project và kiểm tra thay đổi trong Studio.

### 4. Kiểm thử và bảo mật Roblox căn bản

Cần biết:

- Khác biệt giữa client và server.
- Vì sao damage, capture, inventory, reward và persistence phải do server quyết định.
- Cách kiểm tra remote request sai, spam request và target không hợp lệ.
- Test một người chơi, nhiều client, latency và disconnect.
- Viết test case hợp lệ, không hợp lệ và trường hợp biên.
- Đọc log và tái hiện bug bằng các bước rõ ràng.

## P1 — Những kiến thức nên học sớm

### 5. UI/UX căn bản

Cần hiểu:

- Hierarchy thị giác: người chơi phải thấy thông tin nào trước.
- Button, icon, màu sắc và text phải có ý nghĩa rõ ràng.
- Feedback cho loading, success, failure, cooldown và unavailable state.
- Onboarding từng bước, không đưa quá nhiều thông tin cùng lúc.
- Thiết kế cho mobile/touch và màn hình có tỉ lệ khác nhau.
- Khả năng đọc khi có nhiều creature, effect và enemy trên màn hình.

**Bài tập tối thiểu:** vẽ wireframe cho màn hình capture, combat HUD và collection trước khi dựng UI thật.

### 6. Level design và world building căn bản

Cần biết:

- Greybox map trước khi làm art chi tiết.
- Tạo đường đi, landmark, khu an toàn, khu nguy hiểm và vùng encounter.
- Dẫn hướng người chơi bằng hình dạng, ánh sáng, màu sắc và khoảng nhìn.
- Bố trí spawn, combat space, camera space và điểm nghỉ.
- Thiết kế map để không làm người chơi bị kẹt hoặc mất phương hướng.
- Modular kit: tái sử dụng một nhóm asset cho nhiều khu vực.

**Bài tập tối thiểu:** tạo một world nhỏ có làng, một tuyến khám phá, một encounter area và một landmark dễ nhận biết.

### 7. 3D asset và animation căn bản

Không cần học toàn bộ Blender. Chỉ cần học:

- Modeling hình khối đơn giản.
- Tỉ lệ, silhouette và màu nhận diện creature.
- Material và texture đơn giản.
- Export/import asset vào Roblox.
- Rig cơ bản và animation idle, walk, attack, hit, defeated.
- Kiểm tra scale, collision và performance của asset.

Có thể chọn một trong hai hướng:

- **Blockbench:** bắt đầu nhanh với voxel/blocky.
- **Blender:** phù hợp hơn nếu muốn mở rộng sang rig, animation và pipeline 3D đầy đủ.

### 8. Game feel căn bản

Cần hiểu:

- Timing và anticipation trước hành động.
- Hit reaction, damage feedback và trạng thái bị hạ.
- Camera shake hoặc camera movement ở mức vừa phải.
- VFX đơn giản cho skill, capture và rarity.
- Âm thanh phản hồi cho button, bước chân, attack, hit và success/failure.
- Không lạm dụng particle, light hoặc âm thanh đồng thời.

## P2 — Học sau khi core loop ổn định

### 9. Performance và profiling

Cần biết ở mức cơ bản:

- FPS, frame time, memory và network usage.
- Vì sao quá nhiều part, rig, particle hoặc loop mỗi frame gây lag.
- Cách dùng Performance Summary và MicroProfiler.
- Cách test trên thiết bị yếu hơn máy phát triển.

### 10. Data persistence và live game

Cần hiểu:

- Profile data, schema version và migration.
- Save/load an toàn, retry và xử lý lỗi khi disconnect.
- Idempotency để không trao reward hai lần.
- Logging những lỗi ảnh hưởng đến dữ liệu người chơi.
- Analytics căn bản: session length, retention, funnel onboarding và điểm người chơi thoát.

### 11. Quản lý dự án và feedback

Cần biết:

- Chia feature lớn thành task nhỏ có acceptance criteria.
- Viết bug report có bước tái hiện, expected và actual result.
- Giữ changelog và decision log.
- Playtest với người không biết nội bộ dự án.
- Quan sát hành vi người chơi thay vì chỉ hỏi họ có thích game hay không.
- Giới hạn scope và bỏ những feature chưa cần thiết.

### 12. IP, asset và quyền sử dụng

Cần hiểu:

- Asset, font, sound và texture có license gì.
- Lưu nguồn và license cùng asset.
- Không sử dụng tên, creature, biểu tượng hoặc visual language của IP khác.
- Không đưa secret, token hoặc credential vào repository.

## Bộ công cụ nên dùng

### Bắt buộc cho dự án

- Roblox Studio — xây, test và publish game.
- Git — quản lý lịch sử source.
- Rojo — đồng bộ source với Roblox Studio.
- VS Code hoặc editor tương đương — chỉnh Luau.
- Luau Language Server — type checking và autocomplete.
- StyLua — format code.
- Selene — lint code.
- Roblox Studio Server & Clients — test nhiều người chơi.

### Nên bổ sung

- Google Sheets hoặc Excel — balance và economy.
- Figma — wireframe và UI design.
- Blockbench hoặc Blender — creature, environment và animation.
- Krita hoặc Aseprite — texture, icon và concept art.
- Audacity hoặc REAPER — chỉnh sửa âm thanh.
- GitHub Issues/Projects, Notion, Linear hoặc Trello — quản lý task; chỉ cần chọn một hệ thống.

## Thứ tự học đề xuất

1. Roblox Studio và workflow Rojo/Git hiện tại.
2. Client/server, testing và debugging.
3. Game design, progression và balance bằng spreadsheet.
4. UI/UX và onboarding.
5. Greybox level design.
6. Một creature hoàn chỉnh với model và animation cơ bản.
7. VFX, SFX và camera cho combat/capture.
8. Performance, persistence và analytics.

## Tiêu chuẩn hoàn thành tối thiểu

Bạn không cần học chuyên sâu khi đã có thể:

- Giải thích feature đó phục vụ mục tiêu nào của người chơi.
- Tạo prototype nhỏ mà không phụ thuộc hoàn toàn vào người khác.
- Biết cách kiểm thử và nhận ra giới hạn của prototype.
- Biết khi nào cần nhờ artist, designer, animator hoặc technical specialist.
- Ghi lại quyết định, nguồn asset và các lỗi quan trọng trong repository.

