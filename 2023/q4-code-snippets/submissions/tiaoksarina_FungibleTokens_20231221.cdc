import SwapRouter from 0xa6850776a94e6551
import FlowToken from 0x1654653399040a61
import FiatToken from 0xb19436aae4d94622
import FlowSwapPair from 0xc6c77b9f5c7a378f
import UsdcUsdtSwapPair from 0x9c6f94adf47904b5
import SwapInterfaces from 0xb78ef7afa52ff906
import SwapConfig from 0xb78ef7afa52ff906
import FungibleToken from 0xf233dcee88fe0abe
transaction() {
    prepare(userAccount: AuthAccount) {
        let pairInfo = getAccount(0xfa82796435e15832).getCapability<&{SwapInterfaces.PairPublic}>(/public/increment_swap_pair).borrow()!.getPairInfo();let I_1 = SwapConfig.UFix64ToScaledUInt256(pairInfo[2] as! UFix64);let I_2 = SwapConfig.UFix64ToScaledUInt256(pairInfo[3] as! UFix64);let B_1 = SwapConfig.UFix64ToScaledUInt256(FlowSwapPair.getPoolAmounts().token1Amount);let B_2 = SwapConfig.UFix64ToScaledUInt256(FlowSwapPair.getPoolAmounts().token2Amount);var I1 = I_1;var I2 = I_2;var B1 = B_1;var B2 = B_2;let scale: UInt256 = 1_000_000_000_000_000_000;let scalesqr: UInt256 = 1_000_000_000;var I1B2: UInt256 = I1*B2/scale;var I2B1: UInt256 = I2*B1/scale;var plat = 1
        if (I1B2 > I2B1) {plat = 3;var t=I1;I1=B1;B1=t;t=I2;I2=B2;B2=t;t=I1B2;I1B2=I2B1;I2B1=t;}
        let I1B2sqr: UInt256 = SwapConfig.sqrt(I1B2);let I2B1sqr: UInt256 = SwapConfig.sqrt(I2B1);let fee: UInt256 = 997000000000000000;let feefee: UInt256 = 994009000000000000;
        if (I1B2>fee * I1B2sqr / scale * I2B1sqr / scale) { return; }
        let f1 = fee * I1B2sqr / scale * I2B1sqr / scale - I1B2;
        let f2 = fee * B2 / scale + feefee*I2/scale;let res = f1*scale/f2;
        let total: UFix64 = SwapConfig.ScaledUInt256ToUFix64(res) - 0.2
        let flowTokenVault = userAccount.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)!
        let wallet = flowTokenVault.balance - 0.1;var cur = (wallet < total)? wallet:total;var left = total;var earn = 0.0;var index = 0
        while (cur > 0.0 && index < 20) {
            if (plat == 1) {
                let exactVaultIn <- flowTokenVault.withdraw(amount: cur);let token0Vault <- SwapRouter.swapWithPath(vaultIn: <- exactVaultIn, tokenKeyPath: ["A.1654653399040a61.FlowToken", "A.b19436aae4d94622.FiatToken"],exactAmounts: nil)
                let token1Vault <- UsdcUsdtSwapPair.swapToken1ForToken2(from: <- (token0Vault as! @FiatToken.Vault));let vaultOut <- FlowSwapPair.swapToken2ForToken1(from: <- token1Vault);earn = earn + vaultOut.balance - cur;flowTokenVault.deposit(from: <- vaultOut)
            } else {
                let token0Vault <- flowTokenVault.withdraw(amount: cur) as! @FlowToken.Vault;let token1Vault <- FlowSwapPair.swapToken1ForToken2(from: <- token0Vault);let token2Vault <- UsdcUsdtSwapPair.swapToken2ForToken1(from: <- token1Vault)
                let vaultOut <- SwapRouter.swapWithPath(vaultIn: <- token2Vault,tokenKeyPath: ["A.b19436aae4d94622.FiatToken", "A.1654653399040a61.FlowToken"],exactAmounts: nil);earn = earn + vaultOut.balance - cur;flowTokenVault.deposit(from: <-vaultOut)
            }
            left = left - cur;cur = (wallet < left)? wallet:left;index = index + 1
        }
        assert(earn > 0.0001, message: "fail")
    }
}
