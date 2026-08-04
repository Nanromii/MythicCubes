# Rarity, đá trang bị, đội hình và lực chiến

> **Trạng thái:** product direction được người dùng bổ sung ngày 2026-08-04. Công thức và tên hiển thị dưới đây là **DRAFT/TUNABLE** cho balance review. Chưa được triển khai trong source hiện tại.

Inventory, stone board, formation, rarity treatment và combat team HUD phải dùng design system/accessibility rule trong [Định hướng hình ảnh, giao diện và âm thanh](VISUAL_AUDIO_UI_DIRECTION.md); mỗi phase gameplay chịu trách nhiệm cho presentation của feature tương ứng.

## Ranh giới thuật ngữ

- **Creature rarity:** độ hiếm/chất lượng cố định của species/evolution line definition, từ Trắng tới Đỏ; không roll lại theo từng lần bắt và không có hai cá thể cùng loài nhưng khác creature rarity.
- **Evolution stage:** bậc phát triển 1–3 theo level; không phải rarity.
- **Elite:** biến thể combat không capture được của một loài trong world; không phải rarity mới.
- **Legendary wild:** creature rarity Đỏ được spawn độc quyền ở world cho phép; không phải World Boss.
- **Stone rarity:** chất lượng của một viên đá; dùng cùng thang màu nhưng độc lập creature rarity.
- **Slot affinity:** một ô trong bảng 3×3 chỉ nhận đá Máu hoặc Damage.
- **Main lineup:** ba thú cùng player tham chiến.
- **Support lineup:** sáu thú chỉ kích hoạt resonance, không xuất hiện hoặc tham chiến.
- **Team Power:** chỉ số ước lượng từ stat sheet; không phải dự đoán chắc chắn thắng/thua.

## Sáu bậc rarity

| Internal ID | Màu hiển thị | Tên DRAFT | Định hướng sức mạnh của loài | Skill-roll direction |
| --- | --- | --- | --- | --- |
| `common` | Trắng | Phổ Thông | Loài nền, dễ tiếp cận và chỉ số tổng thể thấp hơn | Pool cơ bản, thiên về effect đơn giản |
| `uncommon` | Xanh lá | Cải Tiến | Loài nhỉnh hơn nhóm nền hoặc có một điểm mạnh rõ | Có thêm candidate chuyên biệt |
| `rare` | Xanh dương | Hiếm | Loài mạnh/cân bằng hơn cho đội hình giữa game | Candidate tốt xuất hiện thường hơn |
| `epic` | Tím | Sử Thi | Loài có chỉ số hoặc vai trò nổi bật | Pool mạnh hơn nhưng vẫn đúng hệ/vai trò |
| `mythic` | Vàng | Thần Thoại | Loài mạnh hiếm, có identity/build ceiling cao | Candidate hiếm và tổ hợp mạnh hơn |
| `legendary` | Đỏ | Huyền Thoại | Loài đỉnh của content tier cho phép | Pool đặc trưng và legendary capture policy |

Rarity thuộc về **loài**, không thuộc về lần bắt. Mỗi `creatureId`/evolution line chỉ khai báo đúng một creature rarity; nhiều loài khác nhau có thể cùng rarity. Bắt mười cá thể cùng loài vẫn cho mười cá thể cùng rarity. Những cá thể đó chỉ khác nhau ở stone affinity/unlock order, level/XP, skill đã roll và các progression field được thiết kế cho instance.

Không dùng công thức kiểu `baseStat × rarityMultiplier`. Mỗi loài/evolution stage/role có canonical base stats được author trực tiếp và balance như một bộ hoàn chỉnh. Rarity chỉ đặt kỳ vọng về power band/content tier: loài rarity cao nhìn chung được phép có tổng stat, phân bố stat hoặc skill ceiling mạnh hơn, nhưng không tự động nhân mọi chỉ số theo cùng một tỷ lệ. Cách này cho phép hai loài cùng rarity có vai trò khác nhau và một loài rarity thấp vẫn có niche hữu ích.

Skill candidate lấy từ pool/policy của loài, hệ, evolution stage và rarity cố định của loài; roll skill không thể thay đổi rarity. Species capture difficulty là field riêng để tune từng loài. Red/Legendary species đồng thời dùng legendary classification cho capture. Starter của năm hệ dùng cùng rarity khởi đầu DRAFT là `rare` để lựa chọn công bằng.

## Bảng đá 3×3

Mỗi owned creature có đúng chín cell theo bố cục:

```text
[1] [2] [3]
[4] [5] [6]
[7] [8] [9]
```

Có ba hàng ngang và ba cột dọc, nên khi đủ chín ô có tối đa sáu line bonus cùng hoạt động. Đường chéo không tạo bonus.

