document.addEventListener('DOMContentLoaded', () => {
  const blockCurrentBtn = document.getElementById('blockCurrent');
  const addDomainBtn = document.getElementById('addDomain');
  const manualDomainInput = document.getElementById('manualDomain');
  const blockedList = document.getElementById('blockedList');

  // 現在のタブのドメインを取得してブロック
  blockCurrentBtn.addEventListener('click', () => {
    chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
      if (tabs.length === 0) return;
      const url = new URL(tabs[0].url);
      addDomainToBlockList(url.hostname);
    });
  });

  // 手動でドメインを追加
  addDomainBtn.addEventListener('click', () => {
    const domain = manualDomainInput.value.trim();
    if (domain) {
      addDomainToBlockList(domain);
      manualDomainInput.value = '';
    }
  });

  // ブロックリストにドメインを追加
  function addDomainToBlockList(domain) {
    chrome.storage.sync.get({ blockedDomains: [] }, (data) => {
      const blockedDomains = new Set(data.blockedDomains);
      blockedDomains.add(domain);

      chrome.storage.sync.set(
        { blockedDomains: [...blockedDomains] },
        updateBlockedList
      );
    });
  }

  // ブロックリストの表示を更新
  function updateBlockedList() {
    chrome.storage.sync.get({ blockedDomains: [] }, (data) => {
      blockedList.innerHTML = '';
      data.blockedDomains.forEach((domain) => {
        const li = document.createElement('li');
        li.textContent = domain;

        const removeBtn = document.createElement('span');
        removeBtn.textContent = '❌';
        removeBtn.classList.add('remove-btn');
        removeBtn.addEventListener('click', () =>
          removeDomainFromBlockList(domain)
        );

        li.appendChild(removeBtn);
        blockedList.appendChild(li);
      });

      // ドメインリストが更新されるたびに background.js に送信して updateRules を実行
      chrome.runtime.sendMessage({
        action: 'updateRules',
        domains: data.blockedDomains,
      });
    });
  }

  // ブロックリストからドメインを削除
  function removeDomainFromBlockList(domain) {
    chrome.storage.sync.get({ blockedDomains: [] }, (data) => {
      const blockedDomains = data.blockedDomains.filter((d) => d !== domain);
      chrome.storage.sync.set({ blockedDomains }, updateBlockedList);
    });
  }

  // 初期表示
  updateBlockedList();
});
