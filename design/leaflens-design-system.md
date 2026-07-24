---
version: alpha
name: LeafLens
description: A warm, nature-first Flutter design system with editorial serifs, a lime accent, and hard-offset "sticker" depth. Adapted from the CauseHouse spec.
implements: design/causehouse-design-system.md
---

# LeafLens Design System

This document is the **contract** for building UI in LeafLens. It describes the
tokens, how they map to Flutter code, and the rules every screen must follow.
The visual language is inherited from [`causehouse-design-system.md`](./causehouse-design-system.md):
deep forest-ink, warm cream, a signature lime accent, Fraunces + Inter type, and
a hard 4px offset shadow instead of soft blur.

---

## 0. The one rule you cannot break

> **Never write a color literal in feature code.**
> No `Color(0xFF...)`, no hex strings, no `Colors.green`, no `Colors.black54`.
> Every color comes from `AppColors` or from `Theme.of(context).colorScheme` /
> `Theme.of(context).textTheme`. The **only** file allowed to contain raw color
> literals is `lib/theme/app_colors.dart`.

Why: one source of truth means the whole app re-themes (and supports dark mode)
from a single edit, and nothing drifts off-palette.

**Guard (run before every commit / in CI):**

```bash
# 1. No hex literals outside the tokens file
grep -rn "Color(0x" lib --include="*.dart" | grep -v app_colors.dart
# 2. No Material palette usage (whole-word "Colors" won't match "AppColors")
grep -rnw "Colors" lib --include="*.dart" | grep -v app_colors.dart
```

Both must print nothing. Any output is a violation to fix before merging.

---

## 1. File map

| File | Responsibility |
|------|----------------|
| `lib/theme/app_colors.dart` | Every color token. The sole home of `Color(0x...)` literals. |
| `lib/theme/app_typography.dart` | The Fraunces/Inter type scale as `TextStyle` tokens (google_fonts). |
| `lib/theme/app_spacing.dart` | `AppSpacing` (spacing steps) and `AppRadius` (corner radii + helpers). |
| `lib/theme/app_theme.dart` | Assembles tokens into `AppTheme.light` / `AppTheme.dark`, all component themes, and `AppShadows.hard`. |
| `lib/main.dart` | Applies the theme (`themeMode: ThemeMode.system`) — reference usage. |

Fonts are provided by the `google_fonts` package (no bundled `.ttf`).

---

## 2. Colors

All values live in `AppColors`. Reference them as `AppColors.primary`, or prefer
`Theme.of(context).colorScheme.primary` inside widgets so the value follows the
active light/dark theme.

### Light palette

| Token | Hex | Role |
|-------|-----|------|
| `primary` | `#1D2B1F` | Deep forest-ink. Headlines, borders, key contrast. |
| `secondary` | `#6D7B6F` | Muted sage-gray. Supportive text, subtle UI. |
| `tertiary` | `#BFEA4B` | Lime. Primary CTAs and highlights. |
| `neutral` | `#F7F0E6` | Warm cream. Page background. |
| `surface` | `#FFFDF8` | Off-white. Elevated cards / inputs. |
| `onSurface` | `#1D2B1F` | Default text on light backgrounds. |
| `error` | `#C84D4D` | Restrained alert red. |
| `primary60` | `#4E5B50` | Lifted primary — hover, nuanced borders. |
| `primary80` | `#2D3A30` | Deepened primary — pressed, heavier contrast. |
| `accent` | `#BFEA4B` | Signature highlight (mirrors `tertiary`). Use sparingly. |

### Dark palette (derived)

| Token | Hex | Role |
|-------|-----|------|
| `darkBackground` | `#12180F` | Near-black green. Dark page background. |
| `darkSurface` | `#1D2B1F` | Forest ink. Default dark surface. |
| `darkSurfaceElevated` | `#2D3A30` | Lifted forest. Elevated dark surfaces. |
| `darkNeutral` | `#232E24` | Muted card fill (dark analogue of `neutral`). |
| `onDark` | `#F7F0E6` | Cream. Default text on dark backgrounds. |
| `darkSecondary` | `#9CAA92` | Lightened sage. Supportive dark text. |
| `darkError` | `#E06A6A` | Lightened alert red for dark. |

`tertiary` / `accent` (lime) are shared across both modes.

---

## 3. Typography

Two families, one job each:

- **Fraunces** — expressive display serif. Hero and section headlines only.
- **Inter** — everything functional: sub-headings, body, labels, controls.

Reference styles via the `TextTheme` slot (recommended, carries theme color) or
`AppTypography.<name>` directly. The mapping:

| Token (`AppTypography`) | `TextTheme` slot | Family | Size / Weight | Line height | Tracking |
|-------------------------|------------------|--------|---------------|-------------|----------|
| `headlineDisplay` | `displayLarge` | Fraunces | 74 / 700 | 89 | -1.85 |
| `headlineLg` | `displayMedium` | Fraunces | 52 / 700 | 62 | -1.30 |
| `headlineMd` | `displaySmall` | Fraunces | 37 / 600 | 44 | -0.39 |
| `headlineSm` | `headlineMedium` | Inter | 26 / 600 | 31 | 0 |
| `bodyLg` | `bodyLarge` | Inter | 18 / 400 | 30 | -0.09 |
| `bodyMd` | `bodyMedium` | Inter | 16 / 400 | 26 | -0.05 |
| `bodySm` | `bodySmall` | Inter | 14 / 400 | 22 | 0 |
| `labelLg` | `labelLarge` | Inter | 12 / 700 | 16 | 0.96 |
| `labelMd` | `labelMedium` | Inter | 11 / 700 | 14 | 0.88 |
| `labelSm` | `labelSmall` | Inter | 10 / 700 | 12 | 1.0 |

