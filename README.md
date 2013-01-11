# InterruptableAnimation

I was inspired by [this tweet from @lorenb](https://twitter.com/lorenb/status/243468483545931776), explaining how some of the animation in Twitter for iPad (RIP) was done, and wanted to try to build on it.

There are two things special about the animation in Twitter for iPad:

1. It uses a custom animation curve which features a little bounce at the end.
2. The animations are interruptable. Similiar to UIScrollView, you can grab the view after it's released, in the middle of its animation, and it will pause in its current location and you can go back to scrubbing it.

Both of these are things – using a n-order Bézier animation curve and pausing and altering an animation midflight – are difficult if not impossible using basic CAAnimations. (Although you can simulate a n-order Bézier curve using CAKeyframeAnimations. [Matt Gallagher has a great article about this.](http://www.cocoawithlove.com/2008/09/parametric-acceleration-curves-in-core.html))

This project is the solution, based on Loren's tweet, that I've come up with so far. It's relatively simple, and I'd love to get some feedback on how this is properly done. Please have a look and let me know what you think.

You can email me at [patrick@fadeover.org](mailto://patrick@fadeover.org), tweet at me [@patr1ck](https://twitter.com/patr1ck), or just yell really, really loud.
