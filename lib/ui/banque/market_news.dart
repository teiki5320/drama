import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';

/// "Rumeurs" qui annoncent les triggers narratifs §4.8 de la ROADMAP
/// 1-2 jours avant qu'ils ne s'exécutent. Donne au joueur trader un
/// indice tactique sans révéler la valeur exacte du saut.
///
/// IMPORTANT : les textes ci-dessous sont volontairement génériques pour
/// rester compatibles avec un scénario qui s'étoffera. Si une ligne du
/// scénario futur entre en conflit, on adapte ici. Pour l'instant
/// (J1-J14 jouables), aucune news n'est encore active.
class MarketNews {
  final int day;
  final String headline;
  final String teaser;
  final String ticker;
  final bool bullish;

  const MarketNews({
    required this.day,
    required this.headline,
    required this.teaser,
    required this.ticker,
    required this.bullish,
  });
}

/// Window over which a news is visible : [day .. day+1].
/// Trigger executes at day+2 (= news.day + 2).
const List<MarketNews> kMarketNews = [
  MarketNews(
    day: 33,
    ticker: 'HENG',
    bullish: true,
    headline: 'Heng International : partenariat asiatique imminent',
    teaser:
        'Selon des sources proches du groupe, un protocole d\'accord majeur serait sur le point d\'être signé.',
  ),
  MarketNews(
    day: 50,
    ticker: 'HENG',
    bullish: false,
    headline: 'Heng International : tensions internes',
    teaser:
        'La presse économique évoque des dissensions au sommet et un calendrier qui glisse.',
  ),
  MarketNews(
    day: 74,
    ticker: 'HAN',
    bullish: true,
    headline: 'Hanami Café Co : levée historique en vue',
    teaser:
        'Le réseau franco-japonais préparerait une expansion européenne d\'envergure.',
  ),
  MarketNews(
    day: 96,
    ticker: 'BDE',
    bullish: false,
    headline: 'Banque de l\'Étoile : enquête en cours',
    teaser:
        'Des perquisitions au siège, l\'AMF observe. Le titre est sous pression.',
  ),
];

MarketNews? activeNewsForDay(int day) {
  for (final n in kMarketNews) {
    if (day >= n.day && day < n.day + 2) return n;
  }
  return null;
}

class MarketNewsBanner extends StatelessWidget {
  const MarketNewsBanner({super.key, required this.news});
  final MarketNews news;

  @override
  Widget build(BuildContext context) {
    final tint = news.bullish
        ? AppColors.positive.withValues(alpha: 0.10)
        : AppColors.negative.withValues(alpha: 0.10);
    final color = news.bullish ? AppColors.positive : AppColors.negative;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: tint,
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.campaign_outlined,
              size: 18,
              color: color,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        news.ticker,
                        style: GoogleFonts.inter(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'RUMEUR DU JOUR',
                      style: GoogleFonts.inter(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  news.headline,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  news.teaser,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
