'use strict';

const overrideHref = '/css/site-overrides.css';
const overrideLink = `<link rel="stylesheet" href="${overrideHref}">`;

hexo.extend.filter.register('after_render:html', function injectSiteOverrides(html) {
  if (typeof html !== 'string' || html.includes(overrideHref)) {
    return html;
  }

  return html.replace('</head>', `${overrideLink}</head>`);
});
