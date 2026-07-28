---
name: Neon Pulse
colors:
  surface: '#0f131d'
  surface-dim: '#0f131d'
  surface-bright: '#353944'
  surface-container-lowest: '#0a0e18'
  surface-container-low: '#171b26'
  surface-container: '#1c1f2a'
  surface-container-high: '#262a35'
  surface-container-highest: '#313540'
  on-surface: '#dfe2f1'
  on-surface-variant: '#bbcabf'
  inverse-surface: '#dfe2f1'
  inverse-on-surface: '#2c303b'
  outline: '#86948a'
  outline-variant: '#3c4a42'
  surface-tint: '#4edea3'
  primary: '#4edea3'
  on-primary: '#003824'
  primary-container: '#10b981'
  on-primary-container: '#00422b'
  inverse-primary: '#006c49'
  secondary: '#ffb0cd'
  on-secondary: '#640039'
  secondary-container: '#aa0266'
  on-secondary-container: '#ffbad3'
  tertiary: '#7bd0ff'
  on-tertiary: '#00354a'
  tertiary-container: '#19aee8'
  on-tertiary-container: '#003e55'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#6ffbbe'
  primary-fixed-dim: '#4edea3'
  on-primary-fixed: '#002113'
  on-primary-fixed-variant: '#005236'
  secondary-fixed: '#ffd9e4'
  secondary-fixed-dim: '#ffb0cd'
  on-secondary-fixed: '#3e0022'
  on-secondary-fixed-variant: '#8c0053'
  tertiary-fixed: '#c4e7ff'
  tertiary-fixed-dim: '#7bd0ff'
  on-tertiary-fixed: '#001e2c'
  on-tertiary-fixed-variant: '#004c69'
  background: '#0f131d'
  on-background: '#dfe2f1'
  surface-variant: '#313540'
typography:
  display-score:
    fontFamily: JetBrains Mono
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: JetBrains Mono
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: JetBrains Mono
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-caps:
    fontFamily: JetBrains Mono
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.1em
  button-text:
    fontFamily: JetBrains Mono
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 4px
  gutter: 16px
  margin-mobile: 20px
  margin-desktop: 40px
  safe-area-top: 44px
---

## Brand & Style
The design system is engineered for a high-velocity, cyberpunk gaming environment. It targets a mobile-first audience that values technical precision and immersive aesthetics. The visual language blends **Minimalist Cyberpunk** with **Glassmorphism**, creating a high-contrast interface that feels both futuristic and functional.

The emotional response is one of "focused adrenaline"—achieved through a dark, void-like background contrasted against hyper-saturated neon emitters. The interface utilizes digital-native textures, such as scanline overlays and subtle vector grids, to establish a retro-futuristic atmosphere without sacrificing modern clarity.

## Colors
This design system operates on a "Void and Glow" logic. The canvas is a deep, obsidian navy (#0B0F19) to maximize the perceived luminance of the accent colors.

- **Primary (Neon Green):** Reserved exclusively for the player's entity (the snake) and success states. It represents growth and vitality.
- **Secondary (Neon Pink):** Used for interactive collectibles (fruit) and high-priority alerts. It provides a sharp, aggressive contrast to the primary color.
- **Tertiary (Cyan):** Dedicated to the HUD, navigation, and control elements. It signifies "The System" and provides a cooling effect against the warmer pinks.
- **Surface Tints:** Interactive surfaces use a semi-transparent version of the Neutral color with a 10% Cyan tint to create depth.

## Typography
The typography system balances technical precision with high-speed legibility. 

**JetBrains Mono** is used for all data-driven elements, scores, and headings to reinforce the "coded" nature of the game world. Its monospaced structure ensures that shifting scores do not cause layout jumps. 

**Inter** is utilized for body text and descriptive content, providing a clean, humanist balance to the technicality of the monospaced font. All labels should be set in uppercase with increased letter spacing to emulate terminal readouts.

## Layout & Spacing
The layout follows a **fluid grid** model optimized for thumb-reach zones on mobile devices. The core gameplay area is framed by "Safe Zone" margins to prevent UI elements from interfering with the player's movement area.

- **The Grid:** A background decorative grid of 32px increments should be visible at 5% opacity.
- **HUD Placement:** Critical data (score, speed) is pinned to the top corners with a 20px margin.
- **Control Overlay:** Touch controls are located in the bottom third of the screen, utilizing a wide-set gutter to prevent accidental inputs.
- **Vertical Rhythm:** Elements are spaced using a 4px base unit to maintain strict alignment with the monospaced typography.

## Elevation & Depth
Depth is created through **Glassmorphism** and **Luminance**, rather than traditional shadows.

1.  **Backdrop Blurs:** Any overlay (menus, pause screens) must use a `20px` background blur with a 40% opaque dark fill.
2.  **Neon Glows:** Active elements (the snake head, power-ups) possess an outer glow (bloom) using their respective hex color, set to 20-30% opacity with a large spread (12px - 24px).
3.  **Inner Strokes:** Cards and modals feature a `1px` semi-transparent white top-border to simulate a light source from above, giving the "glass" a physical edge.
4.  **Z-Axis:** Lower levels are dimmer and more desaturated; higher levels (interactive) are brighter and fully saturated.

## Shapes
The shape language is "Sleek Industrial." We avoid sharp 90-degree corners to maintain a premium, ergonomic feel for mobile interaction, but we stop short of fully pill-shaped "playful" geometry.

- **Standard Containers:** Use 0.5rem (8px) corner radius.
- **Large Modals:** Use 1rem (16px) corner radius for a softer, more prominent appearance.
- **Snake Segments:** Use 0.25rem (4px) corner radius to create a segmented, "tech-link" look rather than a smooth organic tube.

## Components
- **Buttons:** Primary buttons use a thick Cyan (#38BDF8) outline with a subtle inner glow. On press, the button fills with a solid Cyan, and text flips to the Neutral dark color.
- **Chips / Badges:** Small, technical readouts (e.g., "LVL 1", "HIGH SCORE") use the Pink (#EC4899) accent with a 10% fill and 100% stroke.
- **Lists:** Settings or leaderboard entries are separated by `1px` borders at 10% white opacity. Active rows use a horizontal gradient hint from Cyan to transparent.
- **Input Fields:** Minimalist lines rather than boxes. A focus state triggers a "scanline" animation across the bottom border.
- **HUD Cards:** Semi-transparent glass containers with a subtle `2px` left-side accent bar in the color of the metric being tracked (e.g., Green for health/length).
- **Snake Segments:** Each segment should have a slight `1px` gap between them to emphasize the mechanical, digital nature of the entity.