// // import { useReverseENSLookUp } from '../../utils/ensLookup';
// // import { resolveNounContractAddress } from '../../utils/resolveNounsContractAddress';
// // import { useEthers } from '@usedapp/core';
// // import classes from './ShortAddress.module.css';
// // import { containsBlockedText } from '../../utils/moderation/containsBlockedText';
// // import { useShortAddress } from '../../utils/addressAndENSDisplayUtils';
// // import React from 'react';
// // import Identicon from '../Identicon';
// // import { useIsNetworkEnsSupported } from '../../hooks/useIsNetworkEnsSupported';
@react.component
let make = (~address, ~avatar=None, ~size=24) => {
  let {data: ensName, isError} = Wagmi.useEnsName({
    address: address->Option.getWithDefault(""),
    chainId: 1,
    suspense: true,
  })

  let shortAddress = AddressAndEnsDisplayUtils.useShortAddress(address)->Option.getExn
  //   if (avatar) {
  //     return (
  //       <div className={classes.shortAddress}>
  //         {hasENS && avatar && (
  //           <div key={address}>
  //             <Identicon size={size} address={address} provider={provider} />
  //           </div>
  //         )}
  //         <span>{ens && !ensMatchesBlocklistRegex ? ens : shortAddress}</span>
  //       </div>
  //     );
  //   }
  <> {ensName->Nullable.toOption->Option.getWithDefault(shortAddress)->React.string} </>
}
