import {
  authenticate,
  block,
  config,
  currentUser,
  query,
  unauthenticate
} from "@onflow/fcl";
import { cadence } from "./verify";

config({
  "accessNode.api": "https://rest-testnet.onflow.org",
  "discovery.wallet": "https://fcl-discovery.onflow.org/testnet/authn"
});

async function signAndVerifyUserSignature(intent) {
  const {
    acctAddress,
    message,
    keyIds,
    signatures,
    signatureBlock
  } = await signMessage(intent);

  try {
    const isValid = await query({
      cadence,
      args: (arg, t) => [
        arg(acctAddress, t.Address),
        arg(intent, t.String),
        arg(message, t.String),
        arg(keyIds, t.Array(t.Int)),
        arg(signatures, t.Array(t.String)),
        arg(signatureBlock.toString(), t.UInt64)
      ]
    });
    console.log({ isValid });
  } catch (e) {
    console.error(e);
  }
}

async function signMessage(intent) {
  const user = await authenticate();

  const latestBlock = await block(true);
  // message needs to be hex for it to be signed
  const intentHex = Buffer.from(intent).toString("hex");
  const message = `${intentHex}${latestBlock.id}`;
  const sig = await currentUser().signUserMessage(message);

  const keyIds = sig.map((s) => {
    return s.keyId.toString();
  });
  const signatures = sig.map((s) => {
    return s.signature;
  });

  return {
    acctAddress: user.addr,
    message,
    keyIds,
    signatures,
    signatureBlock: latestBlock.height
  };
}

const intent = "Withdraw 10.00 $FLOW from the treasury.";
signAndVerifyUserSignature(intent);
