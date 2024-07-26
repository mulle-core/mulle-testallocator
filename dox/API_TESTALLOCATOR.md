# `mulle_testallocator`

> #### No support for scribble
>
> There is no "scribble" option for freed memory, as the library does not
> track allocation sizes.


## Automatic startup is tricky and platform dependent

For this to work, ensure that the mulle-testallocator is actually linked and
incorporated wholesale. Also make sure the constructor function of
mulle-testallocator is run as the very first. You may need to reorder
linking of the library to the earliest or latest possible stage.
