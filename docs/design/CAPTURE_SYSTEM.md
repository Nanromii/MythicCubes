# Thiết kế encounter theo cụm và hệ thống bắt sinh vật

> **Trạng thái:** product direction được người dùng bổ sung ngày 2026-08-04; chưa triển khai trong source. Mọi con số cân bằng vẫn là **DRAFT/TUNABLE**, không phải dữ liệu production.

Camera gameplay dùng góc nhìn 3D high-angle/3/4 readable action-adventure, có thể xoay ở mức hợp lý; không phải flat top-down cố định. Capture bằng bóng là cơ chế thu phục chính. Cooking chỉ là hỗ trợ như lure, prep, buff cơ hội tiếp cận hoặc ảnh hưởng hành vi cụm thú; không thay thế loop capture. Target highlight, thao tác hold–drag–release, animation, VFX và SFX của capture được đóng gói ở Phase 12 theo [Định hướng hình ảnh, giao diện và âm thanh](VISUAL_AUDIO_UI_DIRECTION.md).

## Phạm vi và tương thích với implementation hiện có

Game đích mở rộng vertical slice Phase 4 bằng:

- Một encounter do server sở hữu có thể chứa nhiều sinh vật hợp lệ từ cùng spawn cluster và ba companion chính.
- Người chơi giữ nút ném bóng, chọn đúng một thành viên còn hợp lệ trong encounter rồi thả nút để gửi ý định bắt.

Implementation hiện tại vẫn là 1v1: cluster chỉ quyết định số cá thể và vị trí spawn; `WildCreatureRecord` chưa có `spawnGroupId`; `EncounterRecord`, snapshot và UI chỉ giữ một `wildId`; wild chưa có level, rarity, evolution stage, species capture difficulty hoặc legendary classification; bốn thiết bị hiện tại dùng công thức `baseChance + missingHealthBonus`, từ chối full HP và luôn bị tiêu thụ sau một lần ném hợp lệ, kể cả thất bại. Vertical slice dùng thứ tự `Bóng xanh lá`, `Bóng xanh dương`, `Bóng tím`, `Bóng đỏ`, trong đó Bóng đỏ là special; game đích thay đổi eligibility full HP nhưng tài liệu không giả vờ source đã migration.

Sau khi thiết kế được duyệt, implementation phải migration theo từng bước nhỏ, giữ server authority, regression Phase 2–4 và dữ liệu session hiện có. Capture formula hiện tại vẫn giữ nguyên; tier và special flag chỉ là metadata/registry để định danh bốn entry.

## Thuật ngữ không được dùng lẫn

| Thuật ngữ | Ý nghĩa |
| --- | --- |
| `spawnGroupId` / spawn cluster | Nhóm cá thể được tạo cùng một lần spawn; không phải encounter và không tự trao quyền sở hữu cho player. |
| Encounter | Tập sinh vật server đã khóa vào một combat context. Một encounter có thể có nhiều player participant và nhiều wild từ cùng spawn cluster. |
| Companion target | Đúng một sinh vật mà một trong ba thú chính đang tiếp cận/đánh; mỗi companion có target riêng. |
| Capture target | Đúng một sinh vật người chơi chọn để ném bóng; không bắt buộc trùng companion target. |
| Evolution stage/tier | Bậc phát triển 1–3 của sinh vật. Với evolution line thông thường, stage được suy ra từ level theo mốc 1–17, 18–53 và 54–100. |
| Species capture difficulty/rate | Độ khó bắt riêng của loài, biểu diễn bằng dữ liệu cân bằng; không phải evolution stage. |
| Legendary classification | Phân loại `Normal` hoặc `Legendary`, độc lập với evolution stage và species difficulty. |
| Elite/World Boss | Classification không capture được; bị từ chối trước inventory/roll và không dùng lẫn Legendary. |
| Creature rarity | Một trong sáu bậc Trắng→Đỏ được cố định bởi species/evolution line; cùng loài không roll rarity khác nhau. Rarity định hướng power/skill tier và có capture modifier riêng, không phải evolution stage. |
| Ball tier | Cấp của thiết bị bắt; không phải skill tier hoặc evolution tier. |