### Affinity được quyết định khi nhận creature

- Khi starter/capture/legitimate grant tạo owned creature, server roll độc lập mỗi cell là `Health` hoặc `Damage` với xác suất DRAFT 50/50.
- Cả chín affinity và unlock order được ghi vĩnh viễn vào creature instance; reconnect/evolution không reroll.
- Player nhìn thấy toàn bộ affinity ngay cả khi cell đang khóa để đánh giá tiềm năng cá thể.
- Không ép tối thiểu Health/Damage: layout 9–0 hoặc 0–9 có thể tồn tại nhưng cực hiếm. Điều này tạo lý do bắt duplicate để tìm layout phù hợp build.
- Client không gửi seed, affinity, unlock target hoặc kết quả random.

### Mở slot theo level

DRAFT chọn một slot mở ở level 1 và thêm một slot tại mỗi mốc:

| Slot thứ | Level mở |
| ---: | ---: |
| 1 | 1 |
| 2 | 10 |
| 3 | 20 |
| 4 | 30 |
| 5 | 40 |
| 6 | 50 |
| 7 | 60 |
| 8 | 70 |
| 9 | 80 |

Mỗi mốc mở cell tiếp theo từ `unlockOrder` ngẫu nhiên đã khóa lúc tạo instance. Level-up nhảy qua nhiều mốc phải mở tuần tự tất cả mốc bị vượt, đúng một lần. Từ level 80–100 player có thời gian hoàn thiện build đủ chín ô.

Đá chỉ lắp/tháo tại Nhà Riêng. Tháo đá không phá đá; phí thao tác nếu có vẫn **TBD**, không tự thêm monetization.

## Hai loại đá chính

### Đá Máu

Primary stat là flat hoặc percentage maximum HP. Secondary affix hợp lệ có thể gồm:

- Armor flat hoặc percentage.
- Move speed.
- Healing received/healing effectiveness.
- Regeneration đến từ skill/effect hợp lệ.
- Resistance với debuff hoặc damage type khi hệ thống tương ứng tồn tại.

### Đá Damage

Primary stat là flat hoặc percentage attack/damage budget. Secondary affix hợp lệ có thể gồm:

- Critical chance.
- Critical damage.
- Life steal.
- Basic attack speed.
- Armor penetration hoặc effect potency khi runtime hỗ trợ.

Affix pool, range, incompatibility và cap phải data-driven. Không cho stone tự tạo stat mà combat runtime chưa hỗ trợ.

## Rarity của đá

Đá dùng sáu màu giống creature nhưng là catalog riêng:

| Rarity | Primary roll | Secondary affix DRAFT | Nguồn chính |
| --- | --- | ---: | --- |
| Trắng | Thấp | 0 | World đầu, crafting cơ bản |
| Xanh lá | Thấp–vừa | 1 | Wild thường |
| Xanh dương | Vừa | 1–2 | Wild mạnh/quest |
| Tím | Cao | 2 | Elite, boss, crafting cao |
| Vàng | Rất cao | 2–3 | Elite hiếm, World Boss, event |
| Đỏ | Cực cao có cap | 3 và có thể có unique modifier | World cao/event; cực hiếm |

World/elite mạnh hơn nâng quality table và roll range, không bảo đảm drop mạnh. Rarity cao hơn cho stat budget cao hơn nhưng mọi roll vẫn trong min/max đã validation.

## Sáu line bonus

Một hàng/cột chỉ active khi cả ba cell đã mở và đều được lắp đúng affinity. Bonus dựa trên composition affinity, cộng dồn additive rồi chịu global cap:

| Composition | Tên DRAFT | Bonus mỗi line DRAFT |
| --- | --- | --- |
| 3 Health | Thành Lũy | `+4% Max HP`, `+3% Armor` |
| 2 Health + 1 Damage | Bền Bỉ | `+2% Max HP`, `+2% Healing/Life-steal effectiveness` |
| 1 Health + 2 Damage | Sắc Bén | `+2% Attack`, `+2% Critical Chance` |
| 3 Damage | Cuồng Kích | `+4% Attack`, `+6% Critical Damage` |

Nếu đủ cả 3 hàng và 3 cột, creature nhận sáu bonus. Center cell tham gia một hàng và một cột như quy tắc 3×3 bình thường. UI phải hiển thị line nào đang active và stat nào đã chạm cap.

## Skill-modifier stone

Skill modifier là affix cực hiếm trên một viên đá Health/Damage, không phải slot thứ mười. Hướng effect:

- Cooldown reduction có floor toàn build.
- Area/range expansion có geometry cap.
- Double cast nhưng cooldown cuối tăng 50%.
- Buff/debuff/effect duration extension có cap.

