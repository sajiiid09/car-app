# Design System Strategy: OnlyCars Premium Marketplace

## 1. Overview
OnlyCars should feel like a premium automotive marketplace: clean, modern, structured, and easy to scan.

The visual system must be:
- neutral-first
- premium but restrained
- automotive, not generic lifestyle
- modern, but not flashy
- suitable for mobile product screens, not just hero concepts

The design should avoid overwhelming the user with strong color. Most of the interface should feel calm and neutral, with color used only for emphasis.

The overall color mode is **light**.

---

## 2. Core Visual Direction

### Neutral-First Rule
The app should be built mostly from clean neutral surfaces.

Use approximately:
- 75–85% neutral backgrounds and cards
- 10–15% primary blue accents
- 5–10% secondary soft-blue accents

Do not flood the UI with strong color.

### Color Role Separation
Use two separate accent families:

#### Primary Blue Gradient
Use for:
- primary CTA buttons
- selected states
- promo highlights
- marketplace energy
- featured commercial content

#### Secondary Blue Gradient
Use for:
- tracking
- trust
- support/help
- delivery status
- informational or operational highlights

### Important Rule
**Use only blue-family gradients from this palette.**

Allowed:
- darker blue gradient by itself
- lighter blue gradient by itself

Not allowed:
- unrelated accent colors mixed into the system
- too many strong colored blocks stacked together
- strong color dominating the full screen

---

## 3. Color System

### Base Neutrals
- `background`: #F7F5F3
- `surface`: #FFFFFF
- `surface-soft`: #F2EFEC
- `surface-muted`: #EAE5E1
- `text-primary`: #1C1B1A
- `text-secondary`: #6E675F
- `text-muted`: #9A938B
- `border-subtle`: rgba(28, 27, 26, 0.08)

### Primary Blue Accent Family
- `primary-start`: #1A2C4A
- `primary-end`: #2997FF
- `primary-solid`: #3D4E73
- `primary-soft`: #E1E6F9

Use the primary blue family for high-priority action and featured commerce.

### Secondary Blue Accent Family
- `secondary-start`: #3D4E73
- `secondary-end`: #AECBFA
- `secondary-solid`: #AECBFA
- `secondary-soft`: #E1E6F9

Use the secondary blue family for delivery, tracking, support, and informational emphasis.

### Semantic Colors
- `success`: #2E7D32
- `warning`: #D98A00
- `error`: #D64545

### Usage Rules
- Large sections should remain neutral
- Only one strong color moment should dominate a screen section
- Primary blue should not be the background of the whole app
- Secondary blue should support the system, not compete with primary emphasis

---

## 4. Gradients

### Primary Blue Gradient
Use for:
- primary CTA buttons
- featured promo cards
- key earnings or marketplace highlight cards

Gradient:
- linear 135°
- from `primary-start` to `primary-end`

### Secondary Blue Gradient
Use for:
- tracking cards
- support/help banners
- trust-focused summaries
- delivery status highlights

Gradient:
- linear 135°
- from `secondary-start` to `secondary-end`

### Gradient Restrictions
Do not use gradients on:
- page backgrounds
- every card
- every icon chip
- every navigation item
- long lists

Gradients should be used sparingly, only on highlighted elements.

---

## 5. Layout Philosophy

### Structured, Not Chaotic
The app should feel confident and automotive, not experimental.

Use:
- clean alignment
- consistent spacing
- strong information hierarchy
- large content blocks with breathing room

Do not overuse asymmetry.

### Controlled Asymmetry
Subtle asymmetry is allowed only in:
- hero banners
- promotional blocks
- image crops

Core product screens should remain structured and easy to scan.

---

## 6. Typography

Typography should feel strong, premium, and readable.

### Direction
- Use a bold geometric sans for English display text
- Use a clean Arabic-friendly sans for Arabic
- Prioritize readability over decorative typography

### Hierarchy
- Large headings should be bold and dark
- Small labels should be muted and precise
- Use contrast in size and weight, not excessive styling

### Rules
- Avoid overly thin text
- Avoid decorative headline effects
- Avoid text shadows
- Never use pure black; use `text-primary`

---

## 7. Surfaces, Cards, and Borders

### Surface Philosophy
Most screens should be built from:
- neutral page background
- white or soft-neutral cards
- minimal shadow
- subtle border or tonal contrast when needed

### Borders
Subtle borders are allowed.

Use:
- 1px low-contrast borders only when helpful for clarity
- especially on inputs, list items, lightweight cards

Avoid:
- dark heavy borders
- strong boxed-in feeling

### Card Style
Cards should feel calm and premium:
- background: white or soft neutral
- radius: 16–24px depending on size
- shadow: very soft and light
- padding: generous, not cramped

---

## 8. Elevation and Depth

Use depth carefully.

