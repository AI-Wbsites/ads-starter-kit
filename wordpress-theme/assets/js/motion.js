/* Mirror of prototype/src/scripts/motion.js — keep in sync when the prototype version changes. */

(function () {
  var root = document.documentElement;
  function readVar(name) { return getComputedStyle(root).getPropertyValue(name).trim(); }

  window.motion = {
    duration: function (name) {
      var v = parseFloat(readVar('--duration-' + name + '-s'));
      return isFinite(v) ? v : 0.35;
    },
    ease: function (name) {
      switch (name) {
        case 'standard':   return 'power2.inOut';
        case 'out':        return 'power2.out';
        case 'in':         return 'power2.in';
        case 'emphasized': return 'power3.out';
        case 'spring':     return 'back.out(1.7)';
        default:           return 'power2.out';
      }
    }
  };
})();
