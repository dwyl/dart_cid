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
  dart_cid: ^0.0.1
```

and run the following command 
to fetch the dependencies.

```sh
flutter pub get
```

## Usage

Now just call the `createCid()` function!
Decide if you want to use `base32`
or `base52` to encode the input string.

```dart
import 'package:dart_cid/dart_cid.dart';

String input = 'hello world';
final output = createCid(input, BASE.base58);
```

and you're done! :tada:
You just created your own fancy `cid`!

## Considerations

The previous code snippet 
will yield the following `cid`.

```
zb2rhj7crUKTQYRGCRATFaQ6YFLTde2YzdqbbhAASkL9uRDXn
```

We can use the 
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

Every `cid` generated with this 
package will use the `raw` codec 
and will be hashed using the `sha2-258`
algorithm.
You can choose if you want to
encode with `base32` or `base58`, though.
:smile:

# I need help! ❓

If you have some feedback
or have any question,
do not hesitate and
[open an issue](https://github.com/dwyl/dart_cid/issues)!
We are here to help and are
happy for your contribution!

# License
MIT