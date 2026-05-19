'use strict';

const MATH_PATTERNS = [
  /\$\$[\s\S]+?\$\$/m,
  /(^|[^\\])\$[^$\n][\s\S]*?[^\\]\$/m,
  /\\\([\s\S]+?\\\)/m,
  /\\\[[\s\S]+?\\\]/m,
  /\\begin\{[a-z*]+\}[\s\S]+?\\end\{[a-z*]+\}/mi
];

function hasMath(content) {
  if (!content) {
    return false;
  }

  return MATH_PATTERNS.some((pattern) => pattern.test(content));
}

function autoEnableFeatures(data) {
  if (!data || typeof data !== 'object') {
    return data;
  }

  if (data.math === undefined && hasMath(data.content)) {
    data.math = true;
  }

  return data;
}

hexo.extend.filter.register('before_post_render', autoEnableFeatures);
hexo.extend.filter.register('before_page_render', autoEnableFeatures);
