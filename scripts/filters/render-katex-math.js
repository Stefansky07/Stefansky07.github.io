const katex = require('katex')

const PLACEHOLDER_PREFIX = '__CODEX_KATEX_PROTECT__'
const PROTECTED_PATTERNS = [
  /```[\s\S]*?```/g,
  /~~~[\s\S]*?~~~/g,
  /`[^`\n]+`/g,
  /<pre[\s\S]*?<\/pre>/gi,
  /<code[\s\S]*?<\/code>/gi
]

function protectSegments(text) {
  const placeholders = []
  let protectedText = text

  for (const pattern of PROTECTED_PATTERNS) {
    protectedText = protectedText.replace(pattern, (segment) => {
      const key = `${PLACEHOLDER_PREFIX}${placeholders.length}__`
      placeholders.push(segment)
      return key
    })
  }

  return { protectedText, placeholders }
}

function restoreSegments(text, placeholders) {
  return text.replace(new RegExp(`${PLACEHOLDER_PREFIX}(\\d+)__`, 'g'), (_, index) => {
    return placeholders[Number(index)] ?? ''
  })
}

function renderFormula(expression, displayMode) {
  return katex.renderToString(expression.trim(), {
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

hexo.extend.filter.register('before_post_render', function(data) {
  if (!data?.math || !data.content) {
    return data
  }

  const { protectedText, placeholders } = protectSegments(data.content)
  data.content = restoreSegments(renderMath(protectedText), placeholders)
  return data
})
