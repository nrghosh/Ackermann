# Ackermann
Implementation of the Ackermann function in x86 assembly language


# Instructions
Compile like this:
     ```shell
     $nasm -f elf -gstabs ack.asm && ld -o ack -m elf_i386 ack.o
     ```

Run like this:
     ```shell
     $./ack
     ```

```ruby
require 'redcarpet'
markdown = Redcarpet.new("Hello World!")
puts markdown.to_html
```