Một skill chỉ nhận tối đa một modifier cùng loại và unique modifier không stack. Modifier tham chiếu effect tag/capability, không hard-code tên skill hoặc creature trong service. Nếu skill không tương thích, server từ chối equip mà không phá item.

## Đội hình 3 chính + 6 phụ

### Main lineup

- Đúng tối đa ba creature cùng follow và tham chiến ngoài world.
- Cả ba giữ HP xuyên suốt expedition.
- Mỗi creature có target/cooldown/skill state riêng.
- Khi cả ba bị hạ, player về Nhà Riêng.

### Support lineup

- Có sáu vị trí creature.
- Không spawn, không đánh, không nhận XP hoặc loot participation.
- Chỉ cung cấp membership để kích hoạt resonance catalog.
- Một instance không thể đồng thời nằm ở hai slot.

Main/support lineup, skill, stone và statue-buff snapshot bị khóa khi khởi hành từ cổng Làng; loadout chỉ được chỉnh tại Nhà Riêng.

## Cộng hưởng cố định

Resonance là catalog tổ hợp creature ID cố định, được authoring từ đầu và validation. Một resonance active khi tất cả thành viên yêu cầu xuất hiện trong chín slot main+support. Chỉ ba creature đang ở main nhận combat stat; support chỉ là điều kiện kích hoạt.

Buff phải thể hiện hệ/identity của tổ hợp. Preset hướng thiết kế:

| Hệ/trọng tâm | Stat đặc trưng được ưu tiên |
| --- | --- |
| Thường | HP/Attack/Defense cân bằng, basic damage ổn định |
| Lửa | Attack, critical damage, burn potency |
| Nước | Max HP, armor, healing và slow duration |
| Tự nhiên | Armor, healing-over-time, poison/debuff potency |
| Gió | Move speed, basic attack speed và cooldown cadence có cap |

Ví dụ catalog DRAFT:

```text
resonance_id = ember_chorus
required_creature_ids = [fire_creature_a, fire_creature_b, wind_creature_c]
beneficiaries = required members currently in main lineup
effects = [+Fire Attack%, +Burn Duration%, small Wind Attack Speed%]
```

Không tự cộng hưởng chỉ vì có ba creature cùng element; phải khớp entry cụ thể trong catalog. Một creature có thể tham gia nhiều resonance nhưng effect cùng stat cộng additive và chịu cap. UI Nhà Riêng phải preview resonance và statue buff được bật/tắt trước khi khóa expedition.

## Duplicate cùng loài

Mỗi captured instance độc lập về level, XP, stone layout, unlock order và skill. NPC Nhà Đồng Vọng cho hai lựa chọn, đều tiêu donor cùng loài:

### Truyền XP

- Chọn receiver và donor có cùng `creatureId`.
- Donor bị tiêu vĩnh viễn sau confirm rõ ràng.
- Receiver nhận DRAFT `20%` lifetime combat XP hợp lệ của donor cộng một base XP nhỏ do species/evolution definition quy định; rarity của donor không thể khác receiver vì hai cá thể bắt buộc cùng loài.
- XP donor từng nhận từ duplicate transfer không được tái quy đổi, tránh vòng lặp feed vô hạn.
- Không truyền stone hoặc skill; stone đang lắp phải được tháo về inventory trước khi consume.
- Không cho receiver vượt level 100; XP thừa xử lý theo cap policy.

### Roll skill bằng duplicate

- Một duplicate cùng loài là nguyên liệu bắt buộc cho mỗi skill-roll transaction.
- Có thể cần thêm world material/catalyst theo skill tier.
- Server tạo candidate đúng species skill pool, element, evolution stage, rarity cố định và không duplicate skill hiện có.
- Khi đã có ba skill, player chọn skill thay sau khi xem candidate; không tự ghi đè.
- Request invalid không tiêu donor/material. Commit hợp lệ tiêu đúng một donor và vật liệu dù kết quả candidate không như ý; retry idempotent không tiêu hai lần.

Tỷ lệ XP 20%, candidate count, pity và material quantity đều TUNABLE nhưng nguyên tắc same-species duplicate là yêu cầu sản phẩm.

## Team Power

### Mục đích và giới hạn

Team Power giúp player so sánh stat sheet, đọc recommended power của world/boss và phát hiện đội chưa được nâng. Nó **không** dự đoán chắc chắn đội nào thắng. Skill synergy, element counter, target priority, AoE, crowd control, healing timing, player execution và encounter geometry không được quy đổi hoàn toàn.

