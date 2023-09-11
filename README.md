# dart_cid

A dart implementation of 
`cid` ("content id") = human-friendly 
(readable/typeable) unique ID for **distributed/decentralised systems**.

# Why 🤷

In a database that is distributed,
creating IDs that reference records 
with *virtually no* risk of collision is a must.
We need a standardized way of creating
IDs for both the server and the client-side 
of our [app](https://github.com/dwyl/mvp),
in an offline-first approach.

As we are using Flutter for developing 
our application, we needed a way to create
these IDs using the Dart language.

# What? 🔐

If you are a newbie when it comes to 
`cid`s and how they are applicable 
to distributed scenarios,
we **highly encourage you**
to check the [`dwyl/cid`](https://github.com/dwyl/cid)
repo. 
Although it was made for [Elixir](https://github.com/dwyl/learn-elixir),
you can find more about real-life situations
of how these are used, 
especially with [IPFS](https://docs.ipfs.tech/concepts/content-addressing/#what-is-a-cid).
And yes, it will answer the
obvious question of 
**Why are you not using UUIDs?** :wink:

# How? 💡

Using this package is as easy as pie.
You just need an **input string** that will
be hashed and used to create a corresponding `cid`.
This `cid` will be, as the name implies, 
the content identifier - 
something that will identify that string.

Let's see it in action.

## Installing

Add the following to your 
`pubspec.yaml` file, under `dependencies`.

```yaml
dependencies:
  cid: ^1.0.0
```

and run the following command 
to fetch the dependencies.

```sh
flutter pub get
```

## Usage

### Creating a `CID`

Now just call the `createCid()` function!
You may decide what 
[multibase](https://github.com/multiformats/multibase#multibase-table) 
you want to use.
This library *tries* to support the official/default bases.
If you see one that's missing,
do open 
[an issue](https://github.com/dwyl/dart_cid/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc).


```dart
import 'package:cid/dart_cid.dart';

String input = 'hello world';
CIDInfo output = CID.createCid(input, Multibase.base58btc);

print(output.cid)
// "zb2rhj7crUKTQYRGCRATFaQ6YFLTde2YzdqbbhAASkL9uRDXn"
```

and you're done! :tada:
You just created your own fancy `cid`!

> **Note**
>
> Every `cid` generated with this 
package will use the `raw` codec 
and will be hashed using the `sha2-258`
algorithm.
You may choose which base you want to encode it as, though.

### Decoding a `CID`

If you're given a `CID` and you wish to decode it,
you can use the `decodeCid()` function.

```dart
CIDInfo cidInfo = decodeCid("some_cid");
```

This function will return an instance of `CIDInfo`,
holding relevant information of the provided `CID`.


### Converting `CIDv0` to `CIDv1`

If you've decoded a `CIDv0` string, 
you can convert it to a `CIDv1` object by calling `toV1()`.
This function can receive a multibase parameter if you wish to encode
it in a different base (e.g. `toV1(Multibase.base58btc)`).
By default, it is encoded to `base32`.

```dart
// Decode a v0 cid.
CIDInfo cidInfo = decodeCid("QmcRD4wkPPi6dig81r5sLj9Zm1gDCL4zgpEj9CfuRrGbzF");

// Convert it to v1
cidInfo.toV1();
print(cidInfo.cid)
// "bafybeigrf2dwtpjkiovnigysyto3d55opf6qkdikx6d65onrqnfzwgdkfa"

```

## Considerations

If you're interested in learning more about a given CID's components...

```
zb2rhj7crUKTQYRGCRATFaQ6YFLTde2YzdqbbhAASkL9uRDXn
```

...you can use the 
[IPFS `cid` inspector](https://cid.ipfs.tech/#zb2rhj7crUKTQYRGCRATFaQ6YFLTde2YzdqbbhAASkL9uRDXn)
to see the information that is
hashed into the string.

Open https://cid.ipfs.tech/#zb2rhj7crUKTQYRGCRATFaQ6YFLTde2YzdqbbhAASkL9uRDXn
and see it for yourself!

![inspect](https://user-images.githubusercontent.com/17494745/204067869-f9aa9dbc-13d3-4d64-a94c-c45e9dc3dd78.png)


As you can see, 
the `cid` contains leading identifiers
that clarify which representation is used, 
along with the content-hash. 
It includes:
- [**multibase**](https://github.com/multiformats/multibase)
prefix which specifies the encoding of the `cid`.
- **`cid` version**
- [**multicodec**](https://github.com/multiformats/multicodec)
which indicates the format of the target content.

> For more information about the
> format of `cid`s,
> check this link -> 
> https://docs.ipfs.tech/concepts/content-addressing/#cid-versions


# I need help! ❓

If you have some feedback
or have any question,
do not hesitate and
[open an issue](https://github.com/dwyl/dart_cid/issues)!
We are here to help and are
happy for your contribution!

# License
MIT
