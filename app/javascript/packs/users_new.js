const buttonEthConnect = document.querySelector('button.eth_connect');
const formInputEthAddress = document.querySelector('input.eth_address');
const formNewUser = document.querySelector('form.new_user');

console.log('click')
// metamaskがつながっていない場合はconnectボタンを用意する
if (typeof window.ethereum !== 'undefined') {
    buttonEthConnect.addEventListener('click', async () => {
        const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
        formInputEthAddress.value = accounts[0];
        formNewUser.submit();
    });
}