/* global hexo */

'use strict';

const IMPORTED_SEGMENT = '/_posts/imported/';
const TRUTHY_STRINGS = new Set(['true', '1', 'yes', 'on']);

function isImportedPost(post) {
  if (!post || !post.source) return false;
  const normalized = String(post.source).replace(/\\/g, '/');
  return normalized.startsWith('_posts/imported/')
    || normalized.startsWith('source/_posts/imported/')
    || normalized.includes(IMPORTED_SEGMENT);
}

function isTruthy(value) {
  if (typeof value === 'boolean') return value;
  if (typeof value === 'number') return value === 1;
  if (typeof value === 'string') return TRUTHY_STRINGS.has(value.trim().toLowerCase());
  return false;
}

function shouldKeepPost(post, options) {
  if (isImportedPost(post)) return false;
  if (!options.manualPublishOnly) return true;

  const publishFlag = post && options.publishField ? post[options.publishField] : undefined;
  return isTruthy(publishFlag);
}

function filterCollection(collection, options) {
  if (!collection || typeof collection.filter !== 'function') return collection;
  return collection.filter(post => shouldKeepPost(post, options));
}

function taxonomyHasPublishedPosts(item, options) {
  if (!item || !item.posts || typeof item.posts.filter !== 'function') return false;
  return filterCollection(item.posts, options).length > 0;
}

// Run after theme's default before_generate filter (priority 10) to ensure final locals are filtered.
hexo.extend.filter.register('before_generate', function() {
  this._bindLocals();
  const options = {
    manualPublishOnly: Boolean(this.config.manual_publish_only),
    publishField: this.config.manual_publish_field || 'publish'
  };

  ['posts', 'all_posts', 'index_posts', 'hide_posts'].forEach((key) => {
    const current = this.locals.get(key);
    if (current) {
      this.locals.set(key, filterCollection(current, options));
    }
  });

  ['categories', 'tags'].forEach((key) => {
    const current = this.locals.get(key);
    if (current && typeof current.filter === 'function') {
      this.locals.set(key, current.filter(item => taxonomyHasPublishedPosts(item, options)));
    }
  });
}, 20);