## Encounter gồm nhiều sinh vật

### Tạo và khóa membership ở server

Mỗi lần tạo cluster, server cấp một `spawnGroupId` ổn định cho các thành viên của lần spawn đó. Khi một wild trong cluster kích hoạt aggro/engagement, server thực hiện một đoạn claim không yield:

1. Xác định wild kích hoạt và đọc `spawnGroupId` từ record server.
2. Lấy tất cả thành viên cùng cluster theo thứ tự ổn định.
3. Lọc từng thành viên theo state còn sống, khoảng cách, region/zone, owner proximity và assist range data-driven.
4. Loại thành viên đang `Returning`, `Defeated`, `Despawned` hoặc không còn record hợp lệ.
5. Claim toàn bộ tập còn lại vào cùng `encounterId` và thêm player vào participant set; client không có remote khai báo membership.
6. Tạo `EncounterRecord.wildIds` từ đúng kết quả claim và replicate snapshot cho participant.

Membership là snapshot tại thời điểm claim. Wild spawn/respawn muộn không tự chen vào encounter đang chạy. Encounter là shared cho các user hợp lệ: player khác có thể join và cùng combat vào cùng wild nếu server xác nhận khoảng cách, state và participant hợp lệ. Cụm không bị private chỉ vì một user đang engage; một wild chỉ được thuộc tối đa một `encounterId`, nhưng `encounterId` đó có thể có nhiều player participant.

Claim và mutation membership phải nằm trong coordinator server, không yield giữa kiểm tra và ghi state. Thứ tự `spawnGroupId`, khoảng cách rồi `wildId` giúp kết quả deterministic khi nhiều player đi vào cluster gần như đồng thời; player đến sau join encounter hợp lệ thay vì tạo ownership client-side.

### Hành vi chiến đấu

- Tất cả wild đang hợp lệ trong encounter đều có thể di chuyển tới một trong ba companion sống và dùng cooldown tấn công riêng.
- Mỗi companion chỉ có một `activeTargetWildId`; cả đội có thể chia target hoặc focus cùng một wild theo coordinator server.
- Health/cooldown/position/AI state của từng wild vẫn do server sở hữu. Client chỉ render danh sách đã replicate.
- Damage, target hợp lệ và thời điểm tấn công không được suy ra từ highlight hoặc projectile phía client.
- Wild chết do combat được loại khỏi membership, đi qua lifecycle defeat/despawn và respawn theo zone. Encounter tiếp tục nếu còn thành viên.

### Chọn và chuyển target cho ba companion

Quy tắc DRAFT đề xuất để thảo luận:

1. Giữ target hiện tại khi nó còn sống, vẫn thuộc encounter, ở state `Engaging` và chưa vượt boundary riêng.
2. Lúc bắt đầu, phân phối companion lần lượt vào wild gần nhất có ít companion đang target nhất; nếu ít wild hơn companion, companion dư focus wild có HP ratio thấp nhất.
3. Khi cần chuyển target, ưu tiên wild có ít attacker nhất; nếu bằng nhau chọn HP ratio thấp hơn, rồi khoảng cách, rồi `wildId`.
4. Chuyển target khi target chết, bị bắt, despawn, bắt đầu return hoặc bị loại khỏi encounter.
5. Nếu không còn target hợp lệ, kết thúc encounter và cho companion còn sống trở lại owner.

Đây là rule DRAFT/TUNABLE để tránh cả ba companion overkill một target trong khi wild khác tấn công tự do. Server luôn quyết định target cuối cùng; command focus-fire chủ động có thể được bổ sung sau.

### Disengage, leash và return theo nhóm

