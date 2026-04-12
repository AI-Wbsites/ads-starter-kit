/**
 * Motion helpers — read durations/eases from the design system so they
 * stay in sync with CSS transitions.
 *
 * Example:
 *   import { motion } from './motion.js';
 *   gsap.to(el, { y: 0, duration: motion.duration('base'), ease: motion.ease('emphasized') });
 */

const root = typeof document !== 'undefined' ? document.documentElement : null;

function readVar(name) {
  if (!root) return '';
  return getComputedStyle(root).getPropertyValue(name).trim();
}

export const motion = {
  duration(name) {
    const v = parseFloat(readVar(`--duration-${name}-s`));
    return Number.isFinite(v) ? v : 0.35;
  },
  // Map design-system ease tokens to GSAP ease names.
  ease(name) {
    switch (name) {
      case 'standard':   return 'power2.inOut';
      case 'out':        return 'power2.out';
      case 'in':         return 'power2.in';
      case 'emphasized': return 'power3.out';
      case 'spring':     return 'back.out(1.7)';
      default:           return 'power2.out';
    }
  },
};
