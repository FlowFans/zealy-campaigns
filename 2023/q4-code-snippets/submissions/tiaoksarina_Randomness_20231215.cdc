import OracleInterface from 0xcec15c814971c1dc
import OracleConfig from 0xcec15c814971c1dc
transaction(oracleAddr: Address, price: UFix64) { 
                        prepare(feederAccount: AuthAccount) { 
                            let oraclePublicInterface_FeederRef = getAccount(oracleAddr).getCapability<&{OracleInterface.OraclePublicInterface_Feeder}>(OracleConfig.OraclePublicInterface_FeederPath).borrow() 
                                            ?? panic("Lost oracle public capability at ".concat(oracleAddr.toString())) 
                            let pricePanelRef = feederAccount.borrow<&OracleInterface.PriceFeeder>(from: oraclePublicInterface_FeederRef.getPriceFeederStoragePath()) ?? panic("Lost feeder resource.") 
                            pricePanelRef.publishPrice(price: price) 
                        }
                    }