- Owner chết/rời server, không còn companion sống, hoặc owner vượt `disengageRange` so với đội/encounter trong điều kiện server định nghĩa sẽ gỡ participant đó khỏi encounter. Encounter chỉ kết thúc toàn bộ khi không còn participant hợp lệ.
- Khi participant rời encounter, server bỏ claim của participant đó; wild chỉ chuyển `Returning` khi không còn participant nào. Companion còn sống lập tức quay về follow owner.
- `leashRange` vẫn được đánh giá cho từng wild so với spawn position của chính nó. Một wild vượt leash bị loại và return; các thành viên còn lại có thể tiếp tục.
- Capture/death/despawn của một thành viên không tự reset HP, cooldown hoặc ownership của thành viên khác.
- Một companion bị hạ giữ trạng thái bị hạ tới khi expedition kết thúc và player về Làng Mạch Nguồn hoặc Nhà Riêng; encounter tiếp tục nếu companion khác còn sống. Wipe đủ ba đưa player về Nhà Riêng.
- Nếu membership trở thành rỗng, encounter kết thúc đúng một lần.
- Game đích hồi đầy HP toàn đội khi player trở về một trong hai safe zone: Làng Mạch Nguồn hoặc Nhà Riêng. Disengage/return wild trong cùng expedition không hồi companion.

## Chọn mục tiêu để ném bóng

### UX DRAFT

1. Player giữ nút **Ném bóng** của loại bóng đã chọn.
2. Client mở target overlay từ danh sách `captureEligibleWildIds` trong snapshot server gần nhất và đánh dấu các model tương ứng; elite/World Boss không xuất hiện trong danh sách.
3. Player kéo chuột/ngón tay/stick theo hướng một wild; client raycast/project screen để chọn highlight cục bộ.
4. Khi thả nút, client gửi đúng một intent `{ requestId, encounterId, targetWildId, ballId }`.
5. Sau khi server chấp nhận request gameplay, client trình diễn một quả bóng 3D bay tới model của `targetWildId` theo presentation event/metadata do server phát.

Projectile 3D không có hitbox gameplay, không tự trừ inventory và không quyết định capture. Server có thể đã quyết định kết quả trước khi animation hoàn tất; presentation chỉ phát lại kết quả đã xác nhận và phải chịu được model biến mất giữa animation.

Client không gửi position, HP, level, evolution stage, species modifier, legendary flag, chance, cap, random roll hoặc kết quả. `targetWildId` là intent chưa đáng tin và phải được server đối chiếu lại với membership canonical.

### Target thay đổi trong lúc đang giữ nút

- Snapshot mới loại target khỏi `captureEligibleWildIds`: client bỏ highlight ngay. Nếu còn target khác, chế độ chọn tiếp tục; nếu hết target, client hủy chế độ giữ và hiển thị lý do trung tính.
- Target chết, bị player khác bắt, despawn, return hoặc encounter disengage: xử lý như target không hợp lệ; không tự chuyển sang wild khác khi player thả nút.
- Nếu race xảy ra sau snapshot nhưng trước khi request tới server, server trả `TARGET_INVALID`/`ENCOUNTER_NOT_FOUND`; không roll, không tiêu bóng và không phát thưởng.
- Nếu model chỉ tạm mất phía client nhưng server target còn hợp lệ, client hủy thao tác trình bày; không đoán position hoặc gửi target khác.
- Mỗi lần thả tạo request ID mới. Giữ nút không gửi remote liên tục, nên không tạo traffic theo frame.

### Thứ tự validation ở server

Với request mới chưa có trong idempotency ledger, server kiểm tra theo thứ tự:

1. Exact payload, type/length của ID và không có field lạ.
2. Request ID chưa bị dùng cho intent khác; retry cùng fingerprint trả cached result.
3. Rate limit theo player và theo action.
4. Encounter tồn tại, owner đúng player và `targetWildId` thuộc membership server.
5. Target còn sống, `Engaging`, chưa reserved/captured/defeated và player là participant của đúng `encounterId`.
6. Khoảng cách server quan sát giữa player và target; không dùng position client.
7. Ball definition tồn tại, inventory đủ, target không phải Elite/World Boss và ball cho phép rarity/classification của target.
8. Đọc HP/level/evolution/rarity/species difficulty canonical; full HP vẫn hợp lệ.
9. Tạo capture lock atomic trên đúng `targetWildId` khi server chấp nhận attempt hợp lệ; không lock cả cluster.
10. Tính chance, clamp và random roll hoàn toàn trên server.
11. Nếu capture fail, unlock target ngay sau transaction để mọi user hợp lệ có thể tiếp tục attempt.
12. Nếu capture success, target bị thu phục và không còn cho user khác bắt; commit transaction idempotent rồi mới phát presentation/result snapshot.

