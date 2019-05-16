# Inline Images

Using this filter you can write code blocks that when interpreted by a shell
command result in an image file in some format. These code blocks are
interpreted and replaced with the resultant image.

## Usage

The general syntax is

    ```{cmd=SHELL_COMMAND fmt=IMAGE_FORMAT}
    STDIN_FOR_CMD
    ```

Supported image formats will likely depend on the target output format. The
filter works by converting images into a base 64 encoded data url so, it can
be expected that it will work for the common image media types (png, jpg, gif).

These examples show how to use the filter with `dot` and `gnuplot` but, it will
work for any program on your path that can read from standard input and write
an image to standard output.

    ```{cmd="dot -Tpng" fmt=png}
    digraph test{
      a -> b;
      b -> c;
      c -> a;
    }
    ```

    ```{cmd=gnuplot fmt=png}
    set term png
    plot sin(x)/x
    ```
