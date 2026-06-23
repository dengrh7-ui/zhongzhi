# 种植日记 · Cloudflare Worker 同步后端

极简同步服务。一次部署，永久免费（在 Cloudflare 免费额度内）。

## 一次性部署步骤

```bash
# 1. 安装 Cloudflare 的 CLI（已装可跳过）
npm install -g wrangler

# 2. 登录 Cloudflare（会弹浏览器授权）
wrangler login

# 3. 创建 KV 空间，得到一个 id
wrangler kv namespace create ZHONGZHI_KV
# 输出形如:
#   [[kv_namespaces]]
#   binding = "KV"
#   id = "abcd1234..."

# 4. 把上面的 id 粘进 wrangler.toml 里 REPLACE_WITH_KV_NAMESPACE_ID 的位置

# 5. 部署
cd worker
wrangler deploy
# 输出形如:
#   Published zhongzhi-sync (1.2 sec)
#   https://zhongzhi-sync.<你的子域>.workers.dev
```

部署完会拿到一个形如 `https://zhongzhi-sync.xxx.workers.dev` 的地址。

## 在 App 里启用同步

1. 打开 App，点右上角 `⋯` → `云端同步`
2. **同步地址**：填 `https://zhongzhi-sync.xxx.workers.dev`
3. **同步密码**：自己定一个 6-32 位的字符串（字母、数字、`-`、`_`），越长越好
4. 点 `保存并立即同步`

之后任何设备打开 App，填同样的地址和密码即可拉到全部历史数据。

## 安全提示

- 密码是唯一凭证。**别用 `123456` 这种弱密码**，至少 12 位混合字符。任何拿到密码的人都能读取/覆盖你的数据。
- 数据通过 HTTPS 传输，存储在 Cloudflare KV，明文。如果非常在意患者隐私，可以在 worker 里加一层 AES-GCM 加密（密钥跟密码绑定）。

## 配额

Cloudflare 免费额度（个人用户）：
- Workers：10 万请求 / 天
- KV 读：10 万次 / 天，写：1000 次 / 天

种植日记一天写入次数 = 你保存记录的次数 + 自动推送次数，远低于这个上限。
