import 'package:flutter/material.dart';

/// 사용 예:
/// showGeneralDialog(
///   context: context,
///   barrierDismissible: false, // 바깥 눌러도 안 닫히게
///   barrierLabel: 'skill',
///   barrierColor: Colors.black.withOpacity(0.35), // 딤
///   transitionDuration: const Duration(milliseconds: 180),
///   pageBuilder: (_, __, ___) => const SkillPopupOverlay(),
/// );
class SkillPopupOverlay extends StatelessWidget {
  const SkillPopupOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency, // 게임 화면 위에 얹히는 레이어
      child: SafeArea(
        child: Stack(
          children: [
            // 딤 (필요하면 GestureDetector로 바깥 탭 닫기 가능)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  // 바깥 탭 닫기 원하면 주석 해제
                  // Navigator.of(context).pop();
                },
                child: Container(color: Colors.black.withOpacity(0.35)),
              ),
            ),

            // 팝업 본체
            Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _PopupPanel(
                    title: "일반 스킬",
                    cards: const [
                      SkillCardData(
                        icon: Icons.brightness_1,
                        iconColor: Color(0xFF66D6FF),
                        badge: "New",
                        name: "마법구",
                        desc: "마법구 스킬을 습득",
                        imagePath: "assets/images/skills/magic_orb.png",
                      ),
                      SkillCardData(
                        icon: Icons.flash_on,
                        iconColor: Color(0xFFB86BFF),
                        badge: "New",
                        name: "번개",
                        desc: "번개 스킬 습득",
                        imagePath: "assets/images/skills/lightning.png",
                      ),
                      SkillCardData(
                        icon: Icons.local_fire_department,
                        iconColor: Color(0xFFFF6A3D),
                        badge: "New",
                        name: "파이어볼",
                        desc: "파이어볼 스킬을 습득",
                        imagePath: "assets/images/skills/fireball.png",
                      ),
                    ],
                    onRefresh: () {
                      // TODO: 새로고침 로직
                      debugPrint("refresh");
                    },
                    onSpin: () {
                      // TODO: 돌려! 로직
                      debugPrint("spin");
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),

            // 우상단 닫기 버튼(스샷 느낌)
            Positioned(
              top: 10,
              right: 12,
              child: Row(
                children: [
                  _RoundIconButton(
                    icon: Icons.more_horiz,
                    onTap: () => debugPrint("more"),
                  ),
                  const SizedBox(width: 8),
                  _RoundIconButton(
                    icon: Icons.close,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PopupPanel extends StatelessWidget {
  final String title;
  final List<SkillCardData> cards;
  final VoidCallback onRefresh;
  final VoidCallback onSpin;

  const _PopupPanel({
    required this.title,
    required this.cards,
    required this.onRefresh,
    required this.onSpin,
  });

  @override
  Widget build(BuildContext context) {
    final panelRadius = BorderRadius.circular(14);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: panelRadius,
        border: Border.all(color: Colors.black.withOpacity(0.6), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 리본/배너 타이틀 느낌
            _RibbonTitle(text: title),
            const SizedBox(height: 14),

            // 카드 3개
            LayoutBuilder(
              builder: (context, c) {
                final isNarrow = c.maxWidth < 420;
                return isNarrow
                    ? Column(
                        children: [
                          for (int i = 0; i < cards.length; i++) ...[
                            SkillCard(data: cards[i]),
                            if (i != cards.length - 1) const SizedBox(height: 10),
                          ],
                        ],
                      )
                    : Row(
                        children: [
                          for (int i = 0; i < cards.length; i++) ...[
                            Expanded(child: SkillCard(data: cards[i])),
                            if (i != cards.length - 1) const SizedBox(width: 10),
                          ],
                        ],
                      );
              },
            ),

            const SizedBox(height: 14),

            // 하단: 새로고침 버튼(초록) + 돌려(노랑)
            Row(
              children: [
                Expanded(
                  child: _PrimaryButton(
                    label: "새로고침",
                    background: const Color(0xFF2BE36B),
                    onTap: onRefresh,
                    leading: const Icon(Icons.movie, size: 20, color: Colors.black),
                    textColor: Colors.black,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _PrimaryButton(
                    label: "돌려!",
                    background: const Color(0xFFFFD451),
                    onTap: onSpin,
                    leading: const Icon(Icons.currency_bitcoin, size: 18, color: Colors.black),
                    trailing: const Text(
                      "23",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    textColor: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RibbonTitle extends StatelessWidget {
  final String text;
  const _RibbonTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF59627A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black.withOpacity(0.55), width: 2),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class SkillCardData {
  final IconData icon;
  final Color iconColor;
  final String badge;
  final String name;
  final String desc;
  final String? imagePath;

  const SkillCardData({
    required this.icon,
    required this.iconColor,
    required this.badge,
    required this.name,
    required this.desc,
    this.imagePath,
  });
}

class SkillCard extends StatelessWidget {
  final SkillCardData data;
  const SkillCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => debugPrint("select ${data.name}"),
      child: Container(
        height: 170,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black.withOpacity(0.55), width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 아이콘 + New 배지
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black.withOpacity(0.4)),
                  ),
                  alignment: Alignment.center,
                  child: data.imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            data.imagePath!,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(data.icon, color: data.iconColor, size: 28);
                            },
                          ),
                        )
                      : Icon(data.icon, color: data.iconColor, size: 28),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B1B1B),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.black.withOpacity(0.4)),
                  ),
                  child: Text(
                    data.badge,
                    style: const TextStyle(
                      color: Color(0xFFFFB64A),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Text(
              data.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: Text(
                data.desc,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final Color background;
  final Color textColor;
  final VoidCallback onTap;
  final Widget? leading;
  final Widget? trailing;

  const _PrimaryButton({
    required this.label,
    required this.background,
    required this.onTap,
    this.leading,
    this.trailing,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.black.withOpacity(0.55), width: 2),
          ),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: textColor,
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 10),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 22,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}