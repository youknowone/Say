SayKit
====

Voice composition interface for OS X.

See `man say` for the basis.

Example
----

```
import SayKit

Say(text: "Hello, World!").play()  // play
Say(text: "Hello, World!").writeToURL(NSURL(string: "/tmp/test.aiff")) // save to file

voices = Voice.voices.filter({ $0.locale == 'en_US' }) // filter en_US voices
Say(text: "Specific voice", voice: voices[0]).play() // play with specific voice
```