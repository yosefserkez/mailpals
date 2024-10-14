// compressorjs@1.2.1 downloaded from https://ga.jspm.io/npm:compressorjs@1.2.1/dist/compressor.js

var e="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;var t={};(function(e,r){t=r()})(0,(function(){function ownKeys(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);t&&(a=a.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,a)}return r}function _objectSpread2(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{};t%2?ownKeys(Object(r),!0).forEach((function(t){_defineProperty(e,t,r[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):ownKeys(Object(r)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(r,t))}))}return e}function _classCallCheck(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}function _defineProperties(e,t){for(var r=0;r<t.length;r++){var a=t[r];a.enumerable=a.enumerable||false;a.configurable=true;"value"in a&&(a.writable=true);Object.defineProperty(e,_toPropertyKey(a.key),a)}}function _createClass(e,t,r){t&&_defineProperties(e.prototype,t);r&&_defineProperties(e,r);Object.defineProperty(e,"prototype",{writable:false});return e}function _defineProperty(e,t,r){t=_toPropertyKey(t);t in e?Object.defineProperty(e,t,{value:r,enumerable:true,configurable:true,writable:true}):e[t]=r;return e}function _extends(){_extends=Object.assign?Object.assign.bind():function(e){for(var t=1;t<arguments.length;t++){var r=arguments[t];for(var a in r)Object.prototype.hasOwnProperty.call(r,a)&&(e[a]=r[a])}return e};return _extends.apply(this||e,arguments)}function _toPrimitive(e,t){if("object"!==typeof e||null===e)return e;var r=e[Symbol.toPrimitive];if(void 0!==r){var a=r.call(e,t||"default");if("object"!==typeof a)return a;throw new TypeError("@@toPrimitive must return a primitive value.")}return("string"===t?String:Number)(e)}function _toPropertyKey(e){var t=_toPrimitive(e,"string");return"symbol"===typeof t?t:String(t)}var t={exports:{}};(function(t){"undefined"!==typeof window&&function(r){var a=r.HTMLCanvasElement&&r.HTMLCanvasElement.prototype;var i=r.Blob&&function(){try{return Boolean(new Blob)}catch(e){return false}}();var n=i&&r.Uint8Array&&function(){try{return 100===new Blob([new Uint8Array(100)]).size}catch(e){return false}}();var o=r.BlobBuilder||r.WebKitBlobBuilder||r.MozBlobBuilder||r.MSBlobBuilder;var s=/^data:((.*?)(;charset=.*?)?)(;base64)?,/;var l=(i||o)&&r.atob&&r.ArrayBuffer&&r.Uint8Array&&function(e){var t,r,a,l,f,c,u,h,d;t=e.match(s);if(!t)throw new Error("invalid data URI");r=t[2]?t[1]:"text/plain"+(t[3]||";charset=US-ASCII");a=!!t[4];l=e.slice(t[0].length);f=a?atob(l):decodeURIComponent(l);c=new ArrayBuffer(f.length);u=new Uint8Array(c);for(h=0;h<f.length;h+=1)u[h]=f.charCodeAt(h);if(i)return new Blob([n?u:c],{type:r});d=new o;d.append(c);return d.getBlob(r)};r.HTMLCanvasElement&&!a.toBlob&&(a.mozGetAsFile?a.toBlob=function(t,r,i){var n=this||e;setTimeout((function(){i&&a.toDataURL&&l?t(l(n.toDataURL(r,i))):t(n.mozGetAsFile("blob",r))}))}:a.toDataURL&&l&&(a.msToBlob?a.toBlob=function(t,r,i){var n=this||e;setTimeout((function(){(r&&"image/png"!==r||i)&&a.toDataURL&&l?t(l(n.toDataURL(r,i))):t(n.msToBlob(r))}))}:a.toBlob=function(t,r,a){var i=this||e;setTimeout((function(){t(l(i.toDataURL(r,a)))}))}));t.exports?t.exports=l:r.dataURLtoBlob=l}(window)})(t);var r=t.exports;var a=function isBlob(e){return"undefined"!==typeof Blob&&(e instanceof Blob||"[object Blob]"===Object.prototype.toString.call(e))};var i={
/**
     * Indicates if output the original image instead of the compressed one
     * when the size of the compressed image is greater than the original one's
     * @type {boolean}
     */
