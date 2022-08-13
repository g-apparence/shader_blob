<p>
<img src="docs/title.png"/>
</p>

# Blob Flutter package
Add fancy blobs to your flutter apps. <br>
You can now imagine many usage of blobs into your app (button, loader, background...).

<img src="docs/gifs/blob_demo2.gif" width="200px"/>

## Features
- blob layout
- blob button
- customize your blob as you want

## Roadmap 
- improve documentation
- migrate shader to umbra 
- shader: wait for flutter glsl int / array support
- shader: wait for flutter glsl output support 
- shader: create a gradient version
- button: add push effects
- button: provide custom method to let user create it's own on push effects

## Getting started
install the `flutter_blob` package.

## Usage
### Layout

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
```
> You must provide exactly 8 blob
> This is due to a current limitation of the flutter shader support

An example is available in the example folder of this repository.

### Button
For now buttons only support icon. 

```dart
BlobButton.bouncing(
    onTap: () => print("do w/e you want"),
    backgroundColor: Colors.amber[900],
    icon: Icon(
        Icons.add,
        color: Colors.white,
        size: 32,
    ),
)
```

> You must provide exactly 8 blob
> This is due to a current limitation of the flutter shader support


An example is available in the example folder of this repository.

## Additional information
- 👌 contributions or ideas accepted
- 🤝 I made this package learning how shaders works. <br> 
I'm always open to learn new things. <br>
Don't hesitate suggesting any improvement, I love it. 
## Social


