const VyperContract = artifacts.require('VyperContract');
const SolidityProxy = artifacts.require('SolidityProxy');

contract('test', (accounts) => {

    beforeEach(async () => {
        const [a] =  accounts;
        this.vyperContract = await VyperContract.new(a);
        this.solidityProxy = await SolidityProxy.new(a, this.vyperContract.address);
        this.solidityProxy = await VyperContract.at(this.solidityProxy.address);
    });

    const getState = async (myContract) =>  {
        const a = ((await myContract.a()).toString());
        const b = ((await myContract.b()).toString());
        const c = ((await myContract.c()).toString());
        return {a, b, c};
    }

    it("compareStates", async() => {
        // since it's the contracts the same - you would expect the variables are the same as well
        console.log(await getState(this.vyperContract));
        // {
        //     a: '0xA51043a9afD5e8Fd2869b2cb6d83b568650CB4A4',
        //     b: 'false',
        //     c: '1609608804'
        // }
        console.log(await getState(this.solidityProxy));
        // {
        //     a: '0xA51043a9afD5e8Fd2869b2cb6d83b568650CB4A4',
        //     b: 'false',
        //     c: '1609608805'
        // }

        await this.solidityProxy.set_b_true();
        console.log(await getState(this.solidityProxy));
        // { a: '0xA51043a9afD5e8Fd2869b2cb6d83b568650CB4A4', b: 'false', c: '1' }
        // different result is expected!!!
    });
});
