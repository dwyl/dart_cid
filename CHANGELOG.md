## 0.0.1

* Initial release.
* Allows CID creation with `sha2-256` encoding and choose `base32` and `base58`.

## 0.1.0

* You can now **decode `CID`s**.
* `CID` can now be created with more base options.

## 1.0.0

* Exporting `Multibase` class model.
* `createCid` now returns a `CIDInfo` object.
* `CIDInfo` object has been refactored with new `cid` and `multihashInfo` fields. `multibase` field now uses the `Multibase` class.
* `CIDInfo` objects can now be converted to v1 CIDs with `toV1()`. You may optionally pass a base parameter to encode it in a different multibase.
* Formatting code.