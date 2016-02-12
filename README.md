# Impossible Instant Lab Framework

With this framework you can expose images using the Impossible Instant Lab.

This framework only runs on **iPhone** and **iPod touch** with **iOS 6** and later. To give you the best result, **you need to have a device with a Retina display**.


## Usage

- Integrate the framework into your project via CocoaPods by adding the following line into you Podfile.

    ```
    pod 'InstantLab'
    ```

- Import the header.

    ```objective-c
    #import <InstantLab/InstantLab.h>
    ```

- Present the Instant Lab with your image.

    ```objective-c
    - (IBAction)expose:(id)sender
    {
        UIImage *image = ...
        [IPInstantLab presentInstantLabWithImage:image];
    }
    ```

    If you want, you can skip the first step, where you can crop the image by using the `-[IPInstantLab presentInstantLabWithImage:skipCropping:]` method and passing `YES` as the second parameter.

- Enjoy your pictures!


## Components

This section describes the major building blocks of the framework. You only need to deal with this if you want to dive deeper and interact with the individual components yourself. By doing so you're leaving the supported path.

The standard flow of an image through the expose process goes through four steps:

- Cropping the image
- Optimizing the image and selecting the correct exposure settings
- Exposing the image to instant film using the Instant Lab
- And finally a confirmation that tells the user about the expected development time for his picture

Each of those steps is represented by an own controller class. You may subclass them or call them directly with the appropriate input parameters.


### IPImageCropperViewController

This controller represents the cropping of the image. It crops the image to the aspect ratio of the image on the instant picture.

You can initialize an instance using the `-initWithImage:` method, and passing in an image of your choice.


### IPOptimizationViewController

This controller allows the user to apply basic image filters (Hue, Contrast, Gamma) onto the image. It is also the place where the user can choose on which film he wants to expose which effects the timing during the actual exposure process.

The initializer of this class also only takes an image `-initWithImage:`.


### IPExposureViewController

This class does the actual exposure. It implements a state machine which is triggered by rotating the device face down. A diagram of that state machine can be found in its implementation file.

You can initialize that controller by invoking `-initWithImage:exposureTime:filmIdentifier:`. You already see that besides the image this method also expects an `exposureTime` (in seconds) and a `filmIdentifier`. The `filmIdentifier` is a string which is used to let the user know about the development time that is to be expected for the particular film. Feel free to pass in nil here, or choose one from the `InstaLabFilms.plist` file.


## Example

If you are not sure, how this works, checkout the [demo app](https://github.com/TheImpossibleProject/Possible) we provide you.


## License

```
The MIT License (MIT)

Copyright (c) 2013 Impossible GmbH

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