Request ID được dùng lại với payload khác phải trả `REQUEST_ID_CONFLICT`, không trả cached success của intent cũ.
Nếu nhiều player cùng ném bóng vào một target, request hợp lệ đầu tiên khóa target trên server. Request khác gặp lock phải trả `TARGET_CAPTURE_LOCKED`, không roll và không tiêu bóng. Nếu request đầu roll thất bại, target được unlock ngay sau transaction để request hợp lệ sau có thể thử lại.

### Capture, participation và item drop

- `capture success reward`: creature được cấp cho đúng user có capture attempt thành công; target sau đó không còn cho user khác bắt.
- `combat participation/contribution`: việc nhiều user cùng đánh một shared encounter là một loại credit riêng; cách tính XP hoặc reward participation chưa được quyết định và là `TBD`.
- `kill reward / item drop`: nếu wild chết trước khi được bắt và có item drop, item thuộc về user gây đòn kết liễu cuối cùng (`last-hit final blow`). Không suy ra ownership item drop từ capture attempt hoặc participation chung.

## HP và khả năng capture

- Full-HP normal/legendary target **được phép thử bắt**; không còn ngưỡng HP eligibility. Chance tại 100% HP phải thấp hơn rõ rệt so với cùng target đã mất HP.
- Công thức luôn dùng `healthRatio = currentHealth / maximumHealth`; HP càng thấp thì health factor càng lớn khi các yếu tố khác giống nhau.
- “Làm yếu” là chiến thuật tăng chance, không phải điều kiện bắt buộc.
- Special/Legendary Ball cũng chịu health curve; lợi thế nằm ở base chance, penalty policy và cap.
- Elite và World Boss không capture được ở bất kỳ HP nào.
- `currentHealth` và `maximumHealth` được đọc từ wild record server ở đúng thời điểm transaction.

## Mô hình dữ liệu DRAFT

Không hard-code tên creature hoặc tên bóng trong service. Definition/registry và validator cần chứa tối thiểu:

```text
WildCreatureRecord
  spawnGroupId, level, evolutionStage, rarity

CreatureDefinition.captureProfile
  classification = Normal | Legendary | Elite | WorldBoss
  speciesCaptureMultiplier, rarityCaptureMultiplier

CaptureBallDefinition
  id, displayName, baseChance, captureRange
  allowedClassifications
  healthCurveByClassification
  levelPenaltyPolicy, evolutionPenaltyPolicy
  classificationMultiplier
  floorByClassification, capByClassification
  normalCapsByEvolutionStage, normalCapsByLevelBand
  startingQuantity (prototype only)

EncounterRecord
  id, ownerUserId, wildIds, companionTargetWildIds
  perWildAttackCooldowns
```

`evolutionStage` là state đã được server resolve từ level/evolution definition khi spawn; không suy ra từ tên model. `speciesCaptureMultiplier` mô tả độ khó riêng của loài. `rarity` là bậc cố định đọc từ species/evolution line definition, không được roll khi spawn hoặc capture. `classification` mô tả normal/legendary/elite/world boss. Các trường được validation độc lập.

Nguồn bóng đã chốt theo hướng quest, login, event hoặc crafting bằng vật liệu wild/boss. Giá bán bằng tiền trong game, recipe và quantity vẫn cần economy table; không tự quyết định Robux.

## Công thức xác suất DRAFT/TUNABLE

### Pseudocode và thứ tự

