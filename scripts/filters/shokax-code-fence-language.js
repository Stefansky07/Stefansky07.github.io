'use strict';

const LANGUAGE_ALIASES = new Map([
  ['c++', 'cpp'],
  ['c#', 'csharp'],
  ['cmd', 'batch'],
  ['dos', 'batch'],
  ['git', 'bash'],
  ['bush', 'bash'],
  ['js', 'javascript'],
  ['node', 'javascript'],
  ['ps1', 'powershell'],
  ['py', 'python'],
  ['python3', 'python'],
  ['sage', 'python'],
  ['sagemath', 'python'],
  ['sh', 'bash'],
  ['shell', 'bash'],
  ['ts', 'typescript'],
  ['txt', 'text'],
  ['yml', 'yaml']
]);

const SUPPORTED_LANGUAGES = new Set([
  'asm',
  'bash',
  'batch',
  'c',
  'cpp',
  'csharp',
  'css',
  'diff',
  'dockerfile',
  'go',
  'html',
  'ini',
  'java',
  'javascript',
  'json',
  'kotlin',
  'lua',
  'make',
  'markdown',
  'matlab',
  'php',
  'powershell',
  'python',
  'r',
  'regex',
  'ruby',
  'rust',
  'sql',
  'text',
  'typescript',
  'xml',
  'yaml'
]);

function normalizeFenceInfo(info) {
  const trimmed = info.trim();

  if (!trimmed) {
    return '';
  }

  const [rawLanguage] = trimmed.split(/\s+/);
  const normalized = LANGUAGE_ALIASES.get(rawLanguage.toLowerCase()) || rawLanguage.toLowerCase();

  return SUPPORTED_LANGUAGES.has(normalized) ? normalized : 'text';
}

function normalizeCodeFences(content) {
  let inFence = false;
  let fenceMarker = '';

  return content.split(/\r?\n/).map((line) => {
    const match = line.match(/^(\s*)(`{3,}|~{3,})(.*)$/);

    if (!match) {
      return line;
    }

    const indent = match[1];
    const marker = match[2];
    const info = match[3] || '';

    if (!inFence) {
      inFence = true;
      fenceMarker = marker;

      const language = normalizeFenceInfo(info);
      return language ? `${indent}${marker} ${language}` : `${indent}${marker}`;
    }

    if (marker[0] === fenceMarker[0] && marker.length >= fenceMarker.length && !info.trim()) {
      inFence = false;
      fenceMarker = '';
    }

    return line;
  }).join('\n');
}

hexo.extend.filter.register('before_post_render', (data) => {
  if (data.content) {
    data.content = normalizeCodeFences(data.content);
  }

  return data;
});
