import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/home/home_state.dart';
import 'package:sirsak_pop_nasabah/features/home/home_viewmodel.dart';
import 'package:sirsak_pop_nasabah/features/home/widgets/section_header.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/buttons.dart';

class EventsSection extends StatelessWidget {
  const EventsSection({
    required this.events,
    required this.viewModel,
    super.key,
  });

  final List<Event> events;
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          icon: PhosphorIcons.calendarDots(),
          title: l10n.homeEvents,
        ),
        const Gap(16),
        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: events.length,
            separatorBuilder: (context, index) => const Gap(12),
            itemBuilder: (context, index) {
              return _EventCard(
                event: events[index],
                onRegister: () => viewModel.registerForEvent(events[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({
    required this.event,
    required this.onRegister,
  });

  final Event event;
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event image placeholder
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    PhosphorIcons.image(),
                    size: 48,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      event.date,
                      style: textTheme.labelSmall?.copyWith(
                        fontVariations: AppFonts.medium,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Event details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: textTheme.titleSmall?.copyWith(
                      fontVariations: AppFonts.semiBold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(4),
                  Expanded(
                    child: Text(
                      event.description,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontVariations: AppFonts.regular,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SButton(
                    text: l10n.homeRegisterNow,
                    onPressed: onRegister,
                    size: ButtonSize.small,
                    borderRadius: 25,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