```text
function resolveCapture(serverContext, ball, target): CaptureResult
    assert target belongs to serverContext.encounter owned by player
    assert target is alive, capturable and inside server-observed range

    classification = target.captureProfile.classification
    if classification not in ball.allowedClassifications then
        return REJECTED_BALL_NOT_ALLOWED

    chance = ball.baseChance

    healthRatio = clamp(target.currentHealth / max(1, target.maximumHealth), 0, 1)
    missingHealthRatio = 1 - healthRatio
    chance *= evaluateHealthCurve(ball, classification, missingHealthRatio)

    levelFactor = evaluateLevelPolicy(ball, classification, target.level)
    evolutionFactor = evaluateEvolutionPolicy(ball, classification, target.evolutionStage)
    speciesFactor = evaluateSpeciesPolicy(ball, classification,
        target.captureProfile.speciesCaptureMultiplier)
    rarityFactor = evaluateRarityPolicy(ball, target.captureProfile.rarity)
    chance *= levelFactor * evolutionFactor * speciesFactor * rarityFactor

    chance *= ball.classificationMultiplier[classification]

    floor = ball.floorByClassification[classification]
    cap = resolveCap(ball, classification, target.level, target.evolutionStage)
    chance = clamp(chance, floor, cap)

    roll = serverRandom.NextNumber()
    return roll < chance
end
```

`resolveCap` dùng cap classification trước. Với normal target, cap cuối là giá trị nhỏ nhất giữa cap chung, cap theo level band và cap theo evolution stage. Vì vậy HP rất thấp không thể giúp bóng cấp thấp vượt cap của tổ hợp target. Legendary dùng cap riêng của Tier 3 hoặc Special Ball.

### Hệ số target DRAFT/TUNABLE

Áp dụng cho Ball Tier 1–3 và cho legendary target của Special Ball:

```text
healthFactor = 0.15 + 1.40 * (missingHealthRatio ^ 0.80)
levelFactor = 1 / (1 + 0.01 * max(0, level - 1))
evolutionFactor = { stage1 = 1.00, stage2 = 0.80, stage3 = 0.62 }
speciesCaptureMultiplier = { easy = 1.15, standard = 1.00, hard = 0.80, veryHard = 0.60 }
rarityCaptureMultiplier = {
    common = 1.15, uncommon = 1.08, rare = 1.00,
    epic = 0.85, mythic = 0.70, legendary = 0.55
}
```

Các nhãn `easy/standard/hard/veryHard` chỉ là preset authoring; runtime dùng multiplier đã validation. Level/stage/rarity cao hơn hoặc species khó hơn không thể tự làm chance tăng. Rarity và species difficulty vẫn là hai field độc lập ở cấp definition: nhiều loài cùng rarity có thể có độ khó bắt khác nhau, nhưng mọi cá thể cùng loài vẫn dùng cùng rarity canonical.

Special Ball với normal target dùng policy riêng để gần như không phụ thuộc sức mạnh target nhưng vẫn phụ thuộc HP:

```text
healthFactor = 0.82 + 0.27 * (missingHealthRatio ^ 0.80)
levelFactor = 1.00
evolutionFactor = 1.00
speciesFactor = clamp(speciesCaptureMultiplier, 0.95, 1.05)
```

### Bảng bốn loại bóng DRAFT/TUNABLE

Tên bên dưới là tên kỹ thuật tạm thời.

| Ball | Base chance | Normal target | Legendary target | Floor/cap theo classification |
| --- | ---: | --- | --- | --- |
| Ball Tier 1 | 20% | Cho phép; base thấp, cap mạnh theo level/stage | Từ chối trước khi tính chance | Normal floor 1%; cap theo bảng dưới |
| Ball Tier 2 | 34% | Cho phép; tốt hơn Tier 1 nhưng target mạnh vẫn bị cap | Từ chối trước khi tính chance | Normal floor 1%; cap theo bảng dưới |
| Ball Tier 3 | 48% | Bóng thường cao cấp nhất | Cho phép với classification multiplier 0,04 | Normal floor 1%; legendary floor 0,1%, cap 1,2% |
| Special/Legendary Ball | 90% | Rất cao, bỏ level/evolution penalty nhưng HP thấp vẫn tốt hơn | Cho phép với classification multiplier 0,30 | Normal floor 70%, cap 98%; legendary floor 3%, cap 15% |

