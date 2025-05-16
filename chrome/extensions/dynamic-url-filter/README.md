# 拡張機能: Dynamic URL Blocker

ページを開いたときに、URL を検査し、特定の条件に合致する場合はページの読み込みを中止する

## 要件

- URL の検査は javascript の関数 (入力: URL、出力: true/false) を使用する
- すべてのページを監視する
- declarativeNetRequest を使用する
- manifest v3 を使用する
- ユーザーインタラクションは不要
