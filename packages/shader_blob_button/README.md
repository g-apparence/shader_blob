//TODO IMAGE
# Blob Flutter package
Add fancy blobs to your flutter apps. 

## Features
- blob layout
- blob button
- customize your blob as you want

## Roadmap 
- migrate shader to umbra
- wait for flutter glsl int / array support
- wait for flutter glsl output support 

## Getting started
install the package
add the package to your pubspec.yaml
```json

```

## Usage
### Layout
TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. 

```dart
BlobLayout.from(
    blobs: myBlobsList,
    blobsColor: Colors.blue,
)
```

or using the builder function (recommended)
```dart
BlobLayout.builder(
    builder: (Size areaSize) => [
        RotatingBloB.random(area),
        RotatingBloB.random(area),
        RotatingBloB.random(area),
        RotatingBloB.random(area),
        RotatingBloB.random(area),
        RotatingBloB.random(area),
        RotatingBloB.random(area),
        RotatingBloB.random(area),
    ],
    blobsColor: Colors.blue,
)
RotatingBloB.random(area)
```

> You must provide exactly 8 blob
> This is due to a current limitation of the flutter shader support

### Button
TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. 

```dart
const like = 'sample';
```

## Additional information

## Social


