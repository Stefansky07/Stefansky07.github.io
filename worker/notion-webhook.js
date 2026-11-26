export default {
  async fetch(request, env) {
    if (request.method !== "POST" && request.method !== "GET") {
      return new Response("Method Not Allowed", { status: 405 });
    }
    const url = new URL(request.url);
    const secret = url.searchParams.get("secret") || request.headers.get("x-webhook-secret") || "";
    if (!env.WEBHOOK_SECRET || secret !== env.WEBHOOK_SECRET) {
      return new Response("Unauthorized", { status: 401 });
    }
    const res = await fetch(
      `https://api.github.com/repos/${env.GH_REPO}/actions/workflows/notion-sync.yml/dispatches`,
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${env.GH_PAT}`,
          Accept: "application/vnd.github+json",
          "User-Agent": "notion-blog-trigger",
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ ref: env.GH_BRANCH || "blog-src" }),
      },
    );
    if (!res.ok) return new Response(`GitHub ${res.status}: ${await res.text()}`, { status: 502 });
    return new Response("Triggered Sync Notion Blog", { status: 200 });
  },
};
