---
version: alpha
name: CauseHouse
description: A warm nonprofit marketing system with editorial serifs, playful lime accents, and hand-drawn depth.
colors:
  primary: "#1D2B1F"
  secondary: "#6D7B6F"
  tertiary: "#BFEA4B"
  neutral: "#F7F0E6"
  surface: "#FFFDF8"
  on-surface: "#1D2B1F"
  error: "#C84D4D"
  primary-60: "#4E5B50"
  primary-80: "#2D3A30"
  accent: "#BFEA4B"
typography:
  headline-display:
    fontFamily: Fraunces
    fontSize: 74px
    fontWeight: 700
    lineHeight: 89px
    letterSpacing: -1.85px
  headline-lg:
    fontFamily: Fraunces
    fontSize: 52px
    fontWeight: 700
    lineHeight: 62px
    letterSpacing: -1.30px
  headline-md:
    fontFamily: Fraunces
    fontSize: 37px
    fontWeight: 600
    lineHeight: 44px
    letterSpacing: -0.39px
  headline-sm:
    fontFamily: Inter
    fontSize: 26px
    fontWeight: 600
    lineHeight: 31px
    letterSpacing: 0px
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: 400
    lineHeight: 30px
    letterSpacing: -0.09px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: 400
    lineHeight: 26px
    letterSpacing: -0.05px
  body-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: 400
    lineHeight: 22px
    letterSpacing: 0px
  label-lg:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: 700
    lineHeight: 16px
    letterSpacing: 0.08em
  label-md:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: 700
    lineHeight: 14px
    letterSpacing: 0.08em
  label-sm:
    fontFamily: Inter
    fontSize: 10px
    fontWeight: 700
    lineHeight: 12px
    letterSpacing: 0.1em
rounded:
  none: 0px
  sm: 4px
  md: 8px
  lg: 12px
  xl: 9999px
  full: 9999px
spacing:
  xs: 6px
  sm: 14px
  md: 24px
  lg: 38px
  xl: 80px
  gutter: 24px
components:
  button-primary:
    backgroundColor: "{colors.tertiary}"
    textColor: "{colors.primary}"
    typography: "{typography.label-md}"
    rounded: "{rounded.full}"
    padding: 16px 24px
    height: 44px
  button-primary-hover:
    backgroundColor: "{colors.accent}"
    textColor: "{colors.primary}"
    typography: "{typography.label-md}"
    rounded: "{rounded.full}"
    padding: 16px 24px
    height: 44px
  button-secondary:
    backgroundColor: "{colors.neutral}"
    textColor: "{colors.primary}"
    typography: "{typography.label-md}"
    rounded: "{rounded.full}"
    padding: 16px 24px
    height: 44px
  button-tertiary:
    backgroundColor: "transparent"
    textColor: "{colors.primary}"
    typography: "{typography.label-md}"
    rounded: "{rounded.none}"
    padding: 0px
  card:
    backgroundColor: "{colors.neutral}"
    textColor: "{colors.primary}"
    rounded: "{rounded.lg}"
    padding: 24px
  input:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.primary}"
    typography: "{typography.body-md}"
    rounded: "{rounded.md}"
    padding: 14px 16px
  chip:
    backgroundColor: "{colors.tertiary}"
    textColor: "{colors.primary}"
    typography: "{typography.label-md}"
    rounded: "{rounded.full}"
    padding: 8px 14px
---

# CauseHouse

## Overview
CauseHouse feels warm, hopeful, and highly approachable, with a clear nonprofit-first personality. The visual tone balances editorial polish with a handmade, whimsical spirit, making it suitable for mission-driven organizations that want to feel credible without becoming corporate. The layout is spacious and calm, allowing the bold typography and lime accent to carry the energy.