#### Normal cap theo evolution stage

| Ball | Stage 1 | Stage 2 | Stage 3 |
| --- | ---: | ---: | ---: |
| Ball Tier 1 | 55% | 28% | 14% |
| Ball Tier 2 | 75% | 50% | 30% |
| Ball Tier 3 | 90% | 78% | 60% |
| Special/Legendary Ball | 98% | 98% | 98% |

#### Normal cap theo level band

| Ball | Level 1–25 | Level 26–50 | Level 51–75 | Level 76–100 |
| --- | ---: | ---: | ---: | ---: |
| Ball Tier 1 | 55% | 36% | 22% | 12% |
| Ball Tier 2 | 75% | 62% | 45% | 28% |
| Ball Tier 3 | 90% | 82% | 70% | 55% |
| Special/Legendary Ball | 98% | 98% | 98% | 98% |

#### Ví dụ kiểm tra công thức

Tất cả ví dụ đều là DRAFT, target còn 10% HP, rarity `rare` và species `standard` trừ khi ghi khác:

| Target | Tier 1 | Tier 2 | Tier 3 | Special |
| --- | ---: | ---: | ---: | ---: |
| Normal, level 10, stage 1 | khoảng 26% | khoảng 45% | khoảng 63% | khoảng 96% |
| Normal, level 80, stage 3, species `hard` | khoảng 8% | khoảng 14% | khoảng 19% | khoảng 91% |
| Legendary, level 80, stage 3, species `veryHard`, rarity `legendary` | Từ chối | Từ chối | khoảng 0,3% | khoảng 4,5% |

Ở full HP trước species/level/evolution penalty, normal Tier 1/2/3 lần lượt chỉ có khoảng `3%/5,1%/7,2%`; Special normal khoảng `70–78%` tùy species clamp. Đây là DRAFT nhằm cho phép thử bắt ở 100% HP nhưng vẫn tạo lợi ích rõ rệt khi làm yếu.

Các ví dụ chỉ là sanity check cho xu hướng, không phải mục tiêu economy hoặc telemetry production.

## Security và transaction

- Chance, modifier, cap và random roll chỉ tồn tại ở server. Client không được gửi hoặc override chúng.
- Request ném bóng phải rate-limit; retry cùng request ID hợp lệ được đọc từ idempotency ledger trước khi tạo side effect mới.
- Ledger lưu request fingerprint, trạng thái transaction và response canonical. Cùng ID/cùng fingerprint trả đúng kết quả cũ; cùng ID/khác fingerprint bị từ chối.
- Với một request hợp lệ, consume, roll, collection grant, encounter membership, wild lifecycle và respawn scheduling tạo thành một logical transaction không yield.
- Capture thành công chỉ tạo tối đa một owned creature record, loại đúng một wild khỏi encounter và lên lịch respawn đúng một lần.
- Failure không cấp creature/reward, unlock target ngay và không làm reset các thành viên còn lại.
- Mọi lần ném vượt qua toàn bộ validation gameplay đều tiêu đúng một bóng, kể cả thất bại. Request invalid/rate-limited/race target invalid không được tiêu bóng.
- Persistence thuộc Phase 11. Khi có persistence, idempotency key và commit ordering phải chịu được retry/rejoin; thiết kế Phase 4 không được hứa durability chưa tồn tại.

## Test plan cho future implementation

Chưa viết test trong lượt này. Implementation sau phải có pure/unit, service integration và Studio multi-client plan cho ít nhất các case:

### Công thức và eligibility