strict:true,
/**
     * Indicates if read the image's Exif Orientation information,
     * and then rotate or flip the image automatically.
     * @type {boolean}
     */
checkOrientation:true,
/**
     * Indicates if retain the image's Exif information after compressed.
     * @type {boolean}
    */
retainExif:false,
/**
     * The max width of the output image.
     * @type {number}
     */
maxWidth:Infinity,
/**
     * The max height of the output image.
     * @type {number}
     */
maxHeight:Infinity,
/**
     * The min width of the output image.
     * @type {number}
     */
minWidth:0,
/**
     * The min height of the output image.
     * @type {number}
     */
minHeight:0,
/**
     * The width of the output image.
     * If not specified, the natural width of the source image will be used.
     * @type {number}
     */
width:void 0,
/**
     * The height of the output image.
     * If not specified, the natural height of the source image will be used.
     * @type {number}
     */
height:void 0,
/**
     * Sets how the size of the image should be resized to the container
     * specified by the `width` and `height` options.
     * @type {string}
     */
resize:"none",
/**
     * The quality of the output image.
     * It must be a number between `0` and `1`,
     * and only available for `image/jpeg` and `image/webp` images.
     * Check out {@link https://developer.mozilla.org/en-US/docs/Web/API/HTMLCanvasElement/toBlob canvas.toBlob}.
     * @type {number}
     */
quality:.8,
/**
     * The mime type of the output image.
     * By default, the original mime type of the source image file will be used.
     * @type {string}
     */
mimeType:"auto",
/**
     * Files whose file type is included in this list,
     * and whose file size exceeds the `convertSize` value will be converted to JPEGs.
     * @type {string｜Array}
     */
convertTypes:["image/png"],
/**
     * PNG files over this size (5 MB by default) will be converted to JPEGs.
     * To disable this, just set the value to `Infinity`.
     * @type {number}
     */
convertSize:5e6,
/**
     * The hook function to execute before draw the image into the canvas for compression.
     * @type {Function}
     * @param {CanvasRenderingContext2D} context - The 2d rendering context of the canvas.
     * @param {HTMLCanvasElement} canvas - The canvas for compression.
     * @example
     * function (context, canvas) {
     *   context.fillStyle = '#fff';
     * }
     */
beforeDraw:null,
/**
     * The hook function to execute after drew the image into the canvas for compression.
     * @type {Function}
     * @param {CanvasRenderingContext2D} context - The 2d rendering context of the canvas.
     * @param {HTMLCanvasElement} canvas - The canvas for compression.
     * @example
     * function (context, canvas) {
     *   context.filter = 'grayscale(100%)';
     * }
     */
drew:null,
/**
     * The hook function to execute when success to compress the image.
     * @type {Function}
     * @param {File} file - The compressed image File object.
     * @example
     * function (file) {
     *   console.log(file);
     * }
     */
success:null,
/**
     * The hook function to execute when fail to compress the image.
     * @type {Function}
     * @param {Error} err - An Error object.
     * @example
     * function (err) {
     *   console.log(err.message);
     * }
     */
error:null};var n="undefined"!==typeof window&&"undefined"!==typeof window.document;var o=n?window:{};
/**
   * Check if the given value is a positive number.
   * @param {*} value - The value to check.
   * @returns {boolean} Returns `true` if the given value is a positive number, else `false`.
   */var s=function isPositiveNumber(e){return e>0&&e<Infinity};var l=Array.prototype.slice;
/**
   * Convert array-like or iterable object to an array.
   * @param {*} value - The value to convert.
   * @returns {Array} Returns a new array.
   */function toArray(e){return Array.from?Array.from(e):l.call(e)}var f=/^image\/.+$/;
/**
   * Check if the given value is a mime type of image.
   * @param {*} value - The value to check.
   * @returns {boolean} Returns `true` if the given is a mime type of image, else `false`.
   */function isImageType(e){return f.test(e)}
/**
   * Convert image type to extension.
   * @param {string} value - The image type to convert.
   * @returns {boolean} Returns the image extension.
   */function imageTypeToExtension(e){var t=isImageType(e)?e.substr(6):"";"jpeg"===t&&(t="jpg");return".".concat(t)}var c=String.fromCharCode;
