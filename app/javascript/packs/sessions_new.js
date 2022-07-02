// ステートフルにする（セッションを導入）
const buttonEthConnect = document.querySelector('button.eth_connect');
const formInputEthMessage = document.querySelector('input.eth_message');
const formInputEthAddress = document.querySelector('input.eth_address');
const formInputEthSignature = document.querySelector('input.eth_signature');
const formNewSession = document.querySelector('form.new_session');
if (typeof window.ethereum !== 'undefined') {
    buttonEthConnect.addEventListener('click', async () => {
        const accounts = await requestAccounts();
        const etherbase = accounts[0];
        const nonce = await getUuidByAccount(etherbase);
        if (nonce) {
            const customTitle = "Ethereum on Rails";
            const requestTime = new Date().getTime();
            const message = customTitle + "," + requestTime + "," + nonce;
            const signature = await personalSign(etherbase, message);
        formInputEthMessage.value = message;
        formInputEthAddress.value = etherbase;
        formInputEthSignature.value = signature;
        formNewSession.submit();
        } else {
            formInputEthMessage.value = "まずはサインアップしてください。";
        }
    });
} else {
    buttonEthConnect.innerHTML = "メタマスクが見つかりません";
    buttonEthConnect.disabled = true;
}

async function requestAccounts() {
    const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
    return accounts;
}

async function personalSign(account, message) {
    const signature = await ethereum.request({ method: 'personal_sign', params: [ message, account ] });
    return signature;
}

async function getUuidByAccount(account) {
    const response = await fetch("/api/v1/users/" + account);
    const nonceJson = await response.json();
    if (!nonceJson) return null;
        const uuid = nonceJson[0].eth_nonce;
    return uuid;
}