- Cùng target/ball, HP thấp hơn luôn cho chance cao hơn hoặc bằng sau clamp; trước clamp phải tăng nghiêm ngặt.
- Level cao hơn và evolution stage cao hơn không được vô tình dễ bắt hơn.
- Species multiplier khó hơn không làm chance tăng.
- Rarity cao hơn không vô tình dễ bắt hơn; rarity và legendary classification không bị dùng lẫn.
- Full-HP capturable target được roll với chance thấp; cùng target/ball ở HP thấp hơn không được có chance thấp hơn.
- Tier 1 và Tier 2 từ chối legendary.
- Tier 3 cho roll legendary nhưng áp legendary cap 1,2%.
- Special Ball bắt normal với chance rất cao, gần như độc lập level/stage, nhưng HP thấp vẫn tốt hơn.
- Special Ball bắt legendary với chance thấp nhưng hữu dụng, đúng floor/cap 3–15%.
- Cap normal lấy đúng minimum giữa classification, level band và evolution stage.
- Random roll ở boundary 0/chance/1 có kết quả deterministic khi inject RNG.

### Authority, abuse và idempotency

- Payload có HP, level, chance, modifier, inventory, legendary flag hoặc field lạ bị từ chối.
- `targetWildId` không thuộc encounter, encounter giả, owner sai, target chết/return/despawn hoặc ngoài range bị từ chối không side effect.
- Inventory client giả không ảnh hưởng snapshot server.
- Spam request bị rate-limit.
- Retry cùng request ID/fingerprint trả cached result, không consume/grant/respawn hai lần.
- Dùng lại request ID với target/ball khác trả `REQUEST_ID_CONFLICT`.
- Failure sau validation tiêu đúng một bóng; request invalid không tiêu; retry không tiêu lần hai.

### Encounter cụm và UX target

- Cluster hai hoặc nhiều wild hợp lệ cùng tham gia một encounter.
- Player thứ hai có thể join encounter đang có và cùng damage một wild hợp lệ.
- Mọi wild trong encounter có thể move/attack; mỗi companion chỉ damage một target mỗi tick.
- Ba companion phân phối/chuyển target deterministic khi target chết, bị bắt, despawn hoặc return.
- Owner chạy xa kết thúc toàn nhóm; mọi wild còn lại return và companion còn sống quay về owner, không re-aggro khi owner còn xa.
- Một wild vượt leash riêng bị loại an toàn, thành viên khác không hỏng state.
- Player chọn đúng một target bất kỳ trong `captureEligibleWildIds`, không bị ép chọn companion target.
- Target chết/rời encounter khi đang giữ nút làm highlight biến mất; release không tự chọn target khác.
- Capture thành công một thành viên không kết thúc encounter, không duplicate transaction và không làm hỏng health/cooldown/claim của thành viên còn lại.
- Hai client tranh cùng target không thể cùng sở hữu một wild; request đến sau khi target đang locked bị từ chối không side effect.
- Projectile 3D trượt/mất model/animation bị gián đoạn không thay đổi kết quả server.

## Balance còn mở

1. Tên production của bốn ball và recipe/quantity cụ thể.
2. Health curve, rarity modifier, species multiplier và cap production sau telemetry.
3. Assist range của cluster và grace time trước group disengage.
4. Tuning target distribution ba companion để tránh overkill mà không làm combat khó đọc.
5. Có hiển thị chance chính xác cho client hay chỉ mức độ khó.

## Kế hoạch implementation theo phase

1. Mở rộng type/definition/validator data-driven cho `spawnGroupId`, wild level/stage, capture profile và bốn ball; chưa đổi service behavior.
2. Thay `CaptureCalculator` bằng pure resolver có injected RNG, cap policy và bảng unit test đầy đủ.
3. Thêm identity/lifecycle cluster trong `RegionalWildService`, giữ spawn/respawn regression cũ.
4. Migration `EncounterService` sang membership list, ba companion targets, per-wild cooldown, group disengage và deterministic retarget; mở rộng snapshot.
5. Tạo capture transaction coordinator/ledger, target-specific validation và consume-on-failure.
6. Thêm hold-drag-release target UX và projectile presentation không gameplay trên client.
7. Chạy format/lint/build/unit, rồi Studio one-client/two-client abuse và lifecycle matrix trước khi xin acceptance Phase 4.