/**
   * Get string from char code in data view.
   * @param {DataView} dataView - The data view for read.
   * @param {number} start - The start index.
   * @param {number} length - The read length.
   * @returns {string} The read result.
   */function getStringFromCharCode(e,t,r){var a="";var i;r+=t;for(i=t;i<r;i+=1)a+=c(e.getUint8(i));return a}var u=o.btoa;
/**
   * Transform array buffer to Data URL.
   * @param {ArrayBuffer} arrayBuffer - The array buffer to transform.
   * @param {string} mimeType - The mime type of the Data URL.
   * @returns {string} The result Data URL.
   */function arrayBufferToDataURL(e,t){var r=[];var a=8192;var i=new Uint8Array(e);while(i.length>0){r.push(c.apply(null,toArray(i.subarray(0,a))));i=i.subarray(a)}return"data:".concat(t,";base64,").concat(u(r.join("")))}
/**
   * Get orientation value from given array buffer.
   * @param {ArrayBuffer} arrayBuffer - The array buffer to read.
   * @returns {number} The read orientation value.
   */function resetAndGetOrientation(e){var t=new DataView(e);var r;try{var a;var i;var n;if(255===t.getUint8(0)&&216===t.getUint8(1)){var o=t.byteLength;var s=2;while(s+1<o){if(255===t.getUint8(s)&&225===t.getUint8(s+1)){i=s;break}s+=1}}if(i){var l=i+4;var f=i+10;if("Exif"===getStringFromCharCode(t,l,4)){var c=t.getUint16(f);a=18761===c;if((a||19789===c)&&42===t.getUint16(f+2,a)){var u=t.getUint32(f+4,a);u>=8&&(n=f+u)}}}if(n){var h=t.getUint16(n,a);var d;var v;for(v=0;v<h;v+=1){d=n+12*v+2;if(274===t.getUint16(d,a)){d+=8;r=t.getUint16(d,a);t.setUint16(d,1,a);break}}}}catch(e){r=1}return r}
/**
   * Parse Exif Orientation value.
   * @param {number} orientation - The orientation to parse.
   * @returns {Object} The parsed result.
   */function parseOrientation(e){var t=0;var r=1;var a=1;switch(e){case 2:r=-1;break;case 3:t=-180;break;case 4:a=-1;break;case 5:t=90;a=-1;break;case 6:t=90;break;case 7:t=90;r=-1;break;case 8:t=-90;break}return{rotate:t,scaleX:r,scaleY:a}}var h=/\.\d*(?:0|9){12}\d*$/;
/**
   * Normalize decimal number.
   * Check out {@link https://0.30000000000000004.com/}
   * @param {number} value - The value to normalize.
   * @param {number} [times=100000000000] - The times for normalizing.
   * @returns {number} Returns the normalized number.
   */function normalizeDecimalNumber(e){var t=arguments.length>1&&void 0!==arguments[1]?arguments[1]:1e11;return h.test(e)?Math.round(e*t)/t:e}
/**
   * Get the max sizes in a rectangle under the given aspect ratio.
   * @param {Object} data - The original sizes.
   * @param {string} [type='contain'] - The adjust type.
   * @returns {Object} The result sizes.
   */function getAdjustedSizes(e){var t=e.aspectRatio,r=e.height,a=e.width;var i=arguments.length>1&&void 0!==arguments[1]?arguments[1]:"none";var n=s(a);var o=s(r);if(n&&o){var l=r*t;("contain"===i||"none"===i)&&l>a||"cover"===i&&l<a?r=a/t:a=r*t}else n?r=a/t:o&&(a=r*t);return{width:a,height:r}}
/**
   * Get Exif information from the given array buffer.
   * @param {ArrayBuffer} arrayBuffer - The array buffer to read.
   * @returns {Array} The read Exif information.
   */function getExif(e){var t=toArray(new Uint8Array(e));var r=t.length;var a=[];var i=0;while(i+3<r){var n=t[i];var o=t[i+1];if(255===n&&218===o)break;if(255===n&&216===o)i+=2;else{var s=256*t[i+2]+t[i+3];var l=i+s+2;var f=t.slice(i,l);a.push(f);i=l}}return a.reduce((function(e,t){return 255===t[0]&&225===t[1]?e.concat(t):e}),[])}