### Preferred Depth Method
Create hierarchy through:
- tonal contrast
- spacing
- card size
- subtle shadow

### Shadows
Use very soft ambient shadows only:
- low opacity
- large blur
- no harsh dark shadow edges

Do not use old-style heavy drop shadows.

### Glassmorphism
Only use very lightly, and only when clearly useful:
- floating bottom navigation
- sticky top overlays
- map overlay cards

If used:
- soft white surface
- high transparency restraint
- very light blur

Do not use glassmorphism widely across the app.

---

## 9. Components

### Buttons

#### Primary Button
- primary blue gradient
- white text
- large tap area
- rounded corners: 16px
- bold label

#### Secondary Button
- white or soft-neutral background
- subtle border
- dark text

#### Informational / Operational Button
Secondary blue can be used when the action is related to:
- tracking
- support
- delivery status
- info-related guidance

Do not place primary and secondary blue buttons fighting side-by-side unless hierarchy is very clear.

---

### Inputs
- neutral or white background
- subtle border
- rounded corners: 14–16px
- strong focus state
- focus accent may use `primary-solid`

Inputs should feel practical, not stylized.

---

### Chips and Status
Use chips for:
- status
- filters
- labels
- role tags

Rules:
- keep chips compact
- use full pill only for chips, not large containers
- selected chip may use primary or secondary blue depending on function
- inactive chips stay neutral

---

### Navigation
Bottom navigation should remain mostly neutral.

Use accent color only for:
- selected tab
- small active indicator

Do not turn the whole navigation bar into a strong color block.

---

## 10. Home Screen Rules

The home screen should feel editorial, commercial, and premium.

### Required Home Elements
- header
- search
- advertising / promotional area
- quick actions
- active order or tracking summary
- featured services or workshops
- featured car parts
- optional secondary promotional area

### Advertising Areas
Home must include promotional blocks.

These can be:
- large hero banner
- medium secondary banner
- service promotion card
- seasonal campaign tile

Advertising areas may use:
- primary blue gradient
- secondary blue gradient
- strong automotive imagery

But not too many strong banners stacked together.

### Home Product Layout
Featured parts on Home should be displayed in:
- **2 per row**
- **bento style**
- more visual and editorial
- varied card height is acceptable if still balanced

This layout is for featured discovery, not for dense scanning.

---

## 11. Search and Results Rules

Search screens should be calmer and more utility-focused than Home.

### Product Search Results
Car parts in search/results should be displayed:
- **1 per row**
- clean list style
- easier to scan and compare
- more informational than promotional

### Search Layout
Use:
- more white space
- simpler cards
- less gradient
- clearer text hierarchy
- clearer filter/sort structure

Search should feel efficient, not decorative.

---

## 12. Automotive Feel

The app should feel like an automotive product, not generic e-commerce.

To achieve this:
- use darker text and stronger hierarchy
- use structured information blocks
- let car imagery feel premium and sharp
- avoid playful oversaturation
- keep the base palette grounded and confident

The tone should feel:
- premium
- technical
- trustworthy
- modern
- clean

Not:
- playful
- candy-colored
- over-styled
- fashion-first

---

## 13. Role-Based Screen Tone

### Consumer Screens
- slightly more commercial
- more banners and featured content
- more marketplace energy

### Workshop / Shop Screens
- more operational
- more neutral
- emphasis on clarity and actions

### Delivery / Tracking Screens
- can use more secondary blue
- focus on trust, route, progress, support
- primary blue remains for main CTA

### Profile Screens
- mostly neutral
- calm and clean
- only light accent usage

---

## 14. Do’s and Don’ts

### Do
- Do keep most surfaces neutral
- Do use the provided blue shades as the only accent family
- Do use gradients only on highlight elements
- Do include advertising areas on Home
- Do use 2-column bento parts layout on Home
- Do use 1-column list layout for search results
- Do keep operational screens cleaner than discovery screens
- Do maintain strong readability and hierarchy
- Do make the app feel premium and automotive

### Don’t
- Don’t make the primary blue dominate the whole screen
- Don’t introduce unrelated accent colors back into the system
- Don’t use gradients everywhere
- Don’t overuse asymmetry
- Don’t rely on heavy glassmorphism
- Don’t use loud backgrounds behind every section
- Don’t make search screens overly decorative
- Don’t make the app feel generic or fashion-like
- Don’t use pure black
- Don’t use strong borders everywhere

---

## 15. Stitch Guidance

When generating screens:
- prefer neutral layouts with selective accents
- use primary blue for primary commercial emphasis
- use secondary blue for tracking/trust/support emphasis
- keep most cards white or soft neutral
- use gradients sparingly and intentionally
- Home should feel more promotional
- Search should feel more structured and scannable
- keep the product practical and implementation-friendly