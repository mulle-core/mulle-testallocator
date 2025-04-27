#include <mulle-allocator/mulle-allocator.h>
#include <mulle-testallocator/mulle-testallocator.h>



// MEMO: its a little tricky, when run as a test the environment variables
//       are set right and scribble will work as expected. standalone
//       though we only patch the s


void   hexdump(void *p, size_t length)
{
    unsigned char *buffer = p;
    size_t BYTES_PER_LINE = 16;

    for (size_t i = 0; i < length; i++)
    {
        // Print the byte as a 2-digit hex value
        printf("%02x ", buffer[i]);

        // Add a newline after BYTES_PER_LINE bytes
        if ((i + 1) % BYTES_PER_LINE == 0 && i < length - 1) {
            printf("\n");
        }
    }

    // Add a final newline
    printf("\n");
}



static void   run_test_malloc_default( void)
{
   void  *q;
   int   i;

   for( i = 1; i <= 16; i++)
   {
      printf( "%d: ", i);
      q = mulle_malloc( i);
      hexdump( q, i);
      mulle_free( q);
   }
}

static void   run_test_malloc_stdlib( void)
{
   void  *q;
   int   i;

   for( i = 1; i <= 16; i++)
   {
      printf( "%d: ", i);
      q = mulle_allocator_malloc( &mulle_stdlib_allocator, i);
      hexdump( q, i);
      mulle_allocator_free( &mulle_stdlib_allocator, q);
   }
}


//
// run tests in manual mode, since the compiler might not support
// constructors
//
MULLE__TESTALLOCATOR_GLOBAL
void   *mulle_testallocator_stdlib_realloc( void *q, size_t size, struct mulle_allocator *allocator);

int  main( int argc, char *argv[])
{
   mulle_testallocator_initialize();

   mulle_default_allocator        = mulle_testallocator;
   mulle_stdlib_allocator.realloc = mulle_testallocator_stdlib_realloc;
   {
      printf( "malloc default\n");
      run_test_malloc_default();

      printf( "malloc stdlib\n");
      run_test_malloc_stdlib();
   }
   mulle_testallocator_reset();

   return( 0);
}