/**
   * Insert Exif information into the given array buffer.
   * @param {ArrayBuffer} arrayBuffer - The array buffer to transform.
   * @param {Array} exifArray - The Exif information to insert.
   * @returns {ArrayBuffer} The transformed array buffer.
   */function insertExif(e,t){var r=toArray(new Uint8Array(e));if(255!==r[2]||224!==r[3])return e;var a=256*r[4]+r[5];var i=[255,216].concat(t,r.slice(4+a));return new Uint8Array(i)}var d=o.ArrayBuffer,v=o.FileReader;var m=o.URL||o.webkitURL;var p=/\.\w+$/;var b=o.Compressor;var g=function(){
/**
     * The constructor of Compressor.
     * @param {File|Blob} file - The target image file for compressing.
     * @param {Object} [options] - The options for compressing.
     */
function Compressor(t,r){_classCallCheck(this||e,Compressor);(this||e).file=t;(this||e).exif=[];(this||e).image=new Image;(this||e).options=_objectSpread2(_objectSpread2({},i),r);(this||e).aborted=false;(this||e).result=null;this.init()}_createClass(Compressor,[{key:"init",value:function init(){var t=this||e;var r=(this||e).file,i=(this||e).options;if(a(r)){var n=r.type;if(isImageType(n))if(m&&v){if(!d){i.checkOrientation=false;i.retainExif=false}var o="image/jpeg"===n;var s=o&&i.checkOrientation;var l=o&&i.retainExif;if(!m||s||l){var f=new v;(this||e).reader=f;f.onload=function(e){var a=e.target;var i=a.result;var o={};var f=1;if(s){f=resetAndGetOrientation(i);f>1&&_extends(o,parseOrientation(f))}l&&(t.exif=getExif(i));o.url=s||l?!m||f>1?arrayBufferToDataURL(i,n):m.createObjectURL(r):i;t.load(o)};f.onabort=function(){t.fail(new Error("Aborted to read the image with FileReader."))};f.onerror=function(){t.fail(new Error("Failed to read the image with FileReader."))};f.onloadend=function(){t.reader=null};s||l?f.readAsArrayBuffer(r):f.readAsDataURL(r)}else this.load({url:m.createObjectURL(r)})}else this.fail(new Error("The current browser does not support image compression."));else this.fail(new Error("The first argument must be an image File or Blob object."))}else this.fail(new Error("The first argument must be a File or Blob object."))}},{key:"load",value:function load(t){var r=this||e;var a=(this||e).file,i=(this||e).image;i.onload=function(){r.draw(_objectSpread2(_objectSpread2({},t),{},{naturalWidth:i.naturalWidth,naturalHeight:i.naturalHeight}))};i.onabort=function(){r.fail(new Error("Aborted to load the image."))};i.onerror=function(){r.fail(new Error("Failed to load the image."))};o.navigator&&/(?:iPad|iPhone|iPod).*?AppleWebKit/i.test(o.navigator.userAgent)&&(i.crossOrigin="anonymous");i.alt=a.name;i.src=t.url}},{key:"draw",value:function draw(t){var a=this||e;var i=t.naturalWidth,n=t.naturalHeight,o=t.rotate,l=void 0===o?0:o,f=t.scaleX,c=void 0===f?1:f,u=t.scaleY,h=void 0===u?1:u;var d=(this||e).file,m=(this||e).image,p=(this||e).options;var b=document.createElement("canvas");var g=b.getContext("2d");var y=Math.abs(l)%180===90;var w=("contain"===p.resize||"cover"===p.resize)&&s(p.width)&&s(p.height);var x=Math.max(p.maxWidth,0)||Infinity;var j=Math.max(p.maxHeight,0)||Infinity;var B=Math.max(p.minWidth,0)||0;var A=Math.max(p.minHeight,0)||0;var T=i/n;var U=p.width,O=p.height;if(y){var E=[j,x];x=E[0];j=E[1];var R=[A,B];B=R[0];A=R[1];var C=[O,U];U=C[0];O=C[1]}w&&(T=U/O);var P=getAdjustedSizes({aspectRatio:T,width:x,height:j},"contain");x=P.width;j=P.height;var k=getAdjustedSizes({aspectRatio:T,width:B,height:A},"cover");B=k.width;A=k.height;if(w){var D=getAdjustedSizes({aspectRatio:T,width:U,height:O},p.resize);U=D.width;O=D.height}else{var S=getAdjustedSizes({aspectRatio:T,width:U,height:O});var _=S.width;U=void 0===_?i:_;var z=S.height;O=void 0===z?n:z}U=Math.floor(normalizeDecimalNumber(Math.min(Math.max(U,B),x)));O=Math.floor(normalizeDecimalNumber(Math.min(Math.max(O,A),j)));var L=-U/2;var M=-O/2;var I=U;var F=O;var H=[];if(w){var W=0;var K=0;var N=i;var G=n;var q=getAdjustedSizes({aspectRatio:T,width:i,height:n},{contain:"cover",cover:"contain"}[p.resize]);N=q.width;G=q.height;W=(i-N)/2;K=(n-G)/2;H.push(W,K,N,G)}H.push(L,M,I,F);if(y){var $=[O,U];U=$[0];O=$[1]}b.width=U;b.height=O;isImageType(p.mimeType)||(p.mimeType=d.type);var X="transparent";d.size>p.convertSize&&p.convertTypes.indexOf(p.mimeType)>=0&&(p.mimeType="image/jpeg");var Y="image/jpeg"===p.mimeType;Y&&(X="#fff");g.fillStyle=X;g.fillRect(0,0,U,O);p.beforeDraw&&p.beforeDraw.call(this||e,g,b);if(!(this||e).aborted){g.save();g.translate(U/2,O/2);g.rotate(l*Math.PI/180);g.scale(c,h);g.drawImage.apply(g,[m].concat(H));g.restore();p.drew&&p.drew.call(this||e,g,b);if(!(this||e).aborted){var V=function callback(e){if(!a.aborted){var t=function done(e){return a.done({naturalWidth:i,naturalHeight:n,result:e})};if(e&&Y&&p.retainExif&&a.exif&&a.exif.length>0){var o=function next(e){return t(r(arrayBufferToDataURL(insertExif(e,a.exif),p.mimeType)))};if(e.arrayBuffer)e.arrayBuffer().then(o).catch((function(){a.fail(new Error("Failed to read the compressed image with Blob.arrayBuffer()."))}));else{var s=new v;a.reader=s;s.onload=function(e){var t=e.target;o(t.result)};s.onabort=function(){a.fail(new Error("Aborted to read the compressed image with FileReader."))};s.onerror=function(){a.fail(new Error("Failed to read the compressed image with FileReader."))};s.onloadend=function(){a.reader=null};s.readAsArrayBuffer(e)}}else t(e)}};b.toBlob?b.toBlob(V,p.mimeType,p.quality):V(r(b.toDataURL(p.mimeType,p.quality)))}}}},{key:"done",value:function done(t){var r=t.naturalWidth,a=t.naturalHeight,i=t.result;var n=(this||e).file,o=(this||e).image,s=(this||e).options;m&&0===o.src.indexOf("blob:")&&m.revokeObjectURL(o.src);if(i)if(s.strict&&!s.retainExif&&i.size>n.size&&s.mimeType===n.type&&!(s.width>r||s.height>a||s.minWidth>r||s.minHeight>a||s.maxWidth<r||s.maxHeight<a))i=n;else{var l=new Date;i.lastModified=l.getTime();i.lastModifiedDate=l;i.name=n.name;i.name&&i.type!==n.type&&(i.name=i.name.replace(p,imageTypeToExtension(i.type)))}else i=n;(this||e).result=i;s.success&&s.success.call(this||e,i)}},{key:"fail",value:function fail(t){var r=(this||e).options;if(!r.error)throw t;r.error.call(this||e,t)}},{key:"abort",value:function abort(){if(!(this||e).aborted){(this||e).aborted=true;if((this||e).reader)(this||e).reader.abort();else if((this||e).image.complete)this.fail(new Error("The compression process has been aborted."));else{(this||e).image.onload=null;(this||e).image.onabort()}}}
/**
       * Get the no conflict compressor class.
       * @returns {Compressor} The compressor class.
       */}],[{key:"noConflict",value:function noConflict(){window.Compressor=b;return Compressor}
/**
       * Change the default options.
       * @param {Object} options - The new default options.
       */},{key:"setDefaults",value:function setDefaults(e){_extends(i,e)}}]);return Compressor}();return g}));var r=t;export{r as default};

