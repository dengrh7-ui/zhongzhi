// Minimal sync endpoint for 种植日记.
// Stores one JSON blob per access code in Cloudflare KV.
//
// Routes:
//   GET    /api/sync/:code  -> returns { records, systems, updatedAt } or { empty:true }
//   POST   /api/sync/:code  -> body = { records, systems, updatedAt } ; stores it
//
// Access codes must be 6-32 chars [A-Za-z0-9_-]. Anyone with the code can
// read/write that bucket, so pick a long random one. For real privacy, host
// behind your own Cloudflare account and treat the code as a password.

const CORS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
  'Access-Control-Max-Age': '86400',
};

const json = (obj, status = 200) =>
  new Response(JSON.stringify(obj), {
    status,
    headers: { 'Content-Type': 'application/json; charset=utf-8', ...CORS },
  });

export default {
  async fetch(request, env) {
    if (request.method === 'OPTIONS') return new Response(null, { headers: CORS });

    const url = new URL(request.url);
    const m = url.pathname.match(/^\/api\/sync\/([A-Za-z0-9_-]{6,32})$/);
    if (!m) return json({ error: 'not_found' }, 404);
    const code = m[1];
    const key = `sync:${code}`;

    if (request.method === 'GET') {
      const data = await env.KV.get(key);
      if (!data) return json({ empty: true });
      return new Response(data, {
        headers: { 'Content-Type': 'application/json; charset=utf-8', ...CORS },
      });
    }

    if (request.method === 'POST') {
      const body = await request.text();
      if (body.length > 5 * 1024 * 1024) return json({ error: 'too_large' }, 413);
      try { JSON.parse(body); } catch { return json({ error: 'invalid_json' }, 400); }
      await env.KV.put(key, body);
      return json({ ok: true });
    }

    return json({ error: 'method_not_allowed' }, 405);
  },
};
