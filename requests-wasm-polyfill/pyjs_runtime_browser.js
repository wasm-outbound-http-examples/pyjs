
var createModule = (() => {
  var _scriptDir = typeof document !== 'undefined' && document.currentScript ? document.currentScript.src : undefined;
  
  return (
function(createModule) {
  createModule = createModule || {};



  return createModule.ready
}
);
})();
if (typeof exports === 'object' && typeof module === 'object')
  module.exports = createModule;
else if (typeof define === 'function' && define['amd'])
  define([], function() { return createModule; });
else if (typeof exports === 'object')
  exports["createModule"] = createModule;