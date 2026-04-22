/* global hexo */

'use strict';

const IMPORTED_SEGMENT = '/_posts/imported/';

function isImportedPost(post) {
  if (!post || !post.source) return false;
  const normalized = String(post.source).replace(/\\/g, '/');
  return normalized.startsWith('_posts/imported/')
    || normalized.startsWith('source/_posts/imported/')
    || normalized.includes(IMPORTED_SEGMENT);
}

function filterCollection(collection) {
  if (!collection || typeof collection.filter !== 'function') return collection;
  return collection.filter(post => !isImportedPost(post));
}

// Run after theme's default before_generate filter (priority 10) to ensure final locals are filtered.
hexo.extend.filter.register('before_generate', function() {
  this._bindLocals();

  ['posts', 'all_posts', 'index_posts', 'hide_posts'].forEach((key) => {
    const current = this.locals.get(key);
    if (current) {
      this.locals.set(key, filterCollection(current));
    }
  });
}, 20);