## Colors
- **Primary (#1D2B1F):** A deep forest-ink used for headlines, navigation, borders, and key UI contrast. It gives the system its grounded, trustworthy backbone.
- **Secondary (#6D7B6F):** A muted sage-gray for supportive text and softer UI moments when full primary contrast would feel too heavy.
- **Tertiary (#BFEA4B):** A lively lime accent that signals action, highlights important phrases, and powers primary calls to action. It is the signature optimistic color in the system.
- **Neutral (#F7F0E6):** The warm cream background that defines the site’s overall softness and keeps the palette feeling human rather than stark.
- **Surface (#FFFDF8):** An even lighter off-white surface tone for elevated cards or content areas that need separation without breaking the warm palette.
- **On-surface (#1D2B1F):** The default readable text color on light backgrounds.
- **Error (#C84D4D):** A restrained alert red for validation and destructive states, designed to stay subordinate to the softer brand palette.
- **Primary scale variants (#4E5B50, #2D3A30):** Slightly lifted and deepened tones for hover, pressed, and nuanced text/border contrast.
- **Accent (#BFEA4B):** Mirrors the tertiary highlight and should be used sparingly so it remains special and attention-grabbing.

## Typography
Fraunces is the expressive display family and should be used for major headlines, hero statements, and editorial moments. Its strong serif forms, tight negative letter spacing, and high contrast create the brand’s distinctive voice. Inter handles all functional communication: navigation, body copy, labels, and UI controls, keeping the experience legible and modern.

Headline styles are intentionally dramatic, with the largest sizes reserved for the hero and section introductions. Body copy uses a comfortable 16–18px range with generous line height for reading ease. Labels and buttons use uppercase letter spacing to match the site’s structured, architectural feel, especially in navigation and pill buttons.

## Layout
The layout is spacious and centered around a fixed-max-width content column, with generous side padding and large vertical breathing room. Sections use a soft rhythm built from 6px, 14px, 24px, 38px, and 80px spacing steps, which keeps the page airy while maintaining consistent hierarchy. Cards and content blocks should favor roomy internal padding, while navigation and CTA areas remain compact and aligned.

Use asymmetrical composition when appropriate, but keep text aligned to a clear grid. The overall density is low, so avoid crowding multiple modules into one viewport unless there is a strong editorial reason.

## Elevation & Depth
Depth is not created with soft blur shadows; it comes from bold, graphic offset shadows and dark outlines. The common shadow treatment is a hard, hand-drawn-looking 4px offset in primary, which gives buttons and cards a sticker-like lift. Borders are visible and intentional, reinforcing the illustrated, crafted quality of the interface.

Because the system is mostly flat, contrast and line weight do more of the work than layering. Use the lime accent against the cream background to create emphasis rather than relying on heavy elevation stacks.

## Shapes
The shape language is friendly and rounded, with pill buttons and chips as the most recognizable pattern. Interactive controls lean into `rounded.full`, while cards use a softer `rounded.lg` to preserve structure without feeling rigid. Overall, the shapes should feel approachable, organic, and a little playful rather than strictly geometric.

## Components
Buttons are the most branded component. Use `button-primary` for the bright lime filled CTA, `button-secondary` for the cream alternative, and `button-tertiary` for minimal text-like actions. Buttons should be pill-shaped, uppercase, bold, and compact, with 16px vertical and 24px horizontal padding and a 44px minimum height. Maintain the hard offset shadow to preserve the signature cutout effect.

Cards should use the cream or surface background, a 2px dark border, `rounded.lg`, and 24px padding. Keep card content simple and readable, with strong text contrast and minimal decoration. If cards appear interactive, reuse the offset shadow to match the brand’s tactile style.

Inputs should be calm and functional, with a light surface fill, dark text, and moderate rounding. They should feel like part of the same system as buttons, but without the bold shadow treatment unless a field needs explicit emphasis.

Chips and badges should use the lime accent with compact pill proportions and uppercase label text. They are best for categorization, status, and short contextual signals such as the nonprofit marketing agency tag.

Navigation links should stay understated, using Inter in a small uppercase label style. They should not compete with the CTA button, which should remain the dominant action in the header.

## Do's and Don'ts
- Do keep the cream background dominant so the lime accent stays vivid and memorable.
- Do use Fraunces for hero and section headlines to preserve the editorial personality.
- Do keep labels, nav, and buttons in Inter with uppercase spacing for clarity and structure.
- Do preserve the hard 4px offset shadow on primary interactive elements and cards when elevation is needed.
- Don't replace the lime accent with a more saturated neon or a muted pastel; it should feel energetic but friendly.
- Don't use soft gradients, glassmorphism, or blurred shadows; the system is intentionally tactile and graphic.
- Don't over-tighten layouts or reduce whitespace; the brand relies on breathing room.
- Don't mix in additional type families or decorative fonts beyond the Fraunces/Inter pairing.