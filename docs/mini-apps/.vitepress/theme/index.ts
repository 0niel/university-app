import { h } from 'vue'
import type { Theme } from 'vitepress'
import DefaultTheme from 'vitepress/theme'
import './custom.css'

// Mono eyebrow rendered above the hero headline (Vercel-style kicker).
const HeroEyebrow = () =>
  h('div', { class: 'hero-eyebrow' }, [
    h('span', { class: 'hero-eyebrow-dot' }),
    'Server-Driven UI',
  ])

// Mini Apps docs run the stock VitePress theme with a Vercel/Geist skin
// (see custom.css). Two enhancements on top of pure CSS:
//   1. a mono eyebrow injected into the home hero via a slot;
//   2. a cursor "spotlight" that lights up feature cards on the landing page.
export default {
  extends: DefaultTheme,
  Layout: () =>
    h(DefaultTheme.Layout, null, {
      'home-hero-info-before': () => h(HeroEyebrow),
    }),
  enhanceApp() {
    if (typeof window === 'undefined') return

    // Radial spotlight that follows the pointer across feature cards.
    // rAF-throttled; only the card under the cursor reveals its glow.
    let raf = 0
    const paint = (e: MouseEvent) => {
      const cards = document.querySelectorAll<HTMLElement>('.VPFeature')
      cards.forEach((card) => {
        const r = card.getBoundingClientRect()
        const x = e.clientX - r.left
        const y = e.clientY - r.top
        const inside = x >= 0 && y >= 0 && x <= r.width && y <= r.height
        card.style.setProperty('--mx', `${x}px`)
        card.style.setProperty('--my', `${y}px`)
        card.style.setProperty('--spot', inside ? '1' : '0')
      })
    }
    window.addEventListener(
      'mousemove',
      (e) => {
        if (raf) return
        raf = requestAnimationFrame(() => {
          raf = 0
          paint(e)
        })
      },
      { passive: true },
    )
  },
} satisfies Theme