Thiết kế này phù hợp với hướng dẫn chính thức của RAID: Champion Power dùng HP/Attack/Defense/Speed/Crit và Team Power là tổng power cá thể, nhưng synergy/counter-pick vẫn chính xác hơn để đánh giá khả năng thắng. Blizzard cũng tách base stats, magic attributes và skill-modifying legendary properties, củng cố việc không ép mọi build effect vào một con số duy nhất.

Tham khảo nguyên lý, không sao chép content/IP:

- [RAID: Champion and Team Power](https://raid-support.plarium.com/hc/en-us/articles/360020897500-Champion-and-Team-Power)
- [Blizzard: Itemization in Diablo Immortal](https://news.blizzard.com/en-us/article/23574266/itemization-in-diablo-immortal)

### Công thức DRAFT

Tính trên maximum stat sheet tại Nhà Riêng, không dùng current HP:

```text
EffectiveHP = MaxHP * (1 + Armor / ArmorReference)

BasicDPS = Attack
         * BasicAttacksPerSecond
         * (1 + CritChance * (CritDamageMultiplier - 1))

MobilityFactor = clamp(
    1 + 0.15 * (MoveSpeed / ReferenceMoveSpeed - 1),
    0.95,
    1.10
)

CreaturePower = round(
    PowerScale
    * sqrt(EffectiveHP / ReferenceEffectiveHP)
    * sqrt(BasicDPS / ReferenceBasicDPS)
    * MobilityFactor
)

TeamPower = sum(CreaturePower of the 3 main creatures)
```

`ArmorReference`, reference stats và `PowerScale` đến từ versioned balance definition. Level, evolution, stones, active line bonuses, resonance và tượng active cùng hệ đã đi vào final stats. Creature rarity không tạo multiplier riêng; base stats đã được author trực tiếp theo species/evolution/role. Support creature không cộng power trực tiếp; resonance mà chúng kích hoạt chỉ làm thay đổi stats của main.

Không tính trực tiếp vào Team Power:

- Skill damage coefficient/AoE/target count.
- Heal, shield, buff/debuff synergy.
- Element advantage và counter.
- Skill modifier như double cast hoặc area expansion.
- Player execution và AI target quality.

UI phải ghi “Lực chiến ước lượng”, hiển thị recommended range thay vì khóa content cứng, và cảnh báo đội power thấp vẫn có thể thắng nhờ build/counter.

## Server authority và transaction

- Server đọc creature rarity cố định từ species/evolution definition; server chỉ tạo các instance roll được phép như stone affinity, unlock order, affix, duplicate result, resonance snapshot và Team Power canonical.
- Client chỉ gửi equip/lineup/roll intent bằng instance ID; không gửi stat total, power hoặc RNG result.
- Equip/unequip, consume duplicate, skill roll và reward grant đều idempotent.
- Một stone/creature instance không thể ở hai slot hoặc hai transaction cùng lúc.
- Profile migration phải giữ layout, unlock order và affix; không reroll silently khi schema đổi.
- Team Power được recompute từ canonical stats, không lưu client-provided total.
- Statue buff được resolve từ Nhà Riêng của owner và element canonical; guest không đóng góp buff. Chi tiết ở [Nhà Riêng, trưng bày, tượng và Khu Tập Luyện](PRIVATE_HOME_HOUSING.md).

## Test plan

- Mỗi species/evolution line chỉ có một rarity canonical; capture duplicate không roll hoặc đổi rarity; nhiều species được phép dùng cùng rarity.
- Base stats được resolve trực tiếp từ species/evolution/role definition, không áp dụng rarity multiplier; skill candidate tuân theo species pool và rarity policy cố định.
- Chín affinity + unlock order ổn định qua reconnect; mốc 1/10/…/80 mở đúng một random cell chưa mở.
- Level jump mở đủ các mốc, không duplicate.
- Health stone không vào Damage slot và ngược lại.
- Sáu hàng/cột active đúng composition; đường chéo không active; cap áp dụng đúng.
- Unique skill modifier không stack và incompatible skill bị từ chối không mất item.
- Support không spawn/nhận XP/cộng power trực tiếp; resonance chỉ active khi đủ exact creature IDs.
- Loadout chỉ đổi tại Nhà Riêng và không đổi trong expedition.
- Duplicate transfer chỉ 20% combat-earned XP, không tái chế transferred XP; donor/stone được xử lý an toàn.
- Skill roll bắt buộc duplicate cùng loài, invalid không consume, retry không consume hai lần.
- Team Power tăng khi canonical base stat tăng, không đổi theo current HP và không áp dụng thêm rarity multiplier.
- Hai đội cùng Team Power có thể khác matchup; UI/test không dùng power làm điều kiện chắc thắng.
