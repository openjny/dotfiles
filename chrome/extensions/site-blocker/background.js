// https://github.com/GoogleChrome/chrome-extensions-samples/tree/main/api-samples/declarativeNetRequest/url-blocker
'use strict';

async function getBlockedDomains() {
  return new Promise((resolve) => {
    chrome.storage.sync.get({ blockedDomains: [] }, (data) => {
      resolve(data.blockedDomains);
    });
  });
}

function createRules(domains) {
  return {
    addRules: domains.map((domain, index) => ({
      id: index + 1,
      priority: 1,
      condition: {
        urlFilter: domain,
        resourceTypes: ['main_frame', 'sub_frame', 'script', 'xmlhttprequest'],
      },
      action: { type: 'block' },
    })),
  };
}

async function removeAllRules() {
  chrome.declarativeNetRequest.getDynamicRules((rules) => {
    const ids = rules.map((domain, _index) => domain.id);
    chrome.declarativeNetRequest.updateDynamicRules({
      removeRuleIds: ids,
    });
  });
}

async function updateRules(domains) {
  const rules = createRules(domains);
  console.log('[updateRule] new rules:', rules);

  await removeAllRules();
  console.log('[updateRule] removed existing rules');

  chrome.declarativeNetRequest.updateDynamicRules(rules, () => {
    if (chrome.runtime.lastError) {
      console.error('[updateRule] error:', chrome.runtime.lastError);
    } else {
      chrome.declarativeNetRequest.getDynamicRules((rules) => {
        console.log('[updateRule] updated:', rules);
      });
    }
  });
}

(async () => {
  const blockedDomains = await getBlockedDomains();
  updateRules(blockedDomains);
})();

chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.action === 'updateRules') {
    console.log('[updateRules event] domains:', message.domains);
    updateRules(message.domains);
  }
});
