#include <mulle-allocator/mulle-allocator.h>
#include <mulle-testallocator/mulle-testallocator.h>


static void  run_test( void)
{
   malloc( 1848);  // a leak we can't detect
}


//
// run tests in manual mode, since the compiler might not support
// constructors
//
int  main( int argc, char *argv[])
{
   mulle_testallocator_initialize();
   mulle_default_allocator = mulle_testallocator;
   {
      run_test();
   }
   mulle_testallocator_reset();
   return( 0);
}
