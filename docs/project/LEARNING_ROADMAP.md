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

## Tài liệu và kênh học theo từng kỹ năng

Các nguồn tiếng Việt được đặt trước khi có thể. Với Roblox, Luau, bảo mật, persistence và API, hãy ưu tiên tài liệu chính thức vì video cũ có thể dùng menu hoặc API đã thay đổi.

### 1. Thiết kế game và balance

- **[VI] [Kênh Thiết kế Game trên YouTube](https://www.youtube.com/@thietkegame)** — core loop, game mechanic, GDD và nghề game design.
- **[VI] [Website Thiết kế Game](https://thietkegame.com/)** — bài viết nhập môn về game design, product và game development.
- **[EN] [Game Maker's Toolkit](https://gamemakerstoolkit.com/)** — phân tích mechanic, level design, onboarding và accessibility qua ví dụ thực tế.
- **[EN] [GDC YouTube](https://www.youtube.com/channel/UC0JB7TSe49lg56u6qH8y_MQ/videos)** — talk của các nhà thiết kế và studio; chỉ chọn những video nhập môn phù hợp.

**Nên học trước:** tìm các bài về `core loop`, `game mechanic`, `game design document`, `progression` và `game balance`.

### 2. Roblox Studio và workflow phát triển

- **[VI] [Bắt đầu sáng tạo trên Roblox](https://create.roblox.com/docs/vi-vn/get-started/creating)** — tài liệu nhập môn Roblox Studio.
- **[EN] [Roblox Studio](https://create.roblox.com/docs/studio)** — giao diện, xây dựng, scripting, testing và publishing.
- **[EN] [Intro to coding trong Roblox Studio](https://create.roblox.com/docs/tutorials/curriculums/coding)** — Luau và các khái niệm code cơ bản.
- **[EN] [Roblox Studio Tutorials](https://about.roblox.com/newsroom/2016/11/introducing-roblox-studio-tutorials)** — các bài hướng dẫn ngắn theo task như terrain, script và cơ chế đơn giản.
- **[EN] [Luau documentation](https://luau.org/)** — cú pháp và tính năng của Luau.

### 3. Git, GitHub và quản lý source

- **[EN] [Pro Git](https://git-scm.com/book/en/v2)** — đọc các phần Getting Started, Git Basics và Git Branching.
- **[EN] [GitHub Skills](https://skills.github.com/)** — bài thực hành ngắn để học repository, branch, pull request và collaboration.
- **[EN] [GitHub Docs về Issues và Projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects)** — quản lý task, bug và roadmap.

**Bài tập tối thiểu:** tạo branch thử nghiệm, commit một thay đổi nhỏ, xem diff, mở issue và đóng issue sau khi kiểm tra.

### 4. Testing, client/server và bảo mật Roblox

- **[EN] [Studio testing modes](https://create.roblox.com/docs/studio/testing-modes)** — Play Test, Server & Clients và device emulation.
- **[EN] [Security and cheat mitigation tactics](https://create.roblox.com/docs/scripting/security/security-tactics)** — nguyên tắc không tin client và server authority.
- **[EN] [Securing the client-server boundary](https://create.roblox.com/docs/scripting/security/client-server-boundary)** — validate remote, distance check và rate limiting.
- **[EN] [Remote events and callbacks](https://create.roblox.com/docs/scripting/events/remote)** — giao tiếp client-server bằng RemoteEvent và RemoteFunction.

**Nên áp dụng ngay:** với mỗi feature, tự hỏi “client có thể gửi dữ liệu giả nào?” và “server phải kiểm tra điều gì?”.

### 5. UI/UX và onboarding

- **[VI] [Tài liệu Roblox Creator Hub bằng tiếng Việt](https://create.roblox.com/docs/vi-vn/get-started/creating)** — dùng làm điểm bắt đầu cho giao diện Studio và các bài nhập môn.
- **[EN] [UI and UX design cho Roblox](https://create.roblox.com/docs/production/game-design/ui-ux-design)** — flow, consistency, feedback và usability.
- **[EN] [Design for Roblox](https://create.roblox.com/docs/production/game-design/design-for-roblox)** — thiết kế phù hợp với người chơi Roblox và mobile-first.
- **[EN] [Wireframe your layouts](https://d2gbj0c64xar4a.cloudfront.net/docs/tutorials/curriculums/user-interface-design/wireframe-your-layouts)** — bài thực hành wireframe và bố trí UI.
- **[EN] [Figma Design for beginners](https://help.figma.com/hc/en-us/articles/30848209492887-Course-overview-Figma-Design-for-beginners-2025)** — layer, text, auto layout, component và prototype.

### 6. Level design và world building

- **[VI] [Thiết kế Game](https://www.youtube.com/@thietkegame)** — xem các nội dung về trải nghiệm người chơi, mechanic và flow.
- **[EN] [Game Maker's Toolkit](https://gamemakerstoolkit.com/)** — phân tích level, navigation, tutorial, difficulty và cách game dẫn hướng người chơi.
- **[EN] [Design for Roblox](https://create.roblox.com/docs/production/game-design/design-for-roblox)** — cân nhắc thói quen người chơi Roblox và nhiều loại thiết bị.
- **[EN] [Roblox Studio interface và building tools](https://create.roblox.com/docs/studio/ui-overview)** — làm quen các tab Model, Avatar, UI, Plugins và Toolbox.

**Bài tập tối thiểu:** greybox một khu nhỏ trong MythicCubes, sau đó nhờ một người mới đi qua mà không giải thích trước.

### 7. 3D, voxel art và animation

- **[VI] [Học Viện Blender](https://www.youtube.com/@blendervn)** — giao diện, modeling, material, lighting và animation cơ bản.
- **[EN] [Blender Manual — About Blender](https://docs.blender.org/manual/en/dev/getting_started/about/index.html)** — tổng quan pipeline modeling, rigging, animation, texturing và rendering.
- **[VI] [Kale Game — hướng dẫn Aseprite/pixel art](https://www.youtube.com/watch?v=cRMiQ8BlZZg)** — tham khảo cách tạo icon, texture và asset 2D đơn giản.
- **[EN] [Roblox Studio](https://create.roblox.com/docs/studio)** — phần import asset, Model tools và kiểm tra asset trong Studio.

Chỉ nên chọn **Blockbench hoặc Blender** ở giai đoạn đầu. Với creature voxel đơn giản, Blockbench có thể dễ bắt đầu hơn; với rig và animation dài hạn, Blender có nhiều khả năng mở rộng hơn.

### 8. Game feel, VFX và audio

- **[EN] [Roblox Audio documentation](https://create.roblox.com/docs/audio)** — audio object, sound effect, music và Creator Store.
- **[EN] [Roblox Sound documentation](https://create.roblox.com/docs/sound)** — phát audio và dùng dynamic effects trong game.
- **[EN] [Game Maker's Toolkit](https://gamemakerstoolkit.com/)** — tham khảo feedback, camera, animation và cảm giác điều khiển.
- **[EN] [GDC YouTube](https://www.youtube.com/channel/UC0JB7TSe49lg56u6qH8y_MQ/videos)** — tìm các video về `game feel`, `sound design`, `VFX` và `camera`.

Không tải asset từ nguồn không rõ license. Với asset trong Creator Store, luôn kiểm tra xem model có script hay không trước khi đưa vào project.

### 9. Performance, persistence và analytics

- **[EN] [Performance optimization](https://create.roblox.com/docs/performance-optimization/identify)** — memory, script performance, network simulation và các công cụ profiling.
- **[EN] [MicroProfiler](https://create.roblox.com/docs/performance-optimization/microprofiler)** — tìm frame time spike và bottleneck.
- **[EN] [Data stores](https://create.roblox.com/docs/cloud-services/data-stores)** — lưu inventory, progression và dữ liệu giữa các session.
- **[EN] [Analytics dashboard](https://create.roblox.com/docs/production/analytics/analytics-dashboard)** — retention, engagement, acquisition, feedback và monetization metrics.
- **[EN] [Get started with analytics](https://create.roblox.com/docs/production/analytics/get-started)** — dùng metric để đặt câu hỏi và cải thiện game.

Đây là nhóm học sau khi core loop đã chơi được. Không nên bắt đầu bằng analytics hoặc monetization khi chưa có người chơi thử.

### 10. IP, asset license và vận hành dự án

- **[EN] [Roblox Community Standards](https://en.help.roblox.com/hc/en-us/articles/203313410-Roblox-Community-Standards)** — nội dung và hành vi cần tuân thủ trên Roblox.
- **[EN] [Third-party asset vulnerabilities](https://create.roblox.com/docs/scripting/security/third-party-vulnerabilities)** — rủi ro backdoor trong model và asset bên ngoài.
- **[EN] [GitHub Docs](https://docs.github.com/en)** — tài liệu repository, issue, project và collaboration.

## Cách sử dụng tài liệu và video

- Chọn **một nguồn chính** cho mỗi kỹ năng, không xem cùng lúc quá nhiều playlist.
- Sau mỗi bài, tạo một sản phẩm nhỏ trong project hoặc một sandbox riêng.
- Nếu video khác với giao diện hiện tại, kiểm tra lại Creator Hub hoặc manual chính thức.
- Không copy nguyên hệ thống từ tutorial vào MythicCubes; hãy viết lại theo architecture và naming convention của repo.
- Ghi lại link hữu ích, ghi chú và kết quả bài tập trong issue hoặc decision log.

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
