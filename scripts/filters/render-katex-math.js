const katex = require('katex')

const SKIP_TAGS = new Set(['code', 'pre', 'script', 'style', 'textarea', 'kbd', 'samp'])

function decodeHtmlEntities(text) {
  return text
    .replace(/&#x([0-9a-f]+);/gi, (_, hex) => String.fromCharCode(parseInt(hex, 16)))
    .replace(/&#(\d+);/g, (_, decimal) => String.fromCharCode(parseInt(decimal, 10)))
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>')
    .replace(/&amp;/g, '&')
    .replace(/&quot;/g, '"')
    .replace(/&#39;/g, "'")
}

function renderFormula(expression, displayMode) {
  return katex.renderToString(decodeHtmlEntities(expression).trim(), {
    displayMode,
    output: 'htmlAndMathml',
    throwOnError: false,
    strict: 'ignore'
  })
}

function renderMath(text) {
  let rendered = text

  rendered = rendered.replace(/\$\$([\s\S]+?)\$\$/g, (_, expression) => {
    return `\n${renderFormula(expression, true)}\n`
  })

  rendered = rendered.replace(/\\\[([\s\S]+?)\\\]/g, (_, expression) => {
    return `\n${renderFormula(expression, true)}\n`
  })

  rendered = rendered.replace(/\\\(([\s\S]+?)\\\)/g, (_, expression) => {
    return renderFormula(expression, false)
  })

  rendered = rendered.replace(/(^|[^\\$])\$(?!\$)([^\n]+?)(?<!\\)\$(?!\$)/g, (match, prefix, expression) => {
    if (!expression.trim()) {
      return match
    }

    return `${prefix}${renderFormula(expression, false)}`
  })

  return rendered
}

function shouldSkipTag(tag) {
  const match = tag.match(/^<\/?\s*([a-z0-9-]+)/i)
  return match ? SKIP_TAGS.has(match[1].toLowerCase()) : false
}

function renderMathInHtml(html) {
  let skipDepth = 0

  return html.split(/(<[^>]+>)/g).map((chunk) => {
    if (!chunk) {
      return chunk
    }

    if (chunk.startsWith('<')) {
      if (shouldSkipTag(chunk)) {
        skipDepth += chunk.startsWith('</') ? -1 : 1
        if (skipDepth < 0) {
          skipDepth = 0
        }
      }

      return chunk
    }

    return skipDepth > 0 ? chunk : renderMath(chunk)
  }).join('')
}

hexo.extend.filter.register('after_post_render', function(data) {
  if (!data?.math) {
    return data
  }

  if (data.content) {
    data.content = renderMathInHtml(data.content)
  }

  if (data.more) {
    data.more = renderMathInHtml(data.more)
  }

  return data
})