Rules:
- Labels (`labelLg/md/sm`) are **uppercase** in use (`'Scan'.toUpperCase()`), for
  buttons, chips, and nav — this gives the structured, architectural feel.
- Body copy sits in the comfortable 16–18px range with generous line height.
- Do not introduce other font families or decorative fonts.

```dart
Text('Grow with LeafLens', style: Theme.of(context).textTheme.displayMedium);
Text('body copy',          style: Theme.of(context).textTheme.bodyMedium);
```

---

## 4. Spacing, radius & depth

**Spacing** (`AppSpacing`): `xs 6 · sm 14 · md 24 · lg 38 · xl 80 · gutter 24`.
Build padding, gaps, and section rhythm from these steps only. The system is
low-density — favor breathing room over crowding.

**Radius** (`AppRadius`): `none 0 · sm 4 · md 8 · lg 12 · xl/full 9999`. Ready
`BorderRadius` helpers: `AppRadius.smRadius / mdRadius / lgRadius / fullRadius`.
Interactive controls (buttons, chips) use `full` (pill); cards use `lg`.

**Depth** (`AppShadows.hard`): depth is a hard, graphic 4px offset shadow in
`primary`, not a soft blur. Material elevation cannot produce this, so apply it
via a `Container` decoration when a "sticker" lift is wanted:

```dart
Container(
  decoration: BoxDecoration(
    color: Theme.of(context).cardColor,
    borderRadius: AppRadius.lgRadius,
    border: Border.all(color: Theme.of(context).colorScheme.onSurface, width: 2),
    boxShadow: AppShadows.hard,
  ),
  child: ...,
);
```

Never use soft drop shadows, gradients, or glassmorphism — the system is
intentionally flat and tactile; contrast and line weight do the work.

---

## 5. Widget styles

Component styling lives in `app_theme.dart`, so you use the plain Material
widgets and get the LeafLens look for free.

| Intent | Widget | Result |
|--------|--------|--------|
| Primary CTA | `ElevatedButton` | Lime pill, forest text, uppercase `labelMd`, 44px min height. |
| Secondary action | `OutlinedButton` | Cream/elevated pill with a 2px border. |
| Tertiary / text action | `TextButton` | Minimal, no radius, no padding. |
| Content block | `Card` | Cream/`darkNeutral` fill, 2px border, `lg` radius, flat (add `AppShadows.hard` if it should lift). |
| Tag / status | `Chip` | Lime pill, uppercase `labelMd`. |
| Text field | `TextField` / `InputDecorator` | Surface fill, `md` radius, sage border, primary focus ring. |
| Top bar | `AppBar` | Background-matched, flat, `headlineSm` title. |

```dart
ElevatedButton(onPressed: _scan, child: Text('Scan a leaf'.toUpperCase()));
OutlinedButton(onPressed: _open, child: Text('Browse'.toUpperCase()));
TextButton(onPressed: _more,  child: Text('Learn more'.toUpperCase()));
Chip(label: Text('BETA'));
```

Buttons should stay compact and pill-shaped; keep the lime CTA the dominant
action in any header — secondary/tertiary buttons must not compete with it.

---

## 6. Dark mode

`AppTheme.light` and `AppTheme.dark` are both wired in `main.dart` with
`themeMode: ThemeMode.system`. The dark palette keeps the forest/lime language:
cream text (`onDark`) on near-black-green backgrounds, lime CTAs unchanged.
Always read colors from `Theme.of(context).colorScheme` (not fixed light tokens)
so widgets adapt automatically. Test every screen in both modes.

---

## 7. Adding or changing tokens

1. **Colors** — add or edit a `static const Color` in `app_colors.dart` only.
   Never inline a value elsewhere, even "just once".
2. **Type** — add a `TextStyle` getter in `app_typography.dart`; map it into the
   `TextTheme` in `app_theme.dart` if it should be reachable via `textTheme`.
3. **Spacing / radius** — extend `AppSpacing` / `AppRadius`.
4. **Components** — adjust the relevant `*Theme` in `app_theme.dart` so the
   change lands everywhere at once.

Re-run the guard in section 0 after any UI change.

---

## 8. Do's & Don'ts

**Do**
- Keep the cream background dominant so the lime accent stays vivid.
- Use Fraunces for hero/section headlines; Inter for everything else.
- Keep labels, nav, and buttons uppercase with the label tracking.
- Use the hard 4px offset shadow when an element should lift.
- Read colors/type from `Theme.of(context)` so dark mode just works.

**Don't**
- Don't write any color literal outside `app_colors.dart`.
- Don't swap the lime for a neon or a muted pastel.
- Don't use gradients, glassmorphism, or blurred shadows.
- Don't over-tighten layouts or remove whitespace.
- Don't add font families beyond Fraunces / Inter.
