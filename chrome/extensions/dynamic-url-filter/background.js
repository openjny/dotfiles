// background.js

const STORAGE_KEY = 'dynamicBlockerConditions';
const MAX_CONDITIONS = 1024; // 保存する条件数の上限（例）

// 現在のブロック条件を保持するグローバル変数 (ストレージと同期)
let currentConditions = [];

// === ストレージ関連処理 ===
async function loadConditionsFromStorage() {
  try {
    const result = await chrome.storage.local.get([STORAGE_KEY]);
    currentConditions = Array.isArray(result[STORAGE_KEY])
      ? result[STORAGE_KEY]
      : [];
    console.log(
      'Dynamic URL Blocker: ストレージから条件を読み込みました。',
      currentConditions
    );
  } catch (error) {
    console.error(
      'Dynamic URL Blocker: ストレージから条件を読み込む際にエラーが発生しました:',
      error
    );
    currentConditions = []; // エラー時は空にする
  }
}

async function saveConditionsToStorage() {
  try {
    // 条件数が上限を超える場合は古いものから削除（FIFO）
    if (currentConditions.length > MAX_CONDITIONS) {
      currentConditions = currentConditions.slice(
        currentConditions.length - MAX_CONDITIONS
      );
    }
    await chrome.storage.local.set({ [STORAGE_KEY]: currentConditions });
    console.log(
      'Dynamic URL Blocker: ストレージに条件を保存しました。',
      currentConditions
    );
  } catch (error) {
    console.error(
      'Dynamic URL Blocker: ストレージに条件を保存する際にエラーが発生しました:',
      error
    );
  }
}

// === declarativeNetRequest ルール生成と適用 ===
function generateRulesFromConditions(conditions) {
  let ruleIdCounter = 1;
  const rules = [];
  if (!Array.isArray(conditions)) return rules;

  for (const condition of conditions) {
    let dnrCondition;
    if (condition.type === 'regex' && condition.value) {
      dnrCondition = {
        regexFilter: condition.value,
        resourceTypes: ['main_frame', 'script', 'xmlhttprequest'],
      };
    } else if (condition.type === 'urlFilter' && condition.value) {
      dnrCondition = {
        urlFilter: condition.value,
        resourceTypes: ['main_frame', 'script', 'xmlhttprequest'],
      };
    } else if (condition.type === 'domain' && condition.value) {
      dnrCondition = {
        initiatorDomains: [condition.value],
        resourceTypes: ['main_frame', 'script', 'xmlhttprequest'],
      };
    } else {
      continue; // 無効な条件はスキップ
    }
    rules.push({
      id: ruleIdCounter++,
      priority: 1,
      action: { type: 'block' },
      condition: dnrCondition,
    });
  }
  return rules;
}

async function applyBlockingRules() {
  const newRules = generateRulesFromConditions(currentConditions);
  try {
    const existingRules = await chrome.declarativeNetRequest.getDynamicRules();
    const existingRuleIds = existingRules.map((rule) => rule.id);
    const rulesUpdateOptions = { removeRuleIds: existingRuleIds };
    if (newRules.length > 0) {
      rulesUpdateOptions.addRules = newRules;
    }
    await chrome.declarativeNetRequest.updateDynamicRules(rulesUpdateOptions);
    console.log(
      'Dynamic URL Blocker: 現在の条件に基づいてルールを更新しました。ルール数:',
      newRules.length
    );
  } catch (error) {
    console.error(
      'Dynamic URL Blocker: 動的ルールを更新する際にエラーが発生しました:',
      error
    );
  }
}

// === URL 検査と条件追加ロジック ===

/**
 * URLを検査し、怪しい場合に新しいブロック条件を生成して追加する。
 * @param {string} url 検査対象のURL
 */
async function inspectAndAddNewCondition(url) {
  if (!url || (!url.startsWith('http:') && !url.startsWith('https:'))) {
    return; // http/https以外のURLは無視
  }

  console.log(`Dynamic URL Blocker: URL を検査中 - ${url}`);

  // --- ここに「怪しいURL」を判断する具体的なロジックを実装 ---
  // 例1: URLに特定のキーワードが含まれているか
  const suspiciousKeywords = ['abcdefghijklmnopqrstuvwxyz'];
  let isSuspicious = suspiciousKeywords.some((keyword) =>
    url.includes(keyword)
  );
  let newCondition = null;

  // 例2: 特定のドメインパターンに合致するか (より高度なロジックが必要)
  // const suspiciousDomainPattern = /^([a-z0-9]{10,}\.)+(xyz|top|loan)$/;
  // try {
  //   const parsedUrl = new URL(url);
  //   if (suspiciousDomainPattern.test(parsedUrl.hostname)) {
  //     isSuspicious = true;
  //   }
  // } catch (e) { /* URL解析エラーは無視 */ }

  if (isSuspicious) {
    try {
      // ドメイン全体をブロック
      const parsedUrl = new URL(url);
      const domainPattern = `||${parsedUrl.hostname}`;
      newCondition = { type: 'urlFilter', value: domainPattern };
      console.log(
        `Dynamic URL Blocker: 怪しい URL を検出しました: ${url}。新しい条件:`,
        newCondition
      );
    } catch (e) {
      console.warn(
        `Dynamic URL Blocker: 怪しい URL ${url} を解析してルールを作成できませんでした。`,
        e
      );
      return;
    }
  }
  // --- 怪しいURLの判断ロジックここまで ---

  if (newCondition) {
    // 既存の条件に同じものがなければ追加
    const alreadyExists = currentConditions.some(
      (c) => c.type === newCondition.type && c.value === newCondition.value
    );
    if (!alreadyExists) {
      currentConditions.push(newCondition);
      console.log(
        'Dynamic URL Blocker: 新しい条件を追加しました。条件数:',
        currentConditions.length
      );
      await saveConditionsToStorage();
      await applyBlockingRules(); // ルールを即時適用
    } else {
      console.log(
        'Dynamic URL Blocker: 条件はすでに存在しています:',
        newCondition.value
      );
    }
  }
}

// === イベントリスナー ===

// 拡張機能インストール時またはアップデート時
chrome.runtime.onInstalled.addListener(async (details) => {
  console.log(
    'Dynamic URL Blocker: 拡張機能がインストールまたは更新されました。',
    details.reason
  );
  await loadConditionsFromStorage(); // まずストレージから既存のルールを読み込む
  await applyBlockingRules(); // 適用する
  if (details.reason === 'install') {
    // インストール時に初期のサンプルルールなどを追加する場合はここに記述
    // currentConditions.push({ type: 'urlFilter', value: '||example.com' });
    // await saveConditionsToStorage();
    // await applyBlockingRules();
  }
});

// ブラウザ起動時
chrome.runtime.onStartup.addListener(async () => {
  console.log('Dynamic URL Blocker: ブラウザが起動しました。');
  await loadConditionsFromStorage();
  await applyBlockingRules();
});

// タブが更新されたときのリスナー (URLの変更を検知)
chrome.tabs.onUpdated.addListener(async (tabId, changeInfo, tab) => {
  // 読み込みが完了し、かつURLが存在する場合
  if (changeInfo.status === 'complete' && tab.url) {
    console.log(`Dynamic URL Blocker: タブが更新されました - URL: ${tab.url}`);
    await inspectAndAddNewCondition(tab.url);
  }
});

// 初期化処理 (Service Worker 起動時にストレージから読み込みとルール適用を行う)
// Service Workerはイベントがないと停止するため、起動時に状態を復元することが重要
(async () => {
  await loadConditionsFromStorage();
  await applyBlockingRules();
})();